// D&D 5e game rules calculations — edition-agnostic unless noted

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

  /// Half-caster (Paladin, Ranger): level / 2 rounded down → use full-caster table
  /// Third-caster (Arcane Trickster, Eldritch Knight): level / 3 rounded down

  /// Compute spell slots for multiclass per SRD multiclassing table.
  ///
  /// [classPairs] is a list of (classId, level) pairs for all classes the
  /// character has levels in.
  ///
  /// Full casters: Bard, Cleric, Druid, Sorcerer, Wizard + Artificer (not SRD)
  /// Half casters: Paladin, Ranger  → contribute level / 2
  /// Third casters: Arcane Trickster (Rogue), Eldritch Knight (Fighter) → level / 3
  static Map<int, int> multiclassSpellSlots(
      List<({String classId, int level})> classPairs) {
    int effectiveLevel = 0;

    for (final pair in classPairs) {
      switch (pair.classId) {
        case 'bard':
        case 'cleric':
        case 'druid':
        case 'sorcerer':
        case 'wizard':
          effectiveLevel += pair.level;
        case 'paladin':
        case 'ranger':
          effectiveLevel += pair.level ~/ 2;
        case 'fighter':
        case 'rogue':
          // Subclass-dependent; use 1/3 as conservative assumption
          effectiveLevel += pair.level ~/ 3;
        default:
          // Non-caster classes don't contribute
          break;
      }
    }

    if (effectiveLevel <= 0) return {};
    final idx = (effectiveLevel - 1).clamp(0, 19);
    return _fullCasterSlots[idx];
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

  /// Number of cantrips known by class and level (SRD table)
  static int cantripsKnown(String classId, int level) {
    switch (classId) {
      case 'wizard':
        return level >= 10 ? 5 : level >= 4 ? 4 : 3;
      case 'sorcerer':
        return level >= 10 ? 6 : level >= 4 ? 5 : 4;
      case 'warlock':
        return level >= 10 ? 4 : level >= 4 ? 3 : 2;
      case 'bard':
        return level >= 10 ? 4 : level >= 4 ? 3 : 2;
      case 'cleric':
      case 'druid':
        return level >= 10 ? 4 : level >= 4 ? 3 : 2;
      default:
        return 0;
    }
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
