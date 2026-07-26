import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'roll_result_dialog.dart';

class UniversalDiceRoller extends StatefulWidget {
  const UniversalDiceRoller({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const UniversalDiceRoller(),
    );
  }

  @override
  State<UniversalDiceRoller> createState() => _UniversalDiceRollerState();
}

class _UniversalDiceRollerState extends State<UniversalDiceRoller> {
  int _selectedDie = 20;
  int _numDice = 1;
  int _bonus = 0;

  final List<int> _diceTypes = [4, 6, 8, 10, 12, 20, 100];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.diceRollerTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cinzel',
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: _diceTypes.map((die) {
              final isSelected = _selectedDie == die;
              return ChoiceChip(
                label: Text('d$die'),
                selected: isSelected,
                selectedColor: AppTheme.neonCyan.withValues(alpha: 0.2),
                checkmarkColor: AppTheme.neonCyan,
                labelStyle: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppTheme.neonCyan : Colors.grey,
                ),
                side: BorderSide(
                  color: isSelected ? AppTheme.neonCyan : Colors.grey.shade800,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedDie = die;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    l10n.diceRollerRollCount,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: _numDice > 1 
                            ? () => setState(() => _numDice--) 
                            : null,
                      ),
                      Text(
                        '$_numDice',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: _numDice < 20 
                            ? () => setState(() => _numDice++) 
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    l10n.diceRollerRollBonus,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: _bonus > -20 
                            ? () => setState(() => _bonus--) 
                            : null,
                      ),
                      Text(
                        _bonus >= 0 ? '+$_bonus' : '$_bonus',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: _bonus < 20 
                            ? () => setState(() => _bonus++) 
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            icon: const Icon(Icons.casino),
            label: Text(l10n.diceRollerRoll),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.neonCyan,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              RollResultDialog.show(
                context,
                title: 'Lancer libre',
                bonus: _bonus,
                isD20: _selectedDie == 20 && _numDice == 1,
                diceExpression: '${_numDice}d$_selectedDie',
              );
            },
          ),
        ],
      ),
    );
  }
}
