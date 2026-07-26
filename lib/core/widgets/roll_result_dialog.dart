import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../../../features/character/providers/character_providers.dart';
import '../database/app_database.dart';

enum RollType {
  ability,
  save,
  skill,
  attack,
  damage,
  free,
}

class RollResultDialog extends ConsumerStatefulWidget {
  final int? characterId;
  final RollType rollType;
  final String? rollKey;
  final String title;
  final int bonus;
  final bool isD20;
  final String? diceExpression;
  final void Function(int total, String breakdown)? onRollCompleted;

  const RollResultDialog({
    super.key,
    this.characterId,
    this.rollType = RollType.free,
    this.rollKey,
    required this.title,
    required this.bonus,
    this.isD20 = true,
    this.diceExpression,
    this.onRollCompleted,
  });

  static Future<void> show(
    BuildContext context, {
    int? characterId,
    RollType rollType = RollType.free,
    String? rollKey,
    required String title,
    required int bonus,
    bool isD20 = true,
    String? diceExpression,
    void Function(int total, String breakdown)? onRollCompleted,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RollResultDialog(
        characterId: characterId,
        rollType: rollType,
        rollKey: rollKey,
        title: title,
        bonus: bonus,
        isD20: isD20,
        diceExpression: diceExpression,
        onRollCompleted: onRollCompleted,
      ),
    );
  }

  @override
  ConsumerState<RollResultDialog> createState() => _RollResultDialogState();
}

class _RollResultDialogState extends ConsumerState<RollResultDialog> {
  int _rollMode = 0; // 0 = Normal, 1 = Advantage, -1 = Disadvantage
  bool _isRolling = false;
  bool _rolled = false;
  bool _modeInitialized = false;
  
  int _die1 = 0;
  int _die2 = 0;
  List<int> _otherRolls = [];
  int _finalDieResult = 0;
  int _total = 0;
  String _breakdown = '';

  final Random _random = Random();

  void _startRoll() {
    setState(() {
      _isRolling = true;
      _rolled = true;
    });

    int ticks = 0;
    const maxTicks = 12;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (ticks >= maxTicks) {
        timer.cancel();
        _finalizeRoll();
        return;
      }

      setState(() {
        if (widget.isD20) {
          _die1 = _random.nextInt(20) + 1;
          _die2 = _random.nextInt(20) + 1;
        } else {
          final numDice = _parseNumDice();
          final sides = _parseSides();
          _otherRolls = List.generate(numDice, (_) => _random.nextInt(sides) + 1);
        }
      });

      ticks++;
    });
  }

  int _parseNumDice() {
    if (widget.diceExpression == null) return 1;
    final exp = widget.diceExpression!.toLowerCase().replaceAll(' ', '');
    final match = RegExp(r'(\d+)d').firstMatch(exp);
    return int.tryParse(match?.group(1) ?? '1') ?? 1;
  }

  int _parseSides() {
    if (widget.diceExpression == null) return 6;
    final exp = widget.diceExpression!.toLowerCase().replaceAll(' ', '');
    final match = RegExp(r'd(\d+)').firstMatch(exp);
    return int.tryParse(match?.group(1) ?? '6') ?? 6;
  }

  void _finalizeRoll() {
    if (widget.isD20) {
      _die1 = _random.nextInt(20) + 1;
      _die2 = _random.nextInt(20) + 1;

      if (_rollMode == 1) {
        _finalDieResult = _die1 > _die2 ? _die1 : _die2;
        _total = _finalDieResult + widget.bonus;
        final discard = _die1 > _die2 ? _die2 : _die1;
        _breakdown = 'd20($_finalDieResult) [rejeté: $discard] ${widget.bonus >= 0 ? "+${widget.bonus}" : widget.bonus} = $_total';
      } else if (_rollMode == -1) {
        _finalDieResult = _die1 < _die2 ? _die1 : _die2;
        _total = _finalDieResult + widget.bonus;
        final discard = _die1 < _die2 ? _die2 : _die1;
        _breakdown = 'd20($_finalDieResult) [rejeté: $discard] ${widget.bonus >= 0 ? "+${widget.bonus}" : widget.bonus} = $_total';
      } else {
        _finalDieResult = _die1;
        _total = _finalDieResult + widget.bonus;
        _breakdown = 'd20($_finalDieResult) ${widget.bonus >= 0 ? "+${widget.bonus}" : widget.bonus} = $_total';
      }
    } else {
      final numDice = _parseNumDice();
      final sides = _parseSides();
      _otherRolls = List.generate(numDice, (_) => _random.nextInt(sides) + 1);
      final sum = _otherRolls.reduce((a, b) => a + b);
      _total = sum + widget.bonus;
      final rollsStr = _otherRolls.join('+');
      _breakdown = '${numDice}d$sides[$rollsStr] ${widget.bonus >= 0 ? "+${widget.bonus}" : widget.bonus} = $_total';
    }

    setState(() {
      _isRolling = false;
    });

    if (widget.onRollCompleted != null) {
      widget.onRollCompleted!(_total, _breakdown);
    }
  }

  ({int suggestedMode, List<String> reasons, bool autoFailure}) _calculateRollModifiers({
    required Character char,
    required List<CharacterResource> resources,
    required RollType rollType,
    required String? rollKey,
  }) {
    int mode = 0;
    final List<String> reasons = [];
    bool autoFailure = false;

    final activeConditions = resources
        .where((r) => r.resourceName.startsWith('condition_') && r.current > 0)
        .map((r) => r.resourceName.replaceFirst('condition_', ''))
        .toSet();

    final exhaustion = char.exhaustionLevel;

    if (rollType == RollType.save && (rollKey == 'str' || rollKey == 'dex')) {
      if (activeConditions.contains('paralyzed') ||
          activeConditions.contains('petrified') ||
          activeConditions.contains('stunned') ||
          activeConditions.contains('unconscious')) {
        autoFailure = true;
        final conditionKey = activeConditions.firstWhere((c) => ['paralyzed', 'petrified', 'stunned', 'unconscious'].contains(c));
        final conditionFr = {
          'paralyzed': 'Paralysé',
          'petrified': 'Pétrifié',
          'stunned': 'Étourdi',
          'unconscious': 'Inconscient',
        }[conditionKey] ?? conditionKey;
        reasons.add('Échec automatique : $conditionFr');
      }
    }

    if (rollType == RollType.attack) {
      if (activeConditions.contains('poisoned')) {
        mode = -1;
        reasons.add('Désavantage : Empoisonné');
      }
      if (activeConditions.contains('blinded')) {
        mode = -1;
        reasons.add('Désavantage : Aveuglé');
      }
      if (activeConditions.contains('restrained')) {
        mode = -1;
        reasons.add('Désavantage : Entravé');
      }
      if (activeConditions.contains('prone')) {
        mode = -1;
        reasons.add('Désavantage : À terre');
      }
      if (exhaustion >= 3) {
        mode = -1;
        reasons.add('Désavantage : Épuisement (Niveau $exhaustion)');
      }
      if (activeConditions.contains('invisible')) {
        if (mode == -1) {
          mode = 0;
          reasons.add('Annulation : L\'avantage d\'Invisible compense vos désavantages');
        } else {
          mode = 1;
          reasons.add('Avantage : Invisible');
        }
      }
    }

    if (rollType == RollType.ability || rollType == RollType.skill) {
      if (activeConditions.contains('poisoned')) {
        mode = -1;
        reasons.add('Désavantage : Empoisonné');
      }
      if (exhaustion >= 1) {
        mode = -1;
        reasons.add('Désavantage : Épuisement (Niveau $exhaustion)');
      }
    }

    if (rollType == RollType.save) {
      if (rollKey == 'dex' && activeConditions.contains('restrained')) {
        mode = -1;
        reasons.add('Désavantage : Entravé');
      }
      if (exhaustion >= 3) {
        mode = -1;
        reasons.add('Désavantage : Épuisement (Niveau $exhaustion)');
      }
    }

    return (suggestedMode: mode, reasons: reasons, autoFailure: autoFailure);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    int suggestedMode = 0;
    List<String> reasons = [];
    bool autoFailure = false;

    if (widget.characterId != null) {
      final charAsync = ref.watch(characterByIdProvider(widget.characterId!));
      final resourcesAsync = ref.watch(characterResourcesProvider(widget.characterId!));

      charAsync.whenData((char) {
        if (char != null) {
          resourcesAsync.whenData((resources) {
            final modInfo = _calculateRollModifiers(
              char: char,
              resources: resources,
              rollType: widget.rollType,
              rollKey: widget.rollKey,
            );
            suggestedMode = modInfo.suggestedMode;
            reasons = modInfo.reasons;
            autoFailure = modInfo.autoFailure;

            if (!_modeInitialized && !_rolled) {
              _rollMode = suggestedMode;
              _modeInitialized = true;
            }
          });
        }
      });
    }

    final isNat20 = widget.isD20 && _finalDieResult == 20;
    final isNat1 = widget.isD20 && _finalDieResult == 1;

    return AlertDialog(
      title: Text(
        widget.title,
        style: const TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (reasons.isNotEmpty && !_rolled) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: autoFailure 
                    ? AppTheme.neonRed.withValues(alpha: 0.12) 
                    : (suggestedMode == 1 ? AppTheme.neonCyan.withValues(alpha: 0.1) : Colors.amber.withValues(alpha: 0.1)),
                border: Border.all(
                  color: autoFailure 
                      ? AppTheme.neonRed 
                      : (suggestedMode == 1 ? AppTheme.neonCyan : Colors.amber.withValues(alpha: 0.5)),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: reasons.map((r) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Icon(
                        autoFailure ? Icons.error_outline : Icons.warning_amber_outlined,
                        size: 14,
                        color: autoFailure 
                            ? AppTheme.neonRed 
                            : (suggestedMode == 1 ? AppTheme.neonCyan : Colors.amber),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          r,
                          style: TextStyle(
                            fontSize: 11, 
                            color: autoFailure 
                                ? AppTheme.neonRed 
                                : (suggestedMode == 1 ? AppTheme.neonCyan : Colors.amber),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
          if (widget.isD20 && !_rolled) ...[
            Text(
              l10n.diceRollerMode,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ModeButton(
                  label: l10n.diceRollerNormal,
                  selected: _rollMode == 0,
                  onPressed: () => setState(() => _rollMode = 0),
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                _ModeButton(
                  label: l10n.diceRollerAdvantage,
                  selected: _rollMode == 1,
                  onPressed: () => setState(() => _rollMode = 1),
                  color: AppTheme.neonCyan,
                ),
                const SizedBox(width: 8),
                _ModeButton(
                  label: l10n.diceRollerDisadvantage,
                  selected: _rollMode == -1,
                  onPressed: () => setState(() => _rollMode = -1),
                  color: AppTheme.neonRed,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
          if (_rolled) ...[
            if (widget.isD20) ...[
              if (_rollMode != 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _DieContainer(
                      value: _die1,
                      isDiscarded: !_isRolling && ((_rollMode == 1 && _die1 < _die2) || (_rollMode == -1 && _die1 > _die2)),
                      isChosen: !_isRolling && ((_rollMode == 1 && _die1 >= _die2) || (_rollMode == -1 && _die1 <= _die2)),
                    ),
                    const SizedBox(width: 24),
                    _DieContainer(
                      value: _die2,
                      isDiscarded: !_isRolling && ((_rollMode == 1 && _die2 < _die1) || (_rollMode == -1 && _die2 > _die1)),
                      isChosen: !_isRolling && ((_rollMode == 1 && _die2 >= _die1) || (_rollMode == -1 && _die2 <= _die1)),
                    ),
                  ],
                ),
              ] else ...[
                _DieContainer(value: _die1, isChosen: !_isRolling),
              ],
            ] else ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _otherRolls.map((r) => _DieContainer(
                  value: r, 
                  size: 45, 
                  fontSize: 18,
                  isD20: false,
                  sides: _parseSides(),
                )).toList(),
              ),
            ],
            const SizedBox(height: 24),
            if (!_isRolling) ...[
              if (isNat20)
                const Text(
                  'CRITIQUE NATUREL ! 🎯',
                  style: TextStyle(color: AppTheme.neonCyan, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
                )
              else if (isNat1)
                const Text(
                  'FUMBLE NATUREL ! 💀',
                  style: TextStyle(color: AppTheme.neonRed, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
                ),
              const SizedBox(height: 8),
              Text(
                '${l10n.diceRollerResult} : $_total',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                _breakdown,
                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ],
          if (!_rolled) ...[
            Text(
              widget.diceExpression != null
                  ? '${l10n.diceRollerFormula(widget.diceExpression!)} (${widget.bonus >= 0 ? "+${widget.bonus}" : widget.bonus})'
                  : 'd20 ${widget.bonus >= 0 ? "+${widget.bonus}" : widget.bonus}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
      actions: [
        if (!_rolled) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: _startRoll,
            style: FilledButton.styleFrom(
              backgroundColor: _rollMode == 1 
                  ? AppTheme.neonCyan 
                  : _rollMode == -1 
                      ? AppTheme.neonRed 
                      : colorScheme.primary,
            ),
            child: Text(l10n.diceRollerRoll),
          ),
        ] else if (!_isRolling)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final Color color;

  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : Colors.transparent,
          border: Border.all(
            color: selected ? color : Colors.grey.shade700,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? color : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _DieContainer extends StatelessWidget {
  final int value;
  final bool isDiscarded;
  final bool isChosen;
  final double size;
  final double fontSize;
  final bool isD20;
  final int sides;

  const _DieContainer({
    required this.value,
    this.isDiscarded = false,
    this.isChosen = false,
    this.size = 60,
    this.fontSize = 24,
    this.isD20 = true,
    this.sides = 20,
  });

  @override
  Widget build(BuildContext context) {
    final borderGlow = isChosen
        ? (value == 20 && isD20 
            ? AppTheme.neonCyan 
            : (value == 1 && isD20 ? AppTheme.neonRed : Colors.amber))
        : Colors.transparent;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDiscarded ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.1),
        border: Border.all(
          color: isDiscarded 
              ? Colors.grey.withValues(alpha: 0.3) 
              : (isChosen ? borderGlow : Colors.grey.shade700),
          width: isChosen ? 2.5 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isChosen && borderGlow != Colors.transparent
            ? [
                BoxShadow(
                  color: borderGlow.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Text(
        value > 0 ? value.toString() : '?',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: isDiscarded 
              ? Colors.grey.withValues(alpha: 0.5) 
              : (isChosen 
                  ? (value == 20 && isD20 
                      ? AppTheme.neonCyan 
                      : (value == 1 && isD20 ? AppTheme.neonRed : Colors.amber)) 
                  : Colors.white),
          decoration: isDiscarded ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}
