import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';

/// State object for the character creation wizard
class WizardState {
  // Step 1 – system
  final RulesetVersion ruleset;

  // Step 2 – identity
  final String name;
  final String playerName;
  final String alignment;

  // Step 3 – classes (list supports multiclass)
  final List<WizardClassEntry> classes;

  // Step 4 – origin
  final String? speciesId;
  final String? subspeciesId;
  final String? backgroundId;
  final String? chosenFeatId;
  // 2024: player picks 2 ability scores from the background's eligible list
  final Map<String, int> backgroundAsiChoices; // e.g. {str: 2, wis: 1}

  // Step 5 – ability scores
  final AbilityScoreMethod abilityMethod;
  final Map<String, int> abilityScores; // str/dex/con/int/wis/cha

  // Step 6 – proficiencies (skill keys chosen during wizard)
  final List<String> chosenSkillProficiencies;

  // Step 3b – weapon masteries (DnD 2024 only)
  final List<String> chosenWeaponMasteries;

  // Step 6b – extra proficiencies from origin feats (Skilled, Crafter, Musician)
  final List<String> chosenFeatExtraProficiencies;

  // 2024: warlock level 1 pact invocation choice
  final String? chosenWarlockPact;

  // 2024: cleric level 1 divine order choice
  final String? chosenDivineOrder;

  // 2024: druid level 1 primal order choice
  final String? chosenPrimalOrder;

  // 2024: fighting style feat choice (fighter lvl 1, paladin lvl 2, ranger lvl 2)
  final String? chosenFightingStyle;

  const WizardState({
    this.ruleset = RulesetVersion.dnd2014,
    this.name = '',
    this.playerName = '',
    this.alignment = '',
    this.classes = const [],
    this.speciesId,
    this.subspeciesId,
    this.backgroundId,
    this.chosenFeatId,
    this.backgroundAsiChoices = const {},
    this.abilityMethod = AbilityScoreMethod.pointBuy,
    this.abilityScores = const {
      'str': 8,
      'dex': 8,
      'con': 8,
      'int': 8,
      'wis': 8,
      'cha': 8,
    },
    this.chosenSkillProficiencies = const [],
    this.chosenWeaponMasteries = const [],
    this.chosenFeatExtraProficiencies = const [],
    this.chosenWarlockPact,
    this.chosenDivineOrder,
    this.chosenPrimalOrder,
    this.chosenFightingStyle,
  });

  WizardState copyWith({
    RulesetVersion? ruleset,
    String? name,
    String? playerName,
    String? alignment,
    List<WizardClassEntry>? classes,
    String? speciesId,
    String? subspeciesId,
    String? backgroundId,
    String? chosenFeatId,
    Map<String, int>? backgroundAsiChoices,
    AbilityScoreMethod? abilityMethod,
    Map<String, int>? abilityScores,
    List<String>? chosenSkillProficiencies,
    List<String>? chosenWeaponMasteries,
    List<String>? chosenFeatExtraProficiencies,
    String? chosenWarlockPact,
    String? chosenDivineOrder,
    String? chosenPrimalOrder,
    String? chosenFightingStyle,
  }) {
    return WizardState(
      ruleset: ruleset ?? this.ruleset,
      name: name ?? this.name,
      playerName: playerName ?? this.playerName,
      alignment: alignment ?? this.alignment,
      classes: classes ?? this.classes,
      speciesId: speciesId ?? this.speciesId,
      subspeciesId: subspeciesId ?? this.subspeciesId,
      backgroundId: backgroundId ?? this.backgroundId,
      chosenFeatId: chosenFeatId ?? this.chosenFeatId,
      backgroundAsiChoices: backgroundAsiChoices ?? this.backgroundAsiChoices,
      abilityMethod: abilityMethod ?? this.abilityMethod,
      abilityScores: abilityScores ?? this.abilityScores,
      chosenSkillProficiencies:
          chosenSkillProficiencies ?? this.chosenSkillProficiencies,
      chosenWeaponMasteries: chosenWeaponMasteries ?? this.chosenWeaponMasteries,
      chosenFeatExtraProficiencies:
          chosenFeatExtraProficiencies ?? this.chosenFeatExtraProficiencies,
      chosenWarlockPact: chosenWarlockPact ?? this.chosenWarlockPact,
      chosenDivineOrder: chosenDivineOrder ?? this.chosenDivineOrder,
      chosenPrimalOrder: chosenPrimalOrder ?? this.chosenPrimalOrder,
      chosenFightingStyle: chosenFightingStyle ?? this.chosenFightingStyle,
    );
  }

  /// Total character level across all classes
  int get totalLevel => classes.fold(0, (s, c) => s + c.level);

  bool get isStep2Valid => name.trim().isNotEmpty;
  bool get isStep3Valid => classes.isNotEmpty;
  bool get isStep4Valid => speciesId != null && backgroundId != null;

  /// Point buy: remaining points (standard 27-point buy, costs table SRD)
  int get pointBuyRemaining {
    const costs = {8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5, 14: 7, 15: 9};
    final spent =
        abilityScores.values.fold(0, (s, v) => s + (costs[v] ?? 0));
    return 27 - spent;
  }
}

class WizardClassEntry {
  final String classId;
  final String? subclassId;
  final int level;

  const WizardClassEntry({
    required this.classId,
    this.subclassId,
    this.level = 1,
  });

  WizardClassEntry copyWith({
    String? classId,
    String? subclassId,
    int? level,
  }) {
    return WizardClassEntry(
      classId: classId ?? this.classId,
      subclassId: subclassId ?? this.subclassId,
      level: level ?? this.level,
    );
  }
}

enum AbilityScoreMethod { pointBuy, roll, manual }

/// The wizard notifier
class WizardNotifier extends StateNotifier<WizardState> {
  WizardNotifier() : super(const WizardState());

  void setRuleset(RulesetVersion r) => state = state.copyWith(ruleset: r);
  void setName(String v) => state = state.copyWith(name: v);
  void setPlayerName(String v) => state = state.copyWith(playerName: v);
  void setAlignment(String v) => state = state.copyWith(alignment: v);

  void addClass(WizardClassEntry entry) {
    state = state.copyWith(classes: [...state.classes, entry]);
  }

  void updateClass(int index, WizardClassEntry entry) {
    final updated = [...state.classes];
    updated[index] = entry;
    state = state.copyWith(classes: updated);
  }

  void removeClass(int index) {
    final updated = [...state.classes]..removeAt(index);
    final hasWarlock = updated.any((c) => c.classId == 'warlock');
    final hasCleric = updated.any((c) => c.classId == 'cleric');
    final hasDruid = updated.any((c) => c.classId == 'druid');
    final hasFighter = updated.any((c) => c.classId == 'fighter');
    final hasPaladin = updated.any((c) => c.classId == 'paladin');
    final hasRanger = updated.any((c) => c.classId == 'ranger');
    state = state.copyWith(
      classes: updated,
      chosenWarlockPact: hasWarlock ? state.chosenWarlockPact : null,
      chosenDivineOrder: hasCleric ? state.chosenDivineOrder : null,
      chosenPrimalOrder: hasDruid ? state.chosenPrimalOrder : null,
      chosenFightingStyle: (hasFighter || hasPaladin || hasRanger) ? state.chosenFightingStyle : null,
    );
  }

  void setSpecies(String? id) =>
      state = state.copyWith(speciesId: id, subspeciesId: null);
  void setSubspecies(String? id) => state = state.copyWith(subspeciesId: id);
  void setBackground(String? id) =>
      state = state.copyWith(backgroundId: id, chosenFeatExtraProficiencies: const []);
  void setChosenFeatId(String? id) => state = state.copyWith(chosenFeatId: id);
  void setWarlockPact(String? id) => state = state.copyWith(chosenWarlockPact: id);
  void setDivineOrder(String? id) => state = state.copyWith(chosenDivineOrder: id);
  void setPrimalOrder(String? id) => state = state.copyWith(chosenPrimalOrder: id);
  void setFightingStyle(String? id) => state = state.copyWith(chosenFightingStyle: id);
  void setBackgroundAsi(Map<String, int> choices) =>
      state = state.copyWith(backgroundAsiChoices: choices);

  void setAbilityMethod(AbilityScoreMethod m) {
    const defaults = {
      'str': 8, 'dex': 8, 'con': 8, 'int': 8, 'wis': 8, 'cha': 8
    };
    state = state.copyWith(abilityMethod: m, abilityScores: defaults);
  }

  void setAbilityScore(String ability, int value) {
    final updated = Map<String, int>.from(state.abilityScores);
    updated[ability] = value;
    state = state.copyWith(abilityScores: updated);
  }

  void setAllAbilityScores(Map<String, int> scores) =>
      state = state.copyWith(abilityScores: scores);

  void toggleSkillProficiency(String key) {
    final current = [...state.chosenSkillProficiencies];
    if (current.contains(key)) {
      current.remove(key);
    } else {
      current.add(key);
    }
    state = state.copyWith(chosenSkillProficiencies: current);
  }

  void toggleFeatExtraProficiency(String key) {
    final current = [...state.chosenFeatExtraProficiencies];
    if (current.contains(key)) {
      current.remove(key);
    } else {
      if (current.length < 3) {
        current.add(key);
      }
    }
    state = state.copyWith(chosenFeatExtraProficiencies: current);
  }

  void toggleWeaponMastery(String id) {
    final current = [...state.chosenWeaponMasteries];
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = state.copyWith(chosenWeaponMasteries: current);
  }

  /// Number of weapon mastery slots for the primary class at level 1 (DnD 2024)
  static int weaponMasteryCountForClass(String classId) {
    const counts = {
      'fighter': 3,
      'paladin': 2,
      'ranger': 2,
      'barbarian': 2,
      'rogue': 2,
      'monk': 2,
      'bard': 1,
      'cleric': 1,
      'druid': 1,
      'sorcerer': 1,
      'warlock': 1,
      'wizard': 1,
    };
    return counts[classId] ?? 2;
  }

  void reset() => state = const WizardState();
}

final wizardProvider =
    StateNotifierProvider.autoDispose<WizardNotifier, WizardState>(
  (ref) => WizardNotifier(),
);

/// Compendium data providers for wizard dropdowns

final wizardClassesProvider =
    FutureProvider.autoDispose.family<List<SrdClassesData>, RulesetVersion>(
  (ref, ruleset) async {
    // Needs DB — accessed via ref, injected via ProviderScope
    throw UnimplementedError('Provide DB via override');
  },
);
