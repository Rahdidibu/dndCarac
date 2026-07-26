// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Le Codex de l\'Aventurier';

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

  @override
  String get conditionsSectionTitle => 'States & Conditions';

  @override
  String get conditionsEditTitle => 'Edit States';

  @override
  String get conditionsNoneActive => 'No active states.';

  @override
  String conditionsExhaustionLabel(int level) {
    return 'Exhaustion Level: $level';
  }

  @override
  String get conditionBlinded => 'Blinded';

  @override
  String get conditionBlindedDesc =>
      'You automatically fail any ability check that requires sight. Attack rolls against you have advantage, and your attack rolls have disadvantage.';

  @override
  String get conditionCharmed => 'Charmed';

  @override
  String get conditionCharmedDesc =>
      'You can\'t attack the charmer or target the charmer with harmful abilities or magical effects. The charmer has advantage on any ability check to interact socially with you.';

  @override
  String get conditionDeafened => 'Deafened';

  @override
  String get conditionDeafenedDesc =>
      'You automatically fail any ability check that requires hearing.';

  @override
  String get conditionFrightened => 'Frightened';

  @override
  String get conditionFrightenedDesc =>
      'You have disadvantage on ability checks and attack rolls while the source of your fear is within line of sight. You can\'t willingly move closer to the source of your fear.';

  @override
  String get conditionGrappled => 'Grappled';

  @override
  String get conditionGrappledDesc =>
      'Your speed becomes 0, and it can\'t increase.';

  @override
  String get conditionIncapacitated => 'Incapacitated';

  @override
  String get conditionIncapacitatedDesc =>
      'You can\'t take actions or reactions.';

  @override
  String get conditionInvisible => 'Invisible';

  @override
  String get conditionInvisibleDesc =>
      'You are impossible to see without the aid of magic or a special sense. Attack rolls against you have disadvantage, and your attack rolls have advantage.';

  @override
  String get conditionParalyzed => 'Paralyzed';

  @override
  String get conditionParalyzedDesc =>
      'You are incapacitated and can\'t move. You automatically fail Strength and Dexterity saving throws. Attack rolls against you have advantage, and any attack that hits you is a critical hit if the attacker is within 5 feet of you.';

  @override
  String get conditionPetrified => 'Petrified';

  @override
  String get conditionPetrifiedDesc =>
      'You are transformed along with your nonmagical objects into a solid substance (usually stone). Your weight increases by a factor of ten, you speed becomes 0, and you fail Strength and Dexterity saving throws automatically. You have resistance to all damage, and you are immune to poison and disease.';

  @override
  String get conditionPoisoned => 'Poisoned';

  @override
  String get conditionPoisonedDesc =>
      'You have disadvantage on attack rolls and ability checks.';

  @override
  String get conditionProne => 'Prone';

  @override
  String get conditionProneDesc =>
      'Your only movement option is to crawl. You have disadvantage on attack rolls. Attack rolls against you have advantage if the attacker is within 5 feet of you, otherwise the attack roll has disadvantage.';

  @override
  String get conditionRestrained => 'Restrained';

  @override
  String get conditionRestrainedDesc =>
      'Your speed becomes 0, and it can\'t increase. Your attack rolls have disadvantage, and attack rolls against you have advantage. You have disadvantage on Dexterity saving throws.';

  @override
  String get conditionStunned => 'Stunned';

  @override
  String get conditionStunnedDesc =>
      'You are incapacitated, can\'t move, and can speak only faltingly. You automatically fail Strength and Dexterity saving throws. Attack rolls against you have advantage.';

  @override
  String get conditionUnconscious => 'Unconscious';

  @override
  String get conditionUnconsciousDesc =>
      'You are incapacitated, drop whatever you\'re holding, and fall prone. You automatically fail Strength and Dexterity saving throws. Attack rolls against you have advantage, and any attack that hits you is a critical hit if the attacker is within 5 feet of you.';

  @override
  String get conditionExhaustion => 'Exhaustion';

  @override
  String get conditionExhaustionDesc =>
      'Level 1: Disadvantage on ability checks.\nLevel 2: Speed halved.\nLevel 3: Disadvantage on attack rolls and saving throws.\nLevel 4: Hit point maximum halved.\nLevel 5: Speed reduced to 0.\nLevel 6: Death.';

  @override
  String get diceRollerTitle => 'Dice Roller';

  @override
  String get diceRollerRoll => 'Roll!';

  @override
  String get diceRollerResult => 'Result';

  @override
  String get diceRollerMode => 'Roll Mode';

  @override
  String get diceRollerNormal => 'Normal';

  @override
  String get diceRollerAdvantage => 'Advantage';

  @override
  String get diceRollerDisadvantage => 'Disadvantage';

  @override
  String diceRollerFormula(String formula) {
    return 'Formula: $formula';
  }

  @override
  String get diceRollerRollCount => 'Number of Dice';

  @override
  String get diceRollerRollBonus => 'Modifier';

  @override
  String get diceRollerHistory => 'Roll History';

  @override
  String rollAbilityCheck(String name) {
    return '$name Check';
  }

  @override
  String rollSaveCheck(String name) {
    return '$name Save';
  }

  @override
  String rollSkillCheck(String name) {
    return '$name Check';
  }

  @override
  String rollAttackCheck(String name) {
    return 'Attack Roll: $name';
  }

  @override
  String rollDamageCheck(String name) {
    return 'Damage Roll: $name';
  }
}
