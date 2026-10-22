import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/dnd_rules.dart';
import '../../../../core/utils/level_up_plan.dart';
import '../../../../core/utils/markdown_text.dart';
import '../../../../core/utils/skills_catalog.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/character_providers.dart';
import '../../providers/level_up_provider.dart';

/// Étape caractéristiques / don : +2 ou +1/+1 (plafond 20), don général ou
/// épique, ou augmentation automatique (Champion primitif).
class LevelUpImprovementStep extends ConsumerStatefulWidget {
  final int characterId;
  final LevelUpPlan plan;

  const LevelUpImprovementStep({
    super.key,
    required this.characterId,
    required this.plan,
  });

  @override
  ConsumerState<LevelUpImprovementStep> createState() =>
      _LevelUpImprovementStepState();
}

class _LevelUpImprovementStepState
    extends ConsumerState<LevelUpImprovementStep> {
  late bool _featMode =
      ref.read(levelUpFlowProvider(widget.characterId)).choices.featId != null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final plan = widget.plan;
    final choices = ref.watch(levelUpFlowProvider(widget.characterId)).choices;
    final notifier = ref.read(levelUpFlowProvider(widget.characterId).notifier);
    final textTheme = Theme.of(context).textTheme;

    if (plan.improvement == LevelUpImprovementKind.fixed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.levelUpFixedHint, style: textTheme.titleMedium),
          const SizedBox(height: 12),
          for (final e in plan.fixedIncreases.entries)
            _AbilityRow(
              label: SkillsCatalog.abilityName(e.key, l10n),
              score: plan.state.scores[e.key] ?? 10,
              increase: e.value,
            ),
        ],
      );
    }

    final feats = ref
        .watch(srdFeatsProvider(plan.state.ruleset))
        .maybeWhen(
          data: (all) =>
              plan.eligibleFeats(all, subclassId: choices.subclassId),
          orElse: () => const [],
        );
    final epicBoon = plan.improvement == LevelUpImprovementKind.epicBoon;
    final noRoom = plan.maxAbilityIncreaseTotal(plan.state.scores) == 0;
    final showFeats = epicBoon || _featMode || noRoom;
    final canChoose = feats.isNotEmpty && !epicBoon && !noRoom;

    final total = choices.abilityIncreases.values.fold(0, (a, b) => a + b);
    final remaining = plan.maxAbilityIncreaseTotal(plan.state.scores) - total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.levelUpAsiOrFeat, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        if (epicBoon) Text(l10n.levelUpEpicBoonHint),
        if (canChoose)
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                icon: const Icon(Icons.trending_up),
                label: Text(l10n.levelUpImprovementModeAsi),
              ),
              ButtonSegment(
                value: true,
                icon: const Icon(Icons.military_tech_outlined),
                label: Text(l10n.levelUpImprovementModeFeat),
              ),
            ],
            selected: {_featMode},
            onSelectionChanged: (s) {
              setState(() => _featMode = s.first);
              if (s.first) {
                notifier.clearAbilityIncreases();
              } else {
                notifier.setFeat(null);
              }
            },
          ),
        const SizedBox(height: 12),
        if (!showFeats) ...[
          Text(
            l10n.levelUpImprovementHint(plan.abilityCap),
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          for (final key in DndRules.abilityKeys)
            _AbilityRow(
              label: SkillsCatalog.abilityName(key, l10n),
              score: plan.state.scores[key] ?? 10,
              increase: choices.abilityIncreases[key] ?? 0,
              editable: true,
              onDecrease: (choices.abilityIncreases[key] ?? 0) > 0
                  ? () => notifier.adjustAbility(plan, key, -1)
                  : null,
              onIncrease: plan.canIncrease(choices.abilityIncreases, key)
                  ? () => notifier.adjustAbility(plan, key, 1)
                  : null,
            ),
          const SizedBox(height: 8),
          Text(l10n.levelUpImprovementRemaining(remaining)),
        ] else ...[
          if (noRoom && !epicBoon) Text(l10n.levelUpImprovementNoRoom),
          if (feats.isEmpty)
            Text(l10n.profileNoAvailableFeats)
          else
            for (final f in feats)
              Card(
                color: choices.featId == f.id
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : null,
                child: ListTile(
                  title: Text(f.name),
                  subtitle: MarkdownText(
                    text: f.description,
                    maxLines: choices.featId == f.id ? null : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(
                    choices.featId == f.id
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: choices.featId == f.id
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  onTap: () => notifier.setFeat(f.id),
                ),
              ),
        ],
      ],
    );
  }
}

class _AbilityRow extends StatelessWidget {
  final String label;
  final int score;
  final int increase;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  /// Affiche les boutons +/- (désactivés quand l'action est impossible).
  final bool editable;

  const _AbilityRow({
    required this.label,
    required this.score,
    required this.increase,
    this.onDecrease,
    this.onIncrease,
    this.editable = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final after = score + increase;
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text(
          increase == 0
              ? '$score (${_signed(DndRules.modifier(score))})'
              : '$score → $after (${_signed(DndRules.modifier(after))})',
          style: increase == 0
              ? null
              : TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
        ),
        trailing: editable
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: onDecrease,
                  ),
                  SizedBox(
                    width: 24,
                    child: Text(
                      increase > 0 ? '+$increase' : '',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: onIncrease,
                  ),
                ],
              )
            : null,
      ),
    );
  }

  static String _signed(int v) => v >= 0 ? '+$v' : '$v';
}
