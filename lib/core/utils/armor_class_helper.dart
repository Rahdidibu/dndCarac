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
    int armorMagicBonus = 0;
    String armorName = 'Sans armure';
    String shieldName = '';
    String armorCategory = 'none'; // 'none', 'light', 'medium', 'heavy'

    for (final item in equippedItems) {
      if (!item.equipped) continue;

      final itemName = item.itemName.toLowerCase();
      final notes = (item.notes ?? '').toLowerCase();
      final magicMatch = RegExp(r'\+\s*([1-3])(?!\d)').firstMatch(item.notes ?? '');
      final magicBonus = magicMatch != null ? int.parse(magicMatch.group(1)!) : 0;

      // Shield
      if (itemName.contains('bouclier') || itemName.contains('shield') || itemName.contains('buckler') || itemName.contains('pavois')) {
        int shieldAc = 2;
        if (itemName.contains('buckler') || itemName.contains('poing')) shieldAc = 1;
        if (itemName.contains('pavois') || itemName.contains('tower')) shieldAc = 3;
        shieldBonus += shieldAc + magicBonus;
        shieldName = shieldName.isEmpty ? item.itemName : '$shieldName, ${item.itemName}';
        continue;
      }

      // Heavy armor
      if (itemName.contains('harnois') || itemName.contains('plate') || itemName.contains('clavandier') || itemName.contains('splint') || itemName.contains('cotte de mailles') || itemName.contains('chain mail') || itemName.contains('chainmail')) {
        armorCategory = 'heavy';
        armorName = item.itemName;
        if (itemName.contains('splint') || itemName.contains('clavandier')) {
          armorBase = 17;
        } else if (itemName.contains('cotte de mailles') || itemName.contains('chain mail') || itemName.contains('chainmail')) {
          armorBase = 16;
        } else {
          armorBase = 18;
        }
        dexBonus = 0;
        customBonus += magicBonus;
        armorMagicBonus += magicBonus;
        continue;
      }

      // Medium armor
      if (itemName.contains('chemise de mailles') || itemName.contains('chainshirt') || itemName.contains('cuirasse') || itemName.contains('breastplate') || itemName.contains('écailles') || itemName.contains('scale mail') || itemName.contains('demi-harnois') || itemName.contains('half plate') || itemName.contains('hide') || itemName.contains('peau')) {
        armorCategory = 'medium';
        armorName = item.itemName;
        if (itemName.contains('cuirasse') || itemName.contains('breastplate') || itemName.contains('écailles') || itemName.contains('scale')) {
          armorBase = 14;
        } else if (itemName.contains('demi-harnois') || itemName.contains('half plate')) {
          armorBase = 15;
        } else if (itemName.contains('hide') || itemName.contains('peau')) {
          armorBase = 12;
        } else {
          armorBase = 13;
        }
        dexBonus = math.min(dexMod, 2);
        customBonus += magicBonus;
        armorMagicBonus += magicBonus;
        continue;
      }

      // Light armor
      if (itemName.contains('cuir') || itemName.contains('leather') || itemName.contains('matelassé') || itemName.contains('padded') || itemName.contains('studded') || itemName.contains('cuir clouté')) {
        armorCategory = 'light';
        armorName = item.itemName;
        if (itemName.contains('studded') || itemName.contains('clouté')) {
          armorBase = 12;
        } else {
          armorBase = 11;
        }
        dexBonus = dexMod;
        customBonus += magicBonus;
        armorMagicBonus += magicBonus;
        continue;
      }

      // CA X in notes
      final caMatch = RegExp(r'ca\s*([0-9]+)').firstMatch(notes);
      if (caMatch != null) {
        final val = int.parse(caMatch.group(1)!);
        armorCategory = notes.contains('+') ? 'shield' : val >= 16 ? 'heavy' : val >= 13 ? 'medium' : 'light';
        armorBase = val;
        armorName = item.itemName;
        if (notes.contains('+')) {
          shieldBonus += val + magicBonus;
          shieldName = shieldName.isEmpty ? item.itemName : '$shieldName, ${item.itemName}';
        } else {
          dexBonus = armorCategory == 'heavy' ? 0 : armorCategory == 'medium' ? math.min(dexMod, 2) : dexMod;
          customBonus += magicBonus;
          armorMagicBonus += magicBonus;
        }
      }
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
        } else if ((clsLower.contains('moine') || clsLower.contains('monk')) && shieldBonus == 0) {
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
    if (armorMagicBonus != 0) parts.add('+$armorMagicBonus Bonus magique');
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
