// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'D&D Manager';

  @override
  String get navCharacters => 'Characters';

  @override
  String get navSpells => 'Spells';

  @override
  String get navSettings => 'Settings';

  @override
  String get navForge => 'The Forge';

  @override
  String get invalidNavigation => 'Invalid navigation. Please return to home.';

  @override
  String get charactersEmptyTitle => 'No characters';

  @override
  String get charactersEmptySubtitle =>
      'Create your first character to get started.';

  @override
  String get characterCreate => 'New character';

  @override
  String get characterDelete => 'Delete character';

  @override
  String characterDeleteConfirm(String name) {
    return 'Delete $name? This action cannot be undone.';
  }

  @override
  String get wizardStepSystem => 'Game system';

  @override
  String get wizardStepIdentity => 'Identity';

  @override
  String get wizardStepClass => 'Class';

  @override
  String get wizardStepOrigin => 'Origin';

  @override
  String get wizardStepAbilities => 'Ability Scores';

  @override
  String get wizardStepProficiencies => 'Proficiencies';

  @override
  String get wizardStepSummary => 'Summary';

  @override
  String get wizardNext => 'Next';

  @override
  String get wizardPrevious => 'Previous';

  @override
  String get wizardFinish => 'Create character';

  @override
  String get systemDnd2014 => 'D&D 5e (2014)';

  @override
  String get systemDnd2024 => 'D&D 5e (2024)';

  @override
  String get fieldName => 'Character name';

  @override
  String get fieldPlayerName => 'Player name';

  @override
  String get fieldAlignment => 'Alignment';

  @override
  String get fieldXp => 'Experience points';

  @override
  String get fieldLevel => 'Level';

  @override
  String get abilityStr => 'Strength';

  @override
  String get abilityDex => 'Dexterity';

  @override
  String get abilityCon => 'Constitution';

  @override
  String get abilityInt => 'Intelligence';

  @override
  String get abilityWis => 'Wisdom';

  @override
  String get abilityCha => 'Charisma';

  @override
  String get alignmentLG => 'Lawful Good';

  @override
  String get alignmentNG => 'Neutral Good';

  @override
  String get alignmentCG => 'Chaotic Good';

  @override
  String get alignmentLN => 'Lawful Neutral';

  @override
  String get alignmentTN => 'True Neutral';

  @override
  String get alignmentCN => 'Chaotic Neutral';

  @override
  String get alignmentLE => 'Lawful Evil';

  @override
  String get alignmentNE => 'Neutral Evil';

  @override
  String get alignmentCE => 'Chaotic Evil';

  @override
  String get alignmentU => 'Unaligned';

  @override
  String get classBarbarian => 'Barbarian';

  @override
  String get classBard => 'Bard';

  @override
  String get classCleric => 'Cleric';

  @override
  String get classDruid => 'Druid';

  @override
  String get classFighter => 'Fighter';

  @override
  String get classMonk => 'Monk';

  @override
  String get classPaladin => 'Paladin';

  @override
  String get classRanger => 'Ranger';

  @override
  String get classRogue => 'Rogue';

  @override
  String get classSorcerer => 'Sorcerer';

  @override
  String get classWarlock => 'Warlock';

  @override
  String get classWizard => 'Wizard';

  @override
  String get resourceRage => 'Rage';

  @override
  String get resourceKi => 'Ki Points';

  @override
  String get resourceSorceryPoints => 'Sorcery Points';

  @override
  String get resourceChannelDivinity => 'Channel Divinity';

  @override
  String get resourceWildShape => 'Wild Shape';

  @override
  String get resourceActionSurge => 'Action Surge';

  @override
  String get abilityMethodPointBuy => 'Point buy';

  @override
  String get abilityMethodRoll => 'Dice roll';

  @override
  String get abilityMethodManual => 'Manual entry';

  @override
  String abilityPointsRemaining(int points) {
    return '$points points remaining';
  }

  @override
  String get sheetTabStats => 'Stats';

  @override
  String get sheetTabCombat => 'Combat';

  @override
  String get sheetTabMagic => 'Magic';

  @override
  String get sheetTabEquipment => 'Equipment';

  @override
  String get sheetTabProfile => 'Profile';

  @override
  String get sheetHp => 'Hit Points';

  @override
  String get sheetHpCurrent => 'Current HP';

  @override
  String get sheetHpMax => 'Maximum HP';

  @override
  String get sheetHpTemp => 'Temporary HP';

  @override
  String get sheetArmorClass => 'Armor Class';

  @override
  String get sheetInitiative => 'Initiative';

  @override
  String get sheetSpeed => 'Speed';

  @override
  String get sheetProficiencyBonus => 'Proficiency Bonus';

  @override
  String get sheetPassivePerception => 'Passive Perception';

  @override
  String get sheetDeathSaves => 'Death Saving Throws';

  @override
  String get sheetExhaustion => 'Exhaustion';

  @override
  String get sheetInspiration => 'Inspiration';

  @override
  String get spellsCompendium => 'Compendium';

  @override
  String get spellsMySpells => 'My Spells';

  @override
  String get spellsCustom => 'Custom Spells';

  @override
  String get spellsFilterLevel => 'Level';

  @override
  String get spellsFilterSchool => 'School';

  @override
  String get spellsPrepared => 'Prepared';

  @override
  String get spellSlots => 'Spell Slots';

  @override
  String get spellLevelCantrip => 'Cantrip';

  @override
  String spellLevel(int level) {
    return 'Level $level';
  }

  @override
  String get levelUp => 'Level Up';

  @override
  String levelUpCurrentLevel(int level) {
    return 'Current level: $level';
  }

  @override
  String get levelUpHpRoll => 'Roll hit die';

  @override
  String get levelUpHpAverage => 'Take average';

  @override
  String get levelUpNewFeatures => 'New features';

  @override
  String get levelUpAsiOrFeat => 'Ability Score Improvement or Feat';

  @override
  String get exportCharacterSheet => 'Export sheet';

  @override
  String get exportSpellbook => 'Export spellbook';

  @override
  String get exportGenerating => 'Generating PDF…';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLicenses => 'Licenses';

  @override
  String get settingsAboutText =>
      'D&D Character Manager uses SRD 5.1 and SRD 5.2 data, published under Creative Commons Attribution 4.0 by Wizards of the Coast LLC.';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get errorRequired => 'This field is required';

  @override
  String get errorInvalidNumber => 'Please enter a valid number';

  @override
  String get errorGeneric => 'An error occurred';

  @override
  String get step4RaceLabel => 'Race';

  @override
  String get step4SpeciesLabel => 'Species';

  @override
  String get step4SubraceLabel => 'Subrace';

  @override
  String get step4SubspeciesLabel => 'Subspecies';

  @override
  String get step4NoneOption => '— None —';

  @override
  String get step4AsiInfoText =>
      'In D&D 2024, ability score improvements (+2/+1) come from your background, not your species.';

  @override
  String get hpModifierTitle => 'Modify Hit Points';

  @override
  String hpModifierCurrent(int current, int max) {
    return 'Current: $current / $max';
  }

  @override
  String hpModifierTemp(int temp) {
    return 'Temporary: +$temp';
  }

  @override
  String get hpModifierLabel => 'HP Value';

  @override
  String get hpModifierDamage => 'Damage';

  @override
  String get hpModifierHeal => 'Heal';

  @override
  String get hpModifierSet => 'Set';

  @override
  String get hpModifierError => 'Please enter a positive number';

  @override
  String get restSectionTitle => 'Rests';

  @override
  String get restShortRest => 'Short rest';

  @override
  String get restLongRest => 'Long rest';

  @override
  String get restShortRestConfirm =>
      'Do you want to take a short rest? Your short rest abilities will be recharged.';

  @override
  String get restLongRestConfirm =>
      'Do you want to take a long rest? Your HP, spell slots and abilities will be restored.';

  @override
  String get restSuccessMessage => 'Rest completed!';

  @override
  String get resourceHitDiceD6 => 'Hit Dice (d6)';

  @override
  String get resourceHitDiceD8 => 'Hit Dice (d8)';

  @override
  String get resourceHitDiceD10 => 'Hit Dice (d10)';

  @override
  String get resourceHitDiceD12 => 'Hit Dice (d12)';

  @override
  String get shortRestTitle => 'Short rest';

  @override
  String shortRestRollButton(String die, int count) {
    return 'Roll 1d$die ($count left)';
  }

  @override
  String get shortRestNoDice => 'No hit dice available.';

  @override
  String get shortRestHpFull => 'HP already at maximum.';

  @override
  String shortRestRollResult(int roll, int con, int heal) {
    return 'Roll: $roll + $con (Con) = +$heal HP';
  }

  @override
  String get shortRestClose => 'End rest';
}
