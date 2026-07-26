import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_database.dart';
import '../tables/tables.dart';
import '../../models/character_note.dart';
import '../../utils/supabase_mapper.dart';

part 'character_dao.g.dart';

@DriftAccessor(tables: [
  Characters,
  CharacterClasses,
  CharacterAbilityScores,
  CharacterProficiencies,
  CharacterSpells,
  CharacterFeats,
  CharacterSpellSlots,
  CharacterResources,
  CharacterAttacks,
  CharacterEquipment,
])
class CharacterDao extends DatabaseAccessor<AppDatabase>
    with _$CharacterDaoMixin {
  CharacterDao(super.db);

  // ── Characters ───────────────────────────────────────────

  Stream<List<Character>> watchAllCharacters() {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return Stream.value([]);
    return client
        .from('characters')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((list) {
          final chars = list.map((m) => Character.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
          chars.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          return chars;
        });
  }

  Future<Character?> getCharacterById(int id) async {
    final client = Supabase.instance.client;
    final response = await client
        .from('characters')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (response == null) return null;
    return Character.fromJson(SupabaseMapper.toCamelCaseMap(response));
  }

  Future<int> insertCharacter(CharactersCompanion companion) async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    final map = SupabaseMapper.insertableToMap(companion);
    if (userId != null) {
      map['user_id'] = userId;
    }
    final response = await client
        .from('characters')
        .insert(map)
        .select('id')
        .single();
    return response['id'] as int;
  }

  Future<bool> updateCharacter(CharactersCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final id = companion.id.value;
    await client
        .from('characters')
        .update(map)
        .eq('id', id);
    return true;
  }

  Future<int> deleteCharacter(int id) async {
    final client = Supabase.instance.client;
    await client
        .from('characters')
        .delete()
        .eq('id', id);
    return 1;
  }

  // ── Character classes (multiclass) ───────────────────────

  Future<List<CharacterClassesData>> getCharacterClasses(int characterId) async {
    final client = Supabase.instance.client;
    final response = await client
        .from('character_classes')
        .select()
        .eq('character_id', characterId);
    return response.map((m) => CharacterClassesData.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
  }

  Stream<List<CharacterClassesData>> watchCharacterClasses(int characterId) {
    final client = Supabase.instance.client;
    return client
        .from('character_classes')
        .stream(primaryKey: ['id'])
        .eq('character_id', characterId)
        .map((list) {
          return list.map((m) => CharacterClassesData.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
        });
  }

  Future<int> insertCharacterClass(CharacterClassesCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final response = await client
        .from('character_classes')
        .insert(map)
        .select('id')
        .single();
    return response['id'] as int;
  }

  Future<bool> updateCharacterClass(CharacterClassesCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final id = companion.id.value;
    await client
        .from('character_classes')
        .update(map)
        .eq('id', id);
    return true;
  }

  Future<int> deleteCharacterClass(int id) async {
    final client = Supabase.instance.client;
    await client
        .from('character_classes')
        .delete()
        .eq('id', id);
    return 1;
  }

  // ── Ability scores ───────────────────────────────────────

  Future<CharacterAbilityScore?> getAbilityScores(int characterId) async {
    final client = Supabase.instance.client;
    final response = await client
        .from('character_ability_scores')
        .select()
        .eq('character_id', characterId)
        .maybeSingle();
    if (response == null) return null;
    return CharacterAbilityScore.fromJson(SupabaseMapper.toCamelCaseMap(response));
  }

  Future<int> upsertAbilityScores(
      CharacterAbilityScoresCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    
    final charId = companion.characterId.value;
    final existing = await client
        .from('character_ability_scores')
        .select('id')
        .eq('character_id', charId)
        .maybeSingle();

    if (existing != null) {
      await client
          .from('character_ability_scores')
          .update(map)
          .eq('character_id', charId);
      return existing['id'] as int;
    } else {
      final response = await client
          .from('character_ability_scores')
          .insert(map)
          .select('id')
          .single();
      return response['id'] as int;
    }
  }

  // ── Proficiencies ────────────────────────────────────────

  Future<List<CharacterProficiency>> getProficiencies(int characterId) async {
    final client = Supabase.instance.client;
    final response = await client
        .from('character_proficiencies')
        .select()
        .eq('character_id', characterId);
    return response.map((m) => CharacterProficiency.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
  }

  Future<int> insertProficiency(CharacterProficienciesCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final response = await client
        .from('character_proficiencies')
        .insert(map)
        .select('id')
        .single();
    return response['id'] as int;
  }

  Future<void> deleteProficiency(int characterId, String key) async {
    final client = Supabase.instance.client;
    await client
        .from('character_proficiencies')
        .delete()
        .eq('character_id', characterId)
        .eq('proficiency_key', key);
  }

  Future<void> replaceAllProficiencies(
      int characterId, List<CharacterProficienciesCompanion> companions) async {
    final client = Supabase.instance.client;
    await client
        .from('character_proficiencies')
        .delete()
        .eq('character_id', characterId);

    if (companions.isNotEmpty) {
      final maps = companions.map((c) => SupabaseMapper.insertableToMap(c)).toList();
      await client.from('character_proficiencies').insert(maps);
    }
  }

  // ── Spells ───────────────────────────────────────────────

  Stream<List<CharacterSpell>> watchCharacterSpells(int characterId) {
    final client = Supabase.instance.client;
    return client
        .from('character_spells')
        .stream(primaryKey: ['id'])
        .eq('character_id', characterId)
        .map((list) {
          return list.map((m) => CharacterSpell.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
        });
  }

  Future<List<CharacterSpell>> getCharacterSpells(int characterId) async {
    final client = Supabase.instance.client;
    final response = await client
        .from('character_spells')
        .select()
        .eq('character_id', characterId);
    return response.map((m) => CharacterSpell.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
  }

  Future<int> insertCharacterSpell(CharacterSpellsCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final response = await client
        .from('character_spells')
        .insert(map)
        .select('id')
        .single();
    return response['id'] as int;
  }

  Future<int> deleteCharacterSpell(int id) async {
    final client = Supabase.instance.client;
    await client
        .from('character_spells')
        .delete()
        .eq('id', id);
    return 1;
  }

  Future<bool> updateCharacterSpell(CharacterSpellsCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final id = companion.id.value;
    await client
        .from('character_spells')
        .update(map)
        .eq('id', id);
    return true;
  }

  // ── Spell slots ──────────────────────────────────────────

  Stream<List<CharacterSpellSlot>> watchSpellSlots(int characterId) {
    final client = Supabase.instance.client;
    return client
        .from('character_spell_slots')
        .stream(primaryKey: ['id'])
        .eq('character_id', characterId)
        .map((list) {
          final slots = list.map((m) => CharacterSpellSlot.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
          slots.sort((a, b) => a.slotLevel.compareTo(b.slotLevel));
          return slots;
        });
  }

  Future<void> replaceAllSpellSlots(
      int characterId, List<CharacterSpellSlotsCompanion> slots) async {
    final client = Supabase.instance.client;
    await client
        .from('character_spell_slots')
        .delete()
        .eq('character_id', characterId);

    if (slots.isNotEmpty) {
      final maps = slots.map((s) => SupabaseMapper.insertableToMap(s)).toList();
      await client.from('character_spell_slots').insert(maps);
    }
  }

  Future<bool> updateSpellSlot(CharacterSpellSlotsCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final id = companion.id.value;
    await client
        .from('character_spell_slots')
        .update(map)
        .eq('id', id);
    return true;
  }

  // ── Resources ────────────────────────────────────────────

  Stream<List<CharacterResource>> watchResources(int characterId) {
    final client = Supabase.instance.client;
    return client
        .from('character_resources')
        .stream(primaryKey: ['id'])
        .eq('character_id', characterId)
        .map((list) {
          return list.map((m) => CharacterResource.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
        });
  }

  Future<int> upsertResource(CharacterResourcesCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    
    final charId = companion.characterId.value;
    final resName = companion.resourceName.value;
    final existing = await client
        .from('character_resources')
        .select('id')
        .eq('character_id', charId)
        .eq('resource_name', resName)
        .maybeSingle();

    if (existing != null) {
      await client
          .from('character_resources')
          .update(map)
          .eq('id', existing['id']);
      return existing['id'] as int;
    } else {
      final response = await client
          .from('character_resources')
          .insert(map)
          .select('id')
          .single();
      return response['id'] as int;
    }
  }

  Future<void> deleteResource(int id) async {
    final client = Supabase.instance.client;
    await client.from('character_resources').delete().eq('id', id);
  }

  Future<void> clearConcentration(int characterId) async {
    final client = Supabase.instance.client;
    await client
        .from('character_resources')
        .delete()
        .eq('character_id', characterId)
        .like('resource_name', 'active_concentration_%');
  }

  Future<void> replaceAllResources(
      int characterId, List<CharacterResourcesCompanion> resources) async {
    final client = Supabase.instance.client;
    await client
        .from('character_resources')
        .delete()
        .eq('character_id', characterId);

    if (resources.isNotEmpty) {
      final maps = resources.map((r) => SupabaseMapper.insertableToMap(r)).toList();
      await client.from('character_resources').insert(maps);
    }
  }

  // ── Attacks ──────────────────────────────────────────────

  Stream<List<CharacterAttack>> watchAttacks(int characterId) {
    final client = Supabase.instance.client;
    return client
        .from('character_attacks')
        .stream(primaryKey: ['id'])
        .eq('character_id', characterId)
        .map((list) {
          return list.map((m) => CharacterAttack.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
        });
  }

  Future<int> insertAttack(CharacterAttacksCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final response = await client
        .from('character_attacks')
        .insert(map)
        .select('id')
        .single();
    return response['id'] as int;
  }

  Future<bool> updateAttack(CharacterAttacksCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final id = companion.id.value;
    await client
        .from('character_attacks')
        .update(map)
        .eq('id', id);
    return true;
  }

  Future<int> deleteAttack(int id) async {
    final client = Supabase.instance.client;
    await client
        .from('character_attacks')
        .delete()
        .eq('id', id);
    return 1;
  }

  // ── Equipment ────────────────────────────────────────────

  Stream<List<CharacterEquipmentData>> watchEquipment(int characterId) {
    final client = Supabase.instance.client;
    return client
        .from('character_equipment')
        .stream(primaryKey: ['id'])
        .eq('character_id', characterId)
        .map((list) {
          return list.map((m) => CharacterEquipmentData.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
        });
  }

  Future<int> insertEquipment(CharacterEquipmentCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final response = await client
        .from('character_equipment')
        .insert(map)
        .select('id')
        .single();
    return response['id'] as int;
  }

  Future<bool> updateEquipment(CharacterEquipmentCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final id = companion.id.value;
    await client
        .from('character_equipment')
        .update(map)
        .eq('id', id);
    return true;
  }

  Future<int> deleteEquipment(int id) async {
    final client = Supabase.instance.client;
    await client
        .from('character_equipment')
        .delete()
        .eq('id', id);
    return 1;
  }

  // ── Feats ──────────────────────────────────────────────

  Stream<List<CharacterFeat>> watchCharacterFeats(int characterId) {
    final client = Supabase.instance.client;
    return client
        .from('character_feats')
        .stream(primaryKey: ['id'])
        .eq('character_id', characterId)
        .map((list) {
          return list.map((m) => CharacterFeat.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
        });
  }

  Future<List<CharacterFeat>> getCharacterFeats(int characterId) async {
    final client = Supabase.instance.client;
    final response = await client
        .from('character_feats')
        .select()
        .eq('character_id', characterId);
    return response.map((m) => CharacterFeat.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
  }

  Future<int> insertCharacterFeat(CharacterFeatsCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final response = await client
        .from('character_feats')
        .insert(map)
        .select('id')
        .single();
    return response['id'] as int;
  }

  Future<void> deleteCharacterFeat(int characterId, String featId) async {
    final client = Supabase.instance.client;
    await client
        .from('character_feats')
        .delete()
        .eq('character_id', characterId)
        .eq('feat_id', featId);
  }

  // ── Notes & Journal ──────────────────────────────────────

  Stream<List<CharacterNote>> watchCharacterNotes(int characterId) {
    final client = Supabase.instance.client;
    return client
        .from('character_notes')
        .stream(primaryKey: ['id'])
        .eq('character_id', characterId)
        .map((list) {
          final notes = list
              .map((m) => CharacterNote.fromJson(SupabaseMapper.toCamelCaseMap(m)))
              .toList();
          notes.sort((a, b) {
            if (a.isPinned != b.isPinned) {
              return a.isPinned ? -1 : 1;
            }
            return b.updatedAt.compareTo(a.updatedAt);
          });
          return notes;
        });
  }
  Future<List<CharacterNote>> getCharacterNotes(int characterId) async {
    final client = Supabase.instance.client;
    final response = await client
        .from('character_notes')
        .select()
        .eq('character_id', characterId);
    final notes = response
        .map((m) => CharacterNote.fromJson(SupabaseMapper.toCamelCaseMap(m)))
        .toList();
    notes.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return notes;
  }

  Future<int> insertNote(Map<String, dynamic> map) async {
    final client = Supabase.instance.client;
    final response = await client
        .from('character_notes')
        .insert(map)
        .select('id')
        .single();
    return response['id'] as int;
  }

  Future<bool> updateNote(int id, Map<String, dynamic> map) async {
    final client = Supabase.instance.client;
    await client
        .from('character_notes')
        .update(map)
        .eq('id', id);
    return true;
  }

  Future<int> deleteNote(int id) async {
    final client = Supabase.instance.client;
    await client
        .from('character_notes')
        .delete()
        .eq('id', id);
    return 1;
  }
}
