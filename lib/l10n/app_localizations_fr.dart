// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get skillAthletics => 'Athlétisme';

  @override
  String get skillAcrobatics => 'Acrobaties';

  @override
  String get skillSleightOfHand => 'Escamotage';

  @override
  String get skillStealth => 'Discrétion';

  @override
  String get skillArcana => 'Arcanes';

  @override
  String get skillHistory => 'Histoire';

  @override
  String get skillInvestigation => 'Investigation';

  @override
  String get skillNature => 'Nature';

  @override
  String get skillReligion => 'Religion';

  @override
  String get skillAnimalHandling => 'Dressage';

  @override
  String get skillInsight => 'Perspicacité';

  @override
  String get skillMedicine => 'Médecine';

  @override
  String get skillPerception => 'Perception';

  @override
  String get skillSurvival => 'Survie';

  @override
  String get skillDeception => 'Tromperie';

  @override
  String get skillIntimidation => 'Intimidation';

  @override
  String get skillPerformance => 'Représentation';

  @override
  String get skillPersuasion => 'Persuasion';

  @override
  String get appTitle => 'Le Codex de l\'Aventurier';

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
  String get characterSearch => 'Rechercher un personnage';

  @override
  String get characterNoSearchResults => 'Aucun personnage correspondant';

  @override
  String get characterSort => 'Trier les personnages';

  @override
  String get characterSortName => 'Nom (A à Z)';

  @override
  String get characterSortLevel => 'Niveau (décroissant)';

  @override
  String get characterSortUpdated => 'Dernière modification';

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
  String get alignmentCG => 'Chaotique Bon';

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
  String get sheetTabJournalShort => 'Journal';

  @override
  String get sheetTabCompanionsShort => 'Alliés';

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
  String get profilePhotoUploading => 'Téléchargement de la photo…';

  @override
  String get profilePhotoUpdated => 'Photo mise à jour avec succès !';

  @override
  String profilePhotoUploadError(String error) {
    return 'Erreur lors du téléchargement : $error';
  }

  @override
  String get profileAbilitySection => 'Caractéristiques et statistiques';

  @override
  String get profileEditAbilities =>
      'Modifier les caractéristiques et statistiques';

  @override
  String get profileProficienciesLanguages => 'Maîtrises et langues';

  @override
  String get profileManageProficiencies => 'Gérer les maîtrises';

  @override
  String get proficiencyArmors => 'Armures';

  @override
  String get proficiencyWeapons => 'Armes';

  @override
  String get proficiencyWeaponMasteries => 'Maîtrises d’armes (2024)';

  @override
  String get proficiencyTools => 'Outils';

  @override
  String get profileFeatsSection => 'Dons du personnage';

  @override
  String get profileFeatEmpty => 'Aucun don enregistré';

  @override
  String get profileAddFeat => 'Ajouter un don';

  @override
  String get profileAddFeatTitle => 'Ajouter un don';

  @override
  String get profileSearchFeat => 'Rechercher un don';

  @override
  String get profileNoAvailableFeats => 'Aucun don disponible.';

  @override
  String get proficiencyNone => 'Non';

  @override
  String get proficiencyTrained => 'Maîtrisé';

  @override
  String get proficiencyExpertise => 'Expertise';

  @override
  String get proficiencyManageTitle => 'Gérer les maîtrises et l’expertise';

  @override
  String get proficiencySkillsTab => 'Compétences';

  @override
  String get proficiencyToolsTab => 'Outils';

  @override
  String get actionApply => 'Valider';

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
  String get settingsAccountTitle => 'Compte utilisateur';

  @override
  String get settingsAccountConnected => 'Compte connecté';

  @override
  String get settingsSignOut => 'Se déconnecter';

  @override
  String versionLabel(String version, String buildDate) {
    return 'Version $version ($buildDate)';
  }

  @override
  String get authSignUpSuccess =>
      'Inscription réussie ! Vérifiez vos e-mails si une validation est requise.';

  @override
  String get authLoginFailure =>
      'Échec de l’authentification. Vérifiez vos identifiants et réessayez.';

  @override
  String get authUnexpectedFailure =>
      'Une erreur inattendue est survenue. Veuillez réessayer plus tard.';

  @override
  String get authMissingConfig =>
      'Erreur : les variables d’environnement Supabase sont manquantes.';

  @override
  String get authSignUpDescription => 'Créer un compte de jeu';

  @override
  String get authLoginDescription =>
      'Connectez-vous pour synchroniser vos fiches';

  @override
  String get authEmailLabel => 'Adresse e-mail / nom d’utilisateur';

  @override
  String get authEmailRequired => 'Veuillez saisir une adresse e-mail';

  @override
  String get authEmailInvalid => 'Veuillez saisir une adresse e-mail valide';

  @override
  String get authPasswordLabel => 'Mot de passe';

  @override
  String get authPasswordRequired => 'Veuillez saisir un mot de passe';

  @override
  String get authPasswordMinLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get authConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get authPasswordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get authCreateAccount => 'Créer mon compte';

  @override
  String get authSignIn => 'Se connecter';

  @override
  String get authBackToForm => 'Retour au formulaire de connexion';

  @override
  String get authHaveAccount => 'Déjà un compte ? Connectez-vous';

  @override
  String get authNoAccount => 'Pas encore de compte ? Inscrivez-vous';

  @override
  String get authDownloadAndroid => 'Télécharger l’application Android (APK)';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionClear => 'Effacer';

  @override
  String get noteDeleteTitle => 'Supprimer la note ?';

  @override
  String noteDeleteConfirm(String title) {
    return 'Voulez-vous supprimer « $title » ?';
  }

  @override
  String get noteUntitled => 'cette note';

  @override
  String get noteDeleted => 'Note supprimée';

  @override
  String get journalPin => 'Épingler';

  @override
  String get journalUnpin => 'Désépingler';

  @override
  String get journalCategoryAll => 'Toutes';

  @override
  String get journalCategoryJournal => 'Journal';

  @override
  String get journalCategoryQuest => 'Quêtes';

  @override
  String get journalCategoryNpc => 'PNJ';

  @override
  String get journalCategoryLocation => 'Lieux';

  @override
  String get journalCategoryTreasure => 'Trésors';

  @override
  String get journalNewNote => 'Nouvelle note';

  @override
  String get journalSearchHint => 'Rechercher une note, une quête, un PNJ…';

  @override
  String get journalNoMatches => 'Aucune note ne correspond à vos filtres.';

  @override
  String get journalEmpty => 'Votre journal d’aventure est vide.';

  @override
  String get journalEditTitle => 'Modifier la note';

  @override
  String get journalNewEntryTitle => 'Nouvelle entrée au journal';

  @override
  String get journalCategoryLabel => 'Catégorie';

  @override
  String get journalTitleHint => 'Titre (ex. : rencontre avec le bourgmestre)';

  @override
  String get journalContentHint => 'Détails et notes (Markdown pris en charge)';

  @override
  String get journalPinToTop => 'Épingler cette note en haut';

  @override
  String get spellDeleted => 'Sort supprimé';

  @override
  String get equipmentDeleted => 'Objet supprimé';

  @override
  String get currencyTitle => 'Monnaie';

  @override
  String get currencyManage => 'Gérer et convertir';

  @override
  String get currencyCopper => 'PC';

  @override
  String get currencySilver => 'PA';

  @override
  String get currencyElectrum => 'PE';

  @override
  String get currencyGold => 'PO';

  @override
  String get currencyPlatinum => 'PP';

  @override
  String get currencyCopperName => 'Cuivre';

  @override
  String get currencySilverName => 'Argent';

  @override
  String get currencyElectrumName => 'Électrum';

  @override
  String get currencyGoldName => 'Or';

  @override
  String get currencyPlatinumName => 'Platine';

  @override
  String currencyDecreaseTooltip(String coin) {
    return 'Retirer une pièce de $coin';
  }

  @override
  String currencyIncreaseTooltip(String coin) {
    return 'Ajouter une pièce de $coin';
  }

  @override
  String get currencyOptimized =>
      'Bourse optimisée : les pièces convertibles ont été regroupées.';

  @override
  String get currencyInsufficientFunds => 'Fonds insuffisants dans la bourse.';

  @override
  String currencyAdded(int amount, String coin) {
    return '+$amount $coin ajoutés à la bourse.';
  }

  @override
  String currencySpent(int amount, String coin) {
    return '-$amount $coin dépensés. La monnaie a été rendue automatiquement.';
  }

  @override
  String get currencyEmptyTitle => 'Vider la bourse ?';

  @override
  String get currencyEmptyConfirm =>
      'Voulez-vous vraiment remettre toutes les pièces à zéro ?';

  @override
  String get currencyEmptyButton => 'Vider';

  @override
  String get currencyEmptied =>
      'Bourse vidée. Toutes les pièces ont été remises à zéro.';

  @override
  String get currencyDialogTitle => 'Bourse et monnaies';

  @override
  String get currencyTotalValue => 'Valeur totale';

  @override
  String get currencyPurseWeight => 'Poids de la bourse';

  @override
  String currencyWeightSummary(String weight, int count) {
    return '$weight lb ($count pièces)';
  }

  @override
  String get currencyDetailTab => 'Détail';

  @override
  String get currencyTransactionTab => 'Transaction';

  @override
  String get currencyOptimizeTab => 'Optimiser';

  @override
  String get currencyAmount => 'Montant';

  @override
  String get currencyReceiveLoot => 'Recevoir (butin)';

  @override
  String get currencySpendPurchase => 'Dépenser (achat)';

  @override
  String get currencyAddToPurse => 'Ajouter à la bourse';

  @override
  String get currencyMakePayment => 'Effectuer le paiement';

  @override
  String get currencyOptimizerTitle => 'Optimiseur de bourse';

  @override
  String get currencyOptimizerDescription =>
      'Convertit automatiquement les pièces de cuivre et d’argent en coupures supérieures pour réduire le poids de la bourse.';

  @override
  String get currencyOptimizeButton => 'Convertir et alléger la bourse';

  @override
  String get equipmentInventory => 'Inventaire';

  @override
  String get equipmentEmpty => 'Aucun objet.';

  @override
  String equipmentWeightTotal(String weight) {
    return 'Poids total : $weight kg';
  }

  @override
  String get equipmentAddTitle => 'Ajouter un objet';

  @override
  String get equipmentNameLabel => 'Nom de l’objet';

  @override
  String get equipmentNameHint => 'Ex. : épée longue, rations…';

  @override
  String get equipmentQuantityLabel => 'Quantité';

  @override
  String get equipmentWeightLabel => 'Poids total (kg)';

  @override
  String get equipmentAttuned => 'Syntonie';

  @override
  String get equipmentEquipped => 'Équipé';

  @override
  String get equipmentStow => 'Ranger';

  @override
  String equipmentQuantityWeight(int quantity, String weight) {
    return 'x$quantity • $weight kg';
  }

  @override
  String get equipmentDecreaseQuantity => 'Retirer une unité';

  @override
  String get equipmentIncreaseQuantity => 'Ajouter une unité';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionEdit => 'Modifier';

  @override
  String get actionAdd => 'Ajouter';

  @override
  String get actionConfirm => 'Confirmer';

  @override
  String get actionClose => 'Fermer';

  @override
  String get actionMore => 'Plus d’options';

  @override
  String get errorRequired => 'Ce champ est obligatoire';

  @override
  String get errorInvalidNumber => 'Veuillez entrer un nombre valide';

  @override
  String get errorGeneric => 'Une erreur est survenue';

  @override
  String get errorNetwork =>
      'Connexion impossible. Vérifiez votre réseau et réessayez.';

  @override
  String get errorPermission => 'Action non autorisée pour ce compte.';

  @override
  String get actionRetry => 'Réessayer';

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
  String hpGaugeSemantics(int current, int max) {
    return 'Points de vie : $current sur $max';
  }

  @override
  String hpOutOfMax(int max) {
    return 'sur $max';
  }

  @override
  String get hpDamageAction => 'Dégâts (−1 PV)';

  @override
  String get hpHealAction => 'Soins (+1 PV)';

  @override
  String get hpTemporaryLabel => 'Points de vie temporaires';

  @override
  String get hpTemporaryDecrease => 'Retirer un point de vie temporaire';

  @override
  String get hpTemporaryIncrease => 'Ajouter un point de vie temporaire';

  @override
  String get combatWeaponsTitle => 'Armes et attaques';

  @override
  String get combatNoAttack => 'Aucune attaque configurée.';

  @override
  String get attackAdd => 'Ajouter une attaque';

  @override
  String get attackNameLabel => 'Nom';

  @override
  String get attackBonusLabel => 'Bonus (ex. : +5)';

  @override
  String get attackDamageLabel => 'Dégâts (ex. : 1d8+3)';

  @override
  String get attackTypeLabel => 'Type (ex. : perforant)';

  @override
  String get attackMasteryLabel => 'Maîtrise d’arme (2024)';

  @override
  String get attackMasteryNone => 'Aucune';

  @override
  String get rollAbilityDieTooltip => 'Lancer un dé de caractéristique';

  @override
  String get rollSaveTooltip => 'Lancer un jet de sauvegarde';

  @override
  String get resourceDecrease => 'Utiliser une ressource';

  @override
  String get resourceIncrease => 'Récupérer une ressource';

  @override
  String get spellPreparedTooltip => 'Préparé (cliquer pour retirer)';

  @override
  String get spellUnpreparedTooltip => 'Non préparé (cliquer pour préparer)';

  @override
  String get spellCastTooltip => 'Lancer le sort';

  @override
  String spellAttackTooltip(int bonus) {
    return 'Jet d’attaque magique (d20 + $bonus)';
  }

  @override
  String spellDamageTooltip(String formula) {
    return 'Dégâts ($formula)';
  }

  @override
  String spellAttackTitle(String name) {
    return 'Attaque magique : $name';
  }

  @override
  String spellDamageTitle(String name) {
    return 'Dégâts : $name';
  }

  @override
  String combatQuickTitle(String weapon) {
    return 'Combat rapide : $weapon';
  }

  @override
  String combatHitDamage(String attack, String damage) {
    return 'Touche : $attack | Dégâts : $damage';
  }

  @override
  String get combatAttackAndDamage => 'Attaquer et dégâts (1 clic)';

  @override
  String get combatMode => 'Mode :';

  @override
  String get combatHitOnly => 'Touche seule';

  @override
  String get combatCritical => 'Critique !';

  @override
  String get ammoChooseBeforeFire =>
      'Choisissez des munitions avant de tirer !';

  @override
  String ammoOutOfStock(String item) {
    return 'Vous n’avez plus de $item !';
  }

  @override
  String get heroicInspirationTitle => 'Inspiration héroïque';

  @override
  String weaponMasteryDialogTitle(String name) {
    return 'Maîtrise d’arme : $name';
  }

  @override
  String get deathSaveSuccesses => 'Succès';

  @override
  String get deathSaveFailures => 'Échecs';

  @override
  String deathSaveSuccessMarker(int marker, int count) {
    return 'Succès $marker, $count marqués';
  }

  @override
  String deathSaveFailureMarker(int marker, int count) {
    return 'Échec $marker, $count marqués';
  }

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

  @override
  String get restCharacterNotFound => 'Personnage introuvable';

  @override
  String get characterNotFound => 'Personnage introuvable';

  @override
  String hitPointsCurrent(int current, int max) {
    return '$current / $max PV';
  }

  @override
  String get shortRestHealingHistory => 'Historique des soins';

  @override
  String get conditionsSectionTitle => 'États & Conditions';

  @override
  String get conditionsEditTitle => 'Modifier les États';

  @override
  String get conditionsNoneActive => 'Aucun état particulier.';

  @override
  String conditionsExhaustionLabel(int level) {
    return 'Niveau d\'Épuisement : $level';
  }

  @override
  String get conditionBlinded => 'Aveuglé';

  @override
  String get conditionBlindedDesc =>
      'Vous échouez automatiquement les tests basés sur la vue. Les jets d\'attaque contre vous ont l\'avantage, et vos propres jets d\'attaque ont le désavantage.';

  @override
  String get conditionCharmed => 'Charmé';

  @override
  String get conditionCharmedDesc =>
      'Vous ne pouvez pas attaquer ou cibler avec des capacités nuisibles la créature qui vous a charmé. Elle a l\'avantage aux tests d\'interaction sociale contre vous.';

  @override
  String get conditionDeafened => 'Assourdi';

  @override
  String get conditionDeafenedDesc =>
      'Vous échouez automatiquement les tests basés sur l\'ouïe.';

  @override
  String get conditionFrightened => 'Effrayé';

  @override
  String get conditionFrightenedDesc =>
      'Vous avez le désavantage aux tests de caractéristiques et aux jets d\'attaque tant que la source de votre peur est visible. Vous ne pouvez pas volontairement vous en approcher.';

  @override
  String get conditionGrappled => 'Agrippé';

  @override
  String get conditionGrappledDesc =>
      'Votre vitesse devient 0 et ne peut plus augmenter.';

  @override
  String get conditionIncapacitated => 'Neutralisé';

  @override
  String get conditionIncapacitatedDesc =>
      'Vous ne pouvez faire aucune action ni réaction.';

  @override
  String get conditionInvisible => 'Invisible';

  @override
  String get conditionInvisibleDesc =>
      'Vous êtes impossible à voir sans l\'aide de la magie ou d\'un sens spécial. Vos attaques ont l\'avantage, et les attaques contre vous ont le désavantage.';

  @override
  String get conditionParalyzed => 'Paralysé';

  @override
  String get conditionParalyzedDesc =>
      'Vous êtes neutralisé et votre vitesse est de 0. Échec automatique aux jets de Force et Dextérité. Les attaques contre vous ont l\'avantage, et toute attaque réussie à moins de 1,5 mètre est un coup critique.';

  @override
  String get conditionPetrified => 'Pétrifié';

  @override
  String get conditionPetrifiedDesc =>
      'Vous êtes transformé en pierre solide et votre poids est multiplié par 10. Vitesse = 0, neutralisé. Échec auto aux jets de Force et Dextérité. Résistant à tous les dégâts, immunisé aux poisons et maladies.';

  @override
  String get conditionPoisoned => 'Empoisonné';

  @override
  String get conditionPoisonedDesc =>
      'Vous avez le désavantage aux jets d\'attaque et aux tests de caractéristiques.';

  @override
  String get conditionProne => 'À terre';

  @override
  String get conditionProneDesc =>
      'Votre seule option de déplacement est de ramper. Vos attaques ont le désavantage. Les attaques au corps-à-corps contre vous ont l\'avantage, tandis que les attaques à distance ont le désavantage.';

  @override
  String get conditionRestrained => 'Entravé';

  @override
  String get conditionRestrainedDesc =>
      'Votre vitesse est de 0. Vos attaques ont le désavantage, et les attaques contre vous ont l\'avantage. Vous avez le désavantage aux jets de sauvegarde de Dextérité.';

  @override
  String get conditionStunned => 'Étourdi';

  @override
  String get conditionStunnedDesc =>
      'Vous êtes neutralisé, votre vitesse est de 0, et vous parlez de manière incohérente. Échec automatique aux jets de Force et Dextérité. Les attaques contre vous ont l\'avantage.';

  @override
  String get conditionUnconscious => 'Inconscient';

  @override
  String get conditionUnconsciousDesc =>
      'Vous êtes neutralisé, lâchez tout ce que vous tenez et tombez à terre. Échec automatique aux jets de Force et Dextérité. Les attaques contre vous ont l\'avantage, et toute attaque réussie à moins de 1,5 mètre est un coup critique.';

  @override
  String get conditionExhaustion => 'Épuisement';

  @override
  String get conditionExhaustionDesc =>
      'Niveau 1 : Désavantage aux tests.\nNiveau 2 : Vitesse divisée par 2.\nNiveau 3 : Désavantage aux attaques/sauvegardes.\nNiveau 4 : PV max divisés par 2.\nNiveau 5 : Vitesse = 0.\nNiveau 6 : Mort.';

  @override
  String get diceRollerTitle => 'Lanceur de dés';

  @override
  String get diceRollerRoll => 'Lancer !';

  @override
  String get diceRollerResult => 'Résultat';

  @override
  String get diceRollerMode => 'Mode de lancer';

  @override
  String get diceRollerNormal => 'Normal';

  @override
  String get diceRollerAdvantage => 'Avantage';

  @override
  String get diceRollerDisadvantage => 'Désavantage';

  @override
  String diceRollerFormula(String formula) {
    return 'Formule : $formula';
  }

  @override
  String get diceRollerRollCount => 'Nombre de dés';

  @override
  String get diceRollerRollBonus => 'Modificateur';

  @override
  String diceRollerDieSemantics(int sides) {
    return 'Dé à $sides faces';
  }

  @override
  String get diceRollerDecreaseCount => 'Retirer un dé';

  @override
  String get diceRollerIncreaseCount => 'Ajouter un dé';

  @override
  String get diceRollerDecreaseBonus => 'Diminuer le modificateur';

  @override
  String get diceRollerIncreaseBonus => 'Augmenter le modificateur';

  @override
  String get diceRollerHistory => 'Historique des lancers';

  @override
  String rollAbilityCheck(String name) {
    return 'Test de $name';
  }

  @override
  String rollSaveCheck(String name) {
    return 'Sauvegarde de $name';
  }

  @override
  String rollSkillCheck(String name) {
    return 'Test de $name';
  }

  @override
  String rollAttackCheck(String name) {
    return 'Jet d\'attaque : $name';
  }

  @override
  String rollDamageCheck(String name) {
    return 'Jet de dégâts : $name';
  }

  @override
  String get sheetScoresNotFound => 'Caractéristiques introuvables';

  @override
  String get sheetEditAbilitiesTitle => 'Caractéristiques et statistiques';

  @override
  String get spellPreparationLimit => 'Limite de préparation';

  @override
  String spellPreparationLimitDescription(int count) {
    return 'Vous avez déjà préparé le nombre maximum autorisé de sorts ($count). Retirez-en un avant d’en préparer un autre.';
  }

  @override
  String get spellNoSlots => 'Aucun emplacement disponible';

  @override
  String spellNoSlotsDescription(int level, String name) {
    return 'Il ne vous reste aucun emplacement de niveau $level ou supérieur pour lancer $name.';
  }

  @override
  String spellOvercastTitle(String name) {
    return 'Surclasser $name ?';
  }

  @override
  String spellOvercastDescription(int level) {
    return 'Aucun emplacement de niveau $level disponible. Voulez-vous lancer le sort à un niveau supérieur ?';
  }

  @override
  String spellAvailableSlots(int current, int max) {
    return '$current/$max disponibles';
  }

  @override
  String spellSlotSpent(String name, int level) {
    return 'Lancement de $name ! (emplacement de niveau $level dépensé)';
  }

  @override
  String get actionOk => 'OK';
}
