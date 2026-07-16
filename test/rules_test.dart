import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_manager/core/utils/dnd_rules.dart';

void main() {
  group('DndRules Tests', () {
    test('Calcul des modificateurs de caractéristiques', () {
      expect(DndRules.modifier(1), -5);
      expect(DndRules.modifier(8), -1);
      expect(DndRules.modifier(9), -1);
      expect(DndRules.modifier(10), 0);
      expect(DndRules.modifier(11), 0);
      expect(DndRules.modifier(12), 1);
      expect(DndRules.modifier(13), 1);
      expect(DndRules.modifier(14), 2);
      expect(DndRules.modifier(15), 2);
      expect(DndRules.modifier(16), 3);
      expect(DndRules.modifier(17), 3);
      expect(DndRules.modifier(18), 4);
      expect(DndRules.modifier(20), 5);
      expect(DndRules.modifier(30), 10);
    });

    test('Calcul des PV au niveau 1', () {
      expect(DndRules.hpAtLevel1(8, 10), 8);  // base 8 + con mod 0
      expect(DndRules.hpAtLevel1(8, 14), 10); // base 8 + con mod 2
      expect(DndRules.hpAtLevel1(12, 16), 15); // base 12 + con mod 3
    });

    test('Calcul du bonus de maîtrise (Proficiency Bonus)', () {
      expect(DndRules.proficiencyBonus(1), 2);
      expect(DndRules.proficiencyBonus(4), 2);
      expect(DndRules.proficiencyBonus(5), 3);
      expect(DndRules.proficiencyBonus(8), 3);
      expect(DndRules.proficiencyBonus(9), 4);
      expect(DndRules.proficiencyBonus(12), 4);
      expect(DndRules.proficiencyBonus(13), 5);
      expect(DndRules.proficiencyBonus(16), 5);
      expect(DndRules.proficiencyBonus(17), 6);
      expect(DndRules.proficiencyBonus(20), 6);
    });

    test('Calcul de la perception passive', () {
      // Sagesse 10 (mod +0), non-maîtrisé -> 10
      expect(DndRules.passivePerception(10, 2, proficient: false), 10);
      
      // Sagesse 14 (mod +2), maîtrisé (prof +2) -> 14
      expect(DndRules.passivePerception(14, 2, proficient: true), 14);

      // Sagesse 14 (mod +2), expertise (prof +2 * 2) -> 16
      expect(DndRules.passivePerception(14, 2, proficient: true, expertise: true), 16);

      // Sagesse 8 (mod -1), maîtrisé (prof +3) -> 12
      expect(DndRules.passivePerception(8, 3, proficient: true), 12);
    });

    test('Calcul de l\'initiative', () {
      expect(DndRules.initiative(10), 0);
      expect(DndRules.initiative(16), 3);
      expect(DndRules.initiative(8), -1);
    });

    test('Calcul des PV moyens gagnés lors d\'un passage de niveau', () {
      // d8, constitution 14 (mod +2) -> moyenne de 5 + 2 = 7
      expect(DndRules.hpAverageOnLevelUp(8, 14), 7);
      
      // d10, constitution 10 (mod 0) -> moyenne de 6 + 0 = 6
      expect(DndRules.hpAverageOnLevelUp(10, 10), 6);

      // d6, constitution 8 (mod -1) -> moyenne de 4 - 1 = 3
      expect(DndRules.hpAverageOnLevelUp(6, 8), 3);
    });
  });
}
