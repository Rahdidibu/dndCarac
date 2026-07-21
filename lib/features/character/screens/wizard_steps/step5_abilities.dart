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
    final result = dice.sublist(1);
    final total = result.fold(0, (s, d) => s + d);
    setState(() => _rolls[key] = dice);
    widget.notifier.setAbilityScore(key, total.clamp(3, 18));
  }

  Future<void> _rollAll() async {
    if (_isRolling) return;
    setState(() => _isRolling = true);

    final rand = Random();
    for (int steps = 0; steps < 8; steps++) {
      final tempRolls = <String, List<int>>{};
      for (final key in DndRules.abilityKeys) {
        final dice = List.generate(4, (_) => rand.nextInt(6) + 1);
        dice.sort();
        tempRolls[key] = dice;
      }
      setState(() => _rolls = tempRolls);
      await Future.delayed(const Duration(milliseconds: 60));
    }

    final finalRolls = <String, List<int>>{};
    for (final key in DndRules.abilityKeys) {
      final dice = List.generate(4, (_) => rand.nextInt(6) + 1);
      dice.sort();
      finalRolls[key] = dice;
      final result = dice.sublist(1);
      final total = result.fold(0, (s, d) => s + d);
      widget.notifier.setAbilityScore(key, total.clamp(3, 18));
    }

    setState(() {
      _rolls = finalRolls;
      _isRolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final modifiersAsync = ref.watch(wizardAbilityModifiersProvider);
    final Map<String, int> modifiers = modifiersAsync.maybeWhen(
      data: (map) => map,
      orElse: () => <String, int>{},
    );
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _isRolling ? null : _rollAll,
          icon: _isRolling 
              ? const SizedBox(
                  width: 18, 
                  height: 18, 
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.casino),
          label: Text(
            _isRolling ? 'Lancement des dés...' : 'Tout relancer (4d6 drop lowest)',
            style: const TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        ...DndRules.abilityKeys.map((key) {
          final score = widget.wizard.abilityScores[key] ?? 8;
          final diceResults = _rolls[key] ?? [];
          final l10n = AppLocalizations.of(context)!;
          final modifierVal = modifiers[key] ?? 0;
          final finalScore = score + modifierVal;
          final mod = DndRules.modifier(finalScore);

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: diceResults.isNotEmpty ? colorScheme.primary.withValues(alpha: 0.15) : colorScheme.outline.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _abilityLabel(key, l10n),
                          style: const TextStyle(fontFamily: 'Cinzel', fontSize: 13.5, fontWeight: FontWeight.bold),
                        ),
                        if (diceResults.isNotEmpty && !_isRolling) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Mod final : ${mod >= 0 ? '+' : ''}$mod',
                            style: TextStyle(
                              fontFamily: 'Lora',
                              fontSize: 11,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (diceResults.isNotEmpty)
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: diceResults.asMap().entries.map((e) {
                          final isDropped = e.key == 0;
                          return Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isDropped
                                  ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                                  : colorScheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isDropped
                                    ? colorScheme.outline.withValues(alpha: 0.1)
                                    : colorScheme.primary.withValues(alpha: 0.4),
                                width: isDropped ? 1 : 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${e.value}',
                                style: TextStyle(
                                  fontFamily: 'Cinzel',
                                  color: isDropped
                                      ? colorScheme.onSurface.withValues(alpha: 0.3)
                                      : colorScheme.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  decoration: isDropped ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  else
                    const Expanded(
                        child: Text('—', style: TextStyle(fontSize: 18, color: Colors.grey))),
                  const SizedBox(width: 8),
                  if (modifierVal > 0 && diceResults.isNotEmpty && !_isRolling)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '+$modifierVal',
                          style: TextStyle(fontFamily: 'Cinzel', fontSize: 11, color: colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: diceResults.isEmpty || _isRolling
                          ? Colors.transparent
                          : colorScheme.primary.withValues(alpha: 0.25),
                      border: Border.all(
                        color: diceResults.isEmpty || _isRolling
                            ? colorScheme.outline.withValues(alpha: 0.15)
                            : colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      diceResults.isEmpty || _isRolling ? '—' : '$finalScore',
                      style: TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: diceResults.isEmpty || _isRolling ? colorScheme.onSurface.withValues(alpha: 0.3) : colorScheme.primary,
                      ),
                    ),
                  ),
                  if (!_isRolling)
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
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
    final colorScheme = Theme.of(context).colorScheme;
    final modifiersAsync = ref.watch(wizardAbilityModifiersProvider);
    final int modifierVal = modifiersAsync.maybeWhen(
      data: (map) => map[abilityKey] ?? 0,
      orElse: () => 0,
    );
    final finalScore = score + modifierVal;
    final mod = DndRules.modifier(finalScore);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: modifierVal > 0 ? colorScheme.primary.withValues(alpha: 0.3) : colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Ability details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _abilityLabel(abilityKey, l10n),
                        style: const TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (modifierVal > 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          '(+$modifierVal)',
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Modificateur : ${mod >= 0 ? '+' : ''}$mod',
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 12,
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
                  onPressed: onDecrement,
                ),
                Container(
                  width: 44,
                  height: 44,
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: modifierVal > 0 ? colorScheme.primary : colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: onIncrement != null ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.2),
                    size: 22,
                  ),
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
