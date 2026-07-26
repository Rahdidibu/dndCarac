import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../providers/batman_providers.dart';

class Step1ProfileMode extends ConsumerWidget {
  const Step1ProfileMode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(batmanWizardProvider);
    final profilesAsync = ref.watch(batmanProfilesProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionTitle(context, 'Mode de jeu'),
        const SizedBox(height: 8),
        _modeCard(context, ref, wizard, 'rues', 'Rues de Gotham City',
            'Aventures urbaines réalistes. Accès aux voies communes.'),
        const SizedBox(height: 8),
        _modeCard(context, ref, wizard, 'ombres', 'Ombres de Gotham City',
            'Justiciers et criminels d\'exception. Voies communes + voies des ombres.'),
        const SizedBox(height: 8),
        _modeCard(context, ref, wizard, 'prodiges', 'Prodiges de Gotham City',
            'Super-pouvoirs et menaces majeures. Toutes les voies disponibles.'),
        const SizedBox(height: 24),
        _sectionTitle(context, 'Profil'),
        const SizedBox(height: 8),
        profilesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Erreur: $e'),
          data: (profiles) {
            final filtered =
                profiles.where((p) => _profileFitsMode(p.mode, wizard.mode)).toList();
            return Column(
              children: filtered
                  .map((p) => _profileCard(context, ref, wizard, p))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  bool _profileFitsMode(String profileMode, String selectedMode) {
    if (selectedMode == 'prodiges') return true;
    if (selectedMode == 'ombres') {
      return profileMode == 'rues' || profileMode == 'ombres';
    }
    return profileMode == 'rues';
  }

  Widget _modeCard(BuildContext context, WidgetRef ref, BatmanWizardState wizard,
      String modeId, String title, String subtitle) {
    final selected = wizard.mode == modeId;
    return Card(
      color: selected ? Colors.amber.shade900 : Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: selected
            ? const BorderSide(color: Colors.amber, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => ref.read(batmanWizardProvider.notifier).setMode(modeId),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: Colors.amber,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style: TextStyle(
                            color: Colors.amber.shade200, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileCard(BuildContext context, WidgetRef ref,
      BatmanWizardState wizard, BatmanProfile profile) {
    final selected = wizard.profileId == profile.id;
    return Card(
      color: selected ? Colors.amber.shade900 : Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: selected
            ? const BorderSide(color: Colors.amber, width: 2)
            : BorderSide.none,
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () =>
            ref.read(batmanWizardProvider.notifier).setProfile(profile.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: Colors.amber,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name,
                        style: const TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(profile.description,
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 12)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: [
                        _chip(profile.hitDie),
                        if (profile.atcBonus > 0) _chip('ATC +${profile.atcBonus}'),
                        if (profile.atdBonus > 0) _chip('ATD +${profile.atdBonus}'),
                        _chip('PC: ${profile.capabilityPoints}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label,
            style:
                TextStyle(color: Colors.amber.shade300, fontSize: 11)),
      );

  Widget _sectionTitle(BuildContext context, String title) => Text(
        title,
        style: const TextStyle(
            color: Colors.amber,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      );
}
