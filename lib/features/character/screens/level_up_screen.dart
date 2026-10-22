import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/database_provider.dart';
import '../../../core/utils/app_errors.dart';
import '../../../core/utils/character_service.dart';
import '../../../core/utils/level_up_plan.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/character_features_provider.dart';
import '../providers/character_providers.dart';
import '../providers/level_up_provider.dart';
import '../widgets/level_up/level_up_choice_steps.dart';
import '../widgets/level_up/level_up_class_step.dart';
import '../widgets/level_up/level_up_improvement_step.dart';
import '../widgets/level_up/level_up_summary.dart';

enum _Step { classChoice, hp, subclass, improvement, spells, summary }

/// Assistant de montée de niveau : classe, PV, sous-classe, caractéristiques ou
/// don, sorts, résumé. Rien n'est écrit avant la validation finale, puis tout
/// est appliqué en une seule opération (`CharacterService.levelUp`).
class LevelUpScreen extends ConsumerStatefulWidget {
  final int characterId;
  const LevelUpScreen({super.key, required this.characterId});

  @override
  ConsumerState<LevelUpScreen> createState() => _LevelUpScreenState();
}

class _LevelUpScreenState extends ConsumerState<LevelUpScreen> {
  _Step _step = _Step.classChoice;
  bool _applying = false;
  List<LevelUpChange>? _appliedChanges;

  int get _id => widget.characterId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stateAsync = ref.watch(levelUpStateProvider(_id));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.levelUp),
        automaticallyImplyLeading: _appliedChanges == null,
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => AsyncErrorView(
          error: e,
          stackTrace: st,
          onRetry: () => ref.invalidate(levelUpStateProvider(_id)),
        ),
        data: (state) {
          if (state == null) {
            return Center(child: Text(l10n.levelUpCharacterNotFound));
          }
          if (_appliedChanges != null) {
            return _buildResult(l10n, _appliedChanges!);
          }
          return _buildWizard(l10n, state);
        },
      ),
    );
  }

  // ── Assistant ─────────────────────────────────────────────────────────────

  Widget _buildWizard(AppLocalizations l10n, LevelUpState state) {
    final plan = ref.watch(levelUpPlanProvider(_id)).valueOrNull;
    final choices = ref.watch(levelUpFlowProvider(_id)).choices;
    final feats =
        ref.watch(srdFeatsProvider(state.ruleset)).valueOrNull ?? const [];
    final outcome = plan?.outcome(choices);
    if (plan != null) {
      // Chargés d'avance pour que l'aperçu et le résumé disposent des noms.
      ref.watch(
        srdSubclassesProvider((classId: plan.classId, ruleset: state.ruleset)),
      );
      ref.watch(levelUpFeaturesProvider(state.ruleset));
    }
    final issues = plan?.validate(choices, feats: feats) ?? const [];

    final steps = _visibleSteps(plan, outcome);
    final current = steps.contains(_step) ? _step : _Step.classChoice;
    final index = steps.indexOf(current);
    final isLast = current == _Step.summary;

    return Column(
      children: [
        LinearProgressIndicator(value: (index + 1) / steps.length),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _title(l10n, current),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(l10n.levelUpStepCounter(index + 1, steps.length)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _stepBody(l10n, state, plan, outcome, current),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                if (index > 0)
                  OutlinedButton(
                    onPressed: _applying
                        ? null
                        : () => setState(() => _step = steps[index - 1]),
                    child: Text(l10n.wizardPrevious),
                  ),
                const Spacer(),
                if (_applying)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (isLast)
                  FilledButton.icon(
                    icon: const Icon(Icons.arrow_upward),
                    label: Text(l10n.levelUp),
                    onPressed: plan != null && outcome != null && issues.isEmpty
                        ? () => _apply(l10n, state, plan)
                        : null,
                  )
                else
                  FilledButton(
                    onPressed: plan != null && _isValid(current, issues)
                        ? () => setState(() => _step = steps[index + 1])
                        : null,
                    child: Text(l10n.wizardNext),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Étapes utiles pour la classe choisie ; les autres sont masquées.
  List<_Step> _visibleSteps(LevelUpPlan? plan, LevelUpOutcome? outcome) {
    if (plan == null || outcome == null) return const [_Step.classChoice];
    return [
      _Step.classChoice,
      _Step.hp,
      if (plan.needsSubclass) _Step.subclass,
      if (plan.improvement != LevelUpImprovementKind.none) _Step.improvement,
      if (!outcome.spells.isEmpty || outcome.preparedSpellsMax != null)
        _Step.spells,
      _Step.summary,
    ];
  }

  bool _isValid(_Step step, List<LevelUpIssue> issues) {
    bool blocked(Set<LevelUpIssue> any) => issues.any(any.contains);
    return switch (step) {
      _Step.classChoice => !blocked({
        LevelUpIssue.maxLevel,
        LevelUpIssue.skillChoiceMissing,
        LevelUpIssue.instrumentChoiceMissing,
        LevelUpIssue.multiclassPrerequisite,
      }),
      _Step.subclass => !blocked({LevelUpIssue.subclassMissing}),
      _Step.improvement => !blocked({
        LevelUpIssue.improvementMissing,
        LevelUpIssue.improvementInvalid,
        LevelUpIssue.featNotEligible,
      }),
      _Step.hp || _Step.spells || _Step.summary => true,
    };
  }

  String _title(AppLocalizations l10n, _Step step) => switch (step) {
    _Step.classChoice => l10n.levelUpStepClass,
    _Step.hp => l10n.levelUpStepHp,
    _Step.subclass => l10n.levelUpStepSubclass,
    _Step.improvement => l10n.levelUpStepImprovement,
    _Step.spells => l10n.levelUpStepSpells,
    _Step.summary => l10n.levelUpStepSummary,
  };

  Widget _stepBody(
    AppLocalizations l10n,
    LevelUpState state,
    LevelUpPlan? plan,
    LevelUpOutcome? outcome,
    _Step step,
  ) {
    if (step == _Step.classChoice || plan == null || outcome == null) {
      return LevelUpClassStep(characterId: _id, state: state, plan: plan);
    }
    return switch (step) {
      _Step.hp => LevelUpHpStep(characterId: _id, plan: plan),
      _Step.subclass => LevelUpSubclassStep(characterId: _id, plan: plan),
      _Step.improvement => LevelUpImprovementStep(
        key: ValueKey(plan.classId),
        characterId: _id,
        plan: plan,
      ),
      _Step.spells => LevelUpSpellsStep(plan: plan, outcome: outcome),
      _ => _buildPreview(l10n, plan, outcome),
    };
  }

  Widget _buildPreview(
    AppLocalizations l10n,
    LevelUpPlan plan,
    LevelUpOutcome outcome,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.levelUpSummaryPreview,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Card(child: LevelUpChangesList(changes: _changes(l10n, plan, outcome))),
      ],
    );
  }

  List<LevelUpChange> _changes(
    AppLocalizations l10n,
    LevelUpPlan plan,
    LevelUpOutcome outcome, {
    int? armorClassBefore,
    int? armorClassAfter,
  }) {
    final ruleset = plan.state.ruleset;
    final subclasses = ref
        .read(srdSubclassesProvider((classId: plan.classId, ruleset: ruleset)))
        .valueOrNull;
    final feats = ref.read(srdFeatsProvider(ruleset)).valueOrNull;
    final features = ref.read(levelUpFeaturesProvider(ruleset)).valueOrNull;

    return buildLevelUpChanges(
      outcome: outcome,
      l10n: l10n,
      className: CharacterService.classDisplayName(plan.classId, l10n),
      subclassName: subclasses
          ?.where((s) => s.id == outcome.subclassId)
          .firstOrNull
          ?.name,
      featName: feats?.where((f) => f.id == outcome.featId).firstOrNull?.name,
      featureNames: features == null
          ? const []
          : plan
                .gainedFeatures(features, subclassId: outcome.subclassId)
                .map((f) => f.name)
                .toList(),
      armorClassBefore: armorClassBefore,
      armorClassAfter: armorClassAfter,
    );
  }

  // ── Application ───────────────────────────────────────────────────────────

  Future<void> _apply(
    AppLocalizations l10n,
    LevelUpState state,
    LevelUpPlan plan,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _applying = true);
    try {
      final result = await CharacterService(ref.read(databaseProvider)).levelUp(
        characterId: _id,
        classId: plan.classId,
        choices: ref.read(levelUpFlowProvider(_id)).choices,
        feats:
            ref.read(srdFeatsProvider(state.ruleset)).valueOrNull ?? const [],
        hasSubclassOptions: plan.hasSubclassOptions,
      );
      final changes = _changes(
        l10n,
        plan,
        result.outcome,
        armorClassBefore: result.armorClassBefore,
        armorClassAfter: result.armorClassAfter,
      );
      _refreshCharacterData();
      if (!mounted) return;
      setState(() {
        _applying = false;
        _appliedChanges = changes;
      });
    } catch (e, st) {
      AppErrors.log(e, st, context: 'levelUp');
      if (!mounted) return;
      setState(() => _applying = false);
      final conflict =
          (e is PostgrestException && e.code == 'P0001') ||
          e is LevelUpException;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            conflict
                ? l10n.levelUpConflict
                : l10n.levelUpNotApplied(AppErrors.userMessage(e, l10n)),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _refreshCharacterData() {
    ref.invalidate(characterByIdProvider(_id));
    ref.invalidate(characterClassesProvider(_id));
    ref.invalidate(characterAbilityScoresProvider(_id));
    ref.invalidate(characterProficienciesProvider(_id));
    ref.invalidate(characterFeatsProvider(_id));
    ref.invalidate(characterFeatDetailsProvider(_id));
    ref.invalidate(characterFeaturesProvider(_id));
    ref.invalidate(characterResourcesProvider(_id));
    ref.invalidate(characterSpellSlotsProvider(_id));
  }

  // ── Résumé final ──────────────────────────────────────────────────────────

  Widget _buildResult(AppLocalizations l10n, List<LevelUpChange> changes) {
    final hasSpellLink = changes.any(
      (c) => c.destination == LevelUpDestination.spells,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.levelUpSummaryDone,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: LevelUpChangesList(changes: changes, onOpen: _open),
          ),
          const SizedBox(height: 16),
          if (hasSpellLink)
            OutlinedButton.icon(
              icon: const Icon(Icons.menu_book_outlined),
              label: Text(l10n.levelUpOpenSpells),
              onPressed: () => _open(LevelUpDestination.spells),
            ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.levelUpFinish),
          ),
        ],
      ),
    );
  }

  void _open(LevelUpDestination destination) {
    final navigator = Navigator.of(context);
    if (destination == LevelUpDestination.spells) {
      navigator.pushNamed('/spells', arguments: _id);
      return;
    }
    // Indices de la barre d'onglets mobile de la fiche.
    final tab = switch (destination) {
      LevelUpDestination.stats => 0,
      LevelUpDestination.combat => 1,
      LevelUpDestination.magic => 2,
      LevelUpDestination.profile => 4,
      _ => null,
    };
    if (tab != null) ref.read(sheetTabRequestProvider.notifier).state = tab;
    navigator.pop();
  }
}
