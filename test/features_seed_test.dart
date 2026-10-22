import 'package:dnd_character_manager/core/database/app_database.dart';
import 'package:dnd_character_manager/core/database/tables/tables.dart';
import 'package:dnd_character_manager/core/seed/srd_seeder.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Seed des capacités : 2014 + 2024, traduit, sans doublon au re-seed',
    () async {
      SharedPreferences.setMockInitialValues({});
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      try {
        await db.customSelect('select 1').get();
      } on ArgumentError {
        markTestSkipped('libsqlite3 indisponible dans cet environnement');
        return;
      }

      await SrdSeeder(db).seedIfNeeded();
      final f24 = await db.compendiumDao.getAllFeatures(RulesetVersion.dnd2024);
      final f14 = await db.compendiumDao.getAllFeatures(RulesetVersion.dnd2014);
      expect(f24.length, 232);
      expect(f14, isNotEmpty);
      expect(f14.any((f) => f.name.startsWith('Fighting Style: ')), isFalse);
    expect(f14.firstWhere((f) => f.srdIndex == 'second-wind').name, 'Second souffle');

      final secondWind = f24.firstWhere(
        (f) => f.srdIndex == 'fighter-second-wind',
      );
      expect(secondWind.name, 'Second souffle');
      expect(secondWind.description, contains('Guerrier'));

      // Version déjà enregistrée : pas de ré-import.
      await SrdSeeder(db).seedIfNeeded();
      expect(
        (await db.compendiumDao.getAllFeatures(RulesetVersion.dnd2024)).length,
        232,
      );

      // Version obsolète : remplacement complet, sans doublon.
      SharedPreferences.setMockInitialValues({'srd_features_seed_version': 0});
      await SrdSeeder(db).seedIfNeeded();
      expect(
        (await db.compendiumDao.getAllFeatures(RulesetVersion.dnd2024)).length,
        232,
      );
      expect(
        (await db.compendiumDao.getAllFeatures(RulesetVersion.dnd2014)).length,
        f14.length,
      );
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
