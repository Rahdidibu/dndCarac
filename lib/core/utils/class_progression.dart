import '../database/tables/tables.dart';
import 'dnd_rules.dart';
import 'feature_rules.dart';

/// Prérequis de multiclassage d'une classe (SRD 2014 et 2024 identiques).
class MulticlassPrerequisite {
  /// Caractéristiques à avoir toutes au minimum requis.
  final Map<String, int> allOf;

  /// Caractéristiques dont une seule suffit (Guerrier : FOR ou DEX).
  final Map<String, int> anyOf;

  const MulticlassPrerequisite({
    this.allOf = const {},
    this.anyOf = const {},
  });
}

/// Tables de progression par classe utilisées par la montée de niveau.
/// Les valeurs proviennent de `assets/data/*/classes.json` et `levels.json`
/// (vérifiées par `test/level_up_plan_test.dart`).
class ClassProgression {
  ClassProgression._();

  static const int defaultAbilityCap = 20;

  static const List<String> classIds = [
    'barbarian', 'bard', 'cleric', 'druid', 'fighter', 'monk',
    'paladin', 'ranger', 'rogue', 'sorcerer', 'warlock', 'wizard',
  ];

  static int hitDie(String classId) => switch (classId) {
    'barbarian' => 12,
    'fighter' || 'paladin' || 'ranger' => 10,
    'sorcerer' || 'wizard' => 6,
    _ => 8,
  };

  /// Niveau de classe auquel la sous-classe doit être choisie.
  static int subclassLevel(String classId, RulesetVersion ruleset) {
    if (ruleset == RulesetVersion.dnd2024) return 3;
    return switch (classId) {
      'cleric' || 'sorcerer' || 'warlock' => 1,
      'druid' || 'wizard' => 2,
      _ => 3,
    };
  }

  // ── Amélioration de caractéristiques ──────────────────────────────────────

  /// Niveaux de classe donnant une amélioration de caractéristique ou un don.
  /// En 2024 le niveau 19 donne un Don épique (voir [isEpicBoonLevel]).
  static List<int> abilityImprovementLevels(String classId) =>
      switch (classId) {
        'fighter' => const [4, 6, 8, 12, 14, 16, 19],
        'rogue' => const [4, 8, 10, 12, 16, 19],
        _ => const [4, 8, 12, 16, 19],
      };

  static bool isEpicBoonLevel(RulesetVersion ruleset, int classLevel) =>
      ruleset == RulesetVersion.dnd2024 && classLevel == 19;

  /// Barbare 20 (Champion primitif) : +4 FOR et CON, plafond 24, sans choix.
  static Map<String, int> fixedAbilityIncreases(
    String classId,
    int classLevel,
  ) => classId == 'barbarian' && classLevel == 20
      ? const {'str': 4, 'con': 4}
      : const {};

  static const int primalChampionCap = 24;

  // ── Multiclassage ─────────────────────────────────────────────────────────

  static MulticlassPrerequisite prerequisite(String classId) =>
      switch (classId) {
        'barbarian' => const MulticlassPrerequisite(allOf: {'str': 13}),
        'bard' ||
        'sorcerer' ||
        'warlock' => const MulticlassPrerequisite(allOf: {'cha': 13}),
        'cleric' || 'druid' => const MulticlassPrerequisite(allOf: {'wis': 13}),
        'fighter' => const MulticlassPrerequisite(
          anyOf: {'str': 13, 'dex': 13},
        ),
        'monk' || 'ranger' => const MulticlassPrerequisite(
          allOf: {'dex': 13, 'wis': 13},
        ),
        'paladin' => const MulticlassPrerequisite(
          allOf: {'str': 13, 'cha': 13},
        ),
        'rogue' => const MulticlassPrerequisite(allOf: {'dex': 13}),
        'wizard' => const MulticlassPrerequisite(allOf: {'int': 13}),
        _ => const MulticlassPrerequisite(),
      };

  /// Maîtrises (clés de `character_proficiencies`) gagnées en prenant un
  /// premier niveau de [classId] comme classe supplémentaire.
  static List<String> multiclassProficiencies(
    String classId,
    RulesetVersion ruleset,
  ) {
    final is2024 = ruleset == RulesetVersion.dnd2024;
    return switch (classId) {
      'barbarian' => [
        'armor_shield',
        if (!is2024) 'weapon_simple',
        'weapon_martial',
      ],
      'bard' => const ['armor_light'],
      'warlock' => ['armor_light', if (!is2024) 'weapon_simple'],
      'rogue' => const ['armor_light', 'tool_thieves-tools'],
      'cleric' => const ['armor_light', 'armor_medium', 'armor_shield'],
      'druid' => [
        'armor_light',
        if (!is2024) 'armor_medium',
        'armor_shield',
      ],
      'fighter' || 'paladin' || 'ranger' => [
        'armor_light',
        'armor_medium',
        'armor_shield',
        if (!is2024) 'weapon_simple',
        'weapon_martial',
      ],
      'monk' => is2024 ? const [] : const ['weapon_simple', 'weapon_shortsword'],
      _ => const [],
    };
  }

  static const _rogueSkills = [
    'acrobatics', 'athletics', 'deception', 'insight', 'intimidation',
    'investigation', 'perception', 'performance', 'persuasion',
    'sleight_of_hand', 'stealth',
  ];
  static const _rangerSkills = [
    'animal_handling', 'athletics', 'insight', 'investigation', 'nature',
    'perception', 'stealth', 'survival',
  ];

  /// Compétence au choix gagnée au multiclassage : liste de choix, ou null si
  /// la classe n'en donne pas. Une liste vide signifie « toute compétence ».
  static List<String>? multiclassSkillOptions(String classId) =>
      switch (classId) {
        'bard' => const [],
        'rogue' => _rogueSkills,
        'ranger' => _rangerSkills,
        _ => null,
      };

  /// Le Barde donne aussi un instrument de musique au multiclassage.
  static bool grantsInstrument(String classId) => classId == 'bard';

  // ── Sorts ─────────────────────────────────────────────────────────────────

  // dart format off

  /// Sorts mineurs connus par niveau de classe (index 0 = niveau 1).
  static const _cantrips = <String, List<int>>{
    'bard': [2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
    'cleric': [3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
    'druid': [2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
    'sorcerer': [4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6],
    'warlock': [2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
    'wizard': [3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
  };

  /// 2014 : sorts connus des classes à liste fixe.
  static const _spellsKnown2014 = <String, List<int>>{
    'bard': [4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 15, 16, 18, 19, 19, 20, 22, 22, 22],
    'ranger': [0, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11],
    'sorcerer': [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12, 13, 13, 14, 14, 15, 15, 15, 15],
    'warlock': [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15],
  };

  static const _prepared2024Full = [4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 16, 16, 17, 17, 18, 18, 19, 20, 21, 22];
  static const _prepared2024Half = [2, 3, 4, 5, 6, 6, 7, 7, 9, 9, 10, 10, 11, 11, 12, 12, 14, 14, 15, 15];

  /// 2024 : sorts préparés par niveau de classe (SRD 5.2).
  static const _prepared2024 = <String, List<int>>{
    'bard': _prepared2024Full,
    'cleric': _prepared2024Full,
    'druid': _prepared2024Full,
    'wizard': [4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 16, 16, 17, 18, 19, 21, 22, 23, 24, 25],
    'sorcerer': [2, 4, 6, 7, 9, 10, 11, 12, 14, 15, 16, 16, 17, 17, 18, 18, 19, 20, 21, 22],
    'warlock': [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15],
    'paladin': _prepared2024Half,
    'ranger': _prepared2024Half,
  };

  /// Sorts connus par niveau de classe du Chevalier occulte et de l'Escroc
  /// arcanique (identiques en 2014 et 2024).
  static const _thirdCasterSpells = [0, 0, 3, 4, 4, 4, 5, 6, 6, 7, 8, 8, 9, 10, 10, 11, 11, 11, 12, 13];

  // dart format on

  static int _at(List<int>? table, int level) {
    if (table == null || level < 1) return 0;
    return table[(level - 1).clamp(0, table.length - 1)];
  }

  /// Sorts mineurs connus. La sous-classe compte pour le Chevalier occulte
  /// (2, puis 3 au niveau 10) et l'Escroc arcanique (3, puis 4).
  static int cantripsKnown(String classId, int level, {String? subclassId}) {
    final third = _thirdCaster(classId, subclassId);
    if (third == null) return _at(_cantrips[classId], level);
    if (level < 3) return 0;
    return (third == 'rogue' ? 3 : 2) + (level >= 10 ? 1 : 0);
  }

  /// 'fighter' ou 'rogue' si la sous-classe est une sous-classe lanceuse.
  static String? _thirdCaster(String classId, String? subclassId) {
    final sub = subclassId ?? '';
    if (classId == 'fighter' && sub.contains('eldritch-knight')) return 'fighter';
    if (classId == 'rogue' && sub.contains('arcane-trickster')) return 'rogue';
    return null;
  }

  /// Sorts connus (liste fixe) ou préparés (tables 2024) selon le niveau de
  /// classe. 0 pour les classes dont le nombre dépend de la caractéristique.
  static int fixedSpellCount(
    String classId,
    int level,
    RulesetVersion ruleset, {
    String? subclassId,
  }) {
    if (_thirdCaster(classId, subclassId) != null) {
      return _at(_thirdCasterSpells, level);
    }
    return _at(
      ruleset == RulesetVersion.dnd2024
          ? _prepared2024[classId]
          : _spellsKnown2014[classId],
      level,
    );
  }

  /// Sorts à inscrire dans le grimoire : 6 au niveau 1 puis 2 par niveau.
  static int spellbookSize(int level) => level < 1 ? 0 : 6 + 2 * (level - 1);

  /// 2014 : sorts préparés (Clerc, Druide, Magicien : niveau + modificateur ;
  /// Paladin : moitié du niveau + modificateur), minimum 1. Null si la classe
  /// n'est pas concernée.
  static int? preparedSpells2014(String classId, int level, int abilityMod) {
    if (level < 1) return 0;
    final base = switch (classId) {
      'cleric' || 'druid' || 'wizard' => level,
      'paladin' => level < 2 ? null : level ~/ 2,
      _ => null,
    };
    if (base == null) return null;
    return (base + abilityMod).clamp(1, 999);
  }

  /// Caractéristique d'incantation de la classe.
  static String? spellcastingAbility(String classId) => switch (classId) {
    'bard' || 'paladin' || 'sorcerer' || 'warlock' => 'cha',
    'cleric' || 'druid' || 'ranger' => 'wis',
    'wizard' => 'int',
    _ => null,
  };

  static bool isEldritchKnight(ClassProgress c) =>
      c.classId == 'fighter' &&
      (c.subclassId ?? '').contains('eldritch-knight');

  static bool isArcaneTrickster(ClassProgress c) =>
      c.classId == 'rogue' &&
      (c.subclassId ?? '').contains('arcane-trickster');

  /// Vrai si la classe (avec sa sous-classe) donne l'incantation à ce niveau.
  static bool hasSpellcasting(ClassProgress c, RulesetVersion ruleset) {
    switch (c.classId) {
      case 'bard' || 'cleric' || 'druid' || 'sorcerer' || 'warlock' || 'wizard':
        return true;
      case 'paladin' || 'ranger':
        return ruleset == RulesetVersion.dnd2024 || c.level >= 2;
      case 'fighter':
        return isEldritchKnight(c) && c.level >= 3;
      case 'rogue':
        return isArcaneTrickster(c) && c.level >= 3;
    }
    return false;
  }

  /// Emplacements de sorts d'un personnage. Une seule classe lanceuse de
  /// sorts utilise sa propre table ; plusieurs classes additionnent leurs
  /// niveaux de lanceur (demi-niveau arrondi à l'inférieur en 2014, au
  /// supérieur en 2024 ; tiers arrondi à l'inférieur). La Magie des pactes
  /// de l'Occultiste s'ajoute par niveau d'emplacement.
  static Map<int, int> spellSlots(
    List<ClassProgress> classes,
    RulesetVersion ruleset,
  ) {
    final is2024 = ruleset == RulesetVersion.dnd2024;
    final casters = classes
        .where((c) => c.classId != 'warlock' && hasSpellcasting(c, ruleset))
        .toList();
    final multi = casters.length > 1;

    var casterLevel = 0;
    for (final c in casters) {
      switch (c.classId) {
        case 'paladin' || 'ranger':
          casterLevel += multi && !is2024 ? c.level ~/ 2 : (c.level + 1) ~/ 2;
        case 'fighter' || 'rogue':
          casterLevel += multi ? c.level ~/ 3 : (c.level + 2) ~/ 3;
        default:
          casterLevel += c.level;
      }
    }

    final slots = {...DndRules.slotsForCasterLevel(casterLevel)};
    for (final c in classes.where((c) => c.classId == 'warlock')) {
      DndRules.warlockPactSlots(c.level).forEach(
        (level, count) => slots[level] = (slots[level] ?? 0) + count,
      );
    }
    return slots;
  }
}
