import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/tables/tables.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/utils/class_orders.dart';
import '../../../core/utils/feature_rules.dart';
import 'character_providers.dart';

/// Origine d'une capacité ; l'ordre de l'enum est l'ordre d'affichage.
enum FeatureSource { characterClass, subclass, species, choice, feat }

class CharacterFeatureEntry {
  final FeatureSource source;

  /// Nom du groupe d'origine (classe, sous-classe, espèce…).
  final String origin;
  final String name;
  final String description;
  final int? level;

  /// Index SRD de la capacité (ou du don) pour relier un compteur de ressource.
  final String srdIndex;

  const CharacterFeatureEntry({
    required this.source,
    required this.origin,
    required this.name,
    required this.description,
    required this.srdIndex,
    this.level,
  });
}

String _humanize(String index) => index
    .split('-')
    .where((w) => w.isNotEmpty)
    .map((w) => w[0].toUpperCase() + w.substring(1))
    .join(' ');

/// Capacités du personnage : classe, sous-classe, espèce et dons, triées par
/// source puis niveau puis nom.
final characterFeaturesProvider =
    FutureProvider.family<List<CharacterFeatureEntry>, int>((
      ref,
      characterId,
    ) async {
      final character = await ref.watch(
        characterByIdProvider(characterId).future,
      );
      if (character == null) return const [];
      final classes = await ref.watch(
        characterClassesProvider(characterId).future,
      );
      final feats = await ref.watch(
        characterFeatDetailsProvider(characterId).future,
      );
      final db = ref.watch(databaseProvider);
      final ruleset = character.ruleset;

      final entries = <CharacterFeatureEntry>[];

      if (ruleset != RulesetVersion.batman) {
        final srdClasses = await db.compendiumDao.getClasses(ruleset);
        final allFeatures = await db.compendiumDao.getAllFeatures(ruleset);
        final progress = classes
            .map(
              (c) => ClassProgress(
                classId: c.classId,
                subclassId: c.subclassId,
                level: c.level,
              ),
            )
            .toList();

        final classNames = {for (final c in srdClasses) c.id: c.name};
        final subclassNames = <String, String>{};
        for (final c in classes.where((c) => c.subclassId != null)) {
          final subs = await db.compendiumDao.getSubclasses(c.classId, ruleset);
          for (final s in subs) {
            subclassNames[s.id] = s.name;
          }
        }

        for (final f in FeatureRules.forClasses(
          all: allFeatures,
          ruleset: ruleset,
          classes: progress,
        )) {
          final isSub = f.subclassId != null;
          entries.add(
            CharacterFeatureEntry(
              source: isSub
                  ? FeatureSource.subclass
                  : FeatureSource.characterClass,
              origin: isSub
                  ? (subclassNames[f.subclassId] ?? _humanize(f.subclassId!))
                  : (classNames[f.classId] ?? _humanize(f.classId!)),
              name: f.name,
              description: f.description,
              srdIndex: f.srdIndex,
              level: f.level,
            ),
          );
        }

        if (ruleset == RulesetVersion.dnd2024) {
      for (final c in classes) {
        final option = ClassOrders.find(c.classId, c.classOrder);
        if (option == null) continue;
        entries.add(CharacterFeatureEntry(
          source: FeatureSource.choice,
          origin: option.orderName,
          name: '${option.orderName} : ${option.name}',
          description: option.description,
          srdIndex: 'order-${option.id}',
          level: 1,
        ));
      }
    }

    if (character.speciesId != null) {
          final race = await db.compendiumDao.getRaceById(
            character.speciesId!,
            ruleset,
          );
          if (race != null) {
            final traits = (json.decode(race.traits) as List).cast<String>();
            for (final t in traits) {
              entries.add(
                CharacterFeatureEntry(
                  source: FeatureSource.species,
                  origin: race.name,
                  name: _humanize(t),
                  description: '',
                  srdIndex: t,
                ),
              );
            }
          }
        }
      }

      for (final feat in feats) {
        // Style de combat et pacte (2024) : choix de classe enregistrés comme dons.
        final isClassChoice =
            feat.type == 'fighting-style' || feat.id.startsWith('pact-of-');
        entries.add(
          CharacterFeatureEntry(
            source: isClassChoice ? FeatureSource.choice : FeatureSource.feat,
            origin: feat.name,
            name: feat.name,
            description: feat.description,
            srdIndex: feat.id,
          ),
        );
      }

      entries.sort((a, b) {
        final s = a.source.index.compareTo(b.source.index);
        if (s != 0) return s;
        final o = a.origin.compareTo(b.origin);
        if (o != 0) return o;
        final l = (a.level ?? 0).compareTo(b.level ?? 0);
        return l != 0 ? l : a.name.compareTo(b.name);
      });
      return entries;
    });
