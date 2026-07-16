import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/dnd_rules.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/wizard_provider.dart';
import '../../providers/character_providers.dart';

class Step5Abilities extends ConsumerWidget {
  const Step5Abilities({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final wizard = ref.watch(wizardProvider);
    final notifier = ref.read(wizardProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.wizardStepAbilities,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),

        // Method selector
        SegmentedButton<AbilityScoreMethod>(
          segments: [
            ButtonSegment(
              value: AbilityScoreMethod.pointBuy,
              label: Text(l10n.abilityMethodPointBuy),
              icon: const Icon(Icons.calculate_outlined),
            ),
            ButtonSegment(
              value: AbilityScoreMethod.roll,
              label: Text(l10n.abilityMethodRoll),
              icon: const Icon(Icons.casino_outlined),
            ),
            ButtonSegment(
              value: AbilityScoreMethod.manual,
              label: Text(l10n.abilityMethodManual),
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
          selected: {wizard.abilityMethod},
          onSelectionChanged: (selection) =>
              notifier.setAbilityMethod(selection.first),
        ),

        const SizedBox(height: 24),

        if (wizard.abilityMethod == AbilityScoreMethod.pointBuy)
          _PointBuySection(wizard: wizard, notifier: notifier, l10n: l10n),

        if (wizard.abilityMethod == AbilityScoreMethod.roll)
          _RollSection(wizard: wizard, notifier: notifier),

        if (wizard.abilityMethod == AbilityScoreMethod.manual)
          _ManualSection(wizard: wizard, notifier: notifier),
      ],
    );
  }
}

// ── Point Buy ────────────────────────────────────────────────────────────────

class _PointBuySection extends StatelessWidget {
  final WizardState wizard;
  final WizardNotifier notifier;
  final AppLocalizations l10n;

  const _PointBuySection(
      {required this.wizard, required this.notifier, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final remaining = wizard.pointBuyRemaining;

    return Column(
      children: [
        Card(
          color: remaining == 0
              ? Theme.of(context).colorScheme.primaryContainer
              : remaining < 0
                  ? Theme.of(context).colorScheme.errorContainer
                  : null,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              l10n.abilityPointsRemaining(remaining),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...DndRules.abilityKeys.map((key) {
          final score = wizard.abilityScores[key] ?? 8;
          return _AbilityRow(
            abilityKey: key,
            score: score,
            min: DndRules.pointBuyMin,
            max: DndRules.pointBuyMax,
            l10n: l10n,
            onDecrement: score > DndRules.pointBuyMin
                ? () => notifier.setAbilityScore(key, score - 1)
                : null,
            onIncrement: score < DndRules.pointBuyMax &&
                    wizard.pointBuyRemaining >=
                        (DndRules.pointBuyCost[score + 1]! -
                            DndRules.pointBuyCost[score]!)
                ? () => notifier.setAbilityScore(key, score + 1)
                : null,
          );
        }),
      ],
    );
  }
}

// ── Roll ─────────────────────────────────────────────────────────────────────

class _RollSection extends ConsumerStatefulWidget {
  final WizardState wizard;
  final WizardNotifier notifier;

  const _RollSection({required this.wizard, required this.notifier});

  @override
  ConsumerState<_RollSection> createState() => _RollSectionState();
}

class _RollSectionState extends ConsumerState<_RollSection> {
  // Store roll results per ability key
  Map<String, List<int>> _rolls = {};

  @override
  void initState() {
    super.initState();
    _rolls = {for (final k in DndRules.abilityKeys) k: []};
  }

  void _rollForAbility(String key) {
    final rand = Random();
    final dice = List.generate(4, (_) => rand.nextInt(6) + 1);
    dice.sort();
    final result = dice.sublist(1); // drop lowest
    final total = result.fold(0, (s, d) => s + d);
    setState(() => _rolls[key] = dice);
    widget.notifier.setAbilityScore(key, total.clamp(3, 18));
  }

  void _rollAll() {
    for (final key in DndRules.abilityKeys) {
      _rollForAbility(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    final modifiersAsync = ref.watch(wizardAbilityModifiersProvider);
    final Map<String, int> modifiers = modifiersAsync.maybeWhen(
      data: (map) => map,
      orElse: () => <String, int>{},
    );

    return Column(
      children: [
        FilledButton.icon(
          onPressed: _rollAll,
          icon: const Icon(Icons.casino),
          label: const Text('Tout relancer (4d6 drop lowest)'),
        ),
        const SizedBox(height: 16),
        ...DndRules.abilityKeys.map((key) {
          final score = widget.wizard.abilityScores[key] ?? 8;
          final diceResults = _rolls[key] ?? [];
          final l10n = AppLocalizations.of(context)!;
          final modifierVal = modifiers[key] ?? 0;
          final finalScore = score + modifierVal;
          final mod = DndRules.modifier(finalScore);

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _abilityLabel(key, l10n),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (diceResults.isNotEmpty)
                          Text(
                            'Mod final : ${mod >= 0 ? '+' : ''}$mod',
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (diceResults.isNotEmpty)
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        children: diceResults.asMap().entries.map((e) {
                          // First die (index 0 after sort = lowest) is dropped
                          final isDropped = e.key == 0;
                          return Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isDropped
                                  ? Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest
                                  : Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                '${e.value}',
                                style: TextStyle(
                                  color: isDropped
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.4)
                                      : Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  decoration: isDropped
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  else
                    const Expanded(
                        child: Text('—', style: TextStyle(fontSize: 18))),
                  const SizedBox(width: 8),
                  if (modifierVal > 0 && diceResults.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Chip(
                        label: Text('+$modifierVal'),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  SizedBox(
                    width: 48,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          diceResults.isEmpty ? '—' : '$finalScore',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: modifierVal > 0 && diceResults.isNotEmpty
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        if (modifierVal > 0 && diceResults.isNotEmpty)
                          Text(
                            'Base : $score',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => _rollForAbility(key),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ── Manual ───────────────────────────────────────────────────────────────────

class _ManualSection extends ConsumerStatefulWidget {
  final WizardState wizard;
  final WizardNotifier notifier;

  const _ManualSection({required this.wizard, required this.notifier});

  @override
  ConsumerState<_ManualSection> createState() => _ManualSectionState();
}

class _ManualSectionState extends ConsumerState<_ManualSection> {
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final k in DndRules.abilityKeys)
        k: TextEditingController(
          text: '${widget.wizard.abilityScores[k] ?? 10}',
        ),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modifiersAsync = ref.watch(wizardAbilityModifiersProvider);
    final Map<String, int> modifiers = modifiersAsync.maybeWhen(
      data: (map) => map,
      orElse: () => <String, int>{},
    );

    return Column(
      children: DndRules.abilityKeys.map((key) {
        final baseVal = widget.wizard.abilityScores[key] ?? 10;
        final modifierVal = modifiers[key] ?? 0;
        final finalScore = baseVal + modifierVal;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: _controllers[key],
            decoration: InputDecoration(
              labelText: _abilityLabel(key, l10n),
              border: const OutlineInputBorder(),
              suffixText: modifierVal > 0 
                  ? 'Final: $finalScore (Mod: ${_modStr(finalScore)}, Base: $baseVal)' 
                  : 'Mod: ${_modStr(baseVal)}',
              helperText: modifierVal > 0 ? 'Bonus actif : +$modifierVal' : null,
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              final parsed = int.tryParse(v);
              if (parsed != null && parsed >= 1 && parsed <= 30) {
                widget.notifier.setAbilityScore(key, parsed);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _AbilityRow extends ConsumerWidget {
  final String abilityKey;
  final int score;
  final int min;
  final int max;
  final AppLocalizations l10n;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const _AbilityRow({
    required this.abilityKey,
    required this.score,
    required this.min,
    required this.max,
    required this.l10n,
    this.onDecrement,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modifiersAsync = ref.watch(wizardAbilityModifiersProvider);
    final int modifierVal = modifiersAsync.maybeWhen(
      data: (map) => map[abilityKey] ?? 0,
      orElse: () => 0,
    );
    final finalScore = score + modifierVal;
    final mod = DndRules.modifier(finalScore);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 125,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _abilityLabel(abilityKey, l10n),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Mod final : ${mod >= 0 ? '+' : ''}$mod',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                        ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (modifierVal > 0)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text('+$modifierVal'),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                ),
              ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: onDecrement,
            ),
            SizedBox(
              width: 48,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$finalScore',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: modifierVal > 0 ? Theme.of(context).colorScheme.primary : null,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  if (modifierVal > 0)
                    Text(
                      'Base : $score',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: onIncrement,
            ),
          ],
        ),
      ),
    );
  }
}

String _abilityLabel(String key, AppLocalizations l10n) {
  final labels = {
    'str': l10n.abilityStr,
    'dex': l10n.abilityDex,
    'con': l10n.abilityCon,
    'int': l10n.abilityInt,
    'wis': l10n.abilityWis,
    'cha': l10n.abilityCha,
  };
  return labels[key] ?? key;
}

String _modStr(int score) {
  final mod = DndRules.modifier(score);
  return '${mod >= 0 ? '+' : ''}$mod';
}
