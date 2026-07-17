class StartingItem {
  final String name;
  final int quantity;
  final double weight;
  final bool equipped;

  const StartingItem({
    required this.name,
    this.quantity = 1,
    this.weight = 0.0,
    this.equipped = false,
  });
}

class StartingEquipmentHelper {
  static List<StartingItem> getClassEquipment(String classId) {
    switch (classId.toLowerCase()) {
      case 'barbarian':
        return const [
          StartingItem(name: 'Hache à deux mains (Greataxe)', quantity: 1, weight: 7.0, equipped: true),
          StartingItem(name: 'Hachette (Handaxe)', quantity: 2, weight: 2.0, equipped: false),
          StartingItem(name: 'Javelot (Javelin)', quantity: 4, weight: 2.0, equipped: false),
          StartingItem(name: "Sac d'explorateur (Explorer's Pack)", quantity: 1, weight: 59.0, equipped: false),
        ];
      case 'bard':
        return const [
          StartingItem(name: 'Rapière (Rapier)', quantity: 1, weight: 2.0, equipped: true),
          StartingItem(name: 'Dague (Dagger)', quantity: 1, weight: 1.0, equipped: false),
          StartingItem(name: 'Armure de cuir (Leather Armor)', quantity: 1, weight: 10.0, equipped: true),
          StartingItem(name: "Sac d'artiste (Entertainer's Pack)", quantity: 1, weight: 38.0, equipped: false),
          StartingItem(name: 'Instrument de musique (Musical Instrument)', quantity: 1, weight: 3.0, equipped: false),
        ];
      case 'cleric':
        return const [
          StartingItem(name: 'Masse (Mace)', quantity: 1, weight: 4.0, equipped: true),
          StartingItem(name: 'Chemise de mailles (Chain Shirt)', quantity: 1, weight: 20.0, equipped: true),
          StartingItem(name: 'Bouclier (Shield)', quantity: 1, weight: 6.0, equipped: true),
          StartingItem(name: 'Sac de prêtre (Priest\'s Pack)', quantity: 1, weight: 19.0, equipped: false),
          StartingItem(name: 'Symbole sacré (Holy Symbol)', quantity: 1, weight: 1.0, equipped: false),
        ];
      case 'druid':
        return const [
          StartingItem(name: 'Cimeterre (Scimitar)', quantity: 1, weight: 3.0, equipped: true),
          StartingItem(name: 'Armure de cuir (Leather Armor)', quantity: 1, weight: 10.0, equipped: true),
          StartingItem(name: 'Bouclier en bois (Wooden Shield)', quantity: 1, weight: 6.0, equipped: true),
          StartingItem(name: "Sac d'explorateur (Explorer's Pack)", quantity: 1, weight: 59.0, equipped: false),
          StartingItem(name: 'Focalisateur druidique (Druidic Focus)', quantity: 1, weight: 1.0, equipped: false),
        ];
      case 'fighter':
        return const [
          StartingItem(name: 'Épée à deux mains (Greatsword)', quantity: 1, weight: 6.0, equipped: true),
          StartingItem(name: 'Arbalète légère (Light Crossbow)', quantity: 1, weight: 5.0, equipped: false),
          StartingItem(name: "Carreaux d'arbalète (Crossbow Bolts)", quantity: 20, weight: 0.075, equipped: false),
          StartingItem(name: 'Cotte de mailles (Chain Mail)', quantity: 1, weight: 55.0, equipped: true),
          StartingItem(name: "Sac d'exploration (Dungeoneer's Pack)", quantity: 1, weight: 61.5, equipped: false),
        ];
      case 'monk':
        return const [
          StartingItem(name: 'Épée courte (Shortsword)', quantity: 1, weight: 2.0, equipped: true),
          StartingItem(name: 'Fléchette (Dart)', quantity: 10, weight: 0.25, equipped: false),
          StartingItem(name: "Sac d'explorateur (Explorer's Pack)", quantity: 1, weight: 59.0, equipped: false),
        ];
      case 'paladin':
        return const [
          StartingItem(name: 'Épée longue (Longsword)', quantity: 1, weight: 3.0, equipped: true),
          StartingItem(name: 'Bouclier (Shield)', quantity: 1, weight: 6.0, equipped: true),
          StartingItem(name: 'Javelot (Javelin)', quantity: 5, weight: 2.0, equipped: false),
          StartingItem(name: 'Cotte de mailles (Chain Mail)', quantity: 1, weight: 55.0, equipped: true),
          StartingItem(name: 'Sac de prêtre (Priest\'s Pack)', quantity: 1, weight: 19.0, equipped: false),
          StartingItem(name: 'Symbole sacré (Holy Symbol)', quantity: 1, weight: 1.0, equipped: false),
        ];
      case 'ranger':
        return const [
          StartingItem(name: 'Arc long (Longbow)', quantity: 1, weight: 2.0, equipped: false),
          StartingItem(name: 'Flèche (Arrow)', quantity: 20, weight: 0.05, equipped: false),
          StartingItem(name: 'Épée courte (Shortsword)', quantity: 2, weight: 2.0, equipped: true),
          StartingItem(name: 'Armure de cuir clouté (Studded Leather Armor)', quantity: 1, weight: 13.0, equipped: true),
          StartingItem(name: "Sac d'explorateur (Explorer's Pack)", quantity: 1, weight: 59.0, equipped: false),
        ];
      case 'rogue':
        return const [
          StartingItem(name: 'Rapière (Rapier)', quantity: 1, weight: 2.0, equipped: true),
          StartingItem(name: 'Dague (Dagger)', quantity: 2, weight: 1.0, equipped: false),
          StartingItem(name: 'Arc court (Shortbow)', quantity: 1, weight: 2.0, equipped: false),
          StartingItem(name: 'Flèche (Arrow)', quantity: 20, weight: 0.05, equipped: false),
          StartingItem(name: 'Armure de cuir (Leather Armor)', quantity: 1, weight: 10.0, equipped: true),
          StartingItem(name: 'Outils de voleur (Thieves\' Tools)', quantity: 1, weight: 1.0, equipped: false),
          StartingItem(name: "Sac de cambrioleur (Burglar's Pack)", quantity: 1, weight: 45.5, equipped: false),
        ];
      case 'sorcerer':
        return const [
          StartingItem(name: 'Arbalète légère (Light Crossbow)', quantity: 1, weight: 5.0, equipped: false),
          StartingItem(name: "Carreaux d'arbalète (Crossbow Bolts)", quantity: 20, weight: 0.075, equipped: false),
          StartingItem(name: 'Dague (Dagger)', quantity: 2, weight: 1.0, equipped: false),
          StartingItem(name: 'Focalisateur arcanique (Arcane Focus)', quantity: 1, weight: 1.0, equipped: false),
          StartingItem(name: "Sac d'exploration (Dungeoneer's Pack)", quantity: 1, weight: 61.5, equipped: false),
        ];
      case 'warlock':
        return const [
          StartingItem(name: 'Épieu (Spear)', quantity: 1, weight: 3.0, equipped: true),
          StartingItem(name: 'Dague (Dagger)', quantity: 2, weight: 1.0, equipped: false),
          StartingItem(name: 'Armure de cuir (Leather Armor)', quantity: 1, weight: 10.0, equipped: true),
          StartingItem(name: 'Focalisateur arcanique (Arcane Focus)', quantity: 1, weight: 1.0, equipped: false),
          StartingItem(name: "Sac d'érudit (Scholar's Pack)", quantity: 1, weight: 43.0, equipped: false),
        ];
      case 'wizard':
        return const [
          StartingItem(name: 'Bâton (Quarterstaff)', quantity: 1, weight: 4.0, equipped: true),
          StartingItem(name: 'Grimoire (Spellbook)', quantity: 1, weight: 3.0, equipped: false),
          StartingItem(name: 'Focalisateur arcanique (Arcane Focus)', quantity: 1, weight: 1.0, equipped: false),
          StartingItem(name: "Sac d'érudit (Scholar's Pack)", quantity: 1, weight: 43.0, equipped: false),
          StartingItem(name: 'Dague (Dagger)', quantity: 1, weight: 1.0, equipped: false),
        ];
      default:
        return const [
          StartingItem(name: 'Vêtements de voyage (Common Clothes)', quantity: 1, weight: 3.0, equipped: true),
        ];
    }
  }

  static List<StartingItem> getBackgroundEquipment(String backgroundId) {
    switch (backgroundId.toLowerCase()) {
      case 'acolyte':
        return const [
          StartingItem(name: 'Symbole sacré (Holy Symbol)', quantity: 1, weight: 1.0, equipped: false),
          StartingItem(name: 'Livre de prières (Prayer Book)', quantity: 1, weight: 5.0, equipped: false),
          StartingItem(name: "Bâtonnet d'encens (Incense Stick)", quantity: 5, weight: 0.1, equipped: false),
          StartingItem(name: 'Habits de cérémonie (Vestments)', quantity: 1, weight: 4.0, equipped: false),
        ];
      case 'criminal':
      case 'charlatan':
        return const [
          StartingItem(name: 'Pied-de-biche (Crowbar)', quantity: 1, weight: 5.0, equipped: false),
          StartingItem(name: 'Vêtements sombres (Dark Clothes)', quantity: 1, weight: 3.0, equipped: true),
        ];
      case 'noble':
        return const [
          StartingItem(name: 'Vêtements fins (Fine Clothes)', quantity: 1, weight: 6.0, equipped: true),
          StartingItem(name: 'Chevalière (Signet Ring)', quantity: 1, weight: 0.0, equipped: true),
          StartingItem(name: 'Lettre de noblesse (Scroll of Pedigree)', quantity: 1, weight: 0.0, equipped: false),
        ];
      case 'sage':
      case 'scribe':
        return const [
          StartingItem(name: "Bouteille d'encre (Ink bottle)", quantity: 1, weight: 0.1, equipped: false),
          StartingItem(name: "Plume d'écriture (Quill)", quantity: 1, weight: 0.0, equipped: false),
          StartingItem(name: 'Petit couteau (Small Knife)', quantity: 1, weight: 0.5, equipped: false),
          StartingItem(name: 'Vêtements communs (Common Clothes)', quantity: 1, weight: 3.0, equipped: true),
        ];
      case 'soldier':
      case 'soldat':
        return const [
          StartingItem(name: 'Insigne de grade (Insignia of Rank)', quantity: 1, weight: 0.0, equipped: false),
          StartingItem(name: 'Trophée de guerre (Trophy of Fallen Enemy)', quantity: 1, weight: 0.5, equipped: false),
          StartingItem(name: 'Jeu de dés (Dice Set)', quantity: 1, weight: 0.0, equipped: false),
          StartingItem(name: 'Vêtements communs (Common Clothes)', quantity: 1, weight: 3.0, equipped: true),
        ];
      default:
        return const [
          StartingItem(name: 'Vêtements communs (Common Clothes)', quantity: 1, weight: 3.0, equipped: true),
        ];
    }
  }

  static int getBackgroundStartingGold(String backgroundId) {
    switch (backgroundId.toLowerCase()) {
      case 'noble':
        return 25;
      case 'acolyte':
      case 'criminal':
      case 'charlatan':
        return 15;
      case 'sage':
      case 'soldier':
      case 'artisan':
      case 'entertainer':
      case 'merchant':
        return 10;
      default:
        return 10;
    }
  }
}
