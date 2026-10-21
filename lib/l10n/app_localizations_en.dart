// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get skillAthletics => 'Athletics';

  @override
  String get skillAcrobatics => 'Acrobatics';

  @override
  String get skillSleightOfHand => 'Sleight of Hand';

  @override
  String get skillStealth => 'Stealth';

  @override
  String get skillArcana => 'Arcana';

  @override
  String get skillHistory => 'History';

  @override
  String get skillInvestigation => 'Investigation';

  @override
  String get skillNature => 'Nature';

  @override
  String get skillReligion => 'Religion';

  @override
  String get skillAnimalHandling => 'Animal Handling';

  @override
  String get skillInsight => 'Insight';

  @override
  String get skillMedicine => 'Medicine';

  @override
  String get skillPerception => 'Perception';

  @override
  String get skillSurvival => 'Survival';

  @override
  String get skillDeception => 'Deception';

  @override
  String get skillIntimidation => 'Intimidation';

  @override
  String get skillPerformance => 'Performance';

  @override
  String get skillPersuasion => 'Persuasion';

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
  String get characterSearch => 'Search characters';

  @override
  String get characterNoSearchResults => 'No matching characters';

  @override
  String get characterSort => 'Sort characters';

  @override
  String get characterSortName => 'Name (A to Z)';

  @override
  String get characterSortLevel => 'Level (highest first)';

  @override
  String get characterSortUpdated => 'Last modified';

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
  String get sheetTabJournalShort => 'Journal';

  @override
  String get sheetTabCompanionsShort => 'Allies';

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
  String get profilePhotoUploading => 'Uploading photo…';

  @override
  String get profilePhotoUpdated => 'Photo updated successfully!';

  @override
  String profilePhotoUploadError(String error) {
    return 'Upload failed: $error';
  }

  @override
  String get profileAbilitySection => 'Ability scores and stats';

  @override
  String get profileEditAbilities => 'Edit ability scores and stats';

  @override
  String get profileProficienciesLanguages => 'Proficiencies and languages';

  @override
  String get profileManageProficiencies => 'Manage proficiencies';

  @override
  String get proficiencyArmors => 'Armor';

  @override
  String get proficiencyWeapons => 'Weapons';

  @override
  String get proficiencyWeaponMasteries => 'Weapon masteries (2024)';

  @override
  String get proficiencyTools => 'Tools';

  @override
  String get profileFeatsSection => 'Character feats';

  @override
  String get profileFeatEmpty => 'No feats recorded';

  @override
  String get profileAddFeat => 'Add a feat';

  @override
  String get profileAddFeatTitle => 'Add a feat';

  @override
  String get profileSearchFeat => 'Search feats';

  @override
  String get profileNoAvailableFeats => 'No feats available.';

  @override
  String get proficiencyNone => 'None';

  @override
  String get proficiencyTrained => 'Proficient';

  @override
  String get proficiencyExpertise => 'Expertise';

  @override
  String get proficiencyManageTitle => 'Manage proficiencies and expertise';

  @override
  String get proficiencySkillsTab => 'Skills';

  @override
  String get proficiencyToolsTab => 'Tools';

  @override
  String get actionApply => 'Apply';

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
  String get settingsAccountTitle => 'User account';

  @override
  String get settingsAccountConnected => 'Signed in';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String versionLabel(String version, String buildDate) {
    return 'Version $version ($buildDate)';
  }

  @override
  String get authSignUpSuccess =>
      'Sign-up successful! Check your email if verification is required.';

  @override
  String get authLoginFailure =>
      'Authentication failed. Check your credentials and try again.';

  @override
  String get authUnexpectedFailure =>
      'An unexpected error occurred. Please try again later.';

  @override
  String get authMissingConfig =>
      'Error: Supabase environment variables are missing.';

  @override
  String get authSignUpDescription => 'Create a game account';

  @override
  String get authLoginDescription => 'Sign in to sync your character sheets';

  @override
  String get authEmailLabel => 'Email address / username';

  @override
  String get authEmailRequired => 'Please enter an email address';

  @override
  String get authEmailInvalid => 'Please enter a valid email address';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordRequired => 'Please enter a password';

  @override
  String get authPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authPasswordMismatch => 'Passwords do not match';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authBackToForm => 'Back to sign-in form';

  @override
  String get authHaveAccount => 'Already have an account? Sign in';

  @override
  String get authNoAccount => 'Don\'t have an account yet? Sign up';

  @override
  String get authDownloadAndroid => 'Download the Android app (APK)';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionClear => 'Clear';

  @override
  String get noteDeleteTitle => 'Delete note?';

  @override
  String noteDeleteConfirm(String title) {
    return 'Delete “$title”?';
  }

  @override
  String get noteUntitled => 'this note';

  @override
  String get noteDeleted => 'Note deleted';

  @override
  String get journalPin => 'Pin';

  @override
  String get journalUnpin => 'Unpin';

  @override
  String get journalCategoryAll => 'All';

  @override
  String get journalCategoryJournal => 'Journal';

  @override
  String get journalCategoryQuest => 'Quests';

  @override
  String get journalCategoryNpc => 'NPCs';

  @override
  String get journalCategoryLocation => 'Locations';

  @override
  String get journalCategoryTreasure => 'Treasure';

  @override
  String get journalNewNote => 'New note';

  @override
  String get journalSearchHint => 'Search notes, quests, NPCs…';

  @override
  String get journalNoMatches => 'No notes match your filters.';

  @override
  String get journalEmpty => 'Your adventure journal is empty.';

  @override
  String get journalEditTitle => 'Edit note';

  @override
  String get journalNewEntryTitle => 'New journal entry';

  @override
  String get journalCategoryLabel => 'Category';

  @override
  String get journalTitleHint => 'Title (e.g. meeting with the mayor)';

  @override
  String get journalContentHint => 'Details and notes (Markdown supported)';

  @override
  String get journalPinToTop => 'Pin this note to the top';

  @override
  String get spellDeleted => 'Spell removed';

  @override
  String get equipmentDeleted => 'Item removed';

  @override
  String get currencyTitle => 'Currency';

  @override
  String get currencyManage => 'Manage and convert';

  @override
  String get currencyCopper => 'CP';

  @override
  String get currencySilver => 'SP';

  @override
  String get currencyElectrum => 'EP';

  @override
  String get currencyGold => 'GP';

  @override
  String get currencyPlatinum => 'PP';

  @override
  String get currencyCopperName => 'Copper';

  @override
  String get currencySilverName => 'Silver';

  @override
  String get currencyElectrumName => 'Electrum';

  @override
  String get currencyGoldName => 'Gold';

  @override
  String get currencyPlatinumName => 'Platinum';

  @override
  String currencyDecreaseTooltip(String coin) {
    return 'Remove one $coin coin';
  }

  @override
  String currencyIncreaseTooltip(String coin) {
    return 'Add one $coin coin';
  }

  @override
  String get currencyOptimized =>
      'Purse optimized: convertible coins were consolidated.';

  @override
  String get currencyInsufficientFunds => 'Not enough funds in the purse.';

  @override
  String currencyAdded(int amount, String coin) {
    return 'Added $amount $coin to the purse.';
  }

  @override
  String currencySpent(int amount, String coin) {
    return 'Spent $amount $coin. Change was returned automatically.';
  }

  @override
  String get currencyEmptyTitle => 'Empty the purse?';

  @override
  String get currencyEmptyConfirm =>
      'Are you sure you want to reset all coins to zero?';

  @override
  String get currencyEmptyButton => 'Empty';

  @override
  String get currencyEmptied => 'Purse emptied. All coins were reset to zero.';

  @override
  String get currencyDialogTitle => 'Purse and currency';

  @override
  String get currencyTotalValue => 'Total value';

  @override
  String get currencyPurseWeight => 'Purse weight';

  @override
  String currencyWeightSummary(String weight, int count) {
    return '$weight lb ($count coins)';
  }

  @override
  String get currencyDetailTab => 'Details';

  @override
  String get currencyTransactionTab => 'Transaction';

  @override
  String get currencyOptimizeTab => 'Optimize';

  @override
  String get currencyAmount => 'Amount';

  @override
  String get currencyReceiveLoot => 'Receive (loot)';

  @override
  String get currencySpendPurchase => 'Spend (purchase)';

  @override
  String get currencyAddToPurse => 'Add to purse';

  @override
  String get currencyMakePayment => 'Make payment';

  @override
  String get currencyOptimizerTitle => 'Purse optimizer';

  @override
  String get currencyOptimizerDescription =>
      'Automatically converts copper and silver coins into higher denominations to reduce purse weight.';

  @override
  String get currencyOptimizeButton => 'Convert and lighten purse';

  @override
  String get equipmentInventory => 'Inventory';

  @override
  String get equipmentEmpty => 'No items.';

  @override
  String equipmentWeightTotal(String weight) {
    return 'Total weight: $weight kg';
  }

  @override
  String get equipmentAddTitle => 'Add an item';

  @override
  String get equipmentNameLabel => 'Item name';

  @override
  String get equipmentNameHint => 'E.g. longsword, rations…';

  @override
  String get equipmentQuantityLabel => 'Quantity';

  @override
  String get equipmentWeightLabel => 'Total weight (kg)';

  @override
  String get equipmentAttuned => 'Attuned';

  @override
  String get equipmentEquipped => 'Equipped';

  @override
  String get equipmentStow => 'Stow';

  @override
  String equipmentQuantityWeight(int quantity, String weight) {
    return 'x$quantity • $weight kg';
  }

  @override
  String get equipmentDecreaseQuantity => 'Remove one unit';

  @override
  String get equipmentIncreaseQuantity => 'Add one unit';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionClose => 'Close';

  @override
  String get actionMore => 'More options';

  @override
  String get errorRequired => 'This field is required';

  @override
  String get errorInvalidNumber => 'Please enter a valid number';

  @override
  String get errorGeneric => 'An error occurred';

  @override
  String get errorNetwork =>
      'Unable to connect. Check your network and try again.';

  @override
  String get errorPermission => 'This action is not allowed for this account.';

  @override
  String get actionRetry => 'Retry';

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
  String hpGaugeSemantics(int current, int max) {
    return 'Hit points: $current of $max';
  }

  @override
  String hpOutOfMax(int max) {
    return 'of $max';
  }

  @override
  String get hpDamageAction => 'Damage (−1 HP)';

  @override
  String get hpHealAction => 'Heal (+1 HP)';

  @override
  String get hpTemporaryLabel => 'Temporary hit points';

  @override
  String get hpTemporaryDecrease => 'Remove one temporary hit point';

  @override
  String get hpTemporaryIncrease => 'Add one temporary hit point';

  @override
  String get combatWeaponsTitle => 'Weapons and attacks';

  @override
  String get combatNoAttack => 'No attacks configured.';

  @override
  String get attackAdd => 'Add an attack';

  @override
  String get attackNameLabel => 'Name';

  @override
  String get attackBonusLabel => 'Bonus (e.g. +5)';

  @override
  String get attackDamageLabel => 'Damage (e.g. 1d8+3)';

  @override
  String get attackTypeLabel => 'Type (e.g. piercing)';

  @override
  String get attackMasteryLabel => 'Weapon mastery (2024)';

  @override
  String get attackMasteryNone => 'None';

  @override
  String get rollAbilityDieTooltip => 'Roll an ability die';

  @override
  String get rollSaveTooltip => 'Roll a saving throw';

  @override
  String get resourceDecrease => 'Use one resource';

  @override
  String get resourceIncrease => 'Recover one resource';

  @override
  String get spellPreparedTooltip => 'Prepared (click to unprepare)';

  @override
  String get spellUnpreparedTooltip => 'Not prepared (click to prepare)';

  @override
  String get spellCastTooltip => 'Cast spell';

  @override
  String spellAttackTooltip(int bonus) {
    return 'Spell attack roll (d20 + $bonus)';
  }

  @override
  String spellDamageTooltip(String formula) {
    return 'Damage ($formula)';
  }

  @override
  String spellAttackTitle(String name) {
    return 'Spell attack: $name';
  }

  @override
  String spellDamageTitle(String name) {
    return 'Damage: $name';
  }

  @override
  String combatQuickTitle(String weapon) {
    return 'Quick combat: $weapon';
  }

  @override
  String combatHitDamage(String attack, String damage) {
    return 'Hit: $attack | Damage: $damage';
  }

  @override
  String get combatAttackAndDamage => 'Attack and damage (one click)';

  @override
  String get combatMode => 'Mode:';

  @override
  String get combatHitOnly => 'Hit only';

  @override
  String get combatCritical => 'Critical!';

  @override
  String get ammoChooseBeforeFire => 'Choose ammunition before firing!';

  @override
  String ammoOutOfStock(String item) {
    return 'You are out of $item!';
  }

  @override
  String get heroicInspirationTitle => 'Heroic Inspiration';

  @override
  String weaponMasteryDialogTitle(String name) {
    return 'Weapon mastery: $name';
  }

  @override
  String get deathSaveSuccesses => 'Successes';

  @override
  String get deathSaveFailures => 'Failures';

  @override
  String deathSaveSuccessMarker(int marker, int count) {
    return 'Success marker $marker, $count marked';
  }

  @override
  String deathSaveFailureMarker(int marker, int count) {
    return 'Failure marker $marker, $count marked';
  }

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
  String get restCharacterNotFound => 'Character not found';

  @override
  String get characterNotFound => 'Character not found';

  @override
  String hitPointsCurrent(int current, int max) {
    return '$current / $max HP';
  }

  @override
  String get shortRestHealingHistory => 'Healing history';

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
  String diceRollerDieSemantics(int sides) {
    return '$sides-sided die';
  }

  @override
  String get diceRollerDecreaseCount => 'Remove a die';

  @override
  String get diceRollerIncreaseCount => 'Add a die';

  @override
  String get diceRollerDecreaseBonus => 'Decrease modifier';

  @override
  String get diceRollerIncreaseBonus => 'Increase modifier';

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

  @override
  String get sheetScoresNotFound => 'Ability scores not found';

  @override
  String get sheetEditAbilitiesTitle => 'Ability scores and stats';

  @override
  String get spellPreparationLimit => 'Preparation limit';

  @override
  String spellPreparationLimitDescription(int count) {
    return 'You have already prepared the maximum number of spells ($count). Unprepare one before preparing another.';
  }

  @override
  String get spellNoSlots => 'No spell slots available';

  @override
  String spellNoSlotsDescription(int level, String name) {
    return 'You have no remaining spell slots of level $level or higher to cast $name.';
  }

  @override
  String spellOvercastTitle(String name) {
    return 'Cast $name at a higher level?';
  }

  @override
  String spellOvercastDescription(int level) {
    return 'No level $level slot is available. Cast the spell using a higher-level slot?';
  }

  @override
  String spellAvailableSlots(int current, int max) {
    return '$current/$max available';
  }

  @override
  String spellSlotSpent(String name, int level) {
    return 'Cast $name! (level $level slot spent)';
  }

  @override
  String get actionOk => 'OK';

  @override
  String get editCharacterTitle => 'Edit character';

  @override
  String get editCharacterTooltip => 'Edit';

  @override
  String get editSectionIdentity => 'Identity';

  @override
  String get editSectionAbilities => 'Ability scores';

  @override
  String get editSectionOrigin => 'Origin';

  @override
  String get editBackgroundLabel => 'Background';

  @override
  String get editAlignmentLabel => 'Alignment';

  @override
  String get editNameRequired => 'Name is required';

  @override
  String get editAbilityBase => 'Base';

  @override
  String get editAbilityOriginBonus => 'Origin';

  @override
  String get editAbilityTotal => 'Total';

  @override
  String get editAbilityHint =>
      'Base = score without the origin bonus (level-up increases are included). Total is limited to 1–30.';

  @override
  String get editAbilityOutOfRange => 'Total must be between 1 and 30';

  @override
  String get editModifyOrigin => 'Edit origin';

  @override
  String get editOriginWarning =>
      'Changing species or background changes ability bonuses, tool proficiencies and the origin feat. Proficiencies added manually are kept.';

  @override
  String get editBackgroundAsiTitle => 'Background bonus';

  @override
  String get editConfirmTitle => 'Confirm changes';

  @override
  String editConfirmHpMax(int before, int after) {
    return 'Max HP: $before → $after';
  }

  @override
  String editConfirmAc(int before, int after) {
    return 'AC: $before → $after';
  }

  @override
  String editConfirmProfsAdded(String list) {
    return 'Proficiencies added: $list';
  }

  @override
  String editConfirmProfsRemoved(String list) {
    return 'Proficiencies removed: $list';
  }

  @override
  String editConfirmFeatAdded(String name) {
    return 'Origin feat added: $name';
  }

  @override
  String editConfirmFeatRemoved(String name) {
    return 'Origin feat removed: $name';
  }

  @override
  String get editConfirmNoConsequence =>
      'No consequence on max HP, AC, proficiencies or feats.';

  @override
  String get editSaved => 'Character updated';

  @override
  String editSaveError(String error) {
    return 'Error while saving: $error';
  }
}
