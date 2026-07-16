import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_database.dart';
import '../tables/tables.dart';
import '../../utils/supabase_mapper.dart';

part 'batman_dao.g.dart';

@DriftAccessor(tables: [
  BatmanProfiles,
  BatmanWays,
  BatmanCharacters,
  BatmanCharacterWays,
])
class BatmanDao extends DatabaseAccessor<AppDatabase> with _$BatmanDaoMixin {
  BatmanDao(super.db);

  // ── Profiles ─────────────────────────────────────────────

  Future<List<BatmanProfile>> getAllProfiles() => select(batmanProfiles).get();

  Future<BatmanProfile?> getProfileById(String id) =>
      (select(batmanProfiles)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<int> upsertProfile(BatmanProfilesCompanion companion) =>
      into(batmanProfiles).insertOnConflictUpdate(companion);

  // ── Ways ─────────────────────────────────────────────────

  Future<List<BatmanWay>> getAllWays() => select(batmanWays).get();

  Future<BatmanWay?> getWayById(String id) =>
      (select(batmanWays)..where((w) => w.id.equals(id))).getSingleOrNull();

  Future<int> upsertWay(BatmanWaysCompanion companion) =>
      into(batmanWays).insertOnConflictUpdate(companion);

  // ── Batman Characters ─────────────────────────────────────

  Future<BatmanCharacter?> getBatmanCharacter(int characterId) async {
    final client = Supabase.instance.client;
    final response = await client
        .from('batman_characters')
        .select()
        .eq('character_id', characterId)
        .maybeSingle();
    if (response == null) return null;
    return BatmanCharacter.fromJson(SupabaseMapper.toCamelCaseMap(response));
  }

  Stream<BatmanCharacter?> watchBatmanCharacter(int characterId) {
    final client = Supabase.instance.client;
    return client
        .from('batman_characters')
        .stream(primaryKey: ['id'])
        .eq('character_id', characterId)
        .map((list) {
          if (list.isEmpty) return null;
          return BatmanCharacter.fromJson(SupabaseMapper.toCamelCaseMap(list.first));
        });
  }

  Future<int> upsertBatmanCharacter(BatmanCharactersCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final charId = companion.characterId.value;

    final existing = await client
        .from('batman_characters')
        .select('id')
        .eq('character_id', charId)
        .maybeSingle();

    if (existing != null) {
      await client
          .from('batman_characters')
          .update(map)
          .eq('character_id', charId);
      return existing['id'] as int;
    } else {
      final response = await client
          .from('batman_characters')
          .insert(map)
          .select('id')
          .single();
      return response['id'] as int;
    }
  }

  Future<bool> updateBatmanCharacter(BatmanCharactersCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final charId = companion.characterId.value;
    await client
        .from('batman_characters')
        .update(map)
        .eq('character_id', charId);
    return true;
  }

  // ── Character Ways ────────────────────────────────────────

  Future<List<BatmanCharacterWay>> getCharacterWays(int characterId) async {
    final client = Supabase.instance.client;
    final response = await client
        .from('batman_character_ways')
        .select()
        .eq('character_id', characterId);
    return response.map((m) => BatmanCharacterWay.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
  }

  Stream<List<BatmanCharacterWay>> watchCharacterWays(int characterId) {
    final client = Supabase.instance.client;
    return client
        .from('batman_character_ways')
        .stream(primaryKey: ['id'])
        .eq('character_id', characterId)
        .map((list) {
          return list.map((m) => BatmanCharacterWay.fromJson(SupabaseMapper.toCamelCaseMap(m))).toList();
        });
  }

  Future<int> insertCharacterWay(BatmanCharacterWaysCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final response = await client
        .from('batman_character_ways')
        .insert(map)
        .select('id')
        .single();
    return response['id'] as int;
  }

  Future<bool> updateCharacterWay(BatmanCharacterWaysCompanion companion) async {
    final client = Supabase.instance.client;
    final map = SupabaseMapper.insertableToMap(companion);
    final id = companion.id.value;
    await client
        .from('batman_character_ways')
        .update(map)
        .eq('id', id);
    return true;
  }

  Future<int> deleteCharacterWay(int id) async {
    final client = Supabase.instance.client;
    await client
        .from('batman_character_ways')
        .delete()
        .eq('id', id);
    return 1;
  }

  Future<void> replaceAllCharacterWays(
      int characterId, List<BatmanCharacterWaysCompanion> ways) async {
    final client = Supabase.instance.client;
    await client
        .from('batman_character_ways')
        .delete()
        .eq('character_id', characterId);

    if (ways.isNotEmpty) {
      final maps = ways.map((w) => SupabaseMapper.insertableToMap(w)).toList();
      await client.from('batman_character_ways').insert(maps);
    }
  }

  // ── Seed check ────────────────────────────────────────────

  Future<bool> isSeeded() async {
    final count = await (select(batmanProfiles)).get();
    return count.isNotEmpty;
  }
}

