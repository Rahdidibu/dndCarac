import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/utils/supabase_mapper.dart';
import '../../../core/providers/auth_provider.dart';
import 'wizard_provider.dart';

/// Stream of all characters ordered by last updated
final charactersProvider = StreamProvider<List<Character>>((ref) {
  final userId = ref.watch(userIdProvider);
  if (userId == null) return Stream.value([]);

  final client = Supabase.instance.client;
  return client
      .from('characters')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .map((list) {
        final chars = list.map((m) {
          final camelMap = SupabaseMapper.toCamelCaseMap(m);
          return Character.fromJson(camelMap);
        }).toList();
        // Sort by updatedAt desc locally since stream ordering is primaryKey by default
        chars.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        return chars;
      });
});

/// Stream of CharacterClass rows for a given character
final characterClassesProvider =
    StreamProvider.family<List<CharacterClassesData>, int>((ref, characterId) {
  final client = Supabase.instance.client;
  return client
      .from('character_classes')
      .stream(primaryKey: ['id'])
      .eq('character_id', characterId)
      .map((list) {
        return list.map((m) {
          final camelMap = SupabaseMapper.toCamelCaseMap(m);
          return CharacterClassesData.fromJson(camelMap);
        }).toList();
      });
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

final srdFeatsProvider =
    FutureProvider.family<List<SrdFeat>, RulesetVersion>(
  (ref, ruleset) async {
    final db = ref.watch(databaseProvider);
    return db.compendiumDao.getAllFeats(ruleset);
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
  final client = Supabase.instance.client;
  return client
      .from('characters')
      .stream(primaryKey: ['id'])
      .eq('id', characterId)
      .map((list) {
        if (list.isEmpty) return null;
        final camelMap = SupabaseMapper.toCamelCaseMap(list.first);
        return Character.fromJson(camelMap);
      });
});

final characterAbilityScoresProvider =
    FutureProvider.family<CharacterAbilityScore?, int>((ref, characterId) async {
  final client = Supabase.instance.client;
  final response = await client
      .from('character_ability_scores')
      .select()
      .eq('character_id', characterId)
      .maybeSingle();
  if (response == null) return null;
  final camelMap = SupabaseMapper.toCamelCaseMap(response);
  return CharacterAbilityScore.fromJson(camelMap);
});

final characterProficienciesProvider =
    FutureProvider.family<List<CharacterProficiency>, int>((ref, characterId) async {
  final client = Supabase.instance.client;
  final response = await client
      .from('character_proficiencies')
      .select()
      .eq('character_id', characterId);
  return response.map((m) {
    final camelMap = SupabaseMapper.toCamelCaseMap(m);
    return CharacterProficiency.fromJson(camelMap);
  }).toList();
});

final characterSpellsProvider =
    StreamProvider.family<List<CharacterSpell>, int>((ref, characterId) {
  final client = Supabase.instance.client;
  return client
      .from('character_spells')
      .stream(primaryKey: ['id'])
      .eq('character_id', characterId)
      .map((list) {
        return list.map((m) {
          final camelMap = SupabaseMapper.toCamelCaseMap(m);
          return CharacterSpell.fromJson(camelMap);
        }).toList();
      });
});

final characterSpellSlotsProvider =
    StreamProvider.family<List<CharacterSpellSlot>, int>((ref, characterId) {
  final client = Supabase.instance.client;
  return client
      .from('character_spell_slots')
      .stream(primaryKey: ['id'])
      .eq('character_id', characterId)
      .order('slot_level', ascending: true)
      .map((list) {
        return list.map((m) {
          final camelMap = SupabaseMapper.toCamelCaseMap(m);
          return CharacterSpellSlot.fromJson(camelMap);
        }).toList();
      });
});

final characterResourcesProvider =
    StreamProvider.family<List<CharacterResource>, int>((ref, characterId) {
  final client = Supabase.instance.client;
  return client
      .from('character_resources')
      .stream(primaryKey: ['id'])
      .eq('character_id', characterId)
      .map((list) {
        return list.map((m) {
          final camelMap = SupabaseMapper.toCamelCaseMap(m);
          return CharacterResource.fromJson(camelMap);
        }).toList();
      });
});

final characterAttacksProvider =
    StreamProvider.family<List<CharacterAttack>, int>((ref, characterId) {
  final client = Supabase.instance.client;
  return client
      .from('character_attacks')
      .stream(primaryKey: ['id'])
      .eq('character_id', characterId)
      .map((list) {
        return list.map((m) {
          final camelMap = SupabaseMapper.toCamelCaseMap(m);
          return CharacterAttack.fromJson(camelMap);
        }).toList();
      });
});

final characterEquipmentProvider =
    StreamProvider.family<List<CharacterEquipmentData>, int>((ref, characterId) {
  final client = Supabase.instance.client;
  return client
      .from('character_equipment')
      .stream(primaryKey: ['id'])
      .eq('character_id', characterId)
      .map((list) {
        return list.map((m) {
          final camelMap = SupabaseMapper.toCamelCaseMap(m);
          return CharacterEquipmentData.fromJson(camelMap);
        }).toList();
      });
});

final characterFeatsProvider = StreamProvider.family<List<CharacterFeat>, int>((ref, characterId) {
  final client = Supabase.instance.client;
  return client
      .from('character_feats')
      .stream(primaryKey: ['id'])
      .eq('character_id', characterId)
      .map((list) {
        return list.map((m) {
          final camelMap = SupabaseMapper.toCamelCaseMap(m);
          return CharacterFeat.fromJson(camelMap);
        }).toList();
      });
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

final characterSpeciesNameProvider = FutureProvider.family<String?, int>((ref, characterId) async {
  final charAsync = ref.watch(characterByIdProvider(characterId));
  final character = charAsync.valueOrNull;
  if (character == null || character.speciesId == null) return null;
  final db = ref.watch(databaseProvider);
  final race = await db.compendiumDao.getRaceById(character.speciesId!, character.ruleset);
  return race?.name;
});

final characterSubspeciesNameProvider = FutureProvider.family<String?, int>((ref, characterId) async {
  final charAsync = ref.watch(characterByIdProvider(characterId));
  final character = charAsync.valueOrNull;
  if (character == null || character.speciesId == null || character.subspeciesId == null) return null;
  final db = ref.watch(databaseProvider);
  final subraces = await db.compendiumDao.getSubraces(character.speciesId!, character.ruleset);
  final subrace = subraces.where((s) => s.id == character.subspeciesId).firstOrNull;
  return subrace?.name;
});

final characterBackgroundNameProvider = FutureProvider.family<String?, int>((ref, characterId) async {
  final charAsync = ref.watch(characterByIdProvider(characterId));
  final character = charAsync.valueOrNull;
  if (character == null || character.backgroundId == null) return null;
  final db = ref.watch(databaseProvider);
  final bg = await db.compendiumDao.getBackgroundById(character.backgroundId!, character.ruleset);
  return bg?.name;
});


