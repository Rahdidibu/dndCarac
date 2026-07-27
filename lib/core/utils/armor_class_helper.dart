import 'dart:math' as math;
import '../database/app_database.dart';

class ArmorClassBreakdown {
  final int totalAc;
  final int baseAc;
  final int dexBonus;
  final int shieldBonus;
  final int armorBonus;
  final int customBonus;
  final String armorName;
  final String shieldName;
  final String formulaDescription;

  const ArmorClassBreakdown({
    required this.totalAc,
    required this.baseAc,
    required this.dexBonus,
    required this.shieldBonus,
    required this.armorBonus,
    required this.customBonus,
    required this.armorName,
    required this.shieldName,
    required this.formulaDescription,
  });
}

class ArmorClassHelper {
  /// Calcule la classe d'armure dynamique selon les équipements portés, les caractéristiques et les sorts actifs.
  static ArmorClassBreakdown calculateAc({
    required List<CharacterEquipmentData> equippedItems,
    required int dexMod,
    int conMod = 0,
    int wisMod = 0,
    String? className,
    bool hasDefenseStyle = false,
    bool hasShieldSpell = false, // +5 CA
    bool hasShieldOfFaith = false, // +2 CA
    bool hasMageArmor = false, // Base 13 + DEX
    bool hasBarkskin = false, // Min 16
    bool hasHaste = false, // +2 CA
  }) {
    int baseAc = 10;
    int armorBase = 0;
    int dexBonus = dexMod;
    int shieldBonus = 0;
    int customBonus = 0;

    String armorName = 'Sans armure';
    String shieldName = '';
    String armorCategory = 'none'; // 'none', 'light', 'medium', 'heavy'

    for (final item in equippedItems) {
      if (!item.equipped) continue;
      final nameLower = item.itemName.toLowerCase();
      final notesLower = (item.notes ?? '').toLowerCase();

      // Detection Bouclier
      if (nameLower.contains('bouclier') || nameLower.contains('shield')) {
        shieldBonus = 2;
        shieldName = item.itemName;
        if (notesLower.contains('+1')) shieldBonus += 1;
        if (notesLower.contains('+2')) shieldBonus += 2;
        if (notesLower.contains('+3')) shieldBonus += 3;
        continue;
      }

      // Detection Armures Lourdes
      if (nameLower.contains('harnois') || nameLower.contains('plate') || nameLower.contains('clibanion') || nameLower.contains('splint') || nameLower.contains('cotte de mailles') || nameLower.contains('chain mail') || nameLower.contains('broigne') || nameLower.contains('ring mail')) {
        armorCategory = 'heavy';
        armorName = item.itemName;
        if (nameLower.contains('harnois') || nameLower.contains('full plate')) {
          armorBase = 18;
        } else if (nameLower.contains('clibanion') || nameLower.contains('splint')) {
          armorBase = 17;
        } else if (nameLower.contains('cotte de mailles') || nameLower.contains('chain mail')) {
          armorBase = 16;
        } else {
          armorBase = 14;
        }
        dexBonus = 0; // Aucun bonus de DEX pour armure lourde
      }
      // Detection Armures Intermédiaires
      else if (nameLower.contains('demi-plaque') || nameLower.contains('half plate') || nameLower.contains('cuirasse') || nameLower.contains('breastplate') || nameLower.contains('chemise de mailles') || nameLower.contains('chain shirt') || nameLower.contains('écaille') || nameLower.contains('scale mail') || nameLower.contains('peau') || nameLower.contains('hide')) {
        armorCategory = 'medium';
        armorName = item.itemName;
        if (nameLower.contains('demi-plaque') || nameLower.contains('half plate')) {
          armorBase = 15;
        } else if (nameLower.contains('cuirasse') || nameLower.contains('breastplate')) {
          armorBase = 14;
        } else if (nameLower.contains('chemise de mailles') || nameLower.contains('chain shirt')) {
          armorBase = 13;
        } else {
          armorBase = 12;
        }
        dexBonus = math.min(dexMod, 2); // Max +2 de DEX
      }
      // Detection Armures Légères
      else if (nameLower.contains('cuir clouté') || nameLower.contains('studded leather') || nameLower.contains('cuir') || nameLower.contains('leather') || nameLower.contains('matelassée') || nameLower.contains('padded')) {
        armorCategory = 'light';
        armorName = item.itemName;
        if (nameLower.contains('cuir clouté') || nameLower.contains('studded leather')) {
          armorBase = 12;
        } else if (nameLower.contains('cuir') || nameLower.contains('leather')) {
          armorBase = 11;
        } else {
          armorBase = 11;
        }
        dexBonus = dexMod; // Totalité du bonus de DEX
      }

      // Detect magical bonus (+1, +2, +3)
      if (notesLower.contains('+1')) customBonus += 1;
      if (notesLower.contains('+2')) customBonus += 2;
      if (notesLower.contains('+3')) customBonus += 3;
    }

    // Unarmored / Mage Armor / Barkskin
    if (armorCategory == 'none') {
      if (hasMageArmor) {
        baseAc = 13;
        armorName = 'Armure de Mage (Sort)';
      } else {
        final clsLower = (className ?? '').toLowerCase();
        if (clsLower.contains('barbare') || clsLower.contains('barbarian')) {
          baseAc = 10 + conMod;
          armorName = 'Défense sans armure (Barbare)';
        } else if (clsLower.contains('moine') || clsLower.contains('monk')) {
          baseAc = 10 + wisMod;
          armorName = 'Défense sans armure (Moine)';
        } else {
          baseAc = 10;
        }
      }
    } else {
      baseAc = armorBase;
    }

    // Spell bonuses
    if (hasShieldSpell) customBonus += 5;
    if (hasShieldOfFaith) customBonus += 2;
    if (hasHaste) customBonus += 2;

    // Style de combat Défense (+1 CA si armure portée)
    if (hasDefenseStyle && armorCategory != 'none') {
      customBonus += 1;
    }

    int totalAc = baseAc + dexBonus + shieldBonus + customBonus;

    // Barkskin (minimum 16 CA)
    if (hasBarkskin && totalAc < 16) {
      totalAc = 16;
    }

    List<String> parts = ['$baseAc ($armorName)'];
    if (dexBonus != 0) parts.add('${dexBonus >= 0 ? "+$dexBonus" : "$dexBonus"} DEX');
    if (shieldBonus != 0) parts.add('+$shieldBonus Bouclier');
    if (hasShieldSpell) parts.add('+5 Sort Bouclier');
    if (hasShieldOfFaith) parts.add('+2 Bouclier de la foi');
    if (hasHaste) parts.add('+2 Hâte');
    if (hasDefenseStyle && armorCategory != 'none') parts.add('+1 Style Défense');

    final desc = parts.join(' ');

    return ArmorClassBreakdown(
      totalAc: totalAc,
      baseAc: baseAc,
      dexBonus: dexBonus,
      shieldBonus: shieldBonus,
      armorBonus: armorBase,
      customBonus: customBonus,
      armorName: armorName,
      shieldName: shieldName,
      formulaDescription: desc,
    );
  }
}
