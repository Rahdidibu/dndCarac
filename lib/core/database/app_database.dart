import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/tables.dart';
import 'daos/compendium_dao.dart';
import 'daos/character_dao.dart';
import 'daos/batman_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    // Compendium
    SrdSpells,
    SrdClasses,
    SrdSubclasses,
    SrdRaces,
    SrdSubraces,
    SrdBackgrounds,
    SrdFeatures,
    SrdFeats,
    SrdWeaponMasteries,
    // Batman RPG compendium
    BatmanProfiles,
    BatmanWays,
    // User data
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
    // Batman user data
    BatmanCharacters,
    BatmanCharacterWays,
    // Settings
    AppSettings,
  ],
  daos: [
    CompendiumDao,
    CharacterDao,
    BatmanDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(batmanProfiles);
        await migrator.createTable(batmanWays);
        await migrator.createTable(batmanCharacters);
        await migrator.createTable(batmanCharacterWays);
      }
      if (from < 3) {
        await migrator.createTable(srdFeats);
        await migrator.createTable(srdWeaponMasteries);
        await migrator.createTable(characterFeats);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'dnd_character_manager',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
