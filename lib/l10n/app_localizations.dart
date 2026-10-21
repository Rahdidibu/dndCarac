import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @skillAthletics.
  ///
  /// In fr, this message translates to:
  /// **'Athlétisme'**
  String get skillAthletics;

  /// No description provided for @skillAcrobatics.
  ///
  /// In fr, this message translates to:
  /// **'Acrobaties'**
  String get skillAcrobatics;

  /// No description provided for @skillSleightOfHand.
  ///
  /// In fr, this message translates to:
  /// **'Escamotage'**
  String get skillSleightOfHand;

  /// No description provided for @skillStealth.
  ///
  /// In fr, this message translates to:
  /// **'Discrétion'**
  String get skillStealth;

  /// No description provided for @skillArcana.
  ///
  /// In fr, this message translates to:
  /// **'Arcanes'**
  String get skillArcana;

  /// No description provided for @skillHistory.
  ///
  /// In fr, this message translates to:
  /// **'Histoire'**
  String get skillHistory;

  /// No description provided for @skillInvestigation.
  ///
  /// In fr, this message translates to:
  /// **'Investigation'**
  String get skillInvestigation;

  /// No description provided for @skillNature.
  ///
  /// In fr, this message translates to:
  /// **'Nature'**
  String get skillNature;

  /// No description provided for @skillReligion.
  ///
  /// In fr, this message translates to:
  /// **'Religion'**
  String get skillReligion;

  /// No description provided for @skillAnimalHandling.
  ///
  /// In fr, this message translates to:
  /// **'Dressage'**
  String get skillAnimalHandling;

  /// No description provided for @skillInsight.
  ///
  /// In fr, this message translates to:
  /// **'Perspicacité'**
  String get skillInsight;

  /// No description provided for @skillMedicine.
  ///
  /// In fr, this message translates to:
  /// **'Médecine'**
  String get skillMedicine;

  /// No description provided for @skillPerception.
  ///
  /// In fr, this message translates to:
  /// **'Perception'**
  String get skillPerception;

  /// No description provided for @skillSurvival.
  ///
  /// In fr, this message translates to:
  /// **'Survie'**
  String get skillSurvival;

  /// No description provided for @skillDeception.
  ///
  /// In fr, this message translates to:
  /// **'Tromperie'**
  String get skillDeception;

  /// No description provided for @skillIntimidation.
  ///
  /// In fr, this message translates to:
  /// **'Intimidation'**
  String get skillIntimidation;

  /// No description provided for @skillPerformance.
  ///
  /// In fr, this message translates to:
  /// **'Représentation'**
  String get skillPerformance;

  /// No description provided for @skillPersuasion.
  ///
  /// In fr, this message translates to:
  /// **'Persuasion'**
  String get skillPersuasion;

  /// Titre de l'application
  ///
  /// In fr, this message translates to:
  /// **'Le Codex de l\'Aventurier'**
  String get appTitle;

  /// No description provided for @navCharacters.
  ///
  /// In fr, this message translates to:
  /// **'Personnages'**
  String get navCharacters;

  /// No description provided for @navSpells.
  ///
  /// In fr, this message translates to:
  /// **'Sorts'**
  String get navSpells;

  /// No description provided for @navSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get navSettings;

  /// No description provided for @navForge.
  ///
  /// In fr, this message translates to:
  /// **'La Forge'**
  String get navForge;

  /// No description provided for @invalidNavigation.
  ///
  /// In fr, this message translates to:
  /// **'Navigation invalide. Veuillez retourner à l\'accueil.'**
  String get invalidNavigation;

  /// No description provided for @charactersEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun personnage'**
  String get charactersEmptyTitle;

  /// No description provided for @charactersEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre premier personnage pour commencer.'**
  String get charactersEmptySubtitle;

  /// No description provided for @characterCreate.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau personnage'**
  String get characterCreate;

  /// No description provided for @characterSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un personnage'**
  String get characterSearch;

  /// No description provided for @characterNoSearchResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun personnage correspondant'**
  String get characterNoSearchResults;

  /// No description provided for @characterSort.
  ///
  /// In fr, this message translates to:
  /// **'Trier les personnages'**
  String get characterSort;

  /// No description provided for @characterSortName.
  ///
  /// In fr, this message translates to:
  /// **'Nom (A à Z)'**
  String get characterSortName;

  /// No description provided for @characterSortLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau (décroissant)'**
  String get characterSortLevel;

  /// No description provided for @characterSortUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Dernière modification'**
  String get characterSortUpdated;

  /// No description provided for @characterDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le personnage'**
  String get characterDelete;

  /// No description provided for @characterDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer {name} ? Cette action est irréversible.'**
  String characterDeleteConfirm(String name);

  /// No description provided for @wizardStepSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système de jeu'**
  String get wizardStepSystem;

  /// No description provided for @wizardStepIdentity.
  ///
  /// In fr, this message translates to:
  /// **'Identité'**
  String get wizardStepIdentity;

  /// No description provided for @wizardStepClass.
  ///
  /// In fr, this message translates to:
  /// **'Classe'**
  String get wizardStepClass;

  /// No description provided for @wizardStepOrigin.
  ///
  /// In fr, this message translates to:
  /// **'Origine'**
  String get wizardStepOrigin;

  /// No description provided for @wizardStepAbilities.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristiques'**
  String get wizardStepAbilities;

  /// No description provided for @wizardStepProficiencies.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrises'**
  String get wizardStepProficiencies;

  /// No description provided for @wizardStepSummary.
  ///
  /// In fr, this message translates to:
  /// **'Résumé'**
  String get wizardStepSummary;

  /// No description provided for @wizardNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get wizardNext;

  /// No description provided for @wizardPrevious.
  ///
  /// In fr, this message translates to:
  /// **'Précédent'**
  String get wizardPrevious;

  /// No description provided for @wizardFinish.
  ///
  /// In fr, this message translates to:
  /// **'Créer le personnage'**
  String get wizardFinish;

  /// No description provided for @systemDnd2014.
  ///
  /// In fr, this message translates to:
  /// **'D&D 5e (2014)'**
  String get systemDnd2014;

  /// No description provided for @systemDnd2024.
  ///
  /// In fr, this message translates to:
  /// **'D&D 5e (2024)'**
  String get systemDnd2024;

  /// No description provided for @fieldName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du personnage'**
  String get fieldName;

  /// No description provided for @fieldPlayerName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du joueur'**
  String get fieldPlayerName;

  /// No description provided for @fieldAlignment.
  ///
  /// In fr, this message translates to:
  /// **'Alignement'**
  String get fieldAlignment;

  /// No description provided for @fieldXp.
  ///
  /// In fr, this message translates to:
  /// **'Points d\'expérience'**
  String get fieldXp;

  /// No description provided for @fieldLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau'**
  String get fieldLevel;

  /// No description provided for @abilityStr.
  ///
  /// In fr, this message translates to:
  /// **'Force'**
  String get abilityStr;

  /// No description provided for @abilityDex.
  ///
  /// In fr, this message translates to:
  /// **'Dextérité'**
  String get abilityDex;

  /// No description provided for @abilityCon.
  ///
  /// In fr, this message translates to:
  /// **'Constitution'**
  String get abilityCon;

  /// No description provided for @abilityInt.
  ///
  /// In fr, this message translates to:
  /// **'Intelligence'**
  String get abilityInt;

  /// No description provided for @abilityWis.
  ///
  /// In fr, this message translates to:
  /// **'Sagesse'**
  String get abilityWis;

  /// No description provided for @abilityCha.
  ///
  /// In fr, this message translates to:
  /// **'Charisme'**
  String get abilityCha;

  /// No description provided for @alignmentLG.
  ///
  /// In fr, this message translates to:
  /// **'Loyal Bon'**
  String get alignmentLG;

  /// No description provided for @alignmentNG.
  ///
  /// In fr, this message translates to:
  /// **'Neutre Bon'**
  String get alignmentNG;

  /// No description provided for @alignmentCG.
  ///
  /// In fr, this message translates to:
  /// **'Chaotique Bon'**
  String get alignmentCG;

  /// No description provided for @alignmentLN.
  ///
  /// In fr, this message translates to:
  /// **'Loyal Neutre'**
  String get alignmentLN;

  /// No description provided for @alignmentTN.
  ///
  /// In fr, this message translates to:
  /// **'Neutre'**
  String get alignmentTN;

  /// No description provided for @alignmentCN.
  ///
  /// In fr, this message translates to:
  /// **'Chaotique Neutre'**
  String get alignmentCN;

  /// No description provided for @alignmentLE.
  ///
  /// In fr, this message translates to:
  /// **'Loyal Mauvais'**
  String get alignmentLE;

  /// No description provided for @alignmentNE.
  ///
  /// In fr, this message translates to:
  /// **'Neutre Mauvais'**
  String get alignmentNE;

  /// No description provided for @alignmentCE.
  ///
  /// In fr, this message translates to:
  /// **'Chaotique Mauvais'**
  String get alignmentCE;

  /// No description provided for @alignmentU.
  ///
  /// In fr, this message translates to:
  /// **'Sans alignement'**
  String get alignmentU;

  /// No description provided for @classBarbarian.
  ///
  /// In fr, this message translates to:
  /// **'Barbare'**
  String get classBarbarian;

  /// No description provided for @classBard.
  ///
  /// In fr, this message translates to:
  /// **'Barde'**
  String get classBard;

  /// No description provided for @classCleric.
  ///
  /// In fr, this message translates to:
  /// **'Clerc'**
  String get classCleric;

  /// No description provided for @classDruid.
  ///
  /// In fr, this message translates to:
  /// **'Druide'**
  String get classDruid;

  /// No description provided for @classFighter.
  ///
  /// In fr, this message translates to:
  /// **'Guerrier'**
  String get classFighter;

  /// No description provided for @classMonk.
  ///
  /// In fr, this message translates to:
  /// **'Moine'**
  String get classMonk;

  /// No description provided for @classPaladin.
  ///
  /// In fr, this message translates to:
  /// **'Paladin'**
  String get classPaladin;

  /// No description provided for @classRanger.
  ///
  /// In fr, this message translates to:
  /// **'Rôdeur'**
  String get classRanger;

  /// No description provided for @classRogue.
  ///
  /// In fr, this message translates to:
  /// **'Roublard'**
  String get classRogue;

  /// No description provided for @classSorcerer.
  ///
  /// In fr, this message translates to:
  /// **'Ensorceleur'**
  String get classSorcerer;

  /// No description provided for @classWarlock.
  ///
  /// In fr, this message translates to:
  /// **'Occultiste'**
  String get classWarlock;

  /// No description provided for @classWizard.
  ///
  /// In fr, this message translates to:
  /// **'Magicien'**
  String get classWizard;

  /// No description provided for @resourceRage.
  ///
  /// In fr, this message translates to:
  /// **'Rage'**
  String get resourceRage;

  /// No description provided for @resourceKi.
  ///
  /// In fr, this message translates to:
  /// **'Points de ki'**
  String get resourceKi;

  /// No description provided for @resourceSorceryPoints.
  ///
  /// In fr, this message translates to:
  /// **'Points de sorcellerie'**
  String get resourceSorceryPoints;

  /// No description provided for @resourceChannelDivinity.
  ///
  /// In fr, this message translates to:
  /// **'Conduit divin'**
  String get resourceChannelDivinity;

  /// No description provided for @resourceWildShape.
  ///
  /// In fr, this message translates to:
  /// **'Forme sauvage'**
  String get resourceWildShape;

  /// No description provided for @resourceActionSurge.
  ///
  /// In fr, this message translates to:
  /// **'Fougue'**
  String get resourceActionSurge;

  /// No description provided for @abilityMethodPointBuy.
  ///
  /// In fr, this message translates to:
  /// **'Achat de points'**
  String get abilityMethodPointBuy;

  /// No description provided for @abilityMethodRoll.
  ///
  /// In fr, this message translates to:
  /// **'Tirage de dés'**
  String get abilityMethodRoll;

  /// No description provided for @abilityMethodManual.
  ///
  /// In fr, this message translates to:
  /// **'Saisie manuelle'**
  String get abilityMethodManual;

  /// No description provided for @abilityPointsRemaining.
  ///
  /// In fr, this message translates to:
  /// **'{points} points restants'**
  String abilityPointsRemaining(int points);

  /// No description provided for @sheetTabStats.
  ///
  /// In fr, this message translates to:
  /// **'Stats'**
  String get sheetTabStats;

  /// No description provided for @sheetTabCombat.
  ///
  /// In fr, this message translates to:
  /// **'Combat'**
  String get sheetTabCombat;

  /// No description provided for @sheetTabMagic.
  ///
  /// In fr, this message translates to:
  /// **'Magie'**
  String get sheetTabMagic;

  /// No description provided for @sheetTabEquipment.
  ///
  /// In fr, this message translates to:
  /// **'Équipement'**
  String get sheetTabEquipment;

  /// No description provided for @sheetTabProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get sheetTabProfile;

  /// No description provided for @sheetTabJournalShort.
  ///
  /// In fr, this message translates to:
  /// **'Journal'**
  String get sheetTabJournalShort;

  /// No description provided for @sheetTabCompanionsShort.
  ///
  /// In fr, this message translates to:
  /// **'Alliés'**
  String get sheetTabCompanionsShort;

  /// No description provided for @sheetHp.
  ///
  /// In fr, this message translates to:
  /// **'Points de vie'**
  String get sheetHp;

  /// No description provided for @sheetHpCurrent.
  ///
  /// In fr, this message translates to:
  /// **'PV actuels'**
  String get sheetHpCurrent;

  /// No description provided for @sheetHpMax.
  ///
  /// In fr, this message translates to:
  /// **'PV maximum'**
  String get sheetHpMax;

  /// No description provided for @sheetHpTemp.
  ///
  /// In fr, this message translates to:
  /// **'PV temporaires'**
  String get sheetHpTemp;

  /// No description provided for @sheetArmorClass.
  ///
  /// In fr, this message translates to:
  /// **'Classe d\'armure'**
  String get sheetArmorClass;

  /// No description provided for @sheetInitiative.
  ///
  /// In fr, this message translates to:
  /// **'Initiative'**
  String get sheetInitiative;

  /// No description provided for @sheetSpeed.
  ///
  /// In fr, this message translates to:
  /// **'Vitesse'**
  String get sheetSpeed;

  /// No description provided for @sheetProficiencyBonus.
  ///
  /// In fr, this message translates to:
  /// **'Bonus de maîtrise'**
  String get sheetProficiencyBonus;

  /// No description provided for @sheetPassivePerception.
  ///
  /// In fr, this message translates to:
  /// **'Perception passive'**
  String get sheetPassivePerception;

  /// No description provided for @sheetDeathSaves.
  ///
  /// In fr, this message translates to:
  /// **'Jets de mort'**
  String get sheetDeathSaves;

  /// No description provided for @sheetExhaustion.
  ///
  /// In fr, this message translates to:
  /// **'Épuisement'**
  String get sheetExhaustion;

  /// No description provided for @sheetInspiration.
  ///
  /// In fr, this message translates to:
  /// **'Inspiration'**
  String get sheetInspiration;

  /// No description provided for @spellsCompendium.
  ///
  /// In fr, this message translates to:
  /// **'Compendium'**
  String get spellsCompendium;

  /// No description provided for @spellsMySpells.
  ///
  /// In fr, this message translates to:
  /// **'Mes sorts'**
  String get spellsMySpells;

  /// No description provided for @spellsCustom.
  ///
  /// In fr, this message translates to:
  /// **'Sorts personnalisés'**
  String get spellsCustom;

  /// No description provided for @spellsFilterLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau'**
  String get spellsFilterLevel;

  /// No description provided for @spellsFilterSchool.
  ///
  /// In fr, this message translates to:
  /// **'École'**
  String get spellsFilterSchool;

  /// No description provided for @spellsPrepared.
  ///
  /// In fr, this message translates to:
  /// **'Préparé'**
  String get spellsPrepared;

  /// No description provided for @spellSlots.
  ///
  /// In fr, this message translates to:
  /// **'Emplacements de sorts'**
  String get spellSlots;

  /// No description provided for @spellLevelCantrip.
  ///
  /// In fr, this message translates to:
  /// **'Tour de magie'**
  String get spellLevelCantrip;

  /// No description provided for @spellLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau {level}'**
  String spellLevel(int level);

  /// No description provided for @levelUp.
  ///
  /// In fr, this message translates to:
  /// **'Monter de niveau'**
  String get levelUp;

  /// No description provided for @levelUpCurrentLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau actuel : {level}'**
  String levelUpCurrentLevel(int level);

  /// No description provided for @profilePhotoUploading.
  ///
  /// In fr, this message translates to:
  /// **'Téléchargement de la photo…'**
  String get profilePhotoUploading;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Photo mise à jour avec succès !'**
  String get profilePhotoUpdated;

  /// No description provided for @profilePhotoUploadError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du téléchargement : {error}'**
  String profilePhotoUploadError(String error);

  /// No description provided for @profileAbilitySection.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristiques et statistiques'**
  String get profileAbilitySection;

  /// No description provided for @profileEditAbilities.
  ///
  /// In fr, this message translates to:
  /// **'Modifier les caractéristiques et statistiques'**
  String get profileEditAbilities;

  /// No description provided for @profileProficienciesLanguages.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrises et langues'**
  String get profileProficienciesLanguages;

  /// No description provided for @profileManageProficiencies.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les maîtrises'**
  String get profileManageProficiencies;

  /// No description provided for @proficiencyArmors.
  ///
  /// In fr, this message translates to:
  /// **'Armures'**
  String get proficiencyArmors;

  /// No description provided for @proficiencyWeapons.
  ///
  /// In fr, this message translates to:
  /// **'Armes'**
  String get proficiencyWeapons;

  /// No description provided for @proficiencyWeaponMasteries.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrises d’armes (2024)'**
  String get proficiencyWeaponMasteries;

  /// No description provided for @proficiencyTools.
  ///
  /// In fr, this message translates to:
  /// **'Outils'**
  String get proficiencyTools;

  /// No description provided for @profileFeatsSection.
  ///
  /// In fr, this message translates to:
  /// **'Dons du personnage'**
  String get profileFeatsSection;

  /// No description provided for @profileFeatEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun don enregistré'**
  String get profileFeatEmpty;

  /// No description provided for @profileAddFeat.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un don'**
  String get profileAddFeat;

  /// No description provided for @profileAddFeatTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un don'**
  String get profileAddFeatTitle;

  /// No description provided for @profileSearchFeat.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un don'**
  String get profileSearchFeat;

  /// No description provided for @profileNoAvailableFeats.
  ///
  /// In fr, this message translates to:
  /// **'Aucun don disponible.'**
  String get profileNoAvailableFeats;

  /// No description provided for @proficiencyNone.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get proficiencyNone;

  /// No description provided for @proficiencyTrained.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrisé'**
  String get proficiencyTrained;

  /// No description provided for @proficiencyExpertise.
  ///
  /// In fr, this message translates to:
  /// **'Expertise'**
  String get proficiencyExpertise;

  /// No description provided for @proficiencyManageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les maîtrises et l’expertise'**
  String get proficiencyManageTitle;

  /// No description provided for @proficiencySkillsTab.
  ///
  /// In fr, this message translates to:
  /// **'Compétences'**
  String get proficiencySkillsTab;

  /// No description provided for @proficiencyToolsTab.
  ///
  /// In fr, this message translates to:
  /// **'Outils'**
  String get proficiencyToolsTab;

  /// No description provided for @actionApply.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get actionApply;

  /// No description provided for @levelUpHpRoll.
  ///
  /// In fr, this message translates to:
  /// **'Lancer le dé de vie'**
  String get levelUpHpRoll;

  /// No description provided for @levelUpHpAverage.
  ///
  /// In fr, this message translates to:
  /// **'Prendre la moyenne'**
  String get levelUpHpAverage;

  /// No description provided for @levelUpNewFeatures.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelles capacités'**
  String get levelUpNewFeatures;

  /// No description provided for @levelUpAsiOrFeat.
  ///
  /// In fr, this message translates to:
  /// **'Amélioration de caractéristique ou don'**
  String get levelUpAsiOrFeat;

  /// No description provided for @exportCharacterSheet.
  ///
  /// In fr, this message translates to:
  /// **'Exporter la fiche'**
  String get exportCharacterSheet;

  /// No description provided for @exportSpellbook.
  ///
  /// In fr, this message translates to:
  /// **'Exporter le livre de sorts'**
  String get exportSpellbook;

  /// No description provided for @exportGenerating.
  ///
  /// In fr, this message translates to:
  /// **'Génération du PDF…'**
  String get exportGenerating;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFr;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get settingsAbout;

  /// No description provided for @settingsLicenses.
  ///
  /// In fr, this message translates to:
  /// **'Licences'**
  String get settingsLicenses;

  /// No description provided for @settingsAboutText.
  ///
  /// In fr, this message translates to:
  /// **'D&D Character Manager utilise les données SRD 5.1 et SRD 5.2, publiées sous licence Creative Commons Attribution 4.0 par Wizards of the Coast LLC.'**
  String get settingsAboutText;

  /// No description provided for @settingsAccountTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compte utilisateur'**
  String get settingsAccountTitle;

  /// No description provided for @settingsAccountConnected.
  ///
  /// In fr, this message translates to:
  /// **'Compte connecté'**
  String get settingsAccountConnected;

  /// No description provided for @settingsSignOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get settingsSignOut;

  /// No description provided for @versionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Version {version} ({buildDate})'**
  String versionLabel(String version, String buildDate);

  /// No description provided for @authSignUpSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Inscription réussie ! Vérifiez vos e-mails si une validation est requise.'**
  String get authSignUpSuccess;

  /// No description provided for @authLoginFailure.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l’authentification. Vérifiez vos identifiants et réessayez.'**
  String get authLoginFailure;

  /// No description provided for @authUnexpectedFailure.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur inattendue est survenue. Veuillez réessayer plus tard.'**
  String get authUnexpectedFailure;

  /// No description provided for @authMissingConfig.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : les variables d’environnement Supabase sont manquantes.'**
  String get authMissingConfig;

  /// No description provided for @authSignUpDescription.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte de jeu'**
  String get authSignUpDescription;

  /// No description provided for @authLoginDescription.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour synchroniser vos fiches'**
  String get authLoginDescription;

  /// No description provided for @authEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail / nom d’utilisateur'**
  String get authEmailLabel;

  /// No description provided for @authEmailRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir une adresse e-mail'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir une adresse e-mail valide'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir un mot de passe'**
  String get authPasswordRequired;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères'**
  String get authPasswordMinLength;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authPasswordMismatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get authPasswordMismatch;

  /// No description provided for @authCreateAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get authCreateAccount;

  /// No description provided for @authSignIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authSignIn;

  /// No description provided for @authBackToForm.
  ///
  /// In fr, this message translates to:
  /// **'Retour au formulaire de connexion'**
  String get authBackToForm;

  /// No description provided for @authHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ? Connectez-vous'**
  String get authHaveAccount;

  /// No description provided for @authNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ? Inscrivez-vous'**
  String get authNoAccount;

  /// No description provided for @authDownloadAndroid.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger l’application Android (APK)'**
  String get authDownloadAndroid;

  /// No description provided for @actionSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get actionCancel;

  /// No description provided for @actionClear.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get actionClear;

  /// No description provided for @noteDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la note ?'**
  String get noteDeleteTitle;

  /// No description provided for @noteDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous supprimer « {title} » ?'**
  String noteDeleteConfirm(String title);

  /// No description provided for @noteUntitled.
  ///
  /// In fr, this message translates to:
  /// **'cette note'**
  String get noteUntitled;

  /// No description provided for @noteDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Note supprimée'**
  String get noteDeleted;

  /// No description provided for @journalPin.
  ///
  /// In fr, this message translates to:
  /// **'Épingler'**
  String get journalPin;

  /// No description provided for @journalUnpin.
  ///
  /// In fr, this message translates to:
  /// **'Désépingler'**
  String get journalUnpin;

  /// No description provided for @journalCategoryAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get journalCategoryAll;

  /// No description provided for @journalCategoryJournal.
  ///
  /// In fr, this message translates to:
  /// **'Journal'**
  String get journalCategoryJournal;

  /// No description provided for @journalCategoryQuest.
  ///
  /// In fr, this message translates to:
  /// **'Quêtes'**
  String get journalCategoryQuest;

  /// No description provided for @journalCategoryNpc.
  ///
  /// In fr, this message translates to:
  /// **'PNJ'**
  String get journalCategoryNpc;

  /// No description provided for @journalCategoryLocation.
  ///
  /// In fr, this message translates to:
  /// **'Lieux'**
  String get journalCategoryLocation;

  /// No description provided for @journalCategoryTreasure.
  ///
  /// In fr, this message translates to:
  /// **'Trésors'**
  String get journalCategoryTreasure;

  /// No description provided for @journalNewNote.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle note'**
  String get journalNewNote;

  /// No description provided for @journalSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une note, une quête, un PNJ…'**
  String get journalSearchHint;

  /// No description provided for @journalNoMatches.
  ///
  /// In fr, this message translates to:
  /// **'Aucune note ne correspond à vos filtres.'**
  String get journalNoMatches;

  /// No description provided for @journalEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Votre journal d’aventure est vide.'**
  String get journalEmpty;

  /// No description provided for @journalEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la note'**
  String get journalEditTitle;

  /// No description provided for @journalNewEntryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle entrée au journal'**
  String get journalNewEntryTitle;

  /// No description provided for @journalCategoryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get journalCategoryLabel;

  /// No description provided for @journalTitleHint.
  ///
  /// In fr, this message translates to:
  /// **'Titre (ex. : rencontre avec le bourgmestre)'**
  String get journalTitleHint;

  /// No description provided for @journalContentHint.
  ///
  /// In fr, this message translates to:
  /// **'Détails et notes (Markdown pris en charge)'**
  String get journalContentHint;

  /// No description provided for @journalPinToTop.
  ///
  /// In fr, this message translates to:
  /// **'Épingler cette note en haut'**
  String get journalPinToTop;

  /// No description provided for @spellDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Sort supprimé'**
  String get spellDeleted;

  /// No description provided for @equipmentDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Objet supprimé'**
  String get equipmentDeleted;

  /// No description provided for @currencyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Monnaie'**
  String get currencyTitle;

  /// No description provided for @currencyManage.
  ///
  /// In fr, this message translates to:
  /// **'Gérer et convertir'**
  String get currencyManage;

  /// No description provided for @currencyCopper.
  ///
  /// In fr, this message translates to:
  /// **'PC'**
  String get currencyCopper;

  /// No description provided for @currencySilver.
  ///
  /// In fr, this message translates to:
  /// **'PA'**
  String get currencySilver;

  /// No description provided for @currencyElectrum.
  ///
  /// In fr, this message translates to:
  /// **'PE'**
  String get currencyElectrum;

  /// No description provided for @currencyGold.
  ///
  /// In fr, this message translates to:
  /// **'PO'**
  String get currencyGold;

  /// No description provided for @currencyPlatinum.
  ///
  /// In fr, this message translates to:
  /// **'PP'**
  String get currencyPlatinum;

  /// No description provided for @currencyCopperName.
  ///
  /// In fr, this message translates to:
  /// **'Cuivre'**
  String get currencyCopperName;

  /// No description provided for @currencySilverName.
  ///
  /// In fr, this message translates to:
  /// **'Argent'**
  String get currencySilverName;

  /// No description provided for @currencyElectrumName.
  ///
  /// In fr, this message translates to:
  /// **'Électrum'**
  String get currencyElectrumName;

  /// No description provided for @currencyGoldName.
  ///
  /// In fr, this message translates to:
  /// **'Or'**
  String get currencyGoldName;

  /// No description provided for @currencyPlatinumName.
  ///
  /// In fr, this message translates to:
  /// **'Platine'**
  String get currencyPlatinumName;

  /// No description provided for @currencyDecreaseTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Retirer une pièce de {coin}'**
  String currencyDecreaseTooltip(String coin);

  /// No description provided for @currencyIncreaseTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une pièce de {coin}'**
  String currencyIncreaseTooltip(String coin);

  /// No description provided for @currencyOptimized.
  ///
  /// In fr, this message translates to:
  /// **'Bourse optimisée : les pièces convertibles ont été regroupées.'**
  String get currencyOptimized;

  /// No description provided for @currencyInsufficientFunds.
  ///
  /// In fr, this message translates to:
  /// **'Fonds insuffisants dans la bourse.'**
  String get currencyInsufficientFunds;

  /// No description provided for @currencyAdded.
  ///
  /// In fr, this message translates to:
  /// **'+{amount} {coin} ajoutés à la bourse.'**
  String currencyAdded(int amount, String coin);

  /// No description provided for @currencySpent.
  ///
  /// In fr, this message translates to:
  /// **'-{amount} {coin} dépensés. La monnaie a été rendue automatiquement.'**
  String currencySpent(int amount, String coin);

  /// No description provided for @currencyEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vider la bourse ?'**
  String get currencyEmptyTitle;

  /// No description provided for @currencyEmptyConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment remettre toutes les pièces à zéro ?'**
  String get currencyEmptyConfirm;

  /// No description provided for @currencyEmptyButton.
  ///
  /// In fr, this message translates to:
  /// **'Vider'**
  String get currencyEmptyButton;

  /// No description provided for @currencyEmptied.
  ///
  /// In fr, this message translates to:
  /// **'Bourse vidée. Toutes les pièces ont été remises à zéro.'**
  String get currencyEmptied;

  /// No description provided for @currencyDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bourse et monnaies'**
  String get currencyDialogTitle;

  /// No description provided for @currencyTotalValue.
  ///
  /// In fr, this message translates to:
  /// **'Valeur totale'**
  String get currencyTotalValue;

  /// No description provided for @currencyPurseWeight.
  ///
  /// In fr, this message translates to:
  /// **'Poids de la bourse'**
  String get currencyPurseWeight;

  /// No description provided for @currencyWeightSummary.
  ///
  /// In fr, this message translates to:
  /// **'{weight} lb ({count} pièces)'**
  String currencyWeightSummary(String weight, int count);

  /// No description provided for @currencyDetailTab.
  ///
  /// In fr, this message translates to:
  /// **'Détail'**
  String get currencyDetailTab;

  /// No description provided for @currencyTransactionTab.
  ///
  /// In fr, this message translates to:
  /// **'Transaction'**
  String get currencyTransactionTab;

  /// No description provided for @currencyOptimizeTab.
  ///
  /// In fr, this message translates to:
  /// **'Optimiser'**
  String get currencyOptimizeTab;

  /// No description provided for @currencyAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get currencyAmount;

  /// No description provided for @currencyReceiveLoot.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir (butin)'**
  String get currencyReceiveLoot;

  /// No description provided for @currencySpendPurchase.
  ///
  /// In fr, this message translates to:
  /// **'Dépenser (achat)'**
  String get currencySpendPurchase;

  /// No description provided for @currencyAddToPurse.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à la bourse'**
  String get currencyAddToPurse;

  /// No description provided for @currencyMakePayment.
  ///
  /// In fr, this message translates to:
  /// **'Effectuer le paiement'**
  String get currencyMakePayment;

  /// No description provided for @currencyOptimizerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Optimiseur de bourse'**
  String get currencyOptimizerTitle;

  /// No description provided for @currencyOptimizerDescription.
  ///
  /// In fr, this message translates to:
  /// **'Convertit automatiquement les pièces de cuivre et d’argent en coupures supérieures pour réduire le poids de la bourse.'**
  String get currencyOptimizerDescription;

  /// No description provided for @currencyOptimizeButton.
  ///
  /// In fr, this message translates to:
  /// **'Convertir et alléger la bourse'**
  String get currencyOptimizeButton;

  /// No description provided for @equipmentInventory.
  ///
  /// In fr, this message translates to:
  /// **'Inventaire'**
  String get equipmentInventory;

  /// No description provided for @equipmentEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun objet.'**
  String get equipmentEmpty;

  /// No description provided for @equipmentWeightTotal.
  ///
  /// In fr, this message translates to:
  /// **'Poids total : {weight} kg'**
  String equipmentWeightTotal(String weight);

  /// No description provided for @equipmentAddTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un objet'**
  String get equipmentAddTitle;

  /// No description provided for @equipmentNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l’objet'**
  String get equipmentNameLabel;

  /// No description provided for @equipmentNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. : épée longue, rations…'**
  String get equipmentNameHint;

  /// No description provided for @equipmentQuantityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Quantité'**
  String get equipmentQuantityLabel;

  /// No description provided for @equipmentWeightLabel.
  ///
  /// In fr, this message translates to:
  /// **'Poids total (kg)'**
  String get equipmentWeightLabel;

  /// No description provided for @equipmentAttuned.
  ///
  /// In fr, this message translates to:
  /// **'Syntonie'**
  String get equipmentAttuned;

  /// No description provided for @equipmentEquipped.
  ///
  /// In fr, this message translates to:
  /// **'Équipé'**
  String get equipmentEquipped;

  /// No description provided for @equipmentStow.
  ///
  /// In fr, this message translates to:
  /// **'Ranger'**
  String get equipmentStow;

  /// No description provided for @equipmentQuantityWeight.
  ///
  /// In fr, this message translates to:
  /// **'x{quantity} • {weight} kg'**
  String equipmentQuantityWeight(int quantity, String weight);

  /// No description provided for @equipmentDecreaseQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Retirer une unité'**
  String get equipmentDecreaseQuantity;

  /// No description provided for @equipmentIncreaseQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une unité'**
  String get equipmentIncreaseQuantity;

  /// No description provided for @actionDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get actionDelete;

  /// No description provided for @actionEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get actionEdit;

  /// No description provided for @actionAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get actionAdd;

  /// No description provided for @actionConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get actionConfirm;

  /// No description provided for @actionClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get actionClose;

  /// No description provided for @actionMore.
  ///
  /// In fr, this message translates to:
  /// **'Plus d’options'**
  String get actionMore;

  /// No description provided for @errorRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est obligatoire'**
  String get errorRequired;

  /// No description provided for @errorInvalidNumber.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un nombre valide'**
  String get errorInvalidNumber;

  /// No description provided for @errorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Connexion impossible. Vérifiez votre réseau et réessayez.'**
  String get errorNetwork;

  /// No description provided for @errorPermission.
  ///
  /// In fr, this message translates to:
  /// **'Action non autorisée pour ce compte.'**
  String get errorPermission;

  /// No description provided for @actionRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get actionRetry;

  /// No description provided for @step4RaceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Race'**
  String get step4RaceLabel;

  /// No description provided for @step4SpeciesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Espèce'**
  String get step4SpeciesLabel;

  /// No description provided for @step4SubraceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Sous-race'**
  String get step4SubraceLabel;

  /// No description provided for @step4SubspeciesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Sous-espèce'**
  String get step4SubspeciesLabel;

  /// No description provided for @step4NoneOption.
  ///
  /// In fr, this message translates to:
  /// **'— Aucune —'**
  String get step4NoneOption;

  /// No description provided for @step4AsiInfoText.
  ///
  /// In fr, this message translates to:
  /// **'En D&D 2024, le bonus de caractéristique (+2/+1) vient du background, pas de l\'espèce.'**
  String get step4AsiInfoText;

  /// No description provided for @hpModifierTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier les points de vie'**
  String get hpModifierTitle;

  /// No description provided for @hpModifierCurrent.
  ///
  /// In fr, this message translates to:
  /// **'Actuel : {current} / {max}'**
  String hpModifierCurrent(int current, int max);

  /// No description provided for @hpModifierTemp.
  ///
  /// In fr, this message translates to:
  /// **'Temporaire : +{temp}'**
  String hpModifierTemp(int temp);

  /// No description provided for @hpModifierLabel.
  ///
  /// In fr, this message translates to:
  /// **'Valeur des PV'**
  String get hpModifierLabel;

  /// No description provided for @hpModifierDamage.
  ///
  /// In fr, this message translates to:
  /// **'Dégâts'**
  String get hpModifierDamage;

  /// No description provided for @hpModifierHeal.
  ///
  /// In fr, this message translates to:
  /// **'Soins'**
  String get hpModifierHeal;

  /// No description provided for @hpModifierSet.
  ///
  /// In fr, this message translates to:
  /// **'Définir'**
  String get hpModifierSet;

  /// No description provided for @hpModifierError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un nombre positif'**
  String get hpModifierError;

  /// No description provided for @hpGaugeSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Points de vie : {current} sur {max}'**
  String hpGaugeSemantics(int current, int max);

  /// No description provided for @hpOutOfMax.
  ///
  /// In fr, this message translates to:
  /// **'sur {max}'**
  String hpOutOfMax(int max);

  /// No description provided for @hpDamageAction.
  ///
  /// In fr, this message translates to:
  /// **'Dégâts (−1 PV)'**
  String get hpDamageAction;

  /// No description provided for @hpHealAction.
  ///
  /// In fr, this message translates to:
  /// **'Soins (+1 PV)'**
  String get hpHealAction;

  /// No description provided for @hpTemporaryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Points de vie temporaires'**
  String get hpTemporaryLabel;

  /// No description provided for @hpTemporaryDecrease.
  ///
  /// In fr, this message translates to:
  /// **'Retirer un point de vie temporaire'**
  String get hpTemporaryDecrease;

  /// No description provided for @hpTemporaryIncrease.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un point de vie temporaire'**
  String get hpTemporaryIncrease;

  /// No description provided for @combatWeaponsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Armes et attaques'**
  String get combatWeaponsTitle;

  /// No description provided for @combatNoAttack.
  ///
  /// In fr, this message translates to:
  /// **'Aucune attaque configurée.'**
  String get combatNoAttack;

  /// No description provided for @attackAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une attaque'**
  String get attackAdd;

  /// No description provided for @attackNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get attackNameLabel;

  /// No description provided for @attackBonusLabel.
  ///
  /// In fr, this message translates to:
  /// **'Bonus (ex. : +5)'**
  String get attackBonusLabel;

  /// No description provided for @attackDamageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Dégâts (ex. : 1d8+3)'**
  String get attackDamageLabel;

  /// No description provided for @attackTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type (ex. : perforant)'**
  String get attackTypeLabel;

  /// No description provided for @attackMasteryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrise d’arme (2024)'**
  String get attackMasteryLabel;

  /// No description provided for @attackMasteryNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune'**
  String get attackMasteryNone;

  /// No description provided for @rollAbilityDieTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Lancer un dé de caractéristique'**
  String get rollAbilityDieTooltip;

  /// No description provided for @rollSaveTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Lancer un jet de sauvegarde'**
  String get rollSaveTooltip;

  /// No description provided for @resourceDecrease.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser une ressource'**
  String get resourceDecrease;

  /// No description provided for @resourceIncrease.
  ///
  /// In fr, this message translates to:
  /// **'Récupérer une ressource'**
  String get resourceIncrease;

  /// No description provided for @spellPreparedTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Préparé (cliquer pour retirer)'**
  String get spellPreparedTooltip;

  /// No description provided for @spellUnpreparedTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Non préparé (cliquer pour préparer)'**
  String get spellUnpreparedTooltip;

  /// No description provided for @spellCastTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Lancer le sort'**
  String get spellCastTooltip;

  /// No description provided for @spellAttackTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Jet d’attaque magique (d20 + {bonus})'**
  String spellAttackTooltip(int bonus);

  /// No description provided for @spellDamageTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Dégâts ({formula})'**
  String spellDamageTooltip(String formula);

  /// No description provided for @spellAttackTitle.
  ///
  /// In fr, this message translates to:
  /// **'Attaque magique : {name}'**
  String spellAttackTitle(String name);

  /// No description provided for @spellDamageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dégâts : {name}'**
  String spellDamageTitle(String name);

  /// No description provided for @combatQuickTitle.
  ///
  /// In fr, this message translates to:
  /// **'Combat rapide : {weapon}'**
  String combatQuickTitle(String weapon);

  /// No description provided for @combatHitDamage.
  ///
  /// In fr, this message translates to:
  /// **'Touche : {attack} | Dégâts : {damage}'**
  String combatHitDamage(String attack, String damage);

  /// No description provided for @combatAttackAndDamage.
  ///
  /// In fr, this message translates to:
  /// **'Attaquer et dégâts (1 clic)'**
  String get combatAttackAndDamage;

  /// No description provided for @combatMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode :'**
  String get combatMode;

  /// No description provided for @combatHitOnly.
  ///
  /// In fr, this message translates to:
  /// **'Touche seule'**
  String get combatHitOnly;

  /// No description provided for @combatCritical.
  ///
  /// In fr, this message translates to:
  /// **'Critique !'**
  String get combatCritical;

  /// No description provided for @ammoChooseBeforeFire.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez des munitions avant de tirer !'**
  String get ammoChooseBeforeFire;

  /// No description provided for @ammoOutOfStock.
  ///
  /// In fr, this message translates to:
  /// **'Vous n’avez plus de {item} !'**
  String ammoOutOfStock(String item);

  /// No description provided for @heroicInspirationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inspiration héroïque'**
  String get heroicInspirationTitle;

  /// No description provided for @weaponMasteryDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrise d’arme : {name}'**
  String weaponMasteryDialogTitle(String name);

  /// No description provided for @deathSaveSuccesses.
  ///
  /// In fr, this message translates to:
  /// **'Succès'**
  String get deathSaveSuccesses;

  /// No description provided for @deathSaveFailures.
  ///
  /// In fr, this message translates to:
  /// **'Échecs'**
  String get deathSaveFailures;

  /// No description provided for @deathSaveSuccessMarker.
  ///
  /// In fr, this message translates to:
  /// **'Succès {marker}, {count} marqués'**
  String deathSaveSuccessMarker(int marker, int count);

  /// No description provided for @deathSaveFailureMarker.
  ///
  /// In fr, this message translates to:
  /// **'Échec {marker}, {count} marqués'**
  String deathSaveFailureMarker(int marker, int count);

  /// No description provided for @restSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Repos'**
  String get restSectionTitle;

  /// No description provided for @restShortRest.
  ///
  /// In fr, this message translates to:
  /// **'Repos court'**
  String get restShortRest;

  /// No description provided for @restLongRest.
  ///
  /// In fr, this message translates to:
  /// **'Repos long'**
  String get restLongRest;

  /// No description provided for @restShortRestConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous effectuer un repos court ? Vos capacités de repos court seront réinitialisées.'**
  String get restShortRestConfirm;

  /// No description provided for @restLongRestConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous effectuer un repos long ? Vos PV, emplacements de sorts et capacités seront restaurés.'**
  String get restLongRestConfirm;

  /// No description provided for @restSuccessMessage.
  ///
  /// In fr, this message translates to:
  /// **'Repos effectué !'**
  String get restSuccessMessage;

  /// No description provided for @resourceHitDiceD6.
  ///
  /// In fr, this message translates to:
  /// **'Dés de vie (d6)'**
  String get resourceHitDiceD6;

  /// No description provided for @resourceHitDiceD8.
  ///
  /// In fr, this message translates to:
  /// **'Dés de vie (d8)'**
  String get resourceHitDiceD8;

  /// No description provided for @resourceHitDiceD10.
  ///
  /// In fr, this message translates to:
  /// **'Dés de vie (d10)'**
  String get resourceHitDiceD10;

  /// No description provided for @resourceHitDiceD12.
  ///
  /// In fr, this message translates to:
  /// **'Dés de vie (d12)'**
  String get resourceHitDiceD12;

  /// No description provided for @shortRestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Repos court'**
  String get shortRestTitle;

  /// No description provided for @shortRestRollButton.
  ///
  /// In fr, this message translates to:
  /// **'Lancer 1d{die} ({count} restants)'**
  String shortRestRollButton(String die, int count);

  /// No description provided for @shortRestNoDice.
  ///
  /// In fr, this message translates to:
  /// **'Aucun dé de vie disponible.'**
  String get shortRestNoDice;

  /// No description provided for @shortRestHpFull.
  ///
  /// In fr, this message translates to:
  /// **'Vos PV sont au maximum.'**
  String get shortRestHpFull;

  /// No description provided for @shortRestRollResult.
  ///
  /// In fr, this message translates to:
  /// **'Jet : {roll} + {con} (Con) = +{heal} PV'**
  String shortRestRollResult(int roll, int con, int heal);

  /// No description provided for @shortRestClose.
  ///
  /// In fr, this message translates to:
  /// **'Terminer le repos'**
  String get shortRestClose;

  /// No description provided for @restCharacterNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Personnage introuvable'**
  String get restCharacterNotFound;

  /// No description provided for @characterNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Personnage introuvable'**
  String get characterNotFound;

  /// No description provided for @hitPointsCurrent.
  ///
  /// In fr, this message translates to:
  /// **'{current} / {max} PV'**
  String hitPointsCurrent(int current, int max);

  /// No description provided for @shortRestHealingHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des soins'**
  String get shortRestHealingHistory;

  /// No description provided for @conditionsSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'États & Conditions'**
  String get conditionsSectionTitle;

  /// No description provided for @conditionsEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier les États'**
  String get conditionsEditTitle;

  /// No description provided for @conditionsNoneActive.
  ///
  /// In fr, this message translates to:
  /// **'Aucun état particulier.'**
  String get conditionsNoneActive;

  /// No description provided for @conditionsExhaustionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau d\'Épuisement : {level}'**
  String conditionsExhaustionLabel(int level);

  /// No description provided for @conditionBlinded.
  ///
  /// In fr, this message translates to:
  /// **'Aveuglé'**
  String get conditionBlinded;

  /// No description provided for @conditionBlindedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous échouez automatiquement les tests basés sur la vue. Les jets d\'attaque contre vous ont l\'avantage, et vos propres jets d\'attaque ont le désavantage.'**
  String get conditionBlindedDesc;

  /// No description provided for @conditionCharmed.
  ///
  /// In fr, this message translates to:
  /// **'Charmé'**
  String get conditionCharmed;

  /// No description provided for @conditionCharmedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne pouvez pas attaquer ou cibler avec des capacités nuisibles la créature qui vous a charmé. Elle a l\'avantage aux tests d\'interaction sociale contre vous.'**
  String get conditionCharmedDesc;

  /// No description provided for @conditionDeafened.
  ///
  /// In fr, this message translates to:
  /// **'Assourdi'**
  String get conditionDeafened;

  /// No description provided for @conditionDeafenedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous échouez automatiquement les tests basés sur l\'ouïe.'**
  String get conditionDeafenedDesc;

  /// No description provided for @conditionFrightened.
  ///
  /// In fr, this message translates to:
  /// **'Effrayé'**
  String get conditionFrightened;

  /// No description provided for @conditionFrightenedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez le désavantage aux tests de caractéristiques et aux jets d\'attaque tant que la source de votre peur est visible. Vous ne pouvez pas volontairement vous en approcher.'**
  String get conditionFrightenedDesc;

  /// No description provided for @conditionGrappled.
  ///
  /// In fr, this message translates to:
  /// **'Agrippé'**
  String get conditionGrappled;

  /// No description provided for @conditionGrappledDesc.
  ///
  /// In fr, this message translates to:
  /// **'Votre vitesse devient 0 et ne peut plus augmenter.'**
  String get conditionGrappledDesc;

  /// No description provided for @conditionIncapacitated.
  ///
  /// In fr, this message translates to:
  /// **'Neutralisé'**
  String get conditionIncapacitated;

  /// No description provided for @conditionIncapacitatedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne pouvez faire aucune action ni réaction.'**
  String get conditionIncapacitatedDesc;

  /// No description provided for @conditionInvisible.
  ///
  /// In fr, this message translates to:
  /// **'Invisible'**
  String get conditionInvisible;

  /// No description provided for @conditionInvisibleDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes impossible à voir sans l\'aide de la magie ou d\'un sens spécial. Vos attaques ont l\'avantage, et les attaques contre vous ont le désavantage.'**
  String get conditionInvisibleDesc;

  /// No description provided for @conditionParalyzed.
  ///
  /// In fr, this message translates to:
  /// **'Paralysé'**
  String get conditionParalyzed;

  /// No description provided for @conditionParalyzedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes neutralisé et votre vitesse est de 0. Échec automatique aux jets de Force et Dextérité. Les attaques contre vous ont l\'avantage, et toute attaque réussie à moins de 1,5 mètre est un coup critique.'**
  String get conditionParalyzedDesc;

  /// No description provided for @conditionPetrified.
  ///
  /// In fr, this message translates to:
  /// **'Pétrifié'**
  String get conditionPetrified;

  /// No description provided for @conditionPetrifiedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes transformé en pierre solide et votre poids est multiplié par 10. Vitesse = 0, neutralisé. Échec auto aux jets de Force et Dextérité. Résistant à tous les dégâts, immunisé aux poisons et maladies.'**
  String get conditionPetrifiedDesc;

  /// No description provided for @conditionPoisoned.
  ///
  /// In fr, this message translates to:
  /// **'Empoisonné'**
  String get conditionPoisoned;

  /// No description provided for @conditionPoisonedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez le désavantage aux jets d\'attaque et aux tests de caractéristiques.'**
  String get conditionPoisonedDesc;

  /// No description provided for @conditionProne.
  ///
  /// In fr, this message translates to:
  /// **'À terre'**
  String get conditionProne;

  /// No description provided for @conditionProneDesc.
  ///
  /// In fr, this message translates to:
  /// **'Votre seule option de déplacement est de ramper. Vos attaques ont le désavantage. Les attaques au corps-à-corps contre vous ont l\'avantage, tandis que les attaques à distance ont le désavantage.'**
  String get conditionProneDesc;

  /// No description provided for @conditionRestrained.
  ///
  /// In fr, this message translates to:
  /// **'Entravé'**
  String get conditionRestrained;

  /// No description provided for @conditionRestrainedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Votre vitesse est de 0. Vos attaques ont le désavantage, et les attaques contre vous ont l\'avantage. Vous avez le désavantage aux jets de sauvegarde de Dextérité.'**
  String get conditionRestrainedDesc;

  /// No description provided for @conditionStunned.
  ///
  /// In fr, this message translates to:
  /// **'Étourdi'**
  String get conditionStunned;

  /// No description provided for @conditionStunnedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes neutralisé, votre vitesse est de 0, et vous parlez de manière incohérente. Échec automatique aux jets de Force et Dextérité. Les attaques contre vous ont l\'avantage.'**
  String get conditionStunnedDesc;

  /// No description provided for @conditionUnconscious.
  ///
  /// In fr, this message translates to:
  /// **'Inconscient'**
  String get conditionUnconscious;

  /// No description provided for @conditionUnconsciousDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes neutralisé, lâchez tout ce que vous tenez et tombez à terre. Échec automatique aux jets de Force et Dextérité. Les attaques contre vous ont l\'avantage, et toute attaque réussie à moins de 1,5 mètre est un coup critique.'**
  String get conditionUnconsciousDesc;

  /// No description provided for @conditionExhaustion.
  ///
  /// In fr, this message translates to:
  /// **'Épuisement'**
  String get conditionExhaustion;

  /// No description provided for @conditionExhaustionDesc.
  ///
  /// In fr, this message translates to:
  /// **'Niveau 1 : Désavantage aux tests.\nNiveau 2 : Vitesse divisée par 2.\nNiveau 3 : Désavantage aux attaques/sauvegardes.\nNiveau 4 : PV max divisés par 2.\nNiveau 5 : Vitesse = 0.\nNiveau 6 : Mort.'**
  String get conditionExhaustionDesc;

  /// No description provided for @diceRollerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Lanceur de dés'**
  String get diceRollerTitle;

  /// No description provided for @diceRollerRoll.
  ///
  /// In fr, this message translates to:
  /// **'Lancer !'**
  String get diceRollerRoll;

  /// No description provided for @diceRollerResult.
  ///
  /// In fr, this message translates to:
  /// **'Résultat'**
  String get diceRollerResult;

  /// No description provided for @diceRollerMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode de lancer'**
  String get diceRollerMode;

  /// No description provided for @diceRollerNormal.
  ///
  /// In fr, this message translates to:
  /// **'Normal'**
  String get diceRollerNormal;

  /// No description provided for @diceRollerAdvantage.
  ///
  /// In fr, this message translates to:
  /// **'Avantage'**
  String get diceRollerAdvantage;

  /// No description provided for @diceRollerDisadvantage.
  ///
  /// In fr, this message translates to:
  /// **'Désavantage'**
  String get diceRollerDisadvantage;

  /// No description provided for @diceRollerFormula.
  ///
  /// In fr, this message translates to:
  /// **'Formule : {formula}'**
  String diceRollerFormula(String formula);

  /// No description provided for @diceRollerRollCount.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de dés'**
  String get diceRollerRollCount;

  /// No description provided for @diceRollerRollBonus.
  ///
  /// In fr, this message translates to:
  /// **'Modificateur'**
  String get diceRollerRollBonus;

  /// No description provided for @diceRollerDieSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Dé à {sides} faces'**
  String diceRollerDieSemantics(int sides);

  /// No description provided for @diceRollerDecreaseCount.
  ///
  /// In fr, this message translates to:
  /// **'Retirer un dé'**
  String get diceRollerDecreaseCount;

  /// No description provided for @diceRollerIncreaseCount.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un dé'**
  String get diceRollerIncreaseCount;

  /// No description provided for @diceRollerDecreaseBonus.
  ///
  /// In fr, this message translates to:
  /// **'Diminuer le modificateur'**
  String get diceRollerDecreaseBonus;

  /// No description provided for @diceRollerIncreaseBonus.
  ///
  /// In fr, this message translates to:
  /// **'Augmenter le modificateur'**
  String get diceRollerIncreaseBonus;

  /// No description provided for @diceRollerHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des lancers'**
  String get diceRollerHistory;

  /// No description provided for @rollAbilityCheck.
  ///
  /// In fr, this message translates to:
  /// **'Test de {name}'**
  String rollAbilityCheck(String name);

  /// No description provided for @rollSaveCheck.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde de {name}'**
  String rollSaveCheck(String name);

  /// No description provided for @rollSkillCheck.
  ///
  /// In fr, this message translates to:
  /// **'Test de {name}'**
  String rollSkillCheck(String name);

  /// No description provided for @rollAttackCheck.
  ///
  /// In fr, this message translates to:
  /// **'Jet d\'attaque : {name}'**
  String rollAttackCheck(String name);

  /// No description provided for @rollDamageCheck.
  ///
  /// In fr, this message translates to:
  /// **'Jet de dégâts : {name}'**
  String rollDamageCheck(String name);

  /// No description provided for @sheetScoresNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristiques introuvables'**
  String get sheetScoresNotFound;

  /// No description provided for @sheetEditAbilitiesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristiques et statistiques'**
  String get sheetEditAbilitiesTitle;

  /// No description provided for @spellPreparationLimit.
  ///
  /// In fr, this message translates to:
  /// **'Limite de préparation'**
  String get spellPreparationLimit;

  /// No description provided for @spellPreparationLimitDescription.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez déjà préparé le nombre maximum autorisé de sorts ({count}). Retirez-en un avant d’en préparer un autre.'**
  String spellPreparationLimitDescription(int count);

  /// No description provided for @spellNoSlots.
  ///
  /// In fr, this message translates to:
  /// **'Aucun emplacement disponible'**
  String get spellNoSlots;

  /// No description provided for @spellNoSlotsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Il ne vous reste aucun emplacement de niveau {level} ou supérieur pour lancer {name}.'**
  String spellNoSlotsDescription(int level, String name);

  /// No description provided for @spellOvercastTitle.
  ///
  /// In fr, this message translates to:
  /// **'Surclasser {name} ?'**
  String spellOvercastTitle(String name);

  /// No description provided for @spellOvercastDescription.
  ///
  /// In fr, this message translates to:
  /// **'Aucun emplacement de niveau {level} disponible. Voulez-vous lancer le sort à un niveau supérieur ?'**
  String spellOvercastDescription(int level);

  /// No description provided for @spellAvailableSlots.
  ///
  /// In fr, this message translates to:
  /// **'{current}/{max} disponibles'**
  String spellAvailableSlots(int current, int max);

  /// No description provided for @spellSlotSpent.
  ///
  /// In fr, this message translates to:
  /// **'Lancement de {name} ! (emplacement de niveau {level} dépensé)'**
  String spellSlotSpent(String name, int level);

  /// No description provided for @actionOk.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get actionOk;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
