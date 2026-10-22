import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/dnd_rules.dart';
import '../../../../core/utils/level_up_plan.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/character_providers.dart';
import '../../providers/level_up_provider.dart';

/// Étape PV : moyenne ou jet du dé de vie.
class LevelUpHpStep extends ConsumerWidget {
  final int characterId;
  final LevelUpPlan plan;

  const LevelUpHpStep({
    super.key,
    required this.characterId,
    required this.plan,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final roll = ref.watch(
      levelUpFlowProvider(characterId).select((f) => f.choices.hpRoll),
    );
    final notifier = ref.read(levelUpFlowProvider(characterId).notifier);
    final conMod = DndRules.modifier(plan.state.scores['con'] ?? 10);
    final modifierText = conMod >= 0 ? '+$conMod' : '$conMod';

    Widget option({
      required bool selected,
      required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
    }) => Card(
      color: selected ? colorScheme.secondaryContainer : null,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(
          selected ? Icons.check_circle : Icons.radio_button_unchecked,
          color: selected ? colorScheme.primary : null,
        ),
        onTap: onTap,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.sheetHp, style: textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(l10n.levelUpHpHitDie(plan.hitDie)),
        const SizedBox(height: 12),
        option(
          selected: roll == null,
          icon: Icons.calculate_outlined,
          title: l10n.levelUpHpAverage,
          subtitle: l10n.levelUpHpAverageValue(plan.hpAverageRoll),
          onTap: () => notifier.setHpRoll(null),
        ),
        option(
          selected: roll != null,
          icon: Icons.casino_outlined,
          title: l10n.levelUpHpRoll,
          subtitle: roll == null
              ? 'd${plan.hitDie}'
              : l10n.levelUpHpRollValue(roll),
          onTap: () => notifier.setHpRoll(Random().nextInt(plan.hitDie) + 1),
        ),
        const SizedBox(height: 8),
        Text(l10n.levelUpHpConNote(modifierText), style: textTheme.bodySmall),
      ],
    );
  }
}

/// Étape sous-classe : choix parmi les sous-classes du compendium.
class LevelUpSubclassStep extends ConsumerWidget {
  final int characterId;
  final LevelUpPlan plan;

  const LevelUpSubclassStep({
    super.key,
    required this.characterId,
    required this.plan,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final selected = ref.watch(
      levelUpFlowProvider(characterId).select((f) => f.choices.subclassId),
    );
    final notifier = ref.read(levelUpFlowProvider(characterId).notifier);
    final subclasses = ref.watch(
      srdSubclassesProvider((
        classId: plan.classId,
        ruleset: plan.state.ruleset,
      )),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.levelUpSubclassPick,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(l10n.levelUpSubclassRequired),
        const SizedBox(height: 12),
        subclasses.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text(l10n.errorGeneric),
          data: (list) => Column(
            children: [
              for (final s in list)
                Card(
                  color: selected == s.id
                      ? colorScheme.secondaryContainer
                      : null,
                  child: ListTile(
                    title: Text(s.name),
                    subtitle: Text(
                      s.description,
                      maxLines: selected == s.id ? null : 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      selected == s.id
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: selected == s.id ? colorScheme.primary : null,
                    ),
                    onTap: () => notifier.setSubclass(s.id),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Étape sorts : compteurs, sans bloquer la montée de niveau.
class LevelUpSpellsStep extends StatelessWidget {
  final LevelUpPlan plan;
  final LevelUpOutcome outcome;

  const LevelUpSpellsStep({
    super.key,
    required this.plan,
    required this.outcome,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lines = <(IconData, String)>[
      if (outcome.spells.cantrips > 0)
        (
          Icons.local_fire_department_outlined,
          l10n.levelUpSpellsCantrips(outcome.spells.cantrips),
        ),
      if (outcome.spells.spells > 0)
        (
          Icons.menu_book_outlined,
          l10n.levelUpSpellsToLearn(outcome.spells.spells),
        ),
      if (outcome.spells.spellbook > 0)
        (
          Icons.import_contacts_outlined,
          l10n.levelUpSpellsSpellbook(outcome.spells.spellbook),
        ),
      if (outcome.preparedSpellsMax != null)
        (
          Icons.checklist,
          l10n.levelUpSpellsPrepared(outcome.preparedSpellsMax!),
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.levelUpStepSpells,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        for (final (icon, text) in lines)
          Card(
            child: ListTile(leading: Icon(icon), title: Text(text)),
          ),
        const SizedBox(height: 8),
        Text(
          l10n.levelUpSpellsNonBlocking,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
