import 'dart:convert';
import 'dart:io';

import 'package:dnd_character_manager/core/database/app_database.dart';
import 'package:dnd_character_manager/core/database/tables/tables.dart';
import 'package:dnd_character_manager/core/utils/class_progression.dart';
import 'package:dnd_character_manager/core/utils/dnd_rules.dart';
import 'package:dnd_character_manager/core/utils/feature_rules.dart';
import 'package:dnd_character_manager/core/utils/level_up_plan.dart';
import 'package:flutter_test/flutter_test.dart';

const d14 = RulesetVersion.dnd2014;
const d24 = RulesetVersion.dnd2024;

Map<String, int> scores({
  int str = 10,
  int dex = 10,
  int con = 10,
  int int_ = 10,
  int wis = 10,
  int cha = 10,
}) => {'str': str, 'dex': dex, 'con': con, 'int': int_, 'wis': wis, 'cha': cha};

LevelUpState state(
  RulesetVersion ruleset,
  List<ClassProgress> classes, {
  Map<String, int>? abilities,
  int hpMax = 30,
  int hpCurrent = 30,
  Set<String> proficiencies = const {},
  Set<String> featIds = const {},
}) => LevelUpState(
  ruleset: ruleset,
  classes: classes,
  scores: abilities ?? scores(),
  hpMax: hpMax,
  hpCurrent: hpCurrent,
  proficiencies: proficiencies,
  featIds: featIds,
);

ClassProgress cls(String id, int level, [String? subclass]) =>
    ClassProgress(classId: id, level: level, subclassId: subclass);

SrdFeat feat(
  RulesetVersion ruleset,
  String id,
  String type, {
  bool repeatable = false,
}) => SrdFeat(
  id: id,
  ruleset: ruleset,
  name: id,
  description: '',
  type: type,
  repeatable: repeatable,
);

List<SrdFeature> loadFeatures(RulesetVersion ruleset, String path) {
  final list = json.decode(File(path).readAsStringSync()) as List;
  var id = 0;
  return list
      .where(
        (f) =>
            ruleset != RulesetVersion.dnd2014 ||
            !FeatureRules.isHidden2014Source(
              f['name'] as String,
              f['subclass']?['index'] as String?,
            ),
      )
      .map(
        (f) => SrdFeature(
          id: id++,
          srdIndex: f['index'] as String,
          ruleset: ruleset,
          name: f['name'] as String,
          classId: f['class']?['index'] as String?,
          subclassId: f['subclass']?['index'] as String?,
          level: f['level'] as int,
          description: (f['desc'] as List).join('\n'),
        ),
      )
      .toList();
}

void main() {
  for (final ruleset in [d14, d24]) {
    group('Guerrier 3→4 (${ruleset.name})', () {
      final plan = LevelUpPlan.build(
        state: state(ruleset, [
          cls('fighter', 3, 'champion'),
        ], abilities: scores(str: 16, con: 14)),
        classId: 'fighter',
      );

      test('impose le choix amélioration de caractéristiques ou don', () {
        expect(plan.newClassLevel, 4);
        expect(plan.improvement, LevelUpImprovementKind.abilityScoreOrFeat);
        expect(plan.needsSubclass, isFalse);
        expect(plan.isNewClass, isFalse);
        expect(plan.hitDie, 10);
        expect(plan.validate(const LevelUpChoices()), [
          LevelUpIssue.improvementMissing,
        ]);
      });

      test('accepte +2 ou +1/+1 et refuse le reste', () {
        bool valid(Map<String, int> inc) =>
            plan.validate(LevelUpChoices(abilityIncreases: inc)).isEmpty;
        expect(valid({'str': 2}), isTrue);
        expect(valid({'str': 1, 'dex': 1}), isTrue);
        expect(valid({'str': 1}), isFalse);
        expect(valid({'str': 3}), isFalse);
        expect(valid({'str': 1, 'dex': 1, 'con': 1}), isFalse);
        expect(valid({'str': 0, 'dex': 2}), isFalse);
        expect(valid({'luck': 2}), isFalse);
      });

      test('canIncrease suit les mêmes limites que la validation', () {
        expect(plan.canIncrease(const {}, 'str'), isTrue);
        expect(plan.canIncrease(const {'str': 1}, 'str'), isTrue);
        expect(plan.canIncrease(const {'str': 2}, 'str'), isFalse);
        expect(plan.canIncrease(const {'str': 1}, 'dex'), isTrue);
        expect(plan.canIncrease(const {'str': 1, 'dex': 1}, 'con'), isFalse);
        expect(plan.canIncrease(const {'str': 1, 'dex': 1}, 'str'), isFalse);
      });

      test('le total ne dépasse jamais 20', () {
        final high = LevelUpPlan.build(
          state: state(ruleset, [
            cls('fighter', 3, 'champion'),
          ], abilities: scores(str: 19, dex: 20, con: 20, int_: 20, wis: 20)),
          classId: 'fighter',
        );
        bool valid(Map<String, int> inc) =>
            high.validate(LevelUpChoices(abilityIncreases: inc)).isEmpty;
        expect(valid({'str': 2}), isFalse);
        expect(valid({'str': 1}), isFalse); // CHA 10 peut encore recevoir +1
        expect(valid({'str': 1, 'cha': 1}), isTrue);
        expect(valid({'cha': 2}), isTrue);
        expect(valid({'dex': 2}), isFalse);

        final maxed = LevelUpPlan.build(
          state: state(
            ruleset,
            [cls('fighter', 3, 'champion')],
            abilities: scores(
              str: 20,
              dex: 20,
              con: 20,
              int_: 20,
              wis: 20,
              cha: 19,
            ),
          ),
          classId: 'fighter',
        );
        expect(maxed.maxAbilityIncreaseTotal(maxed.state.scores), 1);
        expect(
          maxed
              .validate(const LevelUpChoices(abilityIncreases: {'cha': 1}))
              .isEmpty,
          isTrue,
        );
      });

      test('CON +2 : modificateur et PV rétroactifs à jour', () {
        // CON 14 (+2) → 16 (+3) ; 3 niveaux déjà acquis ; d10 moyen = 6.
        final outcome = plan.outcome(
          const LevelUpChoices(abilityIncreases: {'con': 2}),
        );
        expect(outcome.scoresAfter['con'], 16);
        expect(outcome.constitutionChanged, isTrue);
        expect(outcome.hpGain, 6 + 3);
        expect(outcome.retroactiveHp, 3);
        expect(outcome.hpMaxAfter, 30 + 9 + 3);
        expect(outcome.hpCurrentAfter, 30 + 9 + 3);
        expect(outcome.abilityChanges, {'con': (before: 14, after: 16)});
      });

      test('sans changement de CON : pas de PV rétroactifs', () {
        final outcome = plan.outcome(
          const LevelUpChoices(abilityIncreases: {'str': 2}),
        );
        expect(outcome.retroactiveHp, 0);
        expect(outcome.hpGain, 6 + 2);
        expect(outcome.scoresAfter['str'], 18);
        expect(outcome.proficiencyBonusAfter, 2);
      });

      test('un jet de dé remplace la moyenne, minimum 1 PV', () {
        final low = LevelUpPlan.build(
          state: state(ruleset, [
            cls('fighter', 3, 'champion'),
          ], abilities: scores(con: 3)),
          classId: 'fighter',
        );
        final outcome = low.outcome(
          const LevelUpChoices(hpRoll: 1, abilityIncreases: {'str': 2}),
        );
        expect(outcome.hpGain, 1);
        expect(outcome.hpMaxAfter, 31);
      });

      test('un don remplace l\'amélioration', () {
        final feats = [feat(ruleset, 'grappler', 'general')];
        final choices = const LevelUpChoices(featId: 'grappler');
        expect(plan.validate(choices, feats: feats), isEmpty);
        expect(plan.validate(choices), [LevelUpIssue.featNotEligible]);
        final outcome = plan.outcome(
          const LevelUpChoices(
            featId: 'grappler',
            abilityIncreases: {'str': 2},
          ),
        );
        expect(outcome.featId, 'grappler');
        expect(outcome.abilityChanges, isEmpty);
      });

      test('capacités gagnées au niveau 4', () {
        final features = loadFeatures(
          ruleset,
          'assets/data/${ruleset == d14 ? 2014 : 2024}/features.json',
        );
        final gained = plan.gainedFeatures(features).map((f) => f.name);
        expect(gained, ['Ability Score Improvement']);
        expect(gained, isNot(contains('Extra Attack')));
      });
    });

    group('Guerrier 5→6 : deuxième amélioration (${ruleset.name})', () {
      test('niveau 6 : choix imposé, niveau 5 : aucun', () {
        final at6 = LevelUpPlan.build(
          state: state(ruleset, [cls('fighter', 5, 'champion')]),
          classId: 'fighter',
        );
        expect(at6.newClassLevel, 6);
        expect(at6.improvement, LevelUpImprovementKind.abilityScoreOrFeat);

        final at5 = LevelUpPlan.build(
          state: state(ruleset, [cls('fighter', 4, 'champion')]),
          classId: 'fighter',
        );
        expect(at5.improvement, LevelUpImprovementKind.none);
        expect(at5.validate(const LevelUpChoices()), isEmpty);
        // Un choix résiduel est ignoré : aucune caractéristique ne bouge.
        expect(
          at5
              .outcome(const LevelUpChoices(abilityIncreases: {'str': 2}))
              .scoresAfter['str'],
          12,
        );
      });

      test('bonus de maîtrise selon le niveau total', () {
        final plan = LevelUpPlan.build(
          state: state(ruleset, [cls('fighter', 4, 'champion')]),
          classId: 'fighter',
        );
        final outcome = plan.outcome(const LevelUpChoices());
        expect(outcome.proficiencyBonusBefore, 2);
        expect(outcome.proficiencyBonusAfter, 3);
      });
    });
  }

  group('Magicien 1→2', () {
    test('2014 : grimoire +2, sous-classe au niveau 2, sorts préparés', () {
      final plan = LevelUpPlan.build(
        state: state(
          d14,
          [cls('wizard', 1)],
          abilities: scores(int_: 16), // +3
        ),
        classId: 'wizard',
      );
      expect(plan.needsSubclass, isTrue);
      expect(plan.validate(const LevelUpChoices()), [
        LevelUpIssue.subclassMissing,
      ]);
      final outcome = plan.outcome(
        const LevelUpChoices(subclassId: 'evocation'),
      );
      expect(outcome.spells.cantrips, 0);
      expect(outcome.spells.spellbook, 2);
      expect(outcome.spells.spells, 0);
      expect(outcome.preparedSpellsMax, 2 + 3);
      expect(outcome.spellSlotsAfter, {1: 3});
      expect(outcome.hpGain, 4 + 0);
    });

    test('2024 : grimoire +2, 1 sort préparé de plus, sous-classe au 3', () {
      final plan = LevelUpPlan.build(
        state: state(d24, [cls('wizard', 1)]),
        classId: 'wizard',
      );
      expect(plan.needsSubclass, isFalse);
      final outcome = plan.outcome(const LevelUpChoices());
      expect(outcome.spells.spellbook, 2);
      expect(outcome.spells.spells, 1);
      expect(outcome.preparedSpellsMax, isNull);
    });

    test('niveau 3→4 : un sort mineur de plus', () {
      final plan = LevelUpPlan.build(
        state: state(d14, [cls('wizard', 3, 'evocation')]),
        classId: 'wizard',
      );
      final spells = plan.spellProgression();
      expect(spells.cantrips, 1);
      expect(spells.isEmpty, isFalse);
    });

    test('2014 : Ensorceleur et Barde apprennent des sorts connus', () {
      final sorcerer = LevelUpPlan.build(
        state: state(d14, [cls('sorcerer', 1, 'draconic')]),
        classId: 'sorcerer',
      );
      expect(sorcerer.spellProgression().spells, 1);
      final bard = LevelUpPlan.build(
        state: state(d14, [cls('bard', 3, 'lore')]),
        classId: 'bard',
      );
      expect(bard.spellProgression().spells, 7 - 6);
    });
  });

  group('Sous-classe', () {
    test('niveau de choix selon l\'édition', () {
      expect(ClassProgression.subclassLevel('cleric', d14), 1);
      expect(ClassProgression.subclassLevel('cleric', d24), 3);
      expect(ClassProgression.subclassLevel('druid', d14), 2);
      expect(ClassProgression.subclassLevel('fighter', d14), 3);
    });

    test('rattrape une sous-classe non choisie, sauf sans options', () {
      final s = state(d14, [cls('fighter', 4)]);
      expect(
        LevelUpPlan.build(state: s, classId: 'fighter').needsSubclass,
        isTrue,
      );
      expect(
        LevelUpPlan.build(
          state: s,
          classId: 'fighter',
          hasSubclassOptions: false,
        ).needsSubclass,
        isFalse,
      );
      expect(
        LevelUpPlan.build(
          state: state(d14, [cls('fighter', 4, 'champion')]),
          classId: 'fighter',
        ).needsSubclass,
        isFalse,
      );
    });
  });

  group('Multiclasse Magicien + Guerrier', () {
    final wizard5 = [cls('wizard', 5, 'evocation')];

    test('2014 : maîtrises du Guerrier sans doublon', () {
      final plan = LevelUpPlan.build(
        state: state(
          d14,
          wizard5,
          abilities: scores(str: 13, int_: 14),
          proficiencies: {'armor_light', 'weapon_dagger'},
        ),
        classId: 'fighter',
      );
      expect(plan.isNewClass, isTrue);
      expect(plan.newClassLevel, 1);
      expect(plan.hitDie, 10);
      expect(plan.multiclassProficiencies, [
        'armor_medium',
        'armor_shield',
        'weapon_simple',
        'weapon_martial',
      ]);
      expect(plan.unmetPrerequisites, isEmpty);
      expect(plan.validate(const LevelUpChoices()), isEmpty);
      expect(plan.needsSubclass, isFalse);

      final outcome = plan.outcome(const LevelUpChoices());
      expect(outcome.proficiencyKeysAdded, plan.multiclassProficiencies);
      expect(outcome.classesAfter.map((c) => c.classId), ['wizard', 'fighter']);
      expect(outcome.hpGain, 6);
      // Le Guerrier de niveau 1 n'ajoute aucun emplacement.
      expect(outcome.spellSlotsAfter, {1: 4, 2: 3, 3: 2});
      expect(outcome.spellSlotsChanged, isFalse);
      expect(outcome.hitDiceKey, 'hitDice_d10');
    });

    test('2024 : pas d\'armes simples, armure lourde ignorée', () {
      final plan = LevelUpPlan.build(
        state: state(
          d24,
          wizard5,
          abilities: scores(str: 13, int_: 14),
          proficiencies: {'armor_all'},
        ),
        classId: 'fighter',
      );
      expect(plan.multiclassProficiencies, ['weapon_martial']);
    });

    test('prérequis : avertissement, avec option de passer outre', () {
      final plan = LevelUpPlan.build(
        state: state(
          d14,
          wizard5,
          abilities: scores(str: 12, dex: 12, int_: 11),
        ),
        classId: 'fighter',
      );
      expect(plan.unmetPrerequisites.map((u) => u.classId), [
        'wizard',
        'fighter',
      ]);
      expect(plan.unmetPrerequisites.last.anyOf, isTrue);
      expect(plan.unmetPrerequisites.last.abilities, ['str', 'dex']);
      expect(plan.validate(const LevelUpChoices()), [
        LevelUpIssue.multiclassPrerequisite,
      ]);
      expect(
        plan.validate(
          const LevelUpChoices(overrideMulticlassPrerequisite: true),
        ),
        isEmpty,
      );
    });

    test(
      'le Guerrier Chevalier occulte ajoute des emplacements au niveau 3',
      () {
        final slots = ClassProgression.spellSlots([
          cls('wizard', 5, 'evocation'),
          cls('fighter', 3, 'eldritch-knight'),
        ], d14);
        // 5 + 3 ~/ 3 = niveau de lanceur 6
        expect(slots, DndRules.slotsForCasterLevel(6));

        final champion = ClassProgression.spellSlots([
          cls('wizard', 5, 'evocation'),
          cls('fighter', 3, 'champion'),
        ], d14);
        expect(champion, {1: 4, 2: 3, 3: 2});
      },
    );

    test('une classe non lanceuse conserve les emplacements existants', () {
      final plan = LevelUpPlan.build(
        state: state(d24, [cls('wizard', 3, 'evoker'), cls('fighter', 1)]),
        classId: 'fighter',
      );
      expect(plan.outcome(const LevelUpChoices()).spellSlotsChanged, isFalse);
    });
  });

  group('Multiclasse : compétences et ressources', () {
    test(
      'Roublard : une compétence de sa liste, hors maîtrises existantes',
      () {
        final plan = LevelUpPlan.build(
          state: state(
            d14,
            [cls('fighter', 3, 'champion')],
            abilities: scores(dex: 13),
            proficiencies: {'skill_stealth'},
          ),
          classId: 'rogue',
        );
        expect(plan.skillChoice, isNotNull);
        expect(plan.skillChoice!.options, isNot(contains('stealth')));
        expect(plan.skillChoice!.options, contains('acrobatics'));
        expect(plan.skillChoice!.options, isNot(contains('arcana')));
        expect(plan.validate(const LevelUpChoices()), [
          LevelUpIssue.skillChoiceMissing,
        ]);
        expect(plan.validate(const LevelUpChoices(skillChoices: ['arcana'])), [
          LevelUpIssue.skillChoiceMissing,
        ]);
        final choices = const LevelUpChoices(skillChoices: ['acrobatics']);
        expect(plan.validate(choices), isEmpty);
        final outcome = plan.outcome(choices);
        expect(outcome.proficiencyKeysAdded, [
          'armor_light',
          'tool_thieves-tools',
          'skill_acrobatics',
        ]);
      },
    );

    test('Barde : toute compétence', () {
      final plan = LevelUpPlan.build(
        state: state(d24, [
          cls('fighter', 3, 'champion'),
        ], abilities: scores(cha: 13)),
        classId: 'bard',
      );
      expect(plan.skillChoice!.options.length, 18);
    });

    test('Barde : un instrument de musique, hors maîtrises existantes', () {
      final plan = LevelUpPlan.build(
        state: state(
          d24,
          [cls('fighter', 3, 'champion')],
          abilities: scores(str: 13, cha: 13),
          proficiencies: {'tool_lute'},
        ),
        classId: 'bard',
      );
      expect(plan.instrumentChoice, isNotNull);
      expect(plan.instrumentChoice!.options, isNot(contains('lute')));
      expect(plan.instrumentChoice!.options, contains('flute'));

      const noInstrument = LevelUpChoices(skillChoices: ['arcana']);
      expect(plan.validate(noInstrument), [
        LevelUpIssue.instrumentChoiceMissing,
      ]);
      const choices = LevelUpChoices(
        skillChoices: ['arcana'],
        instrumentChoices: ['flute'],
      );
      expect(plan.validate(choices), isEmpty);
      expect(plan.outcome(choices).proficiencyKeysAdded, [
        'armor_light',
        'skill_arcana',
        'tool_flute',
      ]);
    });

    test('les autres classes ne demandent pas d\'instrument', () {
      final plan = LevelUpPlan.build(
        state: state(d14, [
          cls('wizard', 3, 'evocation'),
        ], abilities: scores(dex: 13, int_: 13)),
        classId: 'rogue',
      );
      expect(plan.instrumentChoice, isNull);
    });

    test('le premier niveau d\'un personnage ne donne pas de maîtrises', () {
      final plan = LevelUpPlan.build(
        state: state(d14, const []),
        classId: 'fighter',
      );
      expect(plan.multiclassProficiencies, isEmpty);
      expect(plan.unmetPrerequisites, isEmpty);
    });

    test('Barbare 2→3 : rage et dés de vie, courant conservé', () {
      final plan = LevelUpPlan.build(
        state: state(d14, [cls('barbarian', 2)]),
        classId: 'barbarian',
      );
      final outcome = plan.outcome(
        const LevelUpChoices(subclassId: 'berserker'),
      );
      expect(outcome.resourceTargets, {'resourceRage': 3});
      final changes = outcome.resourceChanges({
        'resourceRage': const ResourceValue(0, 2),
        'hitDice_d12': const ResourceValue(1, 2),
        'resourceLucky': const ResourceValue(1, 2),
      });
      expect(changes['resourceRage'], const ResourceValue(1, 3));
      expect(changes['hitDice_d12'], const ResourceValue(2, 3));
      // Bonus de maîtrise toujours 2 : Chanceux inchangé.
      expect(changes.containsKey('resourceLucky'), isFalse);
    });

    test('ressources absentes créées, dés de vie par défaut', () {
      final plan = LevelUpPlan.build(
        state: state(d24, [cls('wizard', 3, 'evoker')]),
        classId: 'monk',
      );
      final outcome = plan.outcome(const LevelUpChoices());
      expect(outcome.resourceChanges(const {}), {
        'hitDice_d8': const ResourceValue(1, 1),
      });

      final monk2 = LevelUpPlan.build(
        state: state(d24, [cls('monk', 1)]),
        classId: 'monk',
      ).outcome(const LevelUpChoices());
      expect(
        monk2.resourceChanges(const {})['resourceKi'],
        const ResourceValue(2, 2),
      );
    });

    test('Chanceux suit le bonus de maîtrise', () {
      final outcome = LevelUpPlan.build(
        state: state(d24, [cls('fighter', 4, 'champion')]),
        classId: 'fighter',
      ).outcome(const LevelUpChoices(abilityIncreases: {'str': 2}));
      final changes = outcome.resourceChanges({
        'resourceLucky': const ResourceValue(0, 2),
      });
      expect(changes['resourceLucky'], const ResourceValue(1, 3));
    });
  });

  group('Niveaux particuliers', () {
    test('Barbare 19→20 : +4 FOR et CON automatiques, plafond 24', () {
      final plan = LevelUpPlan.build(
        state: state(
          d24,
          [cls('barbarian', 19, 'berserker')],
          abilities: scores(str: 20, con: 22),
          hpMax: 200,
          hpCurrent: 150,
        ),
        classId: 'barbarian',
      );
      expect(plan.improvement, LevelUpImprovementKind.fixed);
      expect(plan.validate(const LevelUpChoices()), isEmpty);
      final outcome = plan.outcome(const LevelUpChoices());
      expect(outcome.scoresAfter['str'], 24);
      expect(outcome.scoresAfter['con'], 26);
      expect(outcome.retroactiveHp, 2 * 19);
      expect(outcome.hpMaxAfter, 200 + outcome.hpGain + 38);
    });

    test('Roublard : amélioration au niveau 10', () {
      final plan = LevelUpPlan.build(
        state: state(d14, [cls('rogue', 9, 'thief')]),
        classId: 'rogue',
      );
      expect(plan.improvement, LevelUpImprovementKind.abilityScoreOrFeat);
    });

    test('niveau 19 : amélioration en 2014, don épique en 2024', () {
      final plan14 = LevelUpPlan.build(
        state: state(d14, [cls('wizard', 18, 'evocation')]),
        classId: 'wizard',
      );
      expect(plan14.improvement, LevelUpImprovementKind.abilityScoreOrFeat);

      final plan24 = LevelUpPlan.build(
        state: state(d24, [cls('wizard', 18, 'evoker')]),
        classId: 'wizard',
      );
      expect(plan24.improvement, LevelUpImprovementKind.epicBoon);
      final feats = [
        feat(d24, 'boon-of-fate', 'epic-boon'),
        feat(d24, 'boon-of-spell-recall', 'epic-boon'),
        feat(d24, 'grappler', 'general'),
        feat(d24, 'alert', 'origin'),
        feat(d24, 'ability-score-improvement', 'general'),
      ];
      expect(plan24.eligibleFeats(feats).map((f) => f.id), [
        'boon-of-fate',
        'boon-of-spell-recall',
        'grappler',
      ]);
      expect(plan24.validate(const LevelUpChoices(), feats: feats), [
        LevelUpIssue.improvementMissing,
      ]);
      expect(
        plan24.validate(
          const LevelUpChoices(featId: 'boon-of-fate'),
          feats: feats,
        ),
        isEmpty,
      );
      // Les caractéristiques ne bougent pas avec un don épique.
      expect(
        plan24
            .outcome(
              const LevelUpChoices(
                featId: 'boon-of-fate',
                abilityIncreases: {'int': 2},
              ),
            )
            .abilityChanges,
        isEmpty,
      );
    });

    test('prérequis des dons : Rappel des sorts exige l\'incantation', () {
      final plan = LevelUpPlan.build(
        state: state(d24, [cls('fighter', 18, 'champion')]),
        classId: 'fighter',
      );
      final feats = [
        feat(d24, 'boon-of-fate', 'epic-boon'),
        feat(d24, 'boon-of-spell-recall', 'epic-boon'),
      ];
      expect(plan.eligibleFeats(feats).map((f) => f.id), ['boon-of-fate']);
    });

    test('dons déjà possédés et non répétables exclus', () {
      final plan = LevelUpPlan.build(
        state: state(
          d24,
          [cls('fighter', 3, 'champion')],
          featIds: {'grappler'},
        ),
        classId: 'fighter',
      );
      expect(plan.eligibleFeats([feat(d24, 'grappler', 'general')]), isEmpty);
    });

    test('niveau 20 atteint : plus de montée de niveau', () {
      final plan = LevelUpPlan.build(
        state: state(d14, [cls('fighter', 20, 'champion')]),
        classId: 'fighter',
      );
      expect(
        plan.validate(const LevelUpChoices()),
        contains(LevelUpIssue.maxLevel),
      );
    });
  });

  group('Sorts des sous-classes lanceuses', () {
    test(
      'Guerrier 2→3 Chevalier occulte : sorts mineurs, sorts, emplacements',
      () {
        for (final ruleset in [d14, d24]) {
          final plan = LevelUpPlan.build(
            state: state(ruleset, [cls('fighter', 2)]),
            classId: 'fighter',
          );
          // Avant le choix de sous-classe : rien.
          expect(plan.spellProgression().isEmpty, isTrue);
          final outcome = plan.outcome(
            const LevelUpChoices(subclassId: 'eldritch-knight'),
          );
          expect(outcome.spells.cantrips, 2);
          expect(outcome.spells.spells, 3);
          expect(outcome.spellSlotsAfter, {1: 2});
        }
      },
    );

    test('Escroc arcanique : 3 sorts mineurs au niveau 3, 4 au niveau 10', () {
      final at3 = LevelUpPlan.build(
        state: state(d24, [cls('rogue', 2)]),
        classId: 'rogue',
      ).outcome(const LevelUpChoices(subclassId: 'arcane-trickster'));
      expect(at3.spells.cantrips, 3);
      expect(at3.spells.spells, 3);

      final at10 = LevelUpPlan.build(
        state: state(d24, [cls('rogue', 9, 'arcane-trickster')]),
        classId: 'rogue',
      ).outcome(const LevelUpChoices());
      expect(at10.spells.cantrips, 1);
      expect(at10.spells.spells, 1);
    });

    test('Champion : aucun sort', () {
      final outcome = LevelUpPlan.build(
        state: state(d14, [cls('fighter', 2)]),
        classId: 'fighter',
      ).outcome(const LevelUpChoices(subclassId: 'champion'));
      expect(outcome.spells.isEmpty, isTrue);
      expect(outcome.spellSlotsAfter, isEmpty);
    });
  });

  group('Emplacements de sorts', () {
    test('demi-lanceurs : table propre en solo, 2014 vs 2024', () {
      expect(ClassProgression.spellSlots([cls('paladin', 1)], d14), isEmpty);
      expect(ClassProgression.spellSlots([cls('paladin', 2)], d14), {1: 2});
      expect(ClassProgression.spellSlots([cls('paladin', 3)], d14), {1: 3});
      expect(ClassProgression.spellSlots([cls('paladin', 5)], d14), {
        1: 4,
        2: 2,
      });
      expect(ClassProgression.spellSlots([cls('paladin', 1)], d24), {1: 2});
    });

    test('multiclasse Paladin + Magicien', () {
      // 2014 : 3 ~/ 2 + 3 = 4 ; 2024 : ceil(3 / 2) + 3 = 5
      expect(
        ClassProgression.spellSlots([cls('paladin', 3), cls('wizard', 3)], d14),
        DndRules.slotsForCasterLevel(4),
      );
      expect(
        ClassProgression.spellSlots([cls('paladin', 3), cls('wizard', 3)], d24),
        DndRules.slotsForCasterLevel(5),
      );
    });

    test('Occultiste : magie des pactes, ajoutée aux emplacements', () {
      expect(ClassProgression.spellSlots([cls('warlock', 3)], d24), {2: 2});
      expect(
        ClassProgression.spellSlots([cls('wizard', 3), cls('warlock', 2)], d24),
        {1: 4 + 2, 2: 2},
      );
    });

    test('Guerrier Champion seul : aucun emplacement', () {
      expect(
        ClassProgression.spellSlots([cls('fighter', 5, 'champion')], d14),
        isEmpty,
      );
      expect(
        ClassProgression.spellSlots([
          cls('fighter', 3, 'eldritch-knight'),
        ], d14),
        {1: 2},
      );
    });

    test('la montée de niveau change les emplacements', () {
      final outcome = LevelUpPlan.build(
        state: state(d14, [cls('wizard', 2)]),
        classId: 'wizard',
      ).outcome(const LevelUpChoices(subclassId: 'evocation'));
      expect(outcome.spellSlotsBefore, {1: 3});
      expect(outcome.spellSlotsAfter, {1: 4, 2: 2});
      expect(outcome.spellSlotsChanged, isTrue);
    });
  });

  group('Tables conformes aux données SRD', () {
    for (final entry in {d14: '2014', d24: '2024'}.entries) {
      final ruleset = entry.key;
      final year = entry.value;
      final levels =
          json.decode(File('assets/data/$year/levels.json').readAsStringSync())
              as List;

      List<Map<String, dynamic>> rowsOf(String classId) =>
          levels
              .cast<Map<String, dynamic>>()
              .where(
                (l) => l['class']['index'] == classId && l['subclass'] == null,
              )
              .toList()
            ..sort((a, b) => (a['level'] as int).compareTo(b['level'] as int));

      test('$year : sorts mineurs, sorts connus/préparés', () {
        for (final classId in ClassProgression.classIds) {
          for (final row in rowsOf(classId)) {
            final level = row['level'] as int;
            final sc = row['spellcasting'] as Map<String, dynamic>?;
            if (sc == null) continue;
            // L'export SRD 2024 du Druide contient deux valeurs aberrantes
            // (niveaux 7 et 16) : la règle imprimée fait foi.
            final druid2024 = ruleset == d24 && classId == 'druid';
            if (!druid2024) {
              expect(
                ClassProgression.cantripsKnown(classId, level),
                sc['cantrips_known'] ?? 0,
                reason: '$year $classId $level : sorts mineurs',
              );
            }
            final known = (sc['spells_known'] ?? sc['prepared_spells']) as int?;
            // Même source SRD : le Magicien 2024 y plafonne à 22 sorts
            // préparés au niveau 20 ; le manuel donne 25 (table vérifiée).
            final wizard2024 = ruleset == d24 && classId == 'wizard';
            if (known != null && known > 0 && !wizard2024) {
              expect(
                ClassProgression.fixedSpellCount(classId, level, ruleset),
                known,
                reason: '$year $classId $level : sorts connus/préparés',
              );
            }
          }
        }
      });

      test('$year : niveaux d\'amélioration de caractéristiques', () {
        for (final classId in ClassProgression.classIds) {
          final fromData = rowsOf(classId)
              .where(
                (l) => (l['features'] as List).any(
                  (f) => RegExp(
                    r'Ability Score Improvement|Epic Boon',
                  ).hasMatch(f['name'] as String),
                ),
              )
              .map((l) => l['level'] as int)
              .toList();
          expect(
            ClassProgression.abilityImprovementLevels(classId),
            fromData,
            reason: '$year $classId',
          );
        }
      });

      test('$year : sous-classe au bon niveau', () {
        final pattern = RegExp(
          ruleset == d24
              ? r'Subclass$'
              : r'^(Primal Path|Bard College|Divine Domain|Druid Circle|'
                    r'Martial Archetype|Monastic Tradition|Sacred Oath|'
                    r'Ranger Archetype|Roguish Archetype|Sorcerous Origin|'
                    r'Otherworldly Patron|Arcane Tradition)$',
        );
        for (final classId in ClassProgression.classIds) {
          final level = rowsOf(classId).firstWhere(
            (l) => (l['features'] as List).any(
              (f) => pattern.hasMatch(f['name'] as String),
            ),
          )['level'];
          expect(
            ClassProgression.subclassLevel(classId, ruleset),
            level,
            reason: '$year $classId',
          );
        }
      });

      test('$year : prérequis et maîtrises de multiclassage', () {
        final classes =
            json.decode(
                  File('assets/data/$year/classes.json').readAsStringSync(),
                )
                as List;
        const profKeys = {
          'light-armor': 'armor_light',
          'medium-armor': 'armor_medium',
          'shields': 'armor_shield',
          'simple-weapons': 'weapon_simple',
          'martial-weapons': 'weapon_martial',
          'shortswords': 'weapon_shortsword',
          'thieves-tools': 'tool_thieves-tools',
          'tool-thieves-tools': 'tool_thieves-tools',
        };
        for (final c in classes) {
          final classId = c['index'] as String;
          final mc = c['multi_classing'] as Map<String, dynamic>;

          final allOf = <String, int>{
            for (final p in (mc['prerequisites'] as List? ?? []))
              p['ability_score']['index'] as String: p['minimum_score'] as int,
          };
          final anyOf = <String, int>{
            for (final o
                in ((mc['prerequisite_options']?['from']?['options'])
                        as List? ??
                    []))
              o['ability_score']['index'] as String: o['minimum_score'] as int,
          };
          final prerequisite = ClassProgression.prerequisite(classId);
          expect(prerequisite.allOf, allOf, reason: '$year $classId allOf');
          expect(prerequisite.anyOf, anyOf, reason: '$year $classId anyOf');

          final proficiencies = [
            for (final p in (mc['proficiencies'] as List? ?? []))
              profKeys[p['index']] ?? p['index'] as String,
          ];
          expect(
            ClassProgression.multiclassProficiencies(classId, ruleset),
            proficiencies,
            reason: '$year $classId maîtrises',
          );
        }
      });
    }
  });
}
