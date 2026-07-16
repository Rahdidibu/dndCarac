import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_manager/core/database/tables/tables.dart';
import 'package:dnd_character_manager/features/character/providers/wizard_provider.dart';

void main() {
  group('WizardState and WizardNotifier Tests', () {
    test('Vérification de l\'état par défaut', () {
      final state = const WizardState();
      expect(state.ruleset, RulesetVersion.dnd2014);
      expect(state.name, '');
      expect(state.classes.isEmpty, true);
      expect(state.abilityMethod, AbilityScoreMethod.pointBuy);
      expect(state.abilityScores['str'], 8);
      expect(state.pointBuyRemaining, 27);
    });

    test('Modification des informations d\'identité', () {
      final notifier = WizardNotifier();
      notifier.setName('Faldor');
      notifier.setPlayerName('Alice');
      notifier.setAlignment('Neutre Bon');

      expect(notifier.state.name, 'Faldor');
      expect(notifier.state.playerName, 'Alice');
      expect(notifier.state.alignment, 'Neutre Bon');
      expect(notifier.state.isStep2Valid, true);
    });

    test('Ajout, mise à jour et suppression de classes', () {
      final notifier = WizardNotifier();
      
      // Ajout d'une classe
      notifier.addClass(const WizardClassEntry(classId: 'cleric', level: 1));
      expect(notifier.state.classes.length, 1);
      expect(notifier.state.classes.first.classId, 'cleric');
      expect(notifier.state.totalLevel, 1);
      expect(notifier.state.isStep3Valid, true);

      // Mise à jour de la classe (montée de niveau)
      notifier.updateClass(0, const WizardClassEntry(classId: 'cleric', level: 2, subclassId: 'life-domain'));
      expect(notifier.state.classes.first.level, 2);
      expect(notifier.state.classes.first.subclassId, 'life-domain');
      expect(notifier.state.totalLevel, 2);

      // Suppression de la classe
      notifier.removeClass(0);
      expect(notifier.state.classes.isEmpty, true);
      expect(notifier.state.totalLevel, 0);
      expect(notifier.state.isStep3Valid, false);
    });

    test('Calcul des points de Point Buy', () {
      final notifier = WizardNotifier();

      // Passer la Force à 15 (coût de 9)
      notifier.setAbilityScore('str', 15);
      expect(notifier.state.pointBuyRemaining, 18); // 27 - 9 = 18

      // Passer la Dextérité à 14 (coût de 7)
      notifier.setAbilityScore('dex', 14);
      expect(notifier.state.pointBuyRemaining, 11); // 18 - 7 = 11

      // Passer la Constitution à 10 (coût de 2)
      notifier.setAbilityScore('con', 10);
      expect(notifier.state.pointBuyRemaining, 9); // 11 - 2 = 9

      // Réinitialiser la Force à 8 (coût de 0)
      notifier.setAbilityScore('str', 8);
      expect(notifier.state.pointBuyRemaining, 18); // 9 + 9 = 18
    });

    test('Changement de méthode d\'attribution des caractéristiques', () {
      final notifier = WizardNotifier();
      notifier.setAbilityScore('str', 15);
      
      // Changement pour la méthode Roll (doit réinitialiser les scores à 8)
      notifier.setAbilityMethod(AbilityScoreMethod.roll);
      expect(notifier.state.abilityMethod, AbilityScoreMethod.roll);
      expect(notifier.state.abilityScores['str'], 8);
    });

    test('Sélection d\'origine et validation d\'étape', () {
      final notifier = WizardNotifier();
      expect(notifier.state.isStep4Valid, false);

      notifier.setSpecies('elf');
      notifier.setBackground('sage');
      expect(notifier.state.isStep4Valid, true);
      expect(notifier.state.speciesId, 'elf');
      expect(notifier.state.backgroundId, 'sage');
    });

    test('Réinitialisation complète', () {
      final notifier = WizardNotifier();
      notifier.setName('Grog');
      notifier.addClass(const WizardClassEntry(classId: 'barbarian'));
      
      notifier.reset();
      expect(notifier.state.name, '');
      expect(notifier.state.classes.isEmpty, true);
    });

    test('Sélection et validation des Weapon Masteries', () {
      final notifier = WizardNotifier();
      expect(notifier.state.chosenWeaponMasteries.isEmpty, true);

      // Toggle mastery 'sap'
      notifier.toggleWeaponMastery('sap');
      expect(notifier.state.chosenWeaponMasteries.contains('sap'), true);
      expect(notifier.state.chosenWeaponMasteries.length, 1);

      // Toggle mastery 'sap' again (to remove)
      notifier.toggleWeaponMastery('sap');
      expect(notifier.state.chosenWeaponMasteries.contains('sap'), false);
      expect(notifier.state.chosenWeaponMasteries.isEmpty, true);

      // Check weapon mastery slot count for fighter (should be 3)
      final fighterCount = WizardNotifier.weaponMasteryCountForClass('fighter');
      expect(fighterCount, 3);

      // Check weapon mastery slot count for wizard (should be 1)
      final wizardCount = WizardNotifier.weaponMasteryCountForClass('wizard');
      expect(wizardCount, 1);
    });
  });
}

