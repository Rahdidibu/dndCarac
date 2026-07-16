import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

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

  Stream<List<Character>> watchAllCharacters() =>
      (select(characters)..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
          .watch();

  Future<Character?> getCharacterById(int id) =>
      (select(characters)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> insertCharacter(CharactersCompanion companion) =>
      into(characters).insert(companion);

  Future<bool> updateCharacter(CharactersCompanion companion) =>
      (update(characters)..where((c) => c.id.equals(companion.id.value)))
          .write(companion)
          .then((count) => count > 0);

  Future<int> deleteCharacter(int id) =>
      (delete(characters)..where((c) => c.id.equals(id))).go();

  // ── Character classes (multiclass) ───────────────────────

  Future<List<CharacterClassesData>> getCharacterClasses(int characterId) =>
      (select(characterClasses)
            ..where((cc) => cc.characterId.equals(characterId)))
          .get();

  Stream<List<CharacterClassesData>> watchCharacterClasses(int characterId) =>
      (select(characterClasses)
            ..where((cc) => cc.characterId.equals(characterId)))
          .watch();

  Future<int> insertCharacterClass(CharacterClassesCompanion companion) =>
      into(characterClasses).insert(companion);

  Future<bool> updateCharacterClass(CharacterClassesCompanion companion) =>
      (update(characterClasses)..where((cc) => cc.id.equals(companion.id.value))).write(companion).then((count) => count > 0);

  Future<int> deleteCharacterClass(int id) =>
      (delete(characterClasses)..where((cc) => cc.id.equals(id))).go();

  // ── Ability scores ───────────────────────────────────────

  Future<CharacterAbilityScore?> getAbilityScores(int characterId) =>
      (select(characterAbilityScores)
            ..where((a) => a.characterId.equals(characterId)))
          .getSingleOrNull();

  Future<int> upsertAbilityScores(
          CharacterAbilityScoresCompanion companion) =>
      into(characterAbilityScores).insertOnConflictUpdate(companion);

  // ── Proficiencies ────────────────────────────────────────

  Future<List<CharacterProficiency>> getProficiencies(int characterId) =>
      (select(characterProficiencies)
            ..where((p) => p.characterId.equals(characterId)))
          .get();

  Future<int> insertProficiency(CharacterProficienciesCompanion companion) =>
      into(characterProficiencies).insert(companion);

  Future<void> deleteProficiency(int characterId, String key) =>
      (delete(characterProficiencies)
            ..where((p) =>
                p.characterId.equals(characterId) &
                p.proficiencyKey.equals(key)))
          .go();

  Future<void> replaceAllProficiencies(
      int characterId, List<CharacterProficienciesCompanion> companions) async {
    await (delete(characterProficiencies)
          ..where((p) => p.characterId.equals(characterId)))
        .go();
    await batch(
        (b) => b.insertAll(characterProficiencies, companions));
  }

  // ── Spells ───────────────────────────────────────────────

  Stream<List<CharacterSpell>> watchCharacterSpells(int characterId) =>
      (select(characterSpells)
            ..where((s) => s.characterId.equals(characterId)))
          .watch();

  Future<List<CharacterSpell>> getCharacterSpells(int characterId) =>
      (select(characterSpells)
            ..where((s) => s.characterId.equals(characterId)))
          .get();

  Future<int> insertCharacterSpell(CharacterSpellsCompanion companion) =>
      into(characterSpells).insert(companion);

  Future<int> deleteCharacterSpell(int id) =>
      (delete(characterSpells)..where((s) => s.id.equals(id))).go();

  Future<bool> updateCharacterSpell(CharacterSpellsCompanion companion) =>
      update(characterSpells).replace(companion);

  // ── Spell slots ──────────────────────────────────────────

  Stream<List<CharacterSpellSlot>> watchSpellSlots(int characterId) =>
      (select(characterSpellSlots)
            ..where((s) => s.characterId.equals(characterId))
            ..orderBy([(s) => OrderingTerm.asc(s.slotLevel)]))
          .watch();

  Future<void> replaceAllSpellSlots(
      int characterId, List<CharacterSpellSlotsCompanion> slots) async {
    await (delete(characterSpellSlots)
          ..where((s) => s.characterId.equals(characterId)))
        .go();
    await batch((b) => b.insertAll(characterSpellSlots, slots));
  }

  Future<bool> updateSpellSlot(CharacterSpellSlotsCompanion companion) =>
      update(characterSpellSlots).replace(companion);

  // ── Resources ────────────────────────────────────────────

  Stream<List<CharacterResource>> watchResources(int characterId) =>
      (select(characterResources)
            ..where((r) => r.characterId.equals(characterId)))
          .watch();

  Future<int> upsertResource(CharacterResourcesCompanion companion) =>
      into(characterResources).insertOnConflictUpdate(companion);

  Future<void> replaceAllResources(
      int characterId, List<CharacterResourcesCompanion> resources) async {
    await (delete(characterResources)
          ..where((r) => r.characterId.equals(characterId)))
        .go();
    await batch((b) => b.insertAll(characterResources, resources));
  }

  // ── Attacks ──────────────────────────────────────────────

  Stream<List<CharacterAttack>> watchAttacks(int characterId) =>
      (select(characterAttacks)
            ..where((a) => a.characterId.equals(characterId)))
          .watch();

  Future<int> insertAttack(CharacterAttacksCompanion companion) =>
      into(characterAttacks).insert(companion);

  Future<bool> updateAttack(CharacterAttacksCompanion companion) =>
      update(characterAttacks).replace(companion);

  Future<int> deleteAttack(int id) =>
      (delete(characterAttacks)..where((a) => a.id.equals(id))).go();

  // ── Equipment ────────────────────────────────────────────

  Stream<List<CharacterEquipmentData>> watchEquipment(int characterId) =>
      (select(characterEquipment)
            ..where((e) => e.characterId.equals(characterId)))
          .watch();

  Future<int> insertEquipment(CharacterEquipmentCompanion companion) =>
      into(characterEquipment).insert(companion);

  Future<bool> updateEquipment(CharacterEquipmentCompanion companion) =>
      update(characterEquipment).replace(companion);

  Future<int> deleteEquipment(int id) =>
      (delete(characterEquipment)..where((e) => e.id.equals(id))).go();

  // ── Feats ──────────────────────────────────────────────

  Stream<List<CharacterFeat>> watchCharacterFeats(int characterId) =>
      (select(characterFeats)
            ..where((f) => f.characterId.equals(characterId)))
          .watch();

  Future<List<CharacterFeat>> getCharacterFeats(int characterId) =>
      (select(characterFeats)
            ..where((f) => f.characterId.equals(characterId)))
          .get();

  Future<int> insertCharacterFeat(CharacterFeatsCompanion companion) =>
      into(characterFeats).insert(companion);

  Future<void> deleteCharacterFeat(int characterId, String featId) =>
      (delete(characterFeats)
            ..where((f) =>
                f.characterId.equals(characterId) & f.featId.equals(featId)))
          .go();
}
