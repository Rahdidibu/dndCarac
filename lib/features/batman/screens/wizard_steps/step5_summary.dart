import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/batman_providers.dart';

class Step5Summary extends ConsumerWidget {
  const Step5Summary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(batmanWizardProvider);
    final profilesAsync = ref.watch(batmanProfilesProvider);
    final waysAsync = ref.watch(batmanWaysProvider);

    return profilesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (profiles) => waysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (ways) {
          final profile =
              profiles.where((p) => p.id == wizard.profileId).firstOrNull;
          final selectedWays = ways
              .where((w) => wizard.selectedWayIds.contains(w.id))
              .toList();
          final con = wizard.abilityScores['con'] ?? 8;
          final hp = profile != null ? computeBatmanHP(profile.hitDie, con) : 0;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Récapitulatif',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _row('Nom', wizard.name.isEmpty ? '—' : wizard.name),
              if (wizard.secretIdentity.isNotEmpty)
                _row('Identité secrète', wizard.secretIdentity),
              _row('Mode', _modeLabel(wizard.mode)),
              if (profile != null) _row('Profil', profile.name),
              _row('PV initiaux', '$hp'),
              const Divider(color: Colors.amber),
              const SizedBox(height: 8),
              const Text('Caractéristiques',
                  style: TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['for', 'con', 'dex', 'int', 'per', 'vol']
                    .map((a) {
                  final v = wizard.abilityScores[a] ?? 8;
                  final m = abilityModifier(v);
                  return _abilityBox(
                      abilityShortName(a), v, m >= 0 ? '+$m' : '$m');
                }).toList(),
              ),
              const Divider(color: Colors.amber),
              const SizedBox(height: 8),
              const Text('Voies choisies',
                  style: TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (selectedWays.isEmpty)
                const Text('Aucune voie sélectionnée.',
                    style: TextStyle(color: Colors.grey)),
              ...selectedWays.map((w) => Row(
                    children: [
                      const Icon(Icons.shield, color: Colors.amber, size: 16),
                      const SizedBox(width: 8),
                      Text(w.name,
                          style: const TextStyle(color: Colors.white)),
                    ],
                  )),
              const Divider(color: Colors.amber),
              const SizedBox(height: 8),
              const Text('Éthique',
                  style: TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _ethicBox('Ordre', wizard.ethicsOrder),
                _ethicBox('Justice', wizard.ethicsJustice),
                _ethicBox('Anarchie', wizard.ethicsAnarchy),
                _ethicBox('Crime', wizard.ethicsCrime),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
                width: 130,
                child: Text(label,
                    style: TextStyle(color: Colors.grey.shade400))),
            Expanded(
                child:
                    Text(value, style: const TextStyle(color: Colors.white))),
          ],
        ),
      );

  Widget _abilityBox(String name, int value, String mod) => Container(
        width: 72,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.amber.shade800),
        ),
        child: Column(
          children: [
            Text(mod,
                style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            Text('$value',
                style: TextStyle(color: Colors.grey.shade300, fontSize: 13)),
            Text(name,
                style:
                    TextStyle(color: Colors.grey.shade400, fontSize: 11)),
          ],
        ),
      );

  Widget _ethicBox(String name, int value) => Column(
        children: [
          Text('$value',
              style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Text(name,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
        ],
      );

  String _modeLabel(String mode) {
    switch (mode) {
      case 'rues':
        return 'Rues de Gotham City';
      case 'ombres':
        return 'Ombres de Gotham City';
      case 'prodiges':
        return 'Prodiges de Gotham City';
      default:
        return mode;
    }
  }
}
