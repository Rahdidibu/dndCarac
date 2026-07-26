import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/batman_providers.dart';

class Step3Abilities extends ConsumerWidget {
  const Step3Abilities({super.key});

  static const _abilities = ['for', 'con', 'dex', 'int', 'per', 'vol'];
  static const _costs = {
    8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5, 14: 7, 15: 9, 16: 12, 17: 15, 18: 18,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(batmanWizardProvider);
    final notifier = ref.read(batmanWizardProvider.notifier);
    final budget = wizard.mode == 'rues' ? 18 : 24;
    final spent = wizard.abilityScores.values
        .fold(0, (s, v) => s + (_costs[v] ?? 0));
    final remaining = budget - spent;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Caractéristiques primaires',
          style: TextStyle(
              color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: remaining >= 0 ? Colors.grey.shade900 : Colors.red.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.stars, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'Points restants : $remaining / $budget',
                style: TextStyle(
                  color: remaining >= 0 ? Colors.amber : Colors.red.shade300,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ..._abilities.map((ability) {
          final value = wizard.abilityScores[ability] ?? 8;
          final mod = abilityModifier(value);
          final modStr = mod >= 0 ? '+$mod' : '$mod';
          return _AbilityRow(
            ability: ability,
            value: value,
            mod: modStr,
            onDecrement: value > 8
                ? () => notifier.setAbilityScore(ability, value - 1)
                : null,
            onIncrement: value < 18 && remaining > 0
                ? () {
                    final nextCost = (_costs[value + 1] ?? 0) - (_costs[value] ?? 0);
                    if (nextCost <= remaining) {
                      notifier.setAbilityScore(ability, value + 1);
                    }
                  }
                : null,
          );
        }),
        const SizedBox(height: 16),
        _derivedStats(wizard),
      ],
    );
  }

  Widget _derivedStats(BatmanWizardState wizard) {
    final dex = wizard.abilityScores['dex'] ?? 8;
    final per = wizard.abilityScores['per'] ?? 8;
    final def = computeDefense(dex);
    final ini = computeInitiative(per);
    final iniStr = ini >= 0 ? '+$ini' : '$ini';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Statistiques dérivées',
               style: TextStyle(
                  color: Colors.amber, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _statBox('Défense', '$def'),
            _statBox('Initiative', iniStr),
          ]),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        ],
      );
}

class _AbilityRow extends StatelessWidget {
  final String ability;
  final int value;
  final String mod;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const _AbilityRow({
    required this.ability,
    required this.value,
    required this.mod,
    this.onDecrement,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              abilityShortName(ability),
              style: const TextStyle(
                  color: Colors.amber, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.amber),
            onPressed: onDecrement,
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.amber),
            onPressed: onIncrement,
          ),
          const Spacer(),
          Container(
            width: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber.shade900,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(mod,
                style: const TextStyle(
                    color: Colors.amber, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
