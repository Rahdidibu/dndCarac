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

  static StartingWeaponStats? getWeaponStats(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('grande hache') || lower.contains('hache à deux mains') || lower.contains('greataxe')) {
      return const StartingWeaponStats(name: 'Grande hache', baseDice: '1d12', damageType: 'Tranchant', scalingAbility: 'str', mastery: 'Cleave');
    }
    if (lower.contains('hache d\'armes') || lower.contains('battleaxe') || lower.contains('battle axe')) {
      return const StartingWeaponStats(name: 'Hache d\'armes', baseDice: '1d8', damageType: 'Tranchant', scalingAbility: 'str', mastery: 'Topple');
    }
    if (lower.contains('hachette') || lower.contains('handaxe') || lower.contains('hache')) {
      return const StartingWeaponStats(name: 'Hachette', baseDice: '1d6', damageType: 'Tranchant', scalingAbility: 'str', mastery: 'Vex');
    }
    if (lower.contains('javelot') || lower.contains('javelin')) {
      return const StartingWeaponStats(name: 'Javelot', baseDice: '1d6', damageType: 'Perçant', scalingAbility: 'str', mastery: 'Slow');
    }
    if (lower.contains('rapière') || lower.contains('rapier')) {
      return const StartingWeaponStats(name: 'Rapière', baseDice: '1d8', damageType: 'Perçant', scalingAbility: 'finesse', mastery: 'Vex');
    }
    if (lower.contains('dague') || lower.contains('dagger')) {
      return const StartingWeaponStats(name: 'Dague', baseDice: '1d4', damageType: 'Perçant', scalingAbility: 'finesse', mastery: 'Nick');
    }
    if (lower.contains('masse') || lower.contains('mace')) {
      return const StartingWeaponStats(name: 'Masse', baseDice: '1d6', damageType: 'Contondant', scalingAbility: 'str', mastery: 'Sap');
    }
    if (lower.contains('marteau de guerre') || lower.contains('warhammer')) {
      return const StartingWeaponStats(name: 'Marteau de guerre', baseDice: '1d8', damageType: 'Contondant', scalingAbility: 'str', mastery: 'Push');
    }
    if (lower.contains('mailloche') || lower.contains('maul')) {
      return const StartingWeaponStats(name: 'Mailloche', baseDice: '2d6', damageType: 'Contondant', scalingAbility: 'str', mastery: 'Topple');
    }
    if (lower.contains('marteau') || lower.contains('hammer')) {
      return const StartingWeaponStats(name: 'Marteau léger', baseDice: '1d4', damageType: 'Contondant', scalingAbility: 'str', mastery: 'Nick');
    }
    if (lower.contains('hallebarde') || lower.contains('halberd')) {
      return const StartingWeaponStats(name: 'Hallebarde', baseDice: '1d10', damageType: 'Tranchant', scalingAbility: 'str', mastery: 'Cleave');
    }
    if (lower.contains('glaive') || lower.contains('guisarme')) {
      return const StartingWeaponStats(name: 'Glaive', baseDice: '1d10', damageType: 'Tranchant', scalingAbility: 'str', mastery: 'Graze');
    }
    if (lower.contains('cimeterre') || lower.contains('scimitar')) {
      return const StartingWeaponStats(name: 'Cimeterre', baseDice: '1d6', damageType: 'Tranchant', scalingAbility: 'finesse', mastery: 'Nick');
    }
    if (lower.contains('épée à deux mains') || lower.contains('greatsword')) {
      return const StartingWeaponStats(name: 'Épée à deux mains', baseDice: '2d6', damageType: 'Tranchant', scalingAbility: 'str', mastery: 'Graze');
    }
    if (lower.contains('épée courte') || lower.contains('shortsword')) {
      return const StartingWeaponStats(name: 'Épée courte', baseDice: '1d6', damageType: 'Perçant', scalingAbility: 'finesse', mastery: 'Vex');
    }
    if (lower.contains('épée longue') || lower.contains('longsword') || lower.contains('épée')) {
      return const StartingWeaponStats(name: 'Épée longue', baseDice: '1d8', damageType: 'Tranchant', scalingAbility: 'str', mastery: 'Flex');
    }
    if (lower.contains('arbalète lourde') || lower.contains('heavy crossbow')) {
      return const StartingWeaponStats(name: 'Arbalète lourde', baseDice: '1d10', damageType: 'Perçant', scalingAbility: 'dex', mastery: 'Push', requiresAmmo: true, ammoTag: 'bolt');
    }
    if (lower.contains('arbalète légère') || lower.contains('light crossbow')) {
      return const StartingWeaponStats(name: 'Arbalète légère', baseDice: '1d8', damageType: 'Perçant', scalingAbility: 'dex', mastery: 'Vex', requiresAmmo: true, ammoTag: 'bolt');
    }
    if (lower.contains('arbalète de poing') || lower.contains('hand crossbow') || lower.contains('arbalète')) {
      return const StartingWeaponStats(name: 'Arbalète de poing', baseDice: '1d6', damageType: 'Perçant', scalingAbility: 'dex', mastery: 'Vex', requiresAmmo: true, ammoTag: 'bolt');
    }
    if (lower.contains('arc long') || lower.contains('longbow')) {
      return const StartingWeaponStats(name: 'Arc long', baseDice: '1d8', damageType: 'Perçant', scalingAbility: 'dex', mastery: 'Slow', requiresAmmo: true, ammoTag: 'arrow');
    }
    if (lower.contains('arc court') || lower.contains('shortbow') || lower.contains('arc')) {
      return const StartingWeaponStats(name: 'Arc court', baseDice: '1d6', damageType: 'Perçant', scalingAbility: 'dex', mastery: 'Vex', requiresAmmo: true, ammoTag: 'arrow');
    }
    if (lower.contains('trident')) {
      return const StartingWeaponStats(name: 'Trident', baseDice: '1d6', damageType: 'Perçant', scalingAbility: 'str', mastery: 'Topple');
    }
    if (lower.contains('épieu') || lower.contains('spear') || lower.contains('lance')) {
      return const StartingWeaponStats(name: 'Épieu', baseDice: '1d6', damageType: 'Perçant', scalingAbility: 'str', mastery: 'Flex');
    }
    if (lower.contains('fouet') || lower.contains('whip')) {
      return const StartingWeaponStats(name: 'Fouet', baseDice: '1d4', damageType: 'Tranchant', scalingAbility: 'finesse', mastery: 'Slow');
    }
    if (lower.contains('fronde') || lower.contains('sling')) {
      return const StartingWeaponStats(name: 'Fronde', baseDice: '1d4', damageType: 'Contondant', scalingAbility: 'dex', mastery: 'Slow', requiresAmmo: true, ammoTag: 'bullet');
    }
    if (lower.contains('bâton') || lower.contains('quarterstaff')) {
      return const StartingWeaponStats(name: 'Bâton', baseDice: '1d6', damageType: 'Contondant', scalingAbility: 'str', mastery: 'Topple');
    }
    return null;
  }

  /// Returns true if the given item name is an ammunition item.
  static bool isAmmunitionItem(String name) {
    final lower = name.toLowerCase();
    return lower.contains('flèche') || lower.contains('arrow') ||
           lower.contains('carreau') || lower.contains('bolt') ||
           lower.contains('fléchette') || lower.contains('dart') ||
           lower.contains('bille') || lower.contains('sling bullet') ||
           lower.contains('aiguille') || lower.contains('needle') ||
           lower.contains('munition');
  }

  /// Returns the ammoTag needed by a weapon, or null for melee weapons.
  static String? ammoTagFor(String weaponName) {
    return getWeaponStats(weaponName)?.ammoTag;
  }

  /// Parses ammunition modifier (e.g. "+1", "+2", "-1") from item name or notes.
  static int parseAmmoBonus(String name, [String? notes]) {
    final combined = '$name ${notes ?? ''}';
    final match = RegExp(r'([+-]\d+)').firstMatch(combined);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '0') ?? 0;
    }
    return 0;
  }
}

class StartingWeaponStats {
  final String name;
  final String baseDice;
  final String damageType;
  final String scalingAbility; // "str", "dex", "finesse"
  final String? mastery;
  final bool requiresAmmo;
  final String? ammoTag; // 'arrow', 'bolt', 'dart', 'bullet'

  const StartingWeaponStats({
    required this.name,
    required this.baseDice,
    required this.damageType,
    required this.scalingAbility,
    this.mastery,
    this.requiresAmmo = false,
    this.ammoTag,
  });
}
