import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CombinedAttackResult {
  final String weaponName;
  final int d20Roll1;
  final int? d20Roll2;
  final int rollMode; // -1 = dis, 0 = norm, 1 = adv
  final int attackBonus;
  final int totalAttack;
  final bool isCrit;
  final bool isFumble;
  final String damageExpression;
  final String damageType;
  final List<int> damageRolls;
  final int damageBonus;
  final int totalDamage;
  final String ammoUsed;

  const CombinedAttackResult({
    required this.weaponName,
    required this.d20Roll1,
    this.d20Roll2,
    required this.rollMode,
    required this.attackBonus,
    required this.totalAttack,
    required this.isCrit,
    required this.isFumble,
    required this.damageExpression,
    required this.damageType,
    required this.damageRolls,
    required this.damageBonus,
    required this.totalDamage,
    this.ammoUsed = '',
  });
}

class CombatAttackDialog extends StatefulWidget {
  final String weaponName;
  final int attackBonus;
  final String damageDice; // e.g. "1d8+3" or "2d6+4"
  final String damageType;
  final int rollMode; // -1, 0, 1
  final String ammoName;
  final int ammoBonus;
  final String notes;

  const CombatAttackDialog({
    super.key,
    required this.weaponName,
    required this.attackBonus,
    required this.damageDice,
    required this.damageType,
    this.rollMode = 0,
    this.ammoName = '',
    this.ammoBonus = 0,
    this.notes = '',
  });

  static Future<CombinedAttackResult?> show(
    BuildContext context, {
    required String weaponName,
    required int attackBonus,
    required String damageDice,
    required String damageType,
    int rollMode = 0,
    String ammoName = '',
    int ammoBonus = 0,
    String notes = '',
  }) {
    return showDialog<CombinedAttackResult>(
      context: context,
      builder: (context) => CombatAttackDialog(
        weaponName: weaponName,
        attackBonus: attackBonus,
        damageDice: damageDice,
        damageType: damageType,
        rollMode: rollMode,
        ammoName: ammoName,
        ammoBonus: ammoBonus,
        notes: notes,
      ),
    );
  }

  @override
  State<CombatAttackDialog> createState() => _CombatAttackDialogState();
}

class _CombatAttackDialogState extends State<CombatAttackDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final math.Random _random = math.Random();

  // Weapon trait toggles
  late int _critThreshold;
  late bool _rerollOnesAndTwos;
  late bool _isVicious;

  late int _d20Roll1;
  int? _d20Roll2;
  late int _chosenD20;
  late bool _isCrit;
  late bool _isFumble;
  late int _totalAttackBonus;
  late int _totalAttack;

  late List<int> _damageRolls;
  late List<String> _damageRollStrings;
  late int _damageBonus;
  late int _totalDamage;
  late String _effectiveDamageExpr;

  bool _isRolling = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Auto-detect traits from weapon notes and name
    final combinedNotes = '${widget.weaponName} ${widget.notes}'.toLowerCase();
    _critThreshold = (combinedNotes.contains('19-20') || combinedNotes.contains('19') || combinedNotes.contains('critique 19')) ? 19 : 20;
    _rerollOnesAndTwos = combinedNotes.contains('relance') || combinedNotes.contains('2 mains') || combinedNotes.contains('great weapon');
    _isVicious = combinedNotes.contains('vicieu') || combinedNotes.contains('vicious');

    _executeRolls();
    _animController.forward().then((_) {
      if (mounted) setState(() => _isRolling = false);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _executeRolls() {
    _d20Roll1 = _random.nextInt(20) + 1;
    if (widget.rollMode != 0) {
      _d20Roll2 = _random.nextInt(20) + 1;
      if (widget.rollMode == 1) {
        _chosenD20 = math.max(_d20Roll1, _d20Roll2!);
      } else {
        _chosenD20 = math.min(_d20Roll1, _d20Roll2!);
      }
    } else {
      _d20Roll2 = null;
      _chosenD20 = _d20Roll1;
    }

    _isCrit = _chosenD20 >= _critThreshold;
    _isFumble = _chosenD20 == 1;

    _totalAttackBonus = widget.attackBonus + widget.ammoBonus;
    _totalAttack = _chosenD20 + _totalAttackBonus;

    // Parse damage dice (e.g. 1d8+3 or 2d6)
    final pattern = RegExp(r'(\d+)d(\d+)([+-]\d+)?');
    final match = pattern.firstMatch(widget.damageDice.toLowerCase().replaceAll(' ', ''));

    int numDice = 1;
    int dieSides = 6;
    _damageBonus = 0;

    if (match != null) {
      numDice = int.tryParse(match.group(1) ?? '1') ?? 1;
      dieSides = int.tryParse(match.group(2) ?? '6') ?? 6;
      _damageBonus = int.tryParse(match.group(3) ?? '0') ?? 0;
    }

    // Double dice on crit
    if (_isCrit) {
      numDice *= 2;
      if (_isVicious) {
        _damageBonus += 7; // Arme Vicieuse: +7 dégâts sur crit
      }
    }

    _effectiveDamageExpr = '${numDice}d$dieSides${_damageBonus != 0 ? (_damageBonus > 0 ? "+$_damageBonus" : "$_damageBonus") : ""}';

    _damageRolls = [];
    _damageRollStrings = [];

    for (int i = 0; i < numDice; i++) {
      int r = _random.nextInt(dieSides) + 1;
      if (_rerollOnesAndTwos && (r == 1 || r == 2)) {
        int r2 = _random.nextInt(dieSides) + 1;
        _damageRollStrings.add('$r⟳$r2');
        r = r2;
      } else {
        _damageRollStrings.add('$r');
      }
      _damageRolls.add(r);
    }

    final diceTotal = _damageRolls.fold(0, (sum, r) => sum + r);
    _totalDamage = math.max(0, diceTotal + _damageBonus);
  }

  void _reroll() {
    setState(() {
      _isRolling = true;
      _animController.reset();
      _executeRolls();
      _animController.forward().then((_) {
        if (mounted) setState(() => _isRolling = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color headerColor = AppTheme.neonCyan;
    String headerText = 'JET D\'ATTAQUE & DÉGÂTS';

    if (_isCrit) {
      headerColor = Colors.amber;
      headerText = '🎯 COUP CRITIQUE !';
    } else if (_isFumble) {
      headerColor = Colors.redAccent;
      headerText = '💀 ÉCHEC CRITIQUE !';
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.all(20),
        border: Border.all(color: headerColor.withValues(alpha: 0.4), width: 1.5),
        child: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // En-tête
              Row(
                children: [
                  Icon(Icons.sports_martial_arts, color: headerColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.weaponName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white70),
                    tooltip: 'Relancer',
                    onPressed: _reroll,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Bannière de Résultat (Touche)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: headerColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: headerColor.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Text(
                      headerText,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: headerColor, letterSpacing: 1),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text('TOUCHE : ', style: TextStyle(fontSize: 14, color: Colors.white70)),
                        AnimatedBuilder(
                          animation: _animController,
                          builder: (context, child) {
                            final displayVal = _isRolling
                                ? (_random.nextInt(20) + 1 + _totalAttackBonus)
                                : _totalAttack;
                            return Text(
                              '$displayVal',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: headerColor,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _buildAttackBreakdownStr(),
                      style: const TextStyle(fontSize: 12, color: Colors.white60),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Carte de Dégâts (sauf sur Fumble)
              if (!_isFumble) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.flash_on, color: Colors.redAccent, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'DÉGÂTS (${widget.damageType.toUpperCase()})',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent, letterSpacing: 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AnimatedBuilder(
                        animation: _animController,
                        builder: (context, child) {
                          final displayVal = _isRolling ? _random.nextInt(12) + 1 : _totalDamage;
                          return Text(
                            '$displayVal PV',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Formule : $_effectiveDamageExpr [${_damageRollStrings.join("+")}]${_damageBonus != 0 ? (_damageBonus > 0 ? "+$_damageBonus" : "$_damageBonus") : ""}',
                        style: const TextStyle(fontSize: 11, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Traits d'armes & options de jet
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Traits d\'arme & Modificateurs de jet :',
                      style: TextStyle(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        FilterChip(
                          avatar: const Text('🎯', style: TextStyle(fontSize: 12)),
                          label: Text(
                            _critThreshold == 19 ? 'Critique 19-20' : 'Critique 20',
                            style: const TextStyle(fontSize: 11),
                          ),
                          selected: _critThreshold == 19,
                          selectedColor: Colors.amber.withValues(alpha: 0.3),
                          onSelected: (v) {
                            setState(() {
                              _critThreshold = v ? 19 : 20;
                              _reroll();
                            });
                          },
                        ),
                        FilterChip(
                          avatar: const Text('🔄', style: TextStyle(fontSize: 12)),
                          label: const Text('Relancer 1 & 2', style: TextStyle(fontSize: 11)),
                          selected: _rerollOnesAndTwos,
                          selectedColor: Colors.cyan.withValues(alpha: 0.3),
                          onSelected: (v) {
                            setState(() {
                              _rerollOnesAndTwos = v;
                              _reroll();
                            });
                          },
                        ),
                        FilterChip(
                          avatar: const Text('🗡️', style: TextStyle(fontSize: 12)),
                          label: const Text('Vicieuse (+7 crit)', style: TextStyle(fontSize: 11)),
                          selected: _isVicious,
                          selectedColor: Colors.red.withValues(alpha: 0.3),
                          onSelected: (v) {
                            setState(() {
                              _isVicious = v;
                              _reroll();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Actions
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isRolling
                      ? null
                      : () {
                          final result = CombinedAttackResult(
                            weaponName: widget.weaponName,
                            d20Roll1: _d20Roll1,
                            d20Roll2: _d20Roll2,
                            rollMode: widget.rollMode,
                            attackBonus: _totalAttackBonus,
                            totalAttack: _totalAttack,
                            isCrit: _isCrit,
                            isFumble: _isFumble,
                            damageExpression: _effectiveDamageExpr,
                            damageType: widget.damageType,
                            damageRolls: _damageRolls,
                            damageBonus: _damageBonus,
                            totalDamage: _totalDamage,
                            ammoUsed: widget.ammoName,
                          );
                          Navigator.of(context).pop(result);
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: headerColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.check, size: 20),
                  label: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildAttackBreakdownStr() {
    String d20Str = 'd20($_d20Roll1)';
    if (widget.rollMode == 1) {
      d20Str = 'Avantage [$_d20Roll1, $_d20Roll2] -> $_chosenD20';
    } else if (widget.rollMode == -1) {
      d20Str = 'Désavantage [$_d20Roll1, $_d20Roll2] -> $_chosenD20';
    }
    final bonusStr = _totalAttackBonus >= 0 ? '+$_totalAttackBonus' : '$_totalAttackBonus';
    final ammoStr = widget.ammoName.isNotEmpty ? ' (${widget.ammoName})' : '';
    return '$d20Str $bonusStr$ammoStr = $_totalAttack';
  }
}
