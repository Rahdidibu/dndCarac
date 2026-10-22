import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/utils/character_service.dart';
import '../../../core/utils/level_up_plan.dart';
import 'character_providers.dart';

/// Capacités SRD de l'édition, pour lister celles que gagne le personnage.
final levelUpFeaturesProvider = FutureProvider.autoDispose
    .family<List<SrdFeature>, RulesetVersion>((ref, ruleset) {
      return ref.watch(databaseProvider).compendiumDao.getAllFeatures(ruleset);
    });

/// Onglet de la fiche à ouvrir au prochain affichage (indice de `TabBar`
/// mobile) ; consommé par la fiche puis remis à null.
final sheetTabRequestProvider = StateProvider<int?>((ref) => null);

/// État du personnage lu une seule fois à l'ouverture de l'assistant : il ne
/// doit pas bouger pendant que le joueur fait ses choix.
final levelUpStateProvider = FutureProvider.autoDispose
    .family<LevelUpState?, int>((ref, characterId) {
      return CharacterService(
        ref.watch(databaseProvider),
      ).loadLevelUpState(characterId);
    });

/// Choix du joueur dans l'assistant de montée de niveau.
class LevelUpFlow {
  final String? classId;
  final LevelUpChoices choices;

  const LevelUpFlow({this.classId, this.choices = const LevelUpChoices()});
}

class LevelUpFlowNotifier extends AutoDisposeFamilyNotifier<LevelUpFlow, int> {
  @override
  LevelUpFlow build(int arg) => const LevelUpFlow();

  LevelUpChoices get _choices => state.choices;

  void _set(LevelUpChoices choices) =>
      state = LevelUpFlow(classId: state.classId, choices: choices);

  /// Changer de classe repart de choix vierges : ils dépendent de la classe.
  void selectClass(String? classId) => state = LevelUpFlow(classId: classId);

  void setHpRoll(int? roll) => _set(
    roll == null
        ? _choices.copyWith(clearHpRoll: true)
        : _choices.copyWith(hpRoll: roll),
  );

  void setSubclass(String? subclassId) => _set(
    subclassId == null
        ? _choices.copyWith(clearSubclass: true)
        : _choices.copyWith(subclassId: subclassId),
  );

  void adjustAbility(LevelUpPlan plan, String key, int delta) {
    final next = {..._choices.abilityIncreases};
    final current = next[key] ?? 0;
    if (delta > 0) {
      if (!plan.canIncrease(next, key)) return;
      next[key] = current + 1;
    } else if (current > 0) {
      if (current == 1) {
        next.remove(key);
      } else {
        next[key] = current - 1;
      }
    }
    _set(_choices.copyWith(abilityIncreases: next, clearFeat: true));
  }

  void clearAbilityIncreases() =>
      _set(_choices.copyWith(abilityIncreases: const {}));

  /// Choisir un don annule l'amélioration de caractéristiques.
  void setFeat(String? featId) => _set(
    featId == null
        ? _choices.copyWith(clearFeat: true)
        : _choices.copyWith(featId: featId, abilityIncreases: const {}),
  );

  void toggleSkill(String skill, {required int max}) {
    final skills = [..._choices.skillChoices];
    if (skills.contains(skill)) {
      skills.remove(skill);
    } else {
      if (skills.length >= max) skills.removeAt(0);
      skills.add(skill);
    }
    _set(_choices.copyWith(skillChoices: skills));
  }

  void toggleInstrument(String instrument, {required int max}) {
    final instruments = [..._choices.instrumentChoices];
    if (instruments.contains(instrument)) {
      instruments.remove(instrument);
    } else {
      if (instruments.length >= max) instruments.removeAt(0);
      instruments.add(instrument);
    }
    _set(_choices.copyWith(instrumentChoices: instruments));
  }

  void setOverridePrerequisite(bool value) =>
      _set(_choices.copyWith(overrideMulticlassPrerequisite: value));
}

final levelUpFlowProvider = NotifierProvider.autoDispose
    .family<LevelUpFlowNotifier, LevelUpFlow, int>(LevelUpFlowNotifier.new);

/// Plan de la classe sélectionnée (null tant qu'aucune classe n'est choisie).
final levelUpPlanProvider = FutureProvider.autoDispose
    .family<LevelUpPlan?, int>((ref, characterId) async {
      final state = await ref.watch(levelUpStateProvider(characterId).future);
      final classId = ref.watch(
        levelUpFlowProvider(characterId).select((f) => f.classId),
      );
      if (state == null || classId == null) return null;
      final subclasses = await ref.watch(
        srdSubclassesProvider((
          classId: classId,
          ruleset: state.ruleset,
        )).future,
      );
      return LevelUpPlan.build(
        state: state,
        classId: classId,
        hasSubclassOptions: subclasses.isNotEmpty,
      );
    });
