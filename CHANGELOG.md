# Journal des Modifications (Changelog) - D&D Character Manager

Toutes les modifications notables apportées au projet **D&D Character Manager** sont documentées dans ce fichier.

---

## [2.2.0] - 2026-10-22

### 🛡️ Fiabilité des données (Lot 0)
- **Supabase comme source unique** : les données des personnages passent désormais par les DAOs Supabase, sans accès local Drift parallèle.
- **Écritures atomiques** : remplacement des maîtrises, emplacements de sorts et ressources de classe en une seule opération.
- **Erreurs visibles** : utilitaire `AppErrors` (journalisation et messages utilisateur traduits), widget `AsyncErrorView` avec bouton **Réessayer** et suppression des erreurs silencieuses.
- **Tests** : dédoublonnage des maîtrises et messages d'erreur.

### ✨ Corrections rapides UX/UI (Lot 1)
- **Catalogue de compétences unique** : tri par caractéristique puis alphabétique, avec titres de groupe dans la gestion des maîtrises.
- **Tris alphabétiques** des outils, armes, dons et sorts.
- **Alignement** : sélection en grille 3×3 adaptée au mobile.
- **Achat de points** : lignes de caractéristiques responsives, cibles tactiles de 44 px minimum.
- **Liste de personnages** : recherche et tri (nom, niveau, dernière modification).
- **Onglets mobiles** défilables avec libellés courts.
- **Annulation** : bouton « Annuler » après la suppression d'une note, d'un sort ou d'un équipement.
- **Traductions** : textes en dur de la fiche, des réglages, de l'authentification et des dialogues (repos, PV, monnaies) déplacés vers les `.arb` FR/EN.
- **Accessibilité** : infobulles sur les boutons-icônes, libellés sémantiques (jauge de PV, dés, sauvegardes) et puces plus lisibles.
- **Bouton de gestion d'erreur** sur l'écran d'authentification et la fiche.

### 📝 Édition d'un personnage existant (Lot 2)
- **Écran d'édition** : modification du nom, du joueur, de l'alignement, de l'avatar, des caractéristiques, de l'espèce et de l'historique sans recréer le personnage.
- **Bonus de caractéristiques séparés** : stockage de la base et du bonus (migration Supabase `add_ability_score_base_bonus`).
- **Règles d'édition** testées (`character_edit_rules`).

### ⚔️ Capacités de classe, sous-classe, espèce et dons (Lot 3)
- **Section « Capacités »** de la fiche : traits par niveau avec ressources utilisables, en 2014 et en 2024.
- **Données 2024** : nouveaux fichiers `features.json`, `levels.json` et traductions françaises `features_fr.json`, générés par `tool/build_2024_features.dart`.
- **Ordre de classe** conservé pour les multiclassés (migration `add_class_order`).
- **Export PDF** : capacités ajoutées à la fiche.

### 📈 Montée de niveau complète (Lot 4)
- **Assistant de montée de niveau** en étapes : classe (dont multiclassage), choix de capacités, amélioration de caractéristiques ou don, récapitulatif.
- **Progression de classe** (`class_progression`) et plan de montée de niveau (`level_up_plan`) couvrant PV, sorts, ressources, maîtrises et capacités.
- **Application en une seule opération** via la fonction Supabase `apply_level_up` (migration `add_apply_level_up`).
- **Tests** : plan de montée de niveau et étapes de l'assistant.

### 🔧 Technique
- Schéma Drift passé en version 6 (capacités et ordre de classe), avec régénération des fichiers associés.
- Nouvelles migrations Supabase à appliquer : `20261021000000`, `20261022000000`, `20261023000000`.

---

## [2.0.0] - 2026-07-26

### 🐾 Compagnons, Familiers & Invocations
- **Onglet Dédié "Compagnons"** : Ajout d'une section complète dans la fiche de personnage (onglets mobiles et volet latéral desktop).
- **Cartes Interactives de Créature** : Suivi dynamique des PV actuels/max avec boutons d'ajustement rapide (`+` / `-`), jauge de vie colorée (vert/orange/rouge) et badges pour la Classe d'Armure (CA) et la Vitesse.
- **Attaques & Lancer de Dés Directs** : Boutons 🎲 **Touché** et 🔥 **Dégâts** intégrés aux actions du compagnon, déclenchant le lancer de dés magique (`RollResultDialog`).
- **Presets Express en 1-Clic** :
  - 🦉 **Chouette** (Familier arcanique - Vol 18 m, Vol furtif, Perception aiguë)
  - 🐺 **Loup de combat** (Compagnon animal - CA 13, Morsure 2d4+2, Tactique de meute)
  - 🐎 **Cheval de selle** (Monture rapide - CA 10, Vitesse 18 m, Sabots 2d4+3)
- **Créatures Sur-Mesure** : Formulaire complet d'édition permettant de personnaliser le nom, le type (Familier, Compagnon, Invocation, Monture), les PV, la CA, la vitesse, les attaques et les notes.
- **Synchronisation Supabase** : Table `character_companions` avec RLS policy et interrogation optimisée `FutureProvider`.

### 📄 Exportation & Impression PDF (Fiche Officielle)
- **Bouton d'Exportation PDF** : Icône `picture_as_pdf` intégrée dans l'AppBar de la fiche de personnage.
- **Document A4 Complet sur 2 Pages** :
  - En-tête : Nom, niveau total, classe(s) traduite(s) en français, PV max, CA.
  - Page 1 : Caractéristiques & Modificateurs, Jets de sauvegarde, Statistiques de combat (CA, Vitesse, PB, Perception passive), Tableau des Compétences (avec distinctions Maîtrise / Expertise) et Tableau complet des Attaques & Armes.
  - Page 2 : Grille des sorts préparés/connus par niveau, Inventaire complet, Suivi des monnaies (PO, PA, PP), Dons, Profil (Traits, Idéaux, Liens, Défauts, Backstory) et Journal de Campagne.
- **Police Unicode Roboto** : Chargement automatique des polices Google Fonts Roboto (`PdfGoogleFonts.robotoRegular` & `robotoBold`) pour le rendu parfait des caractères accentués français et de la typographie.
- **Volet d'Impression & Sauvegarde Natif** : Intégration de `Printing.layoutPdf` pour la sauvegarde PDF ou l'impression directe.

### 💤 Système de Repos Court & Repos Long Complet
- **Repos Court (Short Rest)** :
  - Dépense interactive des Dés de Vie (d6/d8/d10/d12) avec jet automatique de `1dDie + Modificateur CON` (min. 1 PV regagné) et suivi en direct de la réserve de dés.
  - Recharge automatique à 100% des emplacements de sorts d'Occultiste (Warlock).
  - Restauration des capacités de repos court : *Ki* (Moine), *Conduit Divin* (Clerc/Paladin), *Forme Sauvage* (Druide), *Sursaut & Second Souffle* (Guerrier 2024), *Inspiration Bardique* (Barde) et *Points de Chance* (Don Chanceux / Lucky).
- **Repos Long (Long Rest)** :
  - Restauration à 100% des PV max et réinitialisation des PV temporaires à 0.
  - Recharge intégrale de tous les emplacements de sorts (Niveaux 1 à 9).
  - Régénération de la moitié de la réserve maximale de Dés de Vie (min. 1 dé récupéré).
  - Réinitialisation de toutes les ressources de classe (Rage, Points de Sorcellerie, etc.).
  - **Réduction automatique du Niveau d'Épuisement de 1 point** (ex: Niv 2 ➔ 1).
  - Dissipation automatique des états *Inconscient* et *À terre*, avec préservation stricte des autres conditions désactivées.
  - Rupture automatique de la concentration active.

### 🔮 Sorts & Filtres Magiques Avancés
- **Filtres Avancés par Composantes & Propriétés** : Modal de filtres avec sélection des composantes nécessaires (🗣️ V, 🖐️ S, 💎 M), des propriétés spéciales (🎯 Concentration, 📖 Rituel), des écoles de magie et des niveaux.
- **Badges Visuels sur la Liste des Sorts** : Indicateurs 🎯 **Conc.** (ambre) et 📖 **Rituel** (violet) affichés à côté de chaque sort dans le Compendium et la fiche du personnage.
- **Suivi Dynamique de la Concentration** : Bannière ambre *"Concentration active : [Sort]"* en haut du Grimoire lors du lancement d'un sort de concentration, avec bouton **Rompre** pour mettre fin à la concentration en 1 clic.

### 📖 Journal d'Aventure & Notes de Campagne
- **Gestion des Notes** : Onglet "Journal" permettant d'ajouter, modifier, épingler et supprimer des notes de campagne.
- **Catégories** : Organisation par thèmes (Quêtes, PNJ, Lieux, Loot, Général).

---

## [1.5.2] - 2026-07-15

### 🎲 Dés & Combat
- **Lancer de Dés Universel (`UniversalDiceRoller`)** : Bouton d'accès rapide aux lancer de dés (d4, d6, d8, d10, d12, d20, d100, 2d6, 8d6, etc.).
- **Modes Avantage / Désavantage** : Prise en charge des dés d20 avec avantage ou désavantage et conservation automatique du résultat approprié.
- **Historique des Jets** : Panneau d'historique de la session.
- **Dialogue de Modification des PV (`HpModifierDialog`)** : Saisie facile des dégâts subis, soins reçus et PV temporaires.

### 🏹 Équipement & Munitions
- **Gestionnaire de Munitions** : Suivi du décompte des flèches, carreaux et billes de fronde, avec application automatique des bonus de munitions sur les attaques à distance.

---

## [1.5.0] - 2026-07-01

### 🎨 Design & Ergonomie
- **Thème Médiéval Fantasy Neons** : Palette personnalisée (Or antique `goldAccent`, Améthyste magique `magicAmethyst`, Rouge cramoisi `crimsonRed`, Vert forêt `forestGreen`).
- **Typographie Cinzel & Lora** : Intégration des polices Google Fonts Cinzel (titres) et Lora (corps de texte).
- **Icônes Dédiées par Classe** : Icônes vectorielles personnalisées pour chacune des 12 classes D&D.

---

## [1.4.10] - 2026-06-15

### 📈 Montée de Niveau (Level Up Wizard)
- **Assistant de Montée de Niveau** : Support du multiclassage, lancer/choix des Dés de Vie au passage de niveau, acquisition d'aptitudes de classe et choix de sous-classes.

---

## [1.3.0] - 2026-05-20

### 👤 Profil & Personnalisation
- **Photo de Personnage / Avatar** : Importation de photos de profil de personnage depuis le navigateur/appareil et stockage sécurisé sur Supabase Storage.

---

## [1.0.0] - 2026-05-01

### 🚀 Lancement Initial
- **Prise en charge des Règles D&D 5e (2014) & D&D 2024 (SRD)**.
- **Architecture Flutter & Riverpod** avec base de données locale Drift et backend distant Supabase PostgreSQL.
- **Forge de Personnage** : Assistant de création en 5 étapes.
- **Application Web PWA & Android**.
