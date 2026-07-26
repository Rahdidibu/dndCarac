// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Gestionnaire D&D';

  @override
  String get navCharacters => 'Personnages';

  @override
  String get navSpells => 'Sorts';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navForge => 'La Forge';

  @override
  String get invalidNavigation =>
      'Navigation invalide. Veuillez retourner à l\'accueil.';

  @override
  String get charactersEmptyTitle => 'Aucun personnage';

  @override
  String get charactersEmptySubtitle =>
      'Créez votre premier personnage pour commencer.';

  @override
  String get characterCreate => 'Nouveau personnage';

  @override
  String get characterDelete => 'Supprimer le personnage';

  @override
  String characterDeleteConfirm(String name) {
    return 'Supprimer $name ? Cette action est irréversible.';
  }

  @override
  String get wizardStepSystem => 'Système de jeu';

  @override
  String get wizardStepIdentity => 'Identité';

  @override
  String get wizardStepClass => 'Classe';

  @override
  String get wizardStepOrigin => 'Origine';

  @override
  String get wizardStepAbilities => 'Caractéristiques';

  @override
  String get wizardStepProficiencies => 'Maîtrises';

  @override
  String get wizardStepSummary => 'Résumé';

  @override
  String get wizardNext => 'Suivant';

  @override
  String get wizardPrevious => 'Précédent';

  @override
  String get wizardFinish => 'Créer le personnage';

  @override
  String get systemDnd2014 => 'D&D 5e (2014)';

  @override
  String get systemDnd2024 => 'D&D 5e (2024)';

  @override
  String get fieldName => 'Nom du personnage';

  @override
  String get fieldPlayerName => 'Nom du joueur';

  @override
  String get fieldAlignment => 'Alignement';

  @override
  String get fieldXp => 'Points d\'expérience';

  @override
  String get fieldLevel => 'Niveau';

  @override
  String get abilityStr => 'Force';

  @override
  String get abilityDex => 'Dextérité';

  @override
  String get abilityCon => 'Constitution';

  @override
  String get abilityInt => 'Intelligence';

  @override
  String get abilityWis => 'Sagesse';

  @override
  String get abilityCha => 'Charisme';

  @override
  String get alignmentLG => 'Loyal Bon';

  @override
  String get alignmentNG => 'Neutre Bon';

  @override
  String get alignmentCG => 'Chaotic Bon';

  @override
  String get alignmentLN => 'Loyal Neutre';

  @override
  String get alignmentTN => 'Neutre';

  @override
  String get alignmentCN => 'Chaotique Neutre';

  @override
  String get alignmentLE => 'Loyal Mauvais';

  @override
  String get alignmentNE => 'Neutre Mauvais';

  @override
  String get alignmentCE => 'Chaotique Mauvais';

  @override
  String get alignmentU => 'Sans alignement';

  @override
  String get classBarbarian => 'Barbare';

  @override
  String get classBard => 'Barde';

  @override
  String get classCleric => 'Clerc';

  @override
  String get classDruid => 'Druide';

  @override
  String get classFighter => 'Guerrier';

  @override
  String get classMonk => 'Moine';

  @override
  String get classPaladin => 'Paladin';

  @override
  String get classRanger => 'Rôdeur';

  @override
  String get classRogue => 'Roublard';

  @override
  String get classSorcerer => 'Ensorceleur';

  @override
  String get classWarlock => 'Occultiste';

  @override
  String get classWizard => 'Magicien';

  @override
  String get resourceRage => 'Rage';

  @override
  String get resourceKi => 'Points de ki';

  @override
  String get resourceSorceryPoints => 'Points de sorcellerie';

  @override
  String get resourceChannelDivinity => 'Conduit divin';

  @override
  String get resourceWildShape => 'Forme sauvage';

  @override
  String get resourceActionSurge => 'Fougue';

  @override
  String get abilityMethodPointBuy => 'Achat de points';

  @override
  String get abilityMethodRoll => 'Tirage de dés';

  @override
  String get abilityMethodManual => 'Saisie manuelle';

  @override
  String abilityPointsRemaining(int points) {
    return '$points points restants';
  }

  @override
  String get sheetTabStats => 'Stats';

  @override
  String get sheetTabCombat => 'Combat';

  @override
  String get sheetTabMagic => 'Magie';

  @override
  String get sheetTabEquipment => 'Équipement';

  @override
  String get sheetTabProfile => 'Profil';

  @override
  String get sheetHp => 'Points de vie';

  @override
  String get sheetHpCurrent => 'PV actuels';

  @override
  String get sheetHpMax => 'PV maximum';

  @override
  String get sheetHpTemp => 'PV temporaires';

  @override
  String get sheetArmorClass => 'Classe d\'armure';

  @override
  String get sheetInitiative => 'Initiative';

  @override
  String get sheetSpeed => 'Vitesse';

  @override
  String get sheetProficiencyBonus => 'Bonus de maîtrise';

  @override
  String get sheetPassivePerception => 'Perception passive';

  @override
  String get sheetDeathSaves => 'Jets de mort';

  @override
  String get sheetExhaustion => 'Épuisement';

  @override
  String get sheetInspiration => 'Inspiration';

  @override
  String get spellsCompendium => 'Compendium';

  @override
  String get spellsMySpells => 'Mes sorts';

  @override
  String get spellsCustom => 'Sorts personnalisés';

  @override
  String get spellsFilterLevel => 'Niveau';

  @override
  String get spellsFilterSchool => 'École';

  @override
  String get spellsPrepared => 'Préparé';

  @override
  String get spellSlots => 'Emplacements de sorts';

  @override
  String get spellLevelCantrip => 'Tour de magie';

  @override
  String spellLevel(int level) {
    return 'Niveau $level';
  }

  @override
  String get levelUp => 'Monter de niveau';

  @override
  String levelUpCurrentLevel(int level) {
    return 'Niveau actuel : $level';
  }

  @override
  String get levelUpHpRoll => 'Lancer le dé de vie';

  @override
  String get levelUpHpAverage => 'Prendre la moyenne';

  @override
  String get levelUpNewFeatures => 'Nouvelles capacités';

  @override
  String get levelUpAsiOrFeat => 'Amélioration de caractéristique ou don';

  @override
  String get exportCharacterSheet => 'Exporter la fiche';

  @override
  String get exportSpellbook => 'Exporter le livre de sorts';

  @override
  String get exportGenerating => 'Génération du PDF…';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsLicenses => 'Licences';

  @override
  String get settingsAboutText =>
      'D&D Character Manager utilise les données SRD 5.1 et SRD 5.2, publiées sous licence Creative Commons Attribution 4.0 par Wizards of the Coast LLC.';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionEdit => 'Modifier';

  @override
  String get actionAdd => 'Ajouter';

  @override
  String get actionConfirm => 'Confirmer';

  @override
  String get errorRequired => 'Ce champ est obligatoire';

  @override
  String get errorInvalidNumber => 'Veuillez entrer un nombre valide';

  @override
  String get errorGeneric => 'Une erreur est survenue';

  @override
  String get step4RaceLabel => 'Race';

  @override
  String get step4SpeciesLabel => 'Espèce';

  @override
  String get step4SubraceLabel => 'Sous-race';

  @override
  String get step4SubspeciesLabel => 'Sous-espèce';

  @override
  String get step4NoneOption => '— Aucune —';

  @override
  String get step4AsiInfoText =>
      'En D&D 2024, le bonus de caractéristique (+2/+1) vient du background, pas de l\'espèce.';

  @override
  String get hpModifierTitle => 'Modifier les points de vie';

  @override
  String hpModifierCurrent(int current, int max) {
    return 'Actuel : $current / $max';
  }

  @override
  String hpModifierTemp(int temp) {
    return 'Temporaire : +$temp';
  }

  @override
  String get hpModifierLabel => 'Valeur des PV';

  @override
  String get hpModifierDamage => 'Dégâts';

  @override
  String get hpModifierHeal => 'Soins';

  @override
  String get hpModifierSet => 'Définir';

  @override
  String get hpModifierError => 'Veuillez entrer un nombre positif';

  @override
  String get restSectionTitle => 'Repos';

  @override
  String get restShortRest => 'Repos court';

  @override
  String get restLongRest => 'Repos long';

  @override
  String get restShortRestConfirm =>
      'Voulez-vous effectuer un repos court ? Vos capacités de repos court seront réinitialisées.';

  @override
  String get restLongRestConfirm =>
      'Voulez-vous effectuer un repos long ? Vos PV, emplacements de sorts et capacités seront restaurés.';

  @override
  String get restSuccessMessage => 'Repos effectué !';

  @override
  String get resourceHitDiceD6 => 'Dés de vie (d6)';

  @override
  String get resourceHitDiceD8 => 'Dés de vie (d8)';

  @override
  String get resourceHitDiceD10 => 'Dés de vie (d10)';

  @override
  String get resourceHitDiceD12 => 'Dés de vie (d12)';

  @override
  String get shortRestTitle => 'Repos court';

  @override
  String shortRestRollButton(String die, int count) {
    return 'Lancer 1d$die ($count restants)';
  }

  @override
  String get shortRestNoDice => 'Aucun dé de vie disponible.';

  @override
  String get shortRestHpFull => 'Vos PV sont au maximum.';

  @override
  String shortRestRollResult(int roll, int con, int heal) {
    return 'Jet : $roll + $con (Con) = +$heal PV';
  }

  @override
  String get shortRestClose => 'Terminer le repos';
}
