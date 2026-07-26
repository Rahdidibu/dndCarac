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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
  Map<String, List<int>> _rolls = {};
  bool _isRolling = false;

  @override
  void initState() {
    super.initState();
    _rolls = {for (final k in DndRules.abilityKeys) k: []};
  }

  void _rollForAbility(String key) {
    final rand = Random();
    final dice = List.generate(4, (_) => rand.nextInt(6) + 1);
    dice.sort();
    final sum = dice[1] + dice[2] + dice[3];
    setState(() {
      _rolls[key] = dice;
    });
    widget.notifier.setAbilityScore(key, sum);
  }

  void _rollAll() {
    setState(() => _isRolling = true);
    final rand = Random();
    final newScores = <String, int>{};
    final newRolls = <String, List<int>>{};

    for (final k in DndRules.abilityKeys) {
      final dice = List.generate(4, (_) => rand.nextInt(6) + 1);
      dice.sort();
      final sum = dice[1] + dice[2] + dice[3];
      newRolls[k] = dice;
      newScores[k] = sum;
    }

    setState(() {
      _rolls = newRolls;
      _isRolling = false;
    });
    for (final entry in newScores.entries) {
      widget.notifier.setAbilityScore(entry.key, entry.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            icon: const Icon(Icons.casino),
            label: const Text('Tout relancer (4d6 drop lowest)'),
            onPressed: _isRolling ? null : _rollAll,
          ),
        ),
        const SizedBox(height: 16),
        ...DndRules.abilityKeys.map((key) {
          final score = widget.wizard.abilityScores[key] ?? 10;
          final dice = _rolls[key] ?? [];
          final String rollsText = dice.isNotEmpty
              ? '${dice[0]} (rejeté), ${dice[1]}, ${dice[2]}, ${dice[3]}'
              : '';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _abilityLabel(key, l10n),
                          style: const TextStyle(
                            fontFamily: 'Cinzel',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (rollsText.isNotEmpty)
                          Text(
                            'Dés: $rollsText',
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    tooltip: 'Relancer',
                    onPressed: () => _rollForAbility(key),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      border: Border.all(color: colorScheme.outline.withValues(alpha: 0.15)),
                    ),
                    child: Text(
                      '$score',
                      style: const TextStyle(
                        fontFamily: 'Cinzel',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (final key in DndRules.abilityKeys) {
      _controllers[key] = TextEditingController(
        text: '${widget.wizard.abilityScores[key] ?? 10}',
      );
    }
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
              isDense: true,
              helperText: modifierVal > 0
                  ? 'Bonus background : +$modifierVal → Total: $finalScore (Mod: ${_modStr(finalScore)})'
                  : 'Mod: ${_modStr(baseVal)}',
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
    final colorScheme = Theme.of(context).colorScheme;
    final modifiersAsync = ref.watch(wizardAbilityModifiersProvider);
    final int modifierVal = modifiersAsync.maybeWhen(
      data: (map) => map[abilityKey] ?? 0,
      orElse: () => 0,
    );
    final finalScore = score + modifierVal;
    final mod = DndRules.modifier(finalScore);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: modifierVal > 0 ? colorScheme.primary.withValues(alpha: 0.4) : colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Ability details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        _abilityLabel(abilityKey, l10n),
                        style: const TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (modifierVal > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.4),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            '+$modifierVal',
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Mod : ${mod >= 0 ? '+' : ''}$mod${modifierVal > 0 ? ' (Base: $score)' : ''}',
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 11.5,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Controls
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: onDecrement != null ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.2),
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: onDecrement,
                ),
                const SizedBox(width: 2),
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: modifierVal > 0 
                        ? colorScheme.primary.withValues(alpha: 0.15)
                        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    border: Border.all(
                      color: modifierVal > 0 ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '$finalScore',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: modifierVal > 0 ? colorScheme.primary : colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: onIncrement != null ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.2),
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: onIncrement,
                ),
              ],
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
