import 'dart:convert';
import 'dart:io';

import 'package:dnd_character_manager/core/database/app_database.dart';
import 'package:dnd_character_manager/core/database/tables/tables.dart';
import 'package:dnd_character_manager/core/utils/class_orders.dart';
import 'package:dnd_character_manager/core/utils/dnd_rules.dart';
import 'package:dnd_character_manager/core/utils/feature_rules.dart';
import 'package:flutter_test/flutter_test.dart';

List<SrdFeature> _load(RulesetVersion ruleset, String path) {
  final list = json.decode(File(path).readAsStringSync()) as List;
  var id = 0;
  return list
      .where(
        (f) =>
            ruleset != RulesetVersion.dnd2014 ||
            !FeatureRules.isHidden2014Source(
              f['name'] as String,
              f['subclass']?['index'] as String?,
            ),
      )
      .map(
        (f) => SrdFeature(
          id: id++,
          srdIndex: f['index'] as String,
          ruleset: ruleset,
          name: f['name'] as String,
          classId: f['class']?['index'] as String?,
          subclassId: f['subclass']?['index'] as String?,
          level: f['level'] as int,
          description: (f['desc'] as List).join('\n'),
        ),
      )
      .toList();
}

int _max(List<ClassResourceSpec> specs, String key) =>
    specs.where((s) => s.key == key).map((s) => s.maximum).firstOrNull ?? 0;

void main() {
  const d14 = RulesetVersion.dnd2014;
  const d24 = RulesetVersion.dnd2024;

  group('classResourceByLevel', () {
    test(
      'Barbare : 2 rages au niveau 1, 4 au niveau 9, illimité au 20 (2014)',
      () {
        expect(
          _max(
            DndRules.classResourceByLevel('barbarian', 1, d14),
            'resourceRage',
          ),
          2,
        );
        expect(
          _max(
            DndRules.classResourceByLevel('barbarian', 9, d14),
            'resourceRage',
          ),
          4,
        );
        expect(
          _max(
            DndRules.classResourceByLevel('barbarian', 20, d14),
            'resourceRage',
          ),
          DndRules.unlimitedResource,
        );
        expect(
          _max(
            DndRules.classResourceByLevel('barbarian', 20, d24),
            'resourceRage',
          ),
          6,
        );
      },
    );

    test('Moine : pas de ki au niveau 1, 2 points au niveau 2', () {
      expect(DndRules.classResourceByLevel('monk', 1, d14), isEmpty);
      expect(
        _max(DndRules.classResourceByLevel('monk', 2, d14), 'resourceKi'),
        2,
      );
      expect(
        _max(DndRules.classResourceByLevel('monk', 2, d24), 'resourceKi'),
        2,
      );
    });

    test('Guerrier : Fougue dès le niveau 2, deux utilisations au 17', () {
      expect(
        _max(
          DndRules.classResourceByLevel('fighter', 1, d24),
          'resourceActionSurge',
        ),
        0,
      );
      expect(
        _max(
          DndRules.classResourceByLevel('fighter', 2, d24),
          'resourceActionSurge',
        ),
        1,
      );
      expect(
        _max(
          DndRules.classResourceByLevel('fighter', 17, d14),
          'resourceActionSurge',
        ),
        2,
      );
      expect(
        _max(
          DndRules.classResourceByLevel('fighter', 4, d24),
          'resourceSecondWind',
        ),
        3,
      );
    });

    test('Classe sans ressource limitée', () {
      expect(DndRules.classResourceByLevel('wizard', 10, d24), isEmpty);
    });

    // Cohérence avec le SRD 5.2 généré dans assets/data/2024/levels.json.
    test('2024 : conforme à levels.json', () {
      final levels =
          json.decode(File('assets/data/2024/levels.json').readAsStringSync())
              as List;
      const mapping = {
        'rage_count': 'resourceRage',
        'focus_points': 'resourceKi',
        'sorcery_points': 'resourceSorceryPoints',
        'channel_divinity_charges': 'resourceChannelDivinity',
        'wild_shape_uses': 'resourceWildShape',
        'second_wind_uses': 'resourceSecondWind',
      };
      for (final l in levels) {
        final cs = (l['class_specific'] as Map).cast<String, dynamic>();
        final specs = DndRules.classResourceByLevel(
          l['class']['index'] as String,
          l['level'] as int,
          d24,
        );
        for (final e in mapping.entries) {
          final expected = cs[e.key];
          if (expected == null) continue;
          expect(
            _max(specs, e.value),
            expected,
            reason: '${l['index']} ${e.key}',
          );
        }
      }
    });
  });

  group('ClassOrders', () {
    test('ordre choisi selon la classe', () {
      expect(
        ClassOrders.chosenFor(
          'cleric',
          divineOrder: 'protector',
          primalOrder: 'warden',
        ),
        'protector',
      );
      expect(
        ClassOrders.chosenFor(
          'druid',
          divineOrder: 'protector',
          primalOrder: 'warden',
        ),
        'warden',
      );
      expect(
        ClassOrders.chosenFor(
          'fighter',
          divineOrder: 'protector',
          primalOrder: 'warden',
        ),
        isNull,
      );
    });

    test('options et maîtrises', () {
      expect(ClassOrders.find('cleric', 'thaumaturge')?.name, 'Thaumaturge');
      expect(ClassOrders.find('druid', 'protector'), isNull);
      expect(ClassOrders.find('druid', null), isNull);
      expect(ClassOrders.proficiencyKeys('protector'), [
        'armor_heavy',
        'weapon_martial',
      ]);
      expect(ClassOrders.proficiencyKeys('warden'), [
        'armor_medium',
        'weapon_martial',
      ]);
      expect(ClassOrders.proficiencyKeys('magician'), isEmpty);
    });
  });

  group('Traductions françaises', () {
    final fr =
        json.decode(File('assets/data/features_fr.json').readAsStringSync())
            as Map<String, dynamic>;

    for (final (year, path) in [
      ('2014', 'assets/data/2014/features.json'),
      ('2024', 'assets/data/2024/features.json'),
    ]) {
      test('$year : toutes les capacités importées sont traduites', () {
        final translations = fr[year] as Map<String, dynamic>;
        final ruleset = year == '2014' ? d14 : d24;
        for (final f in _load(ruleset, path)) {
          final tr = translations[f.srdIndex] as Map<String, dynamic>?;
          expect(tr, isNotNull, reason: f.srdIndex);
          final src = f.description.split('\n').length;
          expect((tr!['desc'] as List).length, src, reason: f.srdIndex);
          expect((tr['name'] as String).trim(), isNotEmpty, reason: f.srdIndex);
        }
      });
    }

    test('2014 : les variantes traduites restent regroupées (Fougue)', () {
      final tr = fr['2014'] as Map<String, dynamic>;
      final translated = _load(d14, 'assets/data/2014/features.json')
          .map(
            (f) => SrdFeature(
              id: f.id,
              srdIndex: f.srdIndex,
              ruleset: f.ruleset,
              name: (tr[f.srdIndex]['name'] as String),
              classId: f.classId,
              subclassId: f.subclassId,
              level: f.level,
              description: f.description,
            ),
          )
          .toList();
      final result = FeatureRules.forClasses(
        all: translated,
        ruleset: d14,
        classes: const [ClassProgress(classId: 'fighter', level: 17)],
      ).where((f) => f.name.startsWith('Fougue'));
      expect(result.map((f) => f.name), ['Fougue (2 utilisations)']);
    });
  });

  group('FeatureRules.forClasses', () {
    final f14 = _load(d14, 'assets/data/2014/features.json');
    final f24 = _load(d24, 'assets/data/2024/features.json');

    test('Guerrier 10 (2024) : capacités jusqu\'au niveau 10, pas le 11', () {
      final result = FeatureRules.forClasses(
        all: f24,
        ruleset: d24,
        classes: const [ClassProgress(classId: 'fighter', level: 10)],
      );
      expect(result.map((f) => f.srdIndex), contains('fighter-extra-attack'));
      expect(
        result.map((f) => f.srdIndex),
        contains('fighter-tactical-master'),
      );
      expect(result.every((f) => f.level <= 10), isTrue);
      expect(
        result.map((f) => f.srdIndex),
        isNot(contains('fighter-two-extra-attacks')),
      );
    });

    test(
      'Guerrier 10 (2014) : sans les capacités du niveau 11 ni les options de style',
      () {
        final result = FeatureRules.forClasses(
          all: f14,
          ruleset: d14,
          classes: const [ClassProgress(classId: 'fighter', level: 10)],
        );
        expect(result.every((f) => f.level <= 10), isTrue);
        expect(result.map((f) => f.name), contains('Fighting Style'));
        expect(
          result.map((f) => f.name),
          isNot(contains('Fighting Style: Archery')),
        );
        expect(
          result.map((f) => f.name).where((n) => n.startsWith('Extra Attack')),
          ['Extra Attack'],
        );
      },
    );

    test(
      '2014 : seule la dernière variante « Action Surge » est conservée',
      () {
        final lvl2 = FeatureRules.forClasses(
          all: f14,
          ruleset: d14,
          classes: const [ClassProgress(classId: 'fighter', level: 2)],
        ).where((f) => f.name.startsWith('Action Surge'));
        expect(lvl2.map((f) => f.name), ['Action Surge (1 use)']);

        final lvl17 = FeatureRules.forClasses(
          all: f14,
          ruleset: d14,
          classes: const [ClassProgress(classId: 'fighter', level: 17)],
        ).where((f) => f.name.startsWith('Action Surge'));
        expect(lvl17.map((f) => f.name), ['Action Surge (2 uses)']);
      },
    );

    test('Sous-classe : seules les capacités de la sous-classe choisie', () {
      final champion = FeatureRules.forClasses(
        all: f24,
        ruleset: d24,
        classes: const [
          ClassProgress(classId: 'fighter', subclassId: 'champion', level: 3),
        ],
      );
      expect(
        champion.map((f) => f.srdIndex),
        contains('champion-improved-critical'),
      );
      // Entrée générique redondante une fois la sous-classe choisie.
      expect(
        champion.map((f) => f.srdIndex),
        isNot(contains('fighter-subclass')),
      );

      final noSub = FeatureRules.forClasses(
        all: f24,
        ruleset: d24,
        classes: const [ClassProgress(classId: 'fighter', level: 3)],
      );
      expect(noSub.map((f) => f.srdIndex), contains('fighter-subclass'));
      expect(
        noSub.map((f) => f.srdIndex),
        isNot(contains('champion-improved-critical')),
      );
    });

    test('Multiclasse : chaque classe est filtrée selon son propre niveau', () {
      final result = FeatureRules.forClasses(
        all: f24,
        ruleset: d24,
        classes: const [
          ClassProgress(classId: 'fighter', level: 5),
          ClassProgress(classId: 'warlock', level: 1),
        ],
      );
      expect(
        result.where((f) => f.classId == 'warlock').every((f) => f.level <= 1),
        isTrue,
      );
      expect(result.map((f) => f.srdIndex), contains('fighter-extra-attack'));
    });
  });
}
