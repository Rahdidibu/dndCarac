// D&D 5e game rules calculations — edition-agnostic unless noted

import '../database/tables/tables.dart';

/// Ressource de classe à usage limité (clé de `character_resources`).
class ClassResourceSpec {
  final String key;
  final int maximum;

  const ClassResourceSpec(this.key, this.maximum);

  @override
  String toString() => '$key=$maximum';
}

class DndRules {
  DndRules._();

  /// Ability score modifier: floor((score - 10) / 2)
  static int modifier(int score) => ((score - 10) / 2).floor();

  /// Proficiency bonus by total character level (same in 2014 and 2024)
  static int proficiencyBonus(int level) {
    if (level <= 4) return 2;
    if (level <= 8) return 3;
    if (level <= 12) return 4;
    if (level <= 16) return 5;
    return 6;
  }

  /// Passive perception = 10 + WIS modifier + proficiency (if proficient)
  static int passivePerception(int wisdom, int profBonus,
          {bool proficient = false, bool expertise = false}) {
    int bonus = modifier(wisdom);
    if (expertise) {
      bonus += profBonus * 2;
    } else if (proficient) {
      bonus += profBonus;
    }
    return 10 + bonus;
  }

  /// Initiative = DEX modifier (+ other bonuses handled at sheet level)
  static int initiative(int dexterity) => modifier(dexterity);

  /// Hit points at level 1: hit die max + CON modifier
  static int hpAtLevel1(int hitDie, int constitution) =>
      hitDie + modifier(constitution);

  /// HP gained on level up (average = hitDie/2 + 1 + CON mod)
  static int hpAverageOnLevelUp(int hitDie, int constitution) =>
      (hitDie ~/ 2) + 1 + modifier(constitution);

  /// ── Spell slot tables ────────────────────────────────────────────────────
  ///
  /// Standard full-caster slots by character level (PHB table).
  /// Key = slot level (1-9), value = number of slots.
  static const List<Map<int, int>> _fullCasterSlots = [
    {1: 2},                                              // level 1
    {1: 3},                                              // level 2
    {1: 4, 2: 2},                                        // level 3
    {1: 4, 2: 3},                                        // level 4
    {1: 4, 2: 3, 3: 2},                                  // level 5
    {1: 4, 2: 3, 3: 3},                                  // level 6
    {1: 4, 2: 3, 3: 3, 4: 1},                            // level 7
    {1: 4, 2: 3, 3: 3, 4: 2},                            // level 8
    {1: 4, 2: 3, 3: 3, 4: 3, 5: 1},                      // level 9
    {1: 4, 2: 3, 3: 3, 4: 3, 5: 2},                      // level 10
    {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1},                // level 11
    {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1},                // level 12
    {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1},          // level 13
    {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1},          // level 14
    {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1, 8: 1},    // level 15
    {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1, 8: 1},    // level 16
    {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1, 8: 1, 9: 1}, // level 17
    {1: 4, 2: 3, 3: 3, 4: 3, 5: 3, 6: 1, 7: 1, 8: 1, 9: 1}, // level 18
    {1: 4, 2: 3, 3: 3, 4: 3, 5: 3, 6: 2, 7: 1, 8: 1, 9: 1}, // level 19
    {1: 4, 2: 3, 3: 3, 4: 3, 5: 3, 6: 2, 7: 2, 8: 1, 9: 1}, // level 20
  ];

  /// Emplacements de sorts pour un niveau de lanceur de sorts effectif
  /// (table du lanceur complet, 1 à 20). Vide si le niveau est nul.
  static Map<int, int> slotsForCasterLevel(int casterLevel) {
    if (casterLevel <= 0) return {};
    return _fullCasterSlots[(casterLevel - 1).clamp(0, 19)];
  }

  /// Spell slots for a single-class character (uses the same full-caster table
  /// for full casters; handles half/third internally)
  static Map<int, int> singleClassSpellSlots(String classId, int level) {
    int effective;
    switch (classId) {
      case 'bard':
      case 'cleric':
      case 'druid':
      case 'sorcerer':
      case 'wizard':
        effective = level;
      case 'paladin':
      case 'ranger':
        effective = level ~/ 2;
      case 'fighter':
      case 'rogue':
        effective = level ~/ 3;
      default:
        return {};
    }
    if (effective <= 0) return {};
    final idx = (effective - 1).clamp(0, 19);
    return _fullCasterSlots[idx];
  }

  /// Warlock uses the Pact Magic table (separate from standard slots)
  static Map<int, int> warlockPactSlots(int level) {
    // slot level: always 1 at lvl1, increases every 3 levels
    final slotLevel = level < 3
        ? 1
        : level < 5
            ? 2
            : level < 7
                ? 3
                : level < 9
                    ? 4
                    : 5;
    final slotCount = level == 1
        ? 1
        : level < 11
            ? 2
            : level < 17
                ? 3
                : 4;
    return {slotLevel: slotCount};
  }

  /// Get the maximum spell level a class can cast at a given level.
  /// Returns 0 for cantrips only, -1 for non-casters.
  static int maxSpellLevelForClass(String classId, int level) {
    if (classId == 'warlock') {
      final slots = warlockPactSlots(level);
      return slots.isEmpty ? 0 : slots.keys.reduce((a, b) => a > b ? a : b);
    }
    final slots = singleClassSpellSlots(classId, level);
    if (slots.isEmpty) {
      if (classId == 'paladin' || classId == 'ranger') return 0;
      if (classId == 'fighter' || classId == 'rogue') return 0;
      return -1;
    }
    return slots.keys.reduce((a, b) => a > b ? a : b);
  }

  /// Point buy cost table (standard 27 points, scores 8-15)
  static const Map<int, int> pointBuyCost = {
    8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5, 14: 7, 15: 9,
  };

  static const int pointBuyTotal = 27;
  static const int pointBuyMin = 8;
  static const int pointBuyMax = 15;

  /// Standard array for ability scores
  static const List<int> standardArray = [15, 14, 13, 12, 10, 8];

  static const List<String> abilityKeys = [
    'str', 'dex', 'con', 'int', 'wis', 'cha'
  ];

  static String abilityName(String key, {required Map<String, String> labels}) {
    return labels[key] ?? key;
  }

  /// Valeur « illimité » utilisée pour les ressources sans plafond (Rage 20, 2014).
  static const int unlimitedResource = 999;

  /// Ressources de classe à usage limité et leur maximum au [level] de la
  /// classe. Les clés correspondent à `character_resources.resource_name`.
  /// Retourne une liste vide si la classe n'a pas de ressource à ce niveau.
  static List<ClassResourceSpec> classResourceByLevel(
      String classId, int level, RulesetVersion ruleset) {
    final is2024 = ruleset == RulesetVersion.dnd2024;
    int steps(List<(int, int)> table) {
      var value = 0;
      for (final (minLevel, amount) in table) {
        if (level >= minLevel) value = amount;
      }
      return value;
    }

    final specs = <ClassResourceSpec>[];
    void add(String key, int maximum) {
      if (maximum > 0) specs.add(ClassResourceSpec(key, maximum));
    }

    switch (classId) {
      case 'barbarian':
        final rages = steps([(1, 2), (3, 3), (6, 4), (12, 5), (17, 6)]);
        add('resourceRage',
            !is2024 && level >= 20 ? unlimitedResource : rages);
      case 'monk':
        add('resourceKi', level >= 2 ? level : 0);
      case 'sorcerer':
        add('resourceSorceryPoints', level >= 2 ? level : 0);
      case 'cleric':
        add(
            'resourceChannelDivinity',
            is2024
                ? steps([(2, 2), (6, 3), (18, 4)])
                : steps([(2, 1), (6, 2), (18, 3)]));
      case 'paladin':
        add('resourceChannelDivinity',
            is2024 ? steps([(3, 2), (11, 3)]) : steps([(3, 1)]));
      case 'druid':
        add(
            'resourceWildShape',
            is2024
                ? steps([(2, 2), (6, 3), (17, 4)])
                : (level >= 20 ? unlimitedResource : steps([(2, 2)])));
      case 'fighter':
        add('resourceSecondWind',
            is2024 ? steps([(1, 2), (4, 3), (10, 4)]) : 1);
        add('resourceActionSurge', steps([(2, 1), (17, 2)]));
    }
    return specs;
  }

  static List<String> alignments(Map<String, String> labels) {
    return [
      labels['alignmentLG'] ?? 'Lawful Good',
      labels['alignmentNG'] ?? 'Neutral Good',
      labels['alignmentCG'] ?? 'Chaotic Good',
      labels['alignmentLN'] ?? 'Lawful Neutral',
      labels['alignmentTN'] ?? 'Neutral',
      labels['alignmentCN'] ?? 'Chaotic Neutral',
      labels['alignmentLE'] ?? 'Lawful Evil',
      labels['alignmentNE'] ?? 'Neutral Evil',
      labels['alignmentCE'] ?? 'Chaotic Evil',
      labels['alignmentU'] ?? 'Unaligned',
    ];
  }
}
