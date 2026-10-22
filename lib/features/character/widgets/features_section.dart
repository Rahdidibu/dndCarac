import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/utils/character_service.dart';
import '../../../core/utils/class_orders.dart';
import '../../../core/utils/dnd_rules.dart';
import '../../../core/utils/feature_rules.dart';
import '../../../core/utils/markdown_text.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/character_features_provider.dart';
import '../providers/character_providers.dart';

/// Section repliable « Capacités » : groupes par origine, recherche et
/// compteurs d'utilisations liés à `character_resources`.
class FeaturesSection extends ConsumerStatefulWidget {
  final int characterId;

  const FeaturesSection({super.key, required this.characterId});

  @override
  ConsumerState<FeaturesSection> createState() => _FeaturesSectionState();
}

class _FeaturesSectionState extends ConsumerState<FeaturesSection> {
  String _query = '';

  String _groupTitle(AppLocalizations l10n, CharacterFeatureEntry first) {
    switch (first.source) {
      case FeatureSource.characterClass:
        return first.origin;
      case FeatureSource.subclass:
        return l10n.featuresGroupSubclass(first.origin);
      case FeatureSource.species:
        return l10n.featuresGroupSpecies(first.origin);
      case FeatureSource.choice:
        return l10n.featuresGroupChoices;
      case FeatureSource.feat:
        return first.origin;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final featuresAsync = ref.watch(
      characterFeaturesProvider(widget.characterId),
    );
    final resources =
        ref.watch(characterResourcesProvider(widget.characterId)).valueOrNull ??
        const <CharacterResource>[];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(Icons.auto_awesome, color: Colors.amber[700]),
          title: Text(
            l10n.featuresSectionTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            _MissingOrderPrompts(characterId: widget.characterId),
            featuresAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, st) =>
                  AsyncErrorView(error: e, stackTrace: st, compact: true),
              data: (all) => _buildContent(context, l10n, all, resources),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    List<CharacterFeatureEntry> all,
    List<CharacterResource> resources,
  ) {
    // Les dons ont leur propre carte dans l'onglet Profil.
    final entries = all.where((e) => e.source != FeatureSource.feat).toList();
    if (entries.isEmpty) {
      return Text(
        l10n.featuresEmpty,
        style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
      );
    }

    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? entries
        : entries
              .where(
                (e) =>
                    e.name.toLowerCase().contains(q) ||
                    e.description.toLowerCase().contains(q),
              )
              .toList();

    final groups = <(FeatureSource, String), List<CharacterFeatureEntry>>{};
    for (final e in filtered) {
      groups.putIfAbsent((e.source, e.origin), () => []).add(e);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, size: 20),
            hintText: l10n.featuresSearchHint,
            isDense: true,
            border: const OutlineInputBorder(),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 8),
        if (groups.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.featuresNoResult,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ),
        for (final g in groups.entries)
          ExpansionTile(
            key: PageStorageKey('features_${g.key.$1.name}_${g.key.$2}'),
            initiallyExpanded: q.isNotEmpty,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: Text(
              _groupTitle(l10n, g.value.first),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              for (final e in g.value)
                _FeatureTile(
                  entry: e,
                  resource: _resourceFor(e, resources),
                  characterId: widget.characterId,
                ),
            ],
          ),
      ],
    );
  }

  CharacterResource? _resourceFor(
    CharacterFeatureEntry e,
    List<CharacterResource> resources,
  ) {
    final key = FeatureRules.resourceKeyFor(e.srdIndex);
    if (key == null) return null;
    return resources.where((r) => r.resourceName == key).firstOrNull;
  }
}

/// Propose de choisir l'ordre divin/primordial (2024) pour les personnages
/// créés avant l'enregistrement de ce choix.
class _MissingOrderPrompts extends ConsumerWidget {
  final int characterId;

  const _MissingOrderPrompts({required this.characterId});

  Future<void> _choose(
    BuildContext context,
    WidgetRef ref,
    CharacterClassesData classRow,
  ) async {
    final options = ClassOrders.all
        .where((o) => o.classId == classRow.classId)
        .toList();
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(options.first.orderName),
        children: [
          for (final o in options)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, o.id),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    o.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(o.description, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
    if (choice == null) return;
    await CharacterService(ref.read(databaseProvider)).setClassOrder(
      characterId: characterId,
      classRowId: classRow.id,
      order: choice,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final character = ref.watch(characterByIdProvider(characterId)).valueOrNull;
    final classes =
        ref.watch(characterClassesProvider(characterId)).valueOrNull ??
        const [];
    if (character?.ruleset != RulesetVersion.dnd2024) {
      return const SizedBox.shrink();
    }

    final missing = classes
        .where(
          (c) =>
              (c.classId == 'cleric' || c.classId == 'druid') &&
              c.classOrder == null,
        )
        .toList();
    return Column(
      children: [
        for (final c in missing)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.help_outline, size: 20),
            title: Text(
              l10n.featuresOrderNotChosen(
                ClassOrders.all
                    .firstWhere((o) => o.classId == c.classId)
                    .orderName,
              ),
            ),
            trailing: TextButton(
              onPressed: () => _choose(context, ref, c),
              child: Text(l10n.featuresOrderChoose),
            ),
          ),
      ],
    );
  }
}

class _FeatureTile extends ConsumerWidget {
  final CharacterFeatureEntry entry;
  final CharacterResource? resource;
  final int characterId;

  const _FeatureTile({
    required this.entry,
    required this.resource,
    required this.characterId,
  });

  Future<void> _setCurrent(WidgetRef ref, int value) async {
    final r = resource!;
    await ref
        .read(databaseProvider)
        .characterDao
        .upsertResource(
          CharacterResourcesCompanion(
            id: Value(r.id),
            characterId: Value(characterId),
            resourceName: Value(r.resourceName),
            current: Value(value.clamp(0, r.maximum)),
            maximum: Value(r.maximum),
          ),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final r = resource;
    final unlimited = r != null && r.maximum >= DndRules.unlimitedResource;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              if (entry.level != null)
                Text(
                  l10n.featuresLevel(entry.level!),
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
          if (r != null)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                  tooltip: l10n.featuresUseOne,
                  onPressed: unlimited || r.current <= 0
                      ? null
                      : () => _setCurrent(ref, r.current - 1),
                ),
                Text(
                  unlimited
                      ? l10n.featuresUnlimited
                      : l10n.featuresUses(r.current, r.maximum),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  tooltip: l10n.featuresRestoreOne,
                  onPressed: unlimited || r.current >= r.maximum
                      ? null
                      : () => _setCurrent(ref, r.current + 1),
                ),
              ],
            ),
          if (entry.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            MarkdownText(
              text: entry.description,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
