import '../database/app_database.dart';
import '../database/tables/tables.dart';
import 'character_edit_rules.dart';
import 'class_progression.dart';
import 'dnd_rules.dart';
import 'feature_rules.dart';
import 'musical_instruments.dart';
import 'skills_catalog.dart';

/// État d'un personnage avant la montée de niveau (lu depuis la base).
class LevelUpState {
  final RulesetVersion ruleset;
  final List<ClassProgress> classes;

  /// Valeurs finales des caractéristiques (`str`, `dex`, `con`, `int`, `wis`, `cha`).
  final Map<String, int> scores;
  final int hpMax;
  final int hpCurrent;

  /// Clés de `character_proficiencies` déjà possédées.
  final Set<String> proficiencies;

  /// Identifiants des dons déjà possédés.
  final Set<String> featIds;

  const LevelUpState({
    required this.ruleset,
    required this.classes,
    required this.scores,
    required this.hpMax,
    required this.hpCurrent,
    this.proficiencies = const {},
    this.featIds = const {},
  });

  int get totalLevel => classes.fold(0, (sum, c) => sum + c.level);
}

/// Ce que le joueur a décidé pendant l'assistant.
class LevelUpChoices {
  /// Résultat du dé de vie (sans modificateur de CON) ; null = moyenne.
  final int? hpRoll;
  final String? subclassId;

  /// Amélioration de caractéristiques (+2 ou +1/+1) à la place d'un don.
  final Map<String, int> abilityIncreases;
  final String? featId;

  /// Compétence gagnée au multiclassage (clé sans préfixe `skill_`).
  final List<String> skillChoices;

  /// Instrument gagné au multiclassage Barde (clé sans préfixe `tool_`).
  final List<String> instrumentChoices;

  /// Passer outre l'avertissement sur les prérequis de multiclassage.
  final bool overrideMulticlassPrerequisite;

  const LevelUpChoices({
    this.hpRoll,
    this.subclassId,
    this.abilityIncreases = const {},
    this.featId,
    this.skillChoices = const [],
    this.instrumentChoices = const [],
    this.overrideMulticlassPrerequisite = false,
  });

  LevelUpChoices copyWith({
    int? hpRoll,
    bool clearHpRoll = false,
    String? subclassId,
    bool clearSubclass = false,
    Map<String, int>? abilityIncreases,
    String? featId,
    bool clearFeat = false,
    List<String>? skillChoices,
    List<String>? instrumentChoices,
    bool? overrideMulticlassPrerequisite,
  }) => LevelUpChoices(
    hpRoll: clearHpRoll ? null : hpRoll ?? this.hpRoll,
    subclassId: clearSubclass ? null : subclassId ?? this.subclassId,
    abilityIncreases: abilityIncreases ?? this.abilityIncreases,
    featId: clearFeat ? null : featId ?? this.featId,
    skillChoices: skillChoices ?? this.skillChoices,
    instrumentChoices: instrumentChoices ?? this.instrumentChoices,
    overrideMulticlassPrerequisite:
        overrideMulticlassPrerequisite ?? this.overrideMulticlassPrerequisite,
  );
}

enum LevelUpImprovementKind {
  /// Aucun gain de caractéristique à ce niveau.
  none,

  /// Amélioration de caractéristiques (+2 / +1 +1) ou don général.
  abilityScoreOrFeat,

  /// 2024, niveau 19 : un don (Don épique ou général), sans ASI.
  epicBoon,

  /// Augmentation automatique (Barbare 20 : Champion primitif).
  fixed,
}

enum LevelUpIssue {
  maxLevel,
  subclassMissing,
  improvementMissing,
  improvementInvalid,
  featNotEligible,
  skillChoiceMissing,
  instrumentChoiceMissing,
  multiclassPrerequisite,
}

/// Prérequis de multiclassage non satisfait.
class UnmetPrerequisite {
  final String classId;

  /// Caractéristiques concernées ; une seule suffit si [anyOf].
  final List<String> abilities;
  final int minimum;
  final bool anyOf;

  const UnmetPrerequisite({
    required this.classId,
    required this.abilities,
    required this.minimum,
    this.anyOf = false,
  });
}

/// Choix de maîtrise à faire en prenant un premier niveau de classe
/// supplémentaire (compétence ou instrument).
class ProficiencyChoice {
  final int count;

  /// Clés autorisées (non encore maîtrisées).
  final List<String> options;

  const ProficiencyChoice({required this.count, required this.options});
}

/// Sorts à choisir grâce à ce niveau : à gérer ensuite dans la gestion des sorts.
class SpellProgression {
  final int cantrips;

  /// Sorts connus (2014) ou préparés (2024) en plus.
  final int spells;

  /// Sorts à inscrire dans le grimoire du Magicien.
  final int spellbook;

  const SpellProgression({
    this.cantrips = 0,
    this.spells = 0,
    this.spellbook = 0,
  });

  bool get isEmpty => cantrips <= 0 && spells <= 0 && spellbook <= 0;
}

class ResourceValue {
  final int current;
  final int maximum;

  const ResourceValue(this.current, this.maximum);

  @override
  bool operator ==(Object other) =>
      other is ResourceValue &&
      other.current == current &&
      other.maximum == maximum;

  @override
  int get hashCode => Object.hash(current, maximum);

  @override
  String toString() => '$current/$maximum';
}

/// Fonction pure : ce que la montée de niveau d'une classe implique, avant tout
/// choix du joueur. [outcome] combine ensuite le plan et les choix.
class LevelUpPlan {
  final LevelUpState state;
  final String classId;
  final bool hasSubclassOptions;

  final bool isNewClass;
  final int oldClassLevel;
  final int newClassLevel;
  final int hitDie;

  final bool needsSubclass;
  final LevelUpImprovementKind improvement;
  final Map<String, int> fixedIncreases;
  final int abilityCap;

  final List<UnmetPrerequisite> unmetPrerequisites;
  final ProficiencyChoice? skillChoice;
  final ProficiencyChoice? instrumentChoice;

  /// Maîtrises de multiclassage réellement nouvelles (sans doublon).
  final List<String> multiclassProficiencies;

  final List<ClassProgress> classesBefore;

  const LevelUpPlan._({
    required this.state,
    required this.classId,
    required this.hasSubclassOptions,
    required this.isNewClass,
    required this.oldClassLevel,
    required this.newClassLevel,
    required this.hitDie,
    required this.needsSubclass,
    required this.improvement,
    required this.fixedIncreases,
    required this.abilityCap,
    required this.unmetPrerequisites,
    required this.skillChoice,
    required this.instrumentChoice,
    required this.multiclassProficiencies,
    required this.classesBefore,
  });

  /// [hasSubclassOptions] : false quand le compendium n'a aucune sous-classe
  /// pour cette classe (le choix est alors ignoré).
  factory LevelUpPlan.build({
    required LevelUpState state,
    required String classId,
    bool hasSubclassOptions = true,
  }) {
    final ruleset = state.ruleset;
    final existing = state.classes
        .where((c) => c.classId == classId)
        .firstOrNull;
    final isNew = existing == null;
    final oldLevel = existing?.level ?? 0;
    final newLevel = oldLevel + 1;

    final subclassChosen = (existing?.subclassId ?? '').isNotEmpty;
    final needsSubclass =
        hasSubclassOptions &&
        !subclassChosen &&
        newLevel >= ClassProgression.subclassLevel(classId, ruleset);

    final fixed = ClassProgression.fixedAbilityIncreases(classId, newLevel);
    final improvement = fixed.isNotEmpty
        ? LevelUpImprovementKind.fixed
        : !ClassProgression.abilityImprovementLevels(classId).contains(newLevel)
        ? LevelUpImprovementKind.none
        : ClassProgression.isEpicBoonLevel(ruleset, newLevel)
        ? LevelUpImprovementKind.epicBoon
        : LevelUpImprovementKind.abilityScoreOrFeat;

    final proficiencies = <String>[];
    ProficiencyChoice? skillChoice;
    ProficiencyChoice? instrumentChoice;
    var unmet = const <UnmetPrerequisite>[];
    if (isNew && state.classes.isNotEmpty) {
      final owned = state.proficiencies;
      final allArmor = owned.contains('armor_all');
      for (final key in ClassProgression.multiclassProficiencies(
        classId,
        ruleset,
      )) {
        final covered =
            owned.contains(key) || (allArmor && key.startsWith('armor_'));
        if (!covered && !proficiencies.contains(key)) proficiencies.add(key);
      }

      final skills = ClassProgression.multiclassSkillOptions(classId);
      if (skills != null) {
        final candidates =
            (skills.isEmpty ? Skill.values.map((s) => s.key) : skills)
                .where((s) => !owned.contains('skill_$s'))
                .toList();
        if (candidates.isNotEmpty) {
          skillChoice = ProficiencyChoice(count: 1, options: candidates);
        }
      }

      if (ClassProgression.grantsInstrument(classId)) {
        final candidates = [
          for (final i in musicalInstruments)
            if (!owned.contains('tool_${i.key}')) i.key,
        ];
        if (candidates.isNotEmpty) {
          instrumentChoice = ProficiencyChoice(count: 1, options: candidates);
        }
      }

      unmet = _unmetPrerequisites(state, classId);
    }

    return LevelUpPlan._(
      state: state,
      classId: classId,
      hasSubclassOptions: hasSubclassOptions,
      isNewClass: isNew,
      oldClassLevel: oldLevel,
      newClassLevel: newLevel,
      hitDie: ClassProgression.hitDie(classId),
      needsSubclass: needsSubclass,
      improvement: improvement,
      fixedIncreases: fixed,
      abilityCap: fixed.isNotEmpty
          ? ClassProgression.primalChampionCap
          : ClassProgression.defaultAbilityCap,
      unmetPrerequisites: unmet,
      skillChoice: skillChoice,
      instrumentChoice: instrumentChoice,
      multiclassProficiencies: proficiencies,
      classesBefore: state.classes,
    );
  }

  static List<UnmetPrerequisite> _unmetPrerequisites(
    LevelUpState state,
    String newClassId,
  ) {
    final unmet = <UnmetPrerequisite>[];
    // Le nouveau multiclassage exige le minimum dans la nouvelle classe et
    // dans toutes les classes actuelles.
    final ids = [...state.classes.map((c) => c.classId), newClassId];
    for (final id in ids) {
      final prerequisite = ClassProgression.prerequisite(id);
      for (final entry in prerequisite.allOf.entries) {
        if ((state.scores[entry.key] ?? 10) < entry.value) {
          unmet.add(
            UnmetPrerequisite(
              classId: id,
              abilities: [entry.key],
              minimum: entry.value,
            ),
          );
        }
      }
      if (prerequisite.anyOf.isNotEmpty &&
          !prerequisite.anyOf.entries.any(
            (e) => (state.scores[e.key] ?? 10) >= e.value,
          )) {
        unmet.add(
          UnmetPrerequisite(
            classId: id,
            abilities: prerequisite.anyOf.keys.toList(),
            minimum: prerequisite.anyOf.values.first,
            anyOf: true,
          ),
        );
      }
    }
    return unmet;
  }

  // ── Dérivés indépendants des choix ────────────────────────────────────────

  int get oldTotalLevel => state.totalLevel;
  int get newTotalLevel => oldTotalLevel + 1;
  bool get isMaxLevel => oldTotalLevel >= 20;

  int get hpAverageRoll => hitDie ~/ 2 + 1;

  /// Sorts à choisir grâce à ce niveau. [subclassId] est la sous-classe
  /// choisie pendant la montée (Chevalier occulte, Escroc arcanique) ; sans
  /// elle, la sous-classe déjà enregistrée est utilisée.
  SpellProgression spellProgression({String? subclassId}) {
    final existing = state.classes
        .where((c) => c.classId == classId)
        .firstOrNull
        ?.subclassId;
    final before = (existing ?? '').isNotEmpty ? existing : null;
    final after = before ?? ((subclassId ?? '').isNotEmpty ? subclassId : null);

    int cantrips(int level, String? sub) =>
        ClassProgression.cantripsKnown(classId, level, subclassId: sub);
    int spells(int level, String? sub) => ClassProgression.fixedSpellCount(
      classId,
      level,
      state.ruleset,
      subclassId: sub,
    );
    int positive(int value) => value > 0 ? value : 0;

    return SpellProgression(
      cantrips: positive(
        cantrips(newClassLevel, after) - cantrips(oldClassLevel, before),
      ),
      spells: positive(
        spells(newClassLevel, after) - spells(oldClassLevel, before),
      ),
      spellbook: classId == 'wizard'
          ? ClassProgression.spellbookSize(newClassLevel) -
                ClassProgression.spellbookSize(oldClassLevel)
          : 0,
    );
  }

  /// Classes après la montée de niveau, avec la sous-classe éventuellement choisie.
  List<ClassProgress> classesAfter({String? subclassId}) {
    final updated = <ClassProgress>[];
    for (final c in state.classes) {
      updated.add(
        c.classId == classId
            ? ClassProgress(
                classId: c.classId,
                level: newClassLevel,
                subclassId: (c.subclassId ?? '').isNotEmpty
                    ? c.subclassId
                    : subclassId,
              )
            : c,
      );
    }
    if (isNewClass) {
      updated.add(
        ClassProgress(classId: classId, level: 1, subclassId: subclassId),
      );
    }
    return updated;
  }

  // ── Dons ──────────────────────────────────────────────────────────────────

  /// Dons proposables à ce niveau, prérequis vérifiés. Les dons d'origine,
  /// de style de combat et le don « Amélioration de caractéristiques » (déjà
  /// proposé comme choix à part) sont exclus.
  List<SrdFeat> eligibleFeats(Iterable<SrdFeat> all, {String? subclassId}) {
    if (improvement != LevelUpImprovementKind.abilityScoreOrFeat &&
        improvement != LevelUpImprovementKind.epicBoon) {
      return const [];
    }
    final after = classesAfter(subclassId: subclassId);
    final types = improvement == LevelUpImprovementKind.epicBoon
        ? const {'general', 'epic-boon'}
        : const {'general'};
    return all
        .where(
          (f) =>
              f.ruleset == state.ruleset &&
              types.contains(f.type) &&
              f.id != 'ability-score-improvement' &&
              (f.repeatable || !state.featIds.contains(f.id)) &&
              _meetsFeatPrerequisites(f, after),
        )
        .toList();
  }

  bool _meetsFeatPrerequisites(SrdFeat feat, List<ClassProgress> after) {
    if (feat.type == 'epic-boon' && newTotalLevel < 19) return false;
    if (feat.type == 'general' && newTotalLevel < 4) return false;
    if (feat.id == 'boon-of-spell-recall') {
      return after.any(
        (c) => ClassProgression.hasSpellcasting(c, state.ruleset),
      );
    }
    return true;
  }

  // ── Capacités ─────────────────────────────────────────────────────────────

  /// Capacités de classe et de sous-classe nouvellement acquises.
  List<SrdFeature> gainedFeatures(
    Iterable<SrdFeature> all, {
    String? subclassId,
  }) {
    final list = all.toList();
    final before = FeatureRules.forClasses(
      all: list,
      ruleset: state.ruleset,
      classes: state.classes,
    ).map((f) => f.id).toSet();
    final after = FeatureRules.forClasses(
      all: list,
      ruleset: state.ruleset,
      classes: classesAfter(subclassId: subclassId),
    );
    return after.where((f) => !before.contains(f.id)).toList()
      ..sort(FeatureRules.compare);
  }

  // ── Validation ────────────────────────────────────────────────────────────

  /// Plus grand total d'amélioration possible (2, 1 ou 0 si tout est au plafond).
  int maxAbilityIncreaseTotal(Map<String, int> scores) {
    final rooms = DndRules.abilityKeys
        .map((k) => abilityCap - (scores[k] ?? 10))
        .where((r) => r > 0)
        .toList();
    if (rooms.any((r) => r >= 2) || rooms.length >= 2) return 2;
    return rooms.length;
  }

  /// Vrai si +1 en [key] reste possible sans dépasser 2 points, 2
  /// caractéristiques ni le plafond, selon [increases] déjà choisies.
  bool canIncrease(Map<String, int> increases, String key) {
    final total = increases.values.fold(0, (a, b) => a + b);
    if (total >= maxAbilityIncreaseTotal(state.scores)) return false;
    final current = increases[key] ?? 0;
    if (current >= 2) return false;
    if (current == 0 && increases.length >= 2) return false;
    return (state.scores[key] ?? 10) + current + 1 <= abilityCap;
  }

  bool isValidAbilityIncrease(Map<String, int> increases) {
    final total = increases.values.fold(0, (a, b) => a + b);
    if (total <= 0 || increases.length > 2) return false;
    if (increases.values.any((v) => v < 1 || v > 2)) return false;
    for (final e in increases.entries) {
      if (!DndRules.abilityKeys.contains(e.key)) return false;
      if ((state.scores[e.key] ?? 10) + e.value > abilityCap) return false;
    }
    return total == maxAbilityIncreaseTotal(state.scores);
  }

  List<LevelUpIssue> validate(
    LevelUpChoices choices, {
    Iterable<SrdFeat> feats = const [],
  }) {
    final issues = <LevelUpIssue>[];
    if (isMaxLevel) issues.add(LevelUpIssue.maxLevel);

    if (needsSubclass && (choices.subclassId ?? '').isEmpty) {
      issues.add(LevelUpIssue.subclassMissing);
    }

    switch (improvement) {
      case LevelUpImprovementKind.abilityScoreOrFeat:
        final hasFeat = choices.featId != null;
        if (hasFeat) {
          if (!eligibleFeats(
            feats,
            subclassId: choices.subclassId,
          ).any((f) => f.id == choices.featId)) {
            issues.add(LevelUpIssue.featNotEligible);
          }
        } else if (choices.abilityIncreases.isEmpty) {
          issues.add(LevelUpIssue.improvementMissing);
        } else if (!isValidAbilityIncrease(choices.abilityIncreases)) {
          issues.add(LevelUpIssue.improvementInvalid);
        }
      case LevelUpImprovementKind.epicBoon:
        if (choices.featId == null) {
          issues.add(LevelUpIssue.improvementMissing);
        } else if (!eligibleFeats(
          feats,
          subclassId: choices.subclassId,
        ).any((f) => f.id == choices.featId)) {
          issues.add(LevelUpIssue.featNotEligible);
        }
      case LevelUpImprovementKind.none || LevelUpImprovementKind.fixed:
        break;
    }

    final skill = skillChoice;
    if (skill != null &&
        (choices.skillChoices.length != skill.count ||
            choices.skillChoices.any((s) => !skill.options.contains(s)))) {
      issues.add(LevelUpIssue.skillChoiceMissing);
    }

    final instrument = instrumentChoice;
    if (instrument != null &&
        (choices.instrumentChoices.length != instrument.count ||
            choices.instrumentChoices.any(
              (s) => !instrument.options.contains(s),
            ))) {
      issues.add(LevelUpIssue.instrumentChoiceMissing);
    }

    if (unmetPrerequisites.isNotEmpty &&
        !choices.overrideMulticlassPrerequisite) {
      issues.add(LevelUpIssue.multiclassPrerequisite);
    }
    return issues;
  }

  // ── Résultat ──────────────────────────────────────────────────────────────

  /// Résultat complet de la montée de niveau pour des choix valides. Sert à la
  /// fois à l'aperçu, au résumé et à l'écriture en base.
  LevelUpOutcome outcome(LevelUpChoices choices) {
    final subclassId = (choices.subclassId ?? '').isEmpty
        ? null
        : choices.subclassId;
    final classesAfter = this.classesAfter(subclassId: subclassId);

    final scoresAfter = {
      for (final k in DndRules.abilityKeys) k: state.scores[k] ?? 10,
    };
    final increases = improvement == LevelUpImprovementKind.fixed
        ? fixedIncreases
        : choices.featId != null
        ? const <String, int>{}
        : choices.abilityIncreases;
    increases.forEach((k, v) {
      scoresAfter[k] = (scoresAfter[k] ?? 10) + v;
    });

    final featId =
        improvement == LevelUpImprovementKind.abilityScoreOrFeat ||
            improvement == LevelUpImprovementKind.epicBoon
        ? choices.featId
        : null;

    final conBefore = state.scores['con'] ?? 10;
    final conAfter = scoresAfter['con'] ?? 10;
    final roll = choices.hpRoll ?? hpAverageRoll;
    final hpGain = (roll + DndRules.modifier(conAfter)).clamp(1, 999);
    // Le nouveau niveau profite déjà du nouveau modificateur : seul l'écart
    // sur les niveaux précédents est rétroactif.
    final retroactive = CharacterEditRules.retroactiveHpDelta(
      oldCon: conBefore,
      newCon: conAfter,
      totalLevel: oldTotalLevel,
    );
    final hp = CharacterEditRules.applyHpDelta(
      hpMax: state.hpMax,
      hpCurrent: state.hpCurrent,
      delta: hpGain + retroactive,
    );

    final proficiencyKeys = <String>[
      ...multiclassProficiencies,
      for (final s in choices.skillChoices) 'skill_$s',
      for (final i in choices.instrumentChoices) 'tool_$i',
    ].where((k) => !state.proficiencies.contains(k)).toSet().toList();

    final resourceTargets = _resourceMaximums(classesAfter, state.ruleset);

    final preparedAbility = ClassProgression.spellcastingAbility(classId);
    final preparedMax =
        state.ruleset == RulesetVersion.dnd2014 && preparedAbility != null
        ? ClassProgression.preparedSpells2014(
            classId,
            newClassLevel,
            DndRules.modifier(scoresAfter[preparedAbility] ?? 10),
          )
        : null;

    return LevelUpOutcome(
      plan: this,
      subclassId: subclassId,
      classesAfter: classesAfter,
      scoresBefore: {
        for (final k in DndRules.abilityKeys) k: state.scores[k] ?? 10,
      },
      scoresAfter: scoresAfter,
      featId: featId,
      hpRoll: roll,
      hpGain: hpGain,
      retroactiveHp: retroactive,
      hpMaxAfter: hp.hpMax,
      hpCurrentAfter: hp.hpCurrent,
      proficiencyBonusBefore: DndRules.proficiencyBonus(oldTotalLevel),
      proficiencyBonusAfter: DndRules.proficiencyBonus(newTotalLevel),
      proficiencyKeysAdded: proficiencyKeys,
      spellSlotsBefore: ClassProgression.spellSlots(
        state.classes,
        state.ruleset,
      ),
      spellSlotsAfter: ClassProgression.spellSlots(classesAfter, state.ruleset),
      resourceTargets: resourceTargets,
      resourceTargetsBefore: _resourceMaximums(state.classes, state.ruleset),
      preparedSpellsMax: preparedMax,
      spells: spellProgression(subclassId: subclassId),
    );
  }

  /// Maximum de chaque ressource de classe ; deux classes partageant une
  /// ressource (Conduit divin) gardent le plus grand.
  static Map<String, int> _resourceMaximums(
    List<ClassProgress> classes,
    RulesetVersion ruleset,
  ) {
    final maximums = <String, int>{};
    for (final c in classes) {
      for (final spec in DndRules.classResourceByLevel(
        c.classId,
        c.level,
        ruleset,
      )) {
        final known = maximums[spec.key];
        if (known == null || spec.maximum > known) {
          maximums[spec.key] = spec.maximum;
        }
      }
    }
    return maximums;
  }
}

class LevelUpOutcome {
  final LevelUpPlan plan;
  final String? subclassId;
  final List<ClassProgress> classesAfter;
  final Map<String, int> scoresBefore;
  final Map<String, int> scoresAfter;
  final String? featId;

  /// Dé de vie utilisé (jet ou moyenne), sans modificateur.
  final int hpRoll;

  /// PV gagnés par le nouveau niveau (dé + CON finale, minimum 1).
  final int hpGain;

  /// PV supplémentaires dus à la hausse du modificateur de CON.
  final int retroactiveHp;
  final int hpMaxAfter;
  final int hpCurrentAfter;
  final int proficiencyBonusBefore;
  final int proficiencyBonusAfter;
  final List<String> proficiencyKeysAdded;
  final Map<int, int> spellSlotsBefore;
  final Map<int, int> spellSlotsAfter;

  /// Maximum visé de chaque ressource de classe après la montée de niveau.
  final Map<String, int> resourceTargets;

  /// Maximum des ressources de classe avant la montée de niveau.
  final Map<String, int> resourceTargetsBefore;

  /// 2014 : nombre maximal de sorts préparés de la classe (null sinon).
  final int? preparedSpellsMax;

  /// Sorts à choisir grâce à ce niveau.
  final SpellProgression spells;

  const LevelUpOutcome({
    required this.plan,
    required this.subclassId,
    required this.classesAfter,
    required this.scoresBefore,
    required this.scoresAfter,
    required this.featId,
    required this.hpRoll,
    required this.hpGain,
    required this.retroactiveHp,
    required this.hpMaxAfter,
    required this.hpCurrentAfter,
    required this.proficiencyBonusBefore,
    required this.proficiencyBonusAfter,
    required this.proficiencyKeysAdded,
    required this.spellSlotsBefore,
    required this.spellSlotsAfter,
    required this.resourceTargets,
    required this.resourceTargetsBefore,
    required this.preparedSpellsMax,
    required this.spells,
  });

  /// Caractéristiques modifiées : clé → (ancienne, nouvelle valeur).
  Map<String, ({int before, int after})> get abilityChanges => {
    for (final k in DndRules.abilityKeys)
      if (scoresBefore[k] != scoresAfter[k])
        k: (before: scoresBefore[k]!, after: scoresAfter[k]!),
  };

  bool get constitutionChanged =>
      DndRules.modifier(scoresBefore['con'] ?? 10) !=
      DndRules.modifier(scoresAfter['con'] ?? 10);

  int get hpMaxDelta => hpMaxAfter - plan.state.hpMax;

  bool get spellSlotsChanged => !_sameSlots(spellSlotsBefore, spellSlotsAfter);

  static bool _sameSlots(Map<int, int> a, Map<int, int> b) =>
      a.length == b.length && a.entries.every((e) => b[e.key] == e.value);

  /// Clé de la ressource de dés de vie de la classe qui progresse.
  String get hitDiceKey => 'hitDice_d${plan.hitDie}';

  /// Ressources à écrire à partir de [existing] (nom → valeurs) : seules les
  /// lignes nouvelles ou modifiées sont retournées. Un maximum qui augmente
  /// ajoute autant d'utilisations disponibles ; un maximum qui diminue
  /// plafonne le courant. Les dés de vie gagnent 1, et le don Chanceux suit le
  /// bonus de maîtrise.
  Map<String, ResourceValue> resourceChanges(
    Map<String, ResourceValue> existing,
  ) {
    final changes = <String, ResourceValue>{};

    void retarget(String key, int maximum) {
      final current = existing[key];
      if (current == null) {
        changes[key] = ResourceValue(maximum, maximum);
        return;
      }
      if (current.maximum == maximum) return;
      final delta = maximum - current.maximum;
      changes[key] = ResourceValue(
        (current.current + (delta > 0 ? delta : 0)).clamp(0, maximum),
        maximum,
      );
    }

    resourceTargets.forEach(retarget);

    final dice = existing[hitDiceKey];
    changes[hitDiceKey] = dice == null
        ? ResourceValue(plan.newClassLevel, plan.newClassLevel)
        : ResourceValue(dice.current + 1, dice.maximum + 1);

    if (existing.containsKey('resourceLucky')) {
      final bonus = proficiencyBonusAfter < 2 ? 2 : proficiencyBonusAfter;
      retarget('resourceLucky', bonus);
    }
    return changes;
  }
}
