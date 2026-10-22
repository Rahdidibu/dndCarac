import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/character_service.dart';
import '../../../../core/utils/class_progression.dart';
import '../../../../core/utils/level_up_plan.dart';
import '../../../../core/utils/skills_catalog.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/level_up_provider.dart';
import 'level_up_summary.dart';

/// Étape 1 : classe à faire progresser, prérequis et maîtrises de multiclassage.
class LevelUpClassStep extends ConsumerStatefulWidget {
  final int characterId;
  final LevelUpState state;
  final LevelUpPlan? plan;

  const LevelUpClassStep({
    super.key,
    required this.characterId,
    required this.state,
    required this.plan,
  });

  @override
  ConsumerState<LevelUpClassStep> createState() => _LevelUpClassStepState();
}

class _LevelUpClassStepState extends ConsumerState<LevelUpClassStep> {
  late bool _newClassMode = widget.plan?.isNewClass ?? false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final flow = ref.watch(levelUpFlowProvider(widget.characterId));
    final notifier = ref.read(levelUpFlowProvider(widget.characterId).notifier);
    final plan = widget.plan;
    final state = widget.state;
    final totalLevel = state.totalLevel;

    if (totalLevel >= 20) {
      return Text(l10n.levelUpMaxLevel, style: textTheme.titleMedium);
    }

    final existingIds = state.classes.map((c) => c.classId).toSet();
    final newIds = ClassProgression.classIds
        .where((id) => !existingIds.contains(id))
        .toList();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LevelBadge(l10n.levelUpLevelCurrentLabel, '$totalLevel'),
                const Icon(Icons.arrow_forward, size: 28),
                _LevelBadge(
                  l10n.levelUpLevelNewLabel,
                  '${totalLevel + 1}',
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(l10n.levelUpChooseClass, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        if (newIds.isNotEmpty && state.classes.isNotEmpty)
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                label: Text(l10n.levelUpExistingClass),
              ),
              ButtonSegment(value: true, label: Text(l10n.levelUpNewClass)),
            ],
            selected: {_newClassMode},
            onSelectionChanged: (s) {
              setState(() => _newClassMode = s.first);
              notifier.selectClass(null);
            },
          ),
        const SizedBox(height: 12),
        if (!_newClassMode)
          for (final c in state.classes)
            Card(
              color: flow.classId == c.classId
                  ? colorScheme.secondaryContainer
                  : null,
              child: ListTile(
                leading: Icon(CharacterService.getClassIcon(c.classId)),
                title: Text(CharacterService.classDisplayName(c.classId, l10n)),
                subtitle: Text(l10n.levelUpClassLevel(c.level)),
                trailing: Icon(
                  flow.classId == c.classId
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: flow.classId == c.classId ? colorScheme.primary : null,
                ),
                onTap: () => notifier.selectClass(c.classId),
              ),
            )
        else
          DropdownButtonFormField<String>(
            key: ValueKey(flow.classId),
            decoration: InputDecoration(
              labelText: l10n.levelUpChooseNewClass,
              border: const OutlineInputBorder(),
            ),
            initialValue: flow.classId,
            items: [
              for (final id in newIds)
                DropdownMenuItem(
                  value: id,
                  child: Text(CharacterService.classDisplayName(id, l10n)),
                ),
            ],
            onChanged: notifier.selectClass,
          ),
        if (plan != null && plan.isNewClass && state.classes.isNotEmpty) ...[
          if (plan.unmetPrerequisites.isNotEmpty)
            _PrerequisiteWarning(
              plan: plan,
              overridden: flow.choices.overrideMulticlassPrerequisite,
              onOverride: notifier.setOverridePrerequisite,
            ),
          if (plan.multiclassProficiencies.isNotEmpty ||
              plan.skillChoice != null ||
              plan.instrumentChoice != null)
            _MulticlassProficiencies(
              plan: plan,
              selectedSkills: flow.choices.skillChoices,
              onToggleSkill: (skill) =>
                  notifier.toggleSkill(skill, max: plan.skillChoice!.count),
              selectedInstruments: flow.choices.instrumentChoices,
              onToggleInstrument: (instrument) => notifier.toggleInstrument(
                instrument,
                max: plan.instrumentChoice!.count,
              ),
            ),
        ],
      ],
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _LevelBadge(this.label, this.value, {this.color});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(label, style: const TextStyle(fontSize: 12)),
      Text(
        value,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}

class _PrerequisiteWarning extends StatelessWidget {
  final LevelUpPlan plan;
  final bool overridden;
  final ValueChanged<bool> onOverride;

  const _PrerequisiteWarning({
    required this.plan,
    required this.overridden,
    required this.onOverride,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String ability(String key) => SkillsCatalog.abilityName(key, l10n);

    return Card(
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppTheme.crimsonRed),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber, color: AppTheme.crimsonRed),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.levelUpPrereqTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final u in plan.unmetPrerequisites)
              Text(
                u.anyOf
                    ? l10n.levelUpPrereqAny(
                        CharacterService.classDisplayName(u.classId, l10n),
                        u.abilities.map(ability).join(' / '),
                        u.minimum,
                      )
                    : l10n.levelUpPrereqAll(
                        CharacterService.classDisplayName(u.classId, l10n),
                        ability(u.abilities.first),
                        u.minimum,
                      ),
              ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: overridden,
              title: Text(l10n.levelUpPrereqOverride),
              onChanged: (v) => onOverride(v ?? false),
            ),
          ],
        ),
      ),
    );
  }
}

class _MulticlassProficiencies extends StatelessWidget {
  final LevelUpPlan plan;
  final List<String> selectedSkills;
  final ValueChanged<String> onToggleSkill;
  final List<String> selectedInstruments;
  final ValueChanged<String> onToggleInstrument;

  const _MulticlassProficiencies({
    required this.plan,
    required this.selectedSkills,
    required this.onToggleSkill,
    required this.selectedInstruments,
    required this.onToggleInstrument,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final skill = plan.skillChoice;
    final instrument = plan.instrumentChoice;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.levelUpProficienciesGained,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final key in plan.multiclassProficiencies)
                Chip(label: Text(levelUpProficiencyLabel(key, l10n))),
            ],
          ),
          if (skill != null) ...[
            const SizedBox(height: 12),
            Text(
              l10n.levelUpSkillChoice,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final key in skill.options)
                  FilterChip(
                    label: Text(levelUpProficiencyLabel('skill_$key', l10n)),
                    selected: selectedSkills.contains(key),
                    onSelected: (_) => onToggleSkill(key),
                  ),
              ],
            ),
          ],
          if (instrument != null) ...[
            const SizedBox(height: 12),
            Text(
              l10n.levelUpInstrumentChoice,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final key in instrument.options)
                  FilterChip(
                    label: Text(levelUpProficiencyLabel('tool_$key', l10n)),
                    selected: selectedInstruments.contains(key),
                    onSelected: (_) => onToggleInstrument(key),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
