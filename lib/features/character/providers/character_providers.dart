import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';
import '../../../core/providers/database_provider.dart';
import 'wizard_provider.dart';

/// Stream of all characters ordered by last updated
final charactersProvider = StreamProvider<List<Character>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.characterDao.watchAllCharacters();
});

/// Stream of CharacterClass rows for a given character
final characterClassesProvider =
    StreamProvider.family<List<CharacterClassesData>, int>((ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.characterDao.watchCharacterClasses(characterId);
});

/// Computed total level for a character
final characterTotalLevelProvider =
    Provider.family<AsyncValue<int>, int>((ref, characterId) {
  final classesAsync = ref.watch(characterClassesProvider(characterId));
  return classesAsync.whenData(
    (classes) => classes.fold<int>(0, (sum, c) => sum + c.level),
  );
});

// ── Compendium providers (used by wizard and sheet) ─────────────────────────

final srdClassesProvider =
    FutureProvider.family<List<SrdClassesData>, RulesetVersion>(
  (ref, ruleset) async {
    final db = ref.watch(databaseProvider);
    return db.compendiumDao.getClasses(ruleset);
  },
);

final srdSubclassesProvider =
    FutureProvider.family<List<SrdSubclassesData>, ({String classId, RulesetVersion ruleset})>(
  (ref, args) async {
    final db = ref.watch(databaseProvider);
    return db.compendiumDao.getSubclasses(args.classId, args.ruleset);
  },
);

final srdRacesProvider =
    FutureProvider.family<List<SrdRace>, RulesetVersion>(
  (ref, ruleset) async {
    final db = ref.watch(databaseProvider);
    return db.compendiumDao.getRaces(ruleset);
  },
);

final srdSubracesProvider =
    FutureProvider.family<List<SrdSubrace>, ({String raceId, RulesetVersion ruleset})>(
  (ref, args) async {
    final db = ref.watch(databaseProvider);
    return db.compendiumDao.getSubraces(args.raceId, args.ruleset);
  },
);

final srdBackgroundsProvider =
    FutureProvider.family<List<SrdBackground>, RulesetVersion>(
  (ref, ruleset) async {
    final db = ref.watch(databaseProvider);
    return db.compendiumDao.getBackgrounds(ruleset);
  },
);

final srdFeatByIdProvider =
    FutureProvider.family<SrdFeat?, ({String featId, RulesetVersion ruleset})>(
  (ref, args) async {
    final db = ref.watch(databaseProvider);
    return db.compendiumDao.getFeatById(args.featId, args.ruleset);
  },
);

final wizardAbilityModifiersProvider = FutureProvider.autoDispose<Map<String, int>>((ref) async {
  final wizard = ref.watch(wizardProvider);
  final db = ref.watch(databaseProvider);
  final modifiers = <String, int>{'str': 0, 'dex': 0, 'con': 0, 'int': 0, 'wis': 0, 'cha': 0};

  if (wizard.ruleset == RulesetVersion.dnd2014) {
    if (wizard.speciesId != null) {
      final race = await db.compendiumDao.getRaceById(wizard.speciesId!, RulesetVersion.dnd2014);
      if (race != null && race.abilityBonuses.isNotEmpty) {
        final List<dynamic> list = json.decode(race.abilityBonuses);
        for (final item in list) {
          final ability = item['ability'] as String;
          final bonus = item['bonus'] as int;
          modifiers[ability] = (modifiers[ability] ?? 0) + bonus;
        }
      }
    }
    if (wizard.subspeciesId != null) {
      final subraces = await db.compendiumDao.getSubraces(wizard.speciesId!, RulesetVersion.dnd2014);
      final subrace = subraces.where((s) => s.id == wizard.subspeciesId).firstOrNull;
      if (subrace != null && subrace.abilityBonuses.isNotEmpty) {
        final List<dynamic> list = json.decode(subrace.abilityBonuses);
        for (final item in list) {
          final ability = item['ability'] as String;
          final bonus = item['bonus'] as int;
          modifiers[ability] = (modifiers[ability] ?? 0) + bonus;
        }
      }
    }
  } else if (wizard.ruleset == RulesetVersion.dnd2024) {
    for (final entry in wizard.backgroundAsiChoices.entries) {
      modifiers[entry.key] = (modifiers[entry.key] ?? 0) + entry.value;
    }
  }
  return modifiers;
});

// ── Character sheet providers ────────────────────────────────────────────────

final characterByIdProvider =
    StreamProvider.family<Character?, int>((ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.characterDao
      .watchAllCharacters()
      .map((list) => list.where((c) => c.id == characterId).firstOrNull);
});

final characterAbilityScoresProvider =
    FutureProvider.family<CharacterAbilityScore?, int>((ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.characterDao.getAbilityScores(characterId);
});

final characterProficienciesProvider =
    FutureProvider.family<List<CharacterProficiency>, int>((ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.characterDao.getProficiencies(characterId);
});

final characterSpellsProvider =
    StreamProvider.family<List<CharacterSpell>, int>((ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.characterDao.watchCharacterSpells(characterId);
});

final characterSpellSlotsProvider =
    StreamProvider.family<List<CharacterSpellSlot>, int>((ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.characterDao.watchSpellSlots(characterId);
});

final characterResourcesProvider =
    StreamProvider.family<List<CharacterResource>, int>((ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.characterDao.watchResources(characterId);
});

final characterAttacksProvider =
    StreamProvider.family<List<CharacterAttack>, int>((ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.characterDao.watchAttacks(characterId);
});

final characterEquipmentProvider =
    StreamProvider.family<List<CharacterEquipmentData>, int>(
        (ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.characterDao.watchEquipment(characterId);
});

final characterFeatsProvider = StreamProvider.family<List<CharacterFeat>, int>((ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.characterDao.watchCharacterFeats(characterId);
});

final characterFeatDetailsProvider = FutureProvider.family<List<SrdFeat>, int>((ref, characterId) async {
  final feats = await ref.watch(characterFeatsProvider(characterId).future);
  final db = ref.watch(databaseProvider);
  final character = await ref.watch(characterByIdProvider(characterId).future);
  final ruleset = character?.ruleset ?? RulesetVersion.dnd2024;

  final list = <SrdFeat>[];
  for (final f in feats) {
    final detail = await db.compendiumDao.getFeatById(f.featId, ruleset);
    if (detail != null) {
      list.add(detail);
    }
  }
  return list;
});

final srdWeaponMasteriesProvider = FutureProvider<List<SrdWeaponMastery>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.compendiumDao.getAllWeaponMasteries();
});

final srdWeaponMasteryByIdProvider = FutureProvider.family<SrdWeaponMastery?, String>((ref, id) async {
  final db = ref.watch(databaseProvider);
  return db.compendiumDao.getWeaponMasteryById(id);
});

