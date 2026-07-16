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

  /// Titre de l'application
  ///
  /// In fr, this message translates to:
  /// **'Gestionnaire D&D'**
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
  /// **'Chaotic Bon'**
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
