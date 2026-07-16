import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../database/app_database.dart';
import '../database/tables/tables.dart';

/// Loads SRD JSON assets into the local SQLite database.
/// Called once at startup if the DB is empty.
class SrdSeeder {
  final AppDatabase db;
  Map<String, dynamic> _translationsFr = {};
  Map<String, dynamic> _spellDescFr = {};

  SrdSeeder(this.db);

  Future<void> seedIfNeeded() async {
    try {
      // Load French translations once
      final rawTr = await rootBundle.loadString('assets/data/translations_fr.json');
      _translationsFr = json.decode(rawTr) as Map<String, dynamic>;

      final rawDesc = await rootBundle.loadString('assets/data/spell_descriptions_fr.json');
      _spellDescFr = json.decode(rawDesc) as Map<String, dynamic>;

      final alreadySeeded2014 =
          await db.compendiumDao.isSeeded(RulesetVersion.dnd2014);
      final alreadySeeded2024 =
          await db.compendiumDao.isSeeded(RulesetVersion.dnd2024);

      if (!alreadySeeded2014) {
        print('Seeding D&D 2014 SRD data...');
        await _seed2014();
      }
      if (!alreadySeeded2024) {
        print('Seeding D&D 2024 SRD data...');
        await _seed2024();
      } else {
        // Force update weapon masteries to French for existing databases
        await _seedWeaponMasteries2024();
      }

      // Force seed 2024 subclasses to ensure French translations are applied
      await _seedSubclasses(RulesetVersion.dnd2024, 'assets/data/2024/subclasses.json');


    } catch (e, stack) {
      print('Error during SRD seeding: $e');
      print(stack);
    }
  }

  String _tr(String category, String index, String fallback) {
    final cat = _translationsFr[category];
    if (cat is Map) return (cat[index] as String?) ?? fallback;
    return fallback;
  }

  String _trMeta(String category, String value) {
    final cat = _spellDescFr[category];
    if (cat is Map) return (cat[value] as String?) ?? value;
    return value;
  }

  Map<String, String?> _spellDetail(String index) {
    final details = _spellDescFr['spell_details'];
    if (details is Map && details[index] is Map) {
      final d = details[index] as Map;
      return {
        'desc': d['desc'] as String?,
        'higher_level': d['higher_level'] as String?,
      };
    }
    return {'desc': null, 'higher_level': null};
  }

  // ── 2014 ────────────────────────────────────────────────

  Future<void> _seed2014() async {
    await _seedSpells2014();
    await _seedClasses(RulesetVersion.dnd2014, 'assets/data/2014/classes.json');
    await _seedSubclasses(
        RulesetVersion.dnd2014, 'assets/data/2014/subclasses.json');
    await _seedRaces2014();
    await _seedSubraces2014();
    await _seedBackgrounds2014();
    await _seedFeatures(
        RulesetVersion.dnd2014, 'assets/data/2014/features.json');
  }

  Future<void> _seedSpells2014() async {
    final raw = await rootBundle.loadString('assets/data/2014/spells.json');
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((s) {
      final classes = (s['classes'] as List?)
              ?.map((c) => c['index'] as String)
              .toList() ??
          [];
      final idx = s['index'] as String;
      final detail = _spellDetail(idx);
      final rawDesc = (s['desc'] as List?)?.join('\n') ?? '';
      final rawHL = (s['higher_level'] as List?)?.join('\n');
      return SrdSpellsCompanion(
        id: Value(idx),
        ruleset: Value(RulesetVersion.dnd2014),
        name: Value(_tr('spells', idx, s['name'] as String)),
        level: Value(s['level'] as int),
        school: Value(_tr('schools', (s['school']?['index'] ?? '') as String, (s['school']?['index'] ?? '') as String)),
        castingTime: Value(_trMeta('casting_times', s['casting_time'] as String? ?? '')),
        range: Value(_trMeta('ranges', s['range'] as String? ?? '')),
        components: Value(json.encode(s['components'] ?? [])),
        duration: Value(_trMeta('durations', s['duration'] as String? ?? '')),
        concentration: Value(s['concentration'] as bool? ?? false),
        ritual: Value(s['ritual'] as bool? ?? false),
        description: Value(detail['desc'] ?? rawDesc),
        higherLevel: Value(detail['higher_level'] ?? rawHL),
        classes: Value(json.encode(classes)),
        isCustom: const Value(false),
      );
    }).toList();
    await db.compendiumDao.insertAllSpells(companions);
  }

  Future<void> _seedClasses(RulesetVersion ruleset, String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((c) {
      // Extract saving throw ability names
      final savingThrows = (c['saving_throws'] as List?)
              ?.map((st) => st['index'] as String)
              .toList() ??
          [];
      // Spellcasting ability
      final spellcastingAbility =
          c['spellcasting']?['spellcasting_ability']?['index'] as String?;
      // Prepared caster classes: cleric, druid, paladin, wizard
      const preparedCasters = {'cleric', 'druid', 'paladin', 'wizard'};
      final isPrepared = preparedCasters.contains(c['index'] as String);
      return SrdClassesCompanion(
        id: Value(c['index'] as String),
        ruleset: Value(ruleset),
        name: Value(c['name'] as String),
        hitDie: Value(c['hit_die'] as int),
        proficiencies: Value(json.encode(c['proficiencies'] ?? [])),
        savingThrows: Value(json.encode(savingThrows)),
        spellcastingAbility: Value(spellcastingAbility),
        isPreparedCaster: Value(isPrepared),
      );
    }).toList();
    await db.compendiumDao.insertAllClasses(companions);
  }

  Future<void> _seedSubclasses(
      RulesetVersion ruleset, String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((s) {
      return SrdSubclassesCompanion(
        id: Value(s['index'] as String),
        ruleset: Value(ruleset),
        name: Value(s['name'] as String),
        classId: Value(s['class']?['index'] as String? ?? ''),
        description: Value((s['desc'] as List?)?.join('\n') ??
            s['description'] as String? ??
            ''),
      );
    }).toList();
    await db.compendiumDao.insertAllSubclasses(companions);
  }

  Future<void> _seedRaces2014() async {
    final raw = await rootBundle.loadString('assets/data/2014/races.json');
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((r) {
      final abilityBonuses = (r['ability_bonuses'] as List?)
              ?.map((ab) => {
                    'ability': ab['ability_score']['index'] as String,
                    'bonus': ab['bonus'] as int,
                  })
              .toList() ??
          [];
      final languages = (r['languages'] as List?)
              ?.map((l) => l['index'] as String)
              .toList() ??
          [];
      final traits = (r['traits'] as List?)
              ?.map((t) => t['index'] as String)
              .toList() ??
          [];
      return SrdRacesCompanion(
        id: Value(r['index'] as String),
        ruleset: const Value(RulesetVersion.dnd2014),
        name: Value(_tr('races', r['index'] as String, r['name'] as String)),
        speed: Value(r['speed'] as int),
        abilityBonuses: Value(json.encode(abilityBonuses)),
        languages: Value(json.encode(languages)),
        traits: Value(json.encode(traits)),
      );
    }).toList();
    await db.compendiumDao.insertAllRaces(companions);
  }

  Future<void> _seedSubraces2014() async {
    final raw = await rootBundle.loadString('assets/data/2014/subraces.json');
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((s) {
      final abilityBonuses = (s['ability_bonuses'] as List?)
              ?.map((ab) => {
                    'ability': ab['ability_score']['index'] as String,
                    'bonus': ab['bonus'] as int,
                  })
              .toList() ??
          [];
      return SrdSubracesCompanion(
        id: Value(s['index'] as String),
        ruleset: const Value(RulesetVersion.dnd2014),
        name: Value(_tr('subraces', s['index'] as String, s['name'] as String)),
        raceId: Value(s['race']?['index'] as String? ?? ''),
        abilityBonuses: Value(json.encode(abilityBonuses)),
      );
    }).toList();
    await db.compendiumDao.insertAllSubraces(companions);
  }

  Future<void> _seedBackgrounds2014() async {
    final raw =
        await rootBundle.loadString('assets/data/2014/backgrounds.json');
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((b) {
      // 2014 backgrounds: skill proficiencies only, no ASI/feat
      final skillProfs = (b['starting_proficiencies'] as List?)
              ?.where((p) =>
                  (p['index'] as String? ?? '').startsWith('skill-'))
              .map((p) =>
                  (p['index'] as String).replaceFirst('skill-', ''))
              .toList() ??
          [];
      return SrdBackgroundsCompanion(
        id: Value(b['index'] as String),
        ruleset: const Value(RulesetVersion.dnd2014),
        name: Value(_tr('backgrounds', b['index'] as String, b['name'] as String)),
        skillProficiencies: Value(json.encode(skillProfs)),
        toolProficiencies: const Value('[]'),
        languages: const Value('[]'),
        asiJson: const Value(null),
        originFeatId: const Value(null),
      );
    }).toList();
    await db.compendiumDao.insertAllBackgrounds(companions);
  }

  Future<void> _seedFeatures(
      RulesetVersion ruleset, String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((f) {
      return SrdFeaturesCompanion(
        srdIndex: Value(f['index'] as String),
        ruleset: Value(ruleset),
        name: Value(f['name'] as String),
        classId: Value(f['class']?['index'] as String?),
        subclassId: Value(f['subclass']?['index'] as String?),
        level: Value(f['level'] as int),
        description:
            Value((f['desc'] as List?)?.join('\n') ?? ''),
      );
    }).toList();
    await db.compendiumDao.insertAllFeatures(companions);
  }

  // ── 2024 ────────────────────────────────────────────────

  Future<void> _seed2024() async {
    // 2024 uses the same spell list as 2014 SRD (no separate spell file yet)
    await _seedSpells2024();
    await _seedClasses(RulesetVersion.dnd2024, 'assets/data/2024/classes.json');
    await _seedSubclasses(
        RulesetVersion.dnd2024, 'assets/data/2024/subclasses.json');
    await _seedSpecies2024();
    await _seedSubspecies2024();
    await _seedBackgrounds2024();
    await _seedFeats2024();
    await _seedWeaponMasteries2024();
  }

  Future<void> _seedSpells2024() async {
    // SRD 5.2 reuses SRD 5.1 spell list with same indices
    final raw = await rootBundle.loadString('assets/data/2014/spells.json');
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((s) {
      final classes = (s['classes'] as List?)
              ?.map((c) => c['index'] as String)
              .toList() ??
          [];
      return SrdSpellsCompanion(
        id: Value(s['index'] as String),
        ruleset: Value(RulesetVersion.dnd2024),
        name: Value(_tr('spells', s['index'] as String, s['name'] as String)),
        level: Value(s['level'] as int),
        school: Value(_tr('schools', (s['school']?['index'] ?? '') as String, (s['school']?['index'] ?? '') as String)),
        castingTime: Value(_trMeta('casting_times', s['casting_time'] as String? ?? '')),
        range: Value(_trMeta('ranges', s['range'] as String? ?? '')),
        components: Value(json.encode(s['components'] ?? [])),
        duration: Value(_trMeta('durations', s['duration'] as String? ?? '')),
        concentration: Value(s['concentration'] as bool? ?? false),
        ritual: Value(s['ritual'] as bool? ?? false),
        description: Value(_spellDetail(s['index'] as String)['desc'] ?? (s['desc'] as List?)?.join('\n') ?? ''),
        higherLevel: Value(_spellDetail(s['index'] as String)['higher_level'] ?? (s['higher_level'] as List?)?.join('\n')),
        classes: Value(json.encode(classes)),
        isCustom: const Value(false),
      );
    }).toList();
    await db.compendiumDao.insertAllSpells(companions);
  }

  Future<void> _seedSpecies2024() async {
    final raw = await rootBundle.loadString('assets/data/2024/species.json');
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((r) {
      final traits = (r['traits'] as List?)
              ?.map((t) => t['index'] as String)
              .toList() ??
          [];
      return SrdRacesCompanion(
        id: Value(r['index'] as String),
        ruleset: const Value(RulesetVersion.dnd2024),
        name: Value(_tr('races', r['index'] as String, r['name'] as String)),
        speed: Value(r['speed'] as int? ?? 30),
        abilityBonuses: const Value('[]'), // no ASI from species in 2024
        languages: const Value('[]'),
        traits: Value(json.encode(traits)),
      );
    }).toList();
    await db.compendiumDao.insertAllRaces(companions);
  }

  Future<void> _seedSubspecies2024() async {
    final raw =
        await rootBundle.loadString('assets/data/2024/subspecies.json');
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((s) {
      return SrdSubracesCompanion(
        id: Value(s['index'] as String),
        ruleset: const Value(RulesetVersion.dnd2024),
        name: Value(_tr('subraces', s['index'] as String, s['name'] as String)),
        raceId: Value(s['species']?['index'] as String? ?? ''),
        abilityBonuses: const Value('[]'),
      );
    }).toList();
    await db.compendiumDao.insertAllSubraces(companions);
  }

  Future<void> _seedBackgrounds2024() async {
    final raw =
        await rootBundle.loadString('assets/data/2024/backgrounds.json');
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((b) {
      // 2024 backgrounds grant ASI: choose 2 from 3 listed ability scores
      // We store the list as JSON; the UI lets the player pick 2
      final abilityScores = (b['ability_scores'] as List?)
              ?.map((a) => a['index'] as String)
              .toList() ??
          [];
      final skillProfs = (b['proficiencies'] as List?)
              ?.where((p) =>
                  (p['index'] as String? ?? '').startsWith('skill-'))
              .map((p) =>
                  (p['index'] as String).replaceFirst('skill-', ''))
              .toList() ??
          [];
      final toolProfs = (b['proficiencies'] as List?)
              ?.where((p) =>
                  (p['index'] as String? ?? '').startsWith('tool-'))
              .map((p) =>
                  (p['index'] as String).replaceFirst('tool-', ''))
              .toList() ??
          [];
      final featId = b['feat']?['index'] as String?;
      return SrdBackgroundsCompanion(
        id: Value(b['index'] as String),
        ruleset: const Value(RulesetVersion.dnd2024),
        name: Value(_tr('backgrounds', b['index'] as String, b['name'] as String)),
        skillProficiencies: Value(json.encode(skillProfs)),
        toolProficiencies: Value(json.encode(toolProfs)),
        languages: const Value('[]'),
        // asiJson stores list of eligible abilities; player picks 2
        asiJson: Value(json.encode(abilityScores)),
        originFeatId: Value(featId),
      );
    }).toList();
    await db.compendiumDao.insertAllBackgrounds(companions);
  }

  Future<void> _seedFeats2024() async {
    final raw = await rootBundle.loadString('assets/data/2024/feats.json');
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((f) {
      return SrdFeatsCompanion(
        id: Value(f['index'] as String),
        ruleset: const Value(RulesetVersion.dnd2024),
        name: Value(f['name'] as String),
        description: Value(f['description'] as String? ?? ''),
        type: Value(f['type'] as String? ?? 'general'),
        repeatable: Value(f['repeatable'] != null),
      );
    }).toList();
    await db.compendiumDao.insertAllFeats(companions);
  }

  static const _masteryTranslations = {
    'cleave': (
      name: 'Fendre',
      desc: 'Si vous touchez une créature avec un jet d\'attaque au corps à corps en utilisant cette arme, vous pouvez effectuer un jet d\'attaque au corps à corps avec l\'arme contre une seconde créature située à 1,5 mètre (5 pieds) de la première et à portée. Si vous touchez, la seconde créature subit les dégâts de l\'arme, mais vous n\'ajoutez pas votre modificateur de caractéristique à ces dégâts, à moins que ce modificateur ne soit négatif. Vous ne pouvez effectuer cette attaque supplémentaire qu\'une fois par tour.'
    ),
    'graze': (
      name: 'Effleurer',
      desc: 'Si votre jet d\'attaque avec cette arme rate une créature, vous pouvez lui infliger des dégâts égaux au modificateur de caractéristique utilisé pour le jet d\'attaque. Ces dégâts sont du même type que ceux normalement infligés par l\'arme et ne peuvent être augmentés qu\'en augmentant le modificateur de caractéristique.'
    ),
    'nick': (
      name: 'Entailler',
      desc: 'Lorsque vous effectuez l\'attaque supplémentaire autorisée par la propriété Légère (combat à deux armes), vous pouvez la faire dans le cadre de votre action Attaquer au lieu d\'utiliser une action bonus. Vous ne pouvez effectuer cette attaque supplémentaire qu\'une fois par tour.'
    ),
    'push': (
      name: 'Pousser',
      desc: 'Si vous touchez une créature avec cette arme, vous pouvez la repousser en ligne droite de 3 mètres (10 pieds) si elle est de taille Grande ou plus petite.'
    ),
    'sap': (
      name: 'Affaiblir',
      desc: 'Si vous touchez une créature avec cette arme, celle-ci subit un désavantage sur son prochain jet d\'attaque effectué avant le début de votre prochain tour.'
    ),
    'slow': (
      name: 'Ralentir',
      desc: 'Si vous touchez une créature avec cette arme et lui infligez des dégâts, la vitesse de celle-ci est réduite de 3 mètres (10 pieds) jusqu\'au début de votre prochain tour. Si la créature est touchée plusieurs fois par des armes ayant cette propriété, la réduction de vitesse ne dépasse pas 3 mètres (10 pieds).'
    ),
    'topple': (
      name: 'Renverser',
      desc: 'Si vous touchez une créature avec cette arme, vous pouvez l\'obliger à effectuer un jet de sauvegarde de Constitution (DD égal à 8 + le modificateur de caractéristique utilisé pour l\'attaque + votre bonus de maîtrise). En cas d\'échec, la créature subit l\'état à terre.'
    ),
    'vex': (
      name: 'Exaspérer',
      desc: 'Si vous touchez une créature avec cette arme et lui infligez des dégâts, vous obtenez l\'avantage sur votre prochain jet d\'attaque contre cette cible avant la fin de votre prochain tour.'
    ),
  };

  Future<void> _seedWeaponMasteries2024() async {
    final raw = await rootBundle.loadString('assets/data/2024/weapon_mastery.json');
    final List<dynamic> list = json.decode(raw);
    final companions = list.map((w) {
      final index = w['index'] as String;
      final tr = _masteryTranslations[index];
      final name = tr != null ? tr.name : w['name'] as String;
      final desc = tr != null ? tr.desc : w['description'] as String? ?? '';
      return SrdWeaponMasteriesCompanion(
        id: Value(index),
        name: Value(name),
        description: Value(desc),
      );
    }).toList();
    await db.compendiumDao.insertAllWeaponMasteries(companions);
  }
}

