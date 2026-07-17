import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'compendium_dao.g.dart';

@DriftAccessor(tables: [
  SrdSpells,
  SrdClasses,
  SrdSubclasses,
  SrdRaces,
  SrdSubraces,
  SrdBackgrounds,
  SrdFeatures,
  SrdFeats,
  SrdWeaponMasteries,
])
class CompendiumDao extends DatabaseAccessor<AppDatabase>
    with _$CompendiumDaoMixin {
  CompendiumDao(super.db);

  // ── Spells ──────────────────────────────────────────────

  Future<List<SrdSpell>> getAllSpells(RulesetVersion ruleset) =>
      (select(srdSpells)
            ..where((s) => s.ruleset.equalsValue(ruleset))
            ..orderBy([(s) => OrderingTerm.asc(s.name)]))
          .get();

  Future<List<SrdSpell>> searchSpells(
    RulesetVersion ruleset, {
    String? query,
    int? level,
    String? school,
    String? classId,
  }) {
    final q = select(srdSpells)
      ..where((s) => s.ruleset.equalsValue(ruleset));
    if (query != null && query.isNotEmpty) {
      q.where((s) => s.name.like('%$query%'));
    }
    if (level != null) {
      q.where((s) => s.level.equals(level));
    }
    if (school != null && school.isNotEmpty) {
      q.where((s) => s.school.equals(school));
    }
    // classId filtering is done in-memory (stored as JSON array)
    return q.get();
  }

  Future<SrdSpell?> getSpellById(String id, RulesetVersion ruleset) =>
      (select(srdSpells)
            ..where((s) => s.id.equals(id) & s.ruleset.equalsValue(ruleset)))
          .getSingleOrNull();

  Future<int> upsertSpell(SrdSpellsCompanion spell) =>
      into(srdSpells).insertOnConflictUpdate(spell);

  Future<void> insertAllSpells(List<SrdSpellsCompanion> spells) =>
      batch((b) => b.insertAllOnConflictUpdate(srdSpells, spells));

  // ── Classes ─────────────────────────────────────────────

  Future<List<SrdClassesData>> getClasses(RulesetVersion ruleset) =>
      (select(srdClasses)
            ..where((c) => c.ruleset.equalsValue(ruleset))
            ..orderBy([(c) => OrderingTerm.asc(c.name)]))
          .get();

  Future<SrdClassesData?> getClassById(String id, RulesetVersion ruleset) =>
      (select(srdClasses)
            ..where((c) => c.id.equals(id) & c.ruleset.equalsValue(ruleset)))
          .getSingleOrNull();

  Future<void> insertAllClasses(List<SrdClassesCompanion> classes) =>
      batch((b) => b.insertAllOnConflictUpdate(srdClasses, classes));

  // ── Subclasses ───────────────────────────────────────────

  Future<List<SrdSubclassesData>> getSubclasses(
          String classId, RulesetVersion ruleset) =>
      (select(srdSubclasses)
            ..where((s) =>
                s.classId.equals(classId) & s.ruleset.equalsValue(ruleset))
            ..orderBy([(s) => OrderingTerm.asc(s.name)]))
          .get();

  Future<void> insertAllSubclasses(List<SrdSubclassesCompanion> subclasses) =>
      batch((b) => b.insertAllOnConflictUpdate(srdSubclasses, subclasses));

  // ── Races / Species ──────────────────────────────────────

  Future<List<SrdRace>> getRaces(RulesetVersion ruleset) =>
      (select(srdRaces)
            ..where((r) => r.ruleset.equalsValue(ruleset))
            ..orderBy([(r) => OrderingTerm.asc(r.name)]))
          .get();

  Future<SrdRace?> getRaceById(String id, RulesetVersion ruleset) =>
      (select(srdRaces)
            ..where((r) => r.id.equals(id) & r.ruleset.equalsValue(ruleset)))
          .getSingleOrNull();

  Future<void> insertAllRaces(List<SrdRacesCompanion> races) =>
      batch((b) => b.insertAllOnConflictUpdate(srdRaces, races));

  // ── Subraces / Subspecies ────────────────────────────────

  Future<List<SrdSubrace>> getSubraces(
          String raceId, RulesetVersion ruleset) =>
      (select(srdSubraces)
            ..where((s) =>
                s.raceId.equals(raceId) & s.ruleset.equalsValue(ruleset))
            ..orderBy([(s) => OrderingTerm.asc(s.name)]))
          .get();

  Future<void> insertAllSubraces(List<SrdSubracesCompanion> subraces) =>
      batch((b) => b.insertAllOnConflictUpdate(srdSubraces, subraces));

  // ── Backgrounds ──────────────────────────────────────────

  Future<List<SrdBackground>> getBackgrounds(RulesetVersion ruleset) =>
      (select(srdBackgrounds)
            ..where((b) => b.ruleset.equalsValue(ruleset))
            ..orderBy([(b) => OrderingTerm.asc(b.name)]))
          .get();

  Future<SrdBackground?> getBackgroundById(String id, RulesetVersion ruleset) =>
      (select(srdBackgrounds)
            ..where((b) => b.id.equals(id) & b.ruleset.equalsValue(ruleset)))
          .getSingleOrNull();

  Future<void> insertAllBackgrounds(
          List<SrdBackgroundsCompanion> backgrounds) =>
      batch((b) => b.insertAllOnConflictUpdate(srdBackgrounds, backgrounds));


  // ── Features ─────────────────────────────────────────────

  Future<List<SrdFeature>> getFeaturesForClass(
          String classId, RulesetVersion ruleset, int level) =>
      (select(srdFeatures)
            ..where((f) =>
                f.classId.equals(classId) &
                f.ruleset.equalsValue(ruleset) &
                f.level.isSmallerOrEqualValue(level)))
          .get();

  Future<List<SrdFeature>> getFeaturesUnlockedAtLevel(
          String classId, RulesetVersion ruleset, int level) =>
      (select(srdFeatures)
            ..where((f) =>
                f.classId.equals(classId) &
                f.ruleset.equalsValue(ruleset) &
                f.level.equals(level)))
          .get();

  Future<void> insertAllFeatures(List<SrdFeaturesCompanion> features) =>
      batch((b) => b.insertAll(srdFeatures, features,
          mode: InsertMode.insertOrIgnore));

  // ── Seed check ───────────────────────────────────────────

  Future<bool> isSeeded(RulesetVersion ruleset) async {
    final countSpells = await (select(srdSpells)
          ..where((s) => s.ruleset.equalsValue(ruleset)))
        .get();
    if (ruleset == RulesetVersion.dnd2024) {
      final countFeats = await select(srdFeats).get();
      final countBgs = await (select(srdBackgrounds)
            ..where((b) => b.ruleset.equalsValue(ruleset)))
          .get();
      final countRaces = await (select(srdRaces)
            ..where((r) => r.ruleset.equalsValue(ruleset)))
          .get();
      return countSpells.isNotEmpty &&
             countFeats.isNotEmpty &&
             countBgs.length >= 16 &&
             countRaces.length >= 10;
    }
    return countSpells.isNotEmpty;
  }

  // ── Feats ──────────────────────────────────────────────

  Future<List<SrdFeat>> getAllFeats(RulesetVersion ruleset) =>
      (select(srdFeats)
            ..where((f) => f.ruleset.equalsValue(ruleset))
            ..orderBy([(f) => OrderingTerm.asc(f.name)]))
          .get();

  Future<SrdFeat?> getFeatById(String id, RulesetVersion ruleset) =>
      (select(srdFeats)
            ..where((f) => f.id.equals(id) & f.ruleset.equalsValue(ruleset)))
          .getSingleOrNull();

  Future<void> insertAllFeats(List<SrdFeatsCompanion> feats) =>
      batch((b) => b.insertAllOnConflictUpdate(srdFeats, feats));

  // ── Weapon Masteries ───────────────────────────────────

  Future<List<SrdWeaponMastery>> getAllWeaponMasteries() =>
      select(srdWeaponMasteries).get();

  Future<SrdWeaponMastery?> getWeaponMasteryById(String id) =>
      (select(srdWeaponMasteries)..where((w) => w.id.equals(id))).getSingleOrNull();

  Future<void> insertAllWeaponMasteries(List<SrdWeaponMasteriesCompanion> masteries) =>
      batch((b) => b.insertAllOnConflictUpdate(srdWeaponMasteries, masteries));
}
