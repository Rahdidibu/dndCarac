import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

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

  Future<BatmanCharacter?> getBatmanCharacter(int characterId) =>
      (select(batmanCharacters)
            ..where((bc) => bc.characterId.equals(characterId)))
          .getSingleOrNull();

  Stream<BatmanCharacter?> watchBatmanCharacter(int characterId) =>
      (select(batmanCharacters)
            ..where((bc) => bc.characterId.equals(characterId)))
          .watchSingleOrNull();

  Future<int> upsertBatmanCharacter(BatmanCharactersCompanion companion) =>
      into(batmanCharacters).insertOnConflictUpdate(companion);

  Future<bool> updateBatmanCharacter(BatmanCharactersCompanion companion) =>
      (update(batmanCharacters)
            ..where((bc) => bc.characterId.equals(companion.characterId.value)))
          .write(companion)
          .then((count) => count > 0);

  // ── Character Ways ────────────────────────────────────────

  Future<List<BatmanCharacterWay>> getCharacterWays(int characterId) =>
      (select(batmanCharacterWays)
            ..where((cw) => cw.characterId.equals(characterId)))
          .get();

  Stream<List<BatmanCharacterWay>> watchCharacterWays(int characterId) =>
      (select(batmanCharacterWays)
            ..where((cw) => cw.characterId.equals(characterId)))
          .watch();

  Future<int> insertCharacterWay(BatmanCharacterWaysCompanion companion) =>
      into(batmanCharacterWays).insert(companion);

  Future<bool> updateCharacterWay(BatmanCharacterWaysCompanion companion) =>
      (update(batmanCharacterWays)
            ..where((cw) => cw.id.equals(companion.id.value)))
          .write(companion)
          .then((count) => count > 0);

  Future<int> deleteCharacterWay(int id) =>
      (delete(batmanCharacterWays)..where((cw) => cw.id.equals(id))).go();

  Future<void> replaceAllCharacterWays(
      int characterId, List<BatmanCharacterWaysCompanion> ways) async {
    await (delete(batmanCharacterWays)
          ..where((cw) => cw.characterId.equals(characterId)))
        .go();
    if (ways.isNotEmpty) {
      await batch((b) => b.insertAll(batmanCharacterWays, ways));
    }
  }

  // ── Seed check ────────────────────────────────────────────

  Future<bool> isSeeded() async {
    final count = await (select(batmanProfiles)).get();
    return count.isNotEmpty;
  }
}

