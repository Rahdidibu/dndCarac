import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_manager/core/utils/character_edit_rules.dart';

void main() {
  group('retroactiveHpDelta', () {
    test('CON 14 -> 16 au niveau 10 = +10 PV', () {
      expect(
        CharacterEditRules.retroactiveHpDelta(oldCon: 14, newCon: 16, totalLevel: 10),
        10,
      );
    });

    test('CON 16 -> 14 au niveau 10 = -10 PV', () {
      expect(
        CharacterEditRules.retroactiveHpDelta(oldCon: 16, newCon: 14, totalLevel: 10),
        -10,
      );
    });

    test('Même modificateur (14 -> 15) : aucun écart', () {
      expect(
        CharacterEditRules.retroactiveHpDelta(oldCon: 14, newCon: 15, totalLevel: 10),
        0,
      );
    });

    test('Modificateurs négatifs (8 -> 12) au niveau 3', () {
      expect(
        CharacterEditRules.retroactiveHpDelta(oldCon: 8, newCon: 12, totalLevel: 3),
        6,
      );
    });
  });

  group('applyHpDelta', () {
    test('une hausse augmente PV max et PV courants', () {
      final r = CharacterEditRules.applyHpDelta(hpMax: 50, hpCurrent: 30, delta: 10);
      expect((r.hpMax, r.hpCurrent), (60, 40));
    });

    test('une baisse plafonne les PV courants au nouveau maximum', () {
      final r = CharacterEditRules.applyHpDelta(hpMax: 50, hpCurrent: 50, delta: -10);
      expect((r.hpMax, r.hpCurrent), (40, 40));
    });

    test('une baisse ne touche pas des PV courants déjà plus bas', () {
      final r = CharacterEditRules.applyHpDelta(hpMax: 50, hpCurrent: 20, delta: -10);
      expect((r.hpMax, r.hpCurrent), (40, 20));
    });

    test('les PV max ne descendent jamais sous 1', () {
      final r = CharacterEditRules.applyHpDelta(hpMax: 5, hpCurrent: 5, delta: -20);
      expect(r.hpMax, 1);
      expect(r.hpCurrent, 1);
    });
  });

  group('bonus d\'origine', () {
    test('parseAbilityBonuses lit les bonus de race', () {
      expect(
        CharacterEditRules.parseAbilityBonuses(
          '[{"ability":"dex","bonus":2},{"ability":"int","bonus":1}]',
        ),
        {'dex': 2, 'int': 1},
      );
    });

    test('parseAbilityBonuses tolère vide / null', () {
      expect(CharacterEditRules.parseAbilityBonuses(null), isEmpty);
      expect(CharacterEditRules.parseAbilityBonuses(''), isEmpty);
      expect(CharacterEditRules.parseAbilityBonuses('[]'), isEmpty);
    });

    test('sumBonuses cumule race et sous-race', () {
      expect(
        CharacterEditRules.sumBonuses([
          {'dex': 2},
          {'dex': 1, 'wis': 1},
        ]),
        {'dex': 3, 'wis': 1},
      );
    });

    test('base <-> final', () {
      expect(CharacterEditRules.baseFromFinal(16, 2), 14);
      expect(CharacterEditRules.finalFromBase(14, 2), 16);
    });

    test('bornes 1-30 sur le total', () {
      expect(CharacterEditRules.isValidBase(0, 0), isFalse);
      expect(CharacterEditRules.isValidBase(1, 0), isTrue);
      expect(CharacterEditRules.isValidBase(28, 2), isTrue);
      expect(CharacterEditRules.isValidBase(29, 2), isFalse);
      expect(CharacterEditRules.isValidBase(-1, 2), isTrue);
    });
  });

  group('ASI d\'historique 2024', () {
    test('parseEligibleAsi', () {
      expect(
        CharacterEditRules.parseEligibleAsi('["str","dex","con"]'),
        ['str', 'dex', 'con'],
      );
      expect(CharacterEditRules.parseEligibleAsi(null), isEmpty);
    });
  });

  test('diffKeys liste ce qui disparaît et ce qui apparaît', () {
    final d = CharacterEditRules.diffKeys(
      ['tool_a', 'tool_b'],
      ['tool_b', 'tool_c'],
    );
    expect(d.removed, ['tool_a']);
    expect(d.added, ['tool_c']);
  });
}
