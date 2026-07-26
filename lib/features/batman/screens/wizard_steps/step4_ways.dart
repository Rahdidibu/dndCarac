import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/batman_providers.dart';

class Step4Ways extends ConsumerWidget {
  const Step4Ways({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(batmanWizardProvider);
    final waysAsync = ref.watch(batmanWaysProvider);
    final profilesAsync = ref.watch(batmanProfilesProvider);

    return waysAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur: $e')),
      data: (ways) => profilesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (profiles) {
          final profile =
              profiles.where((p) => p.id == wizard.profileId).firstOrNull;
          final allowedType = wizard.mode == 'rues'
              ? ['commune']
              : wizard.mode == 'ombres'
                  ? ['commune', 'ombre']
                  : ['commune', 'ombre', 'prodige'];

          final filteredWays =
              ways.where((w) => allowedType.contains(w.type)).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Choisissez vos voies',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              if (profile != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Voies initiales de votre profil : ${profile.capabilityPoints} points de capacité',
                  style:
                      TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ],
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'Voies sélectionnées : ${wizard.selectedWayIds.length}',
                  style: const TextStyle(color: Colors.amber),
                ),
              ),
              const SizedBox(height: 12),
              ...filteredWays.map((way) {
                final selected = wizard.selectedWayIds.contains(way.id);
                return Card(
                  color: selected ? Colors.amber.shade900 : Colors.grey.shade900,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: selected
                        ? const BorderSide(color: Colors.amber, width: 1.5)
                        : BorderSide.none,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () =>
                        ref.read(batmanWizardProvider.notifier).toggleWay(way.id),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text(way.name,
                                    style: const TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  _typeLabel(way.type),
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'commune':
        return 'Voie commune';
      case 'ombre':
        return 'Voie des ombres';
      case 'prodige':
        return 'Voie des prodiges';
      default:
        return type;
    }
  }
}
