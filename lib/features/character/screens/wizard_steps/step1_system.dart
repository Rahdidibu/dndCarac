import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/tables/tables.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/wizard_provider.dart';

class Step1System extends ConsumerWidget {
  const Step1System({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ruleset = ref.watch(wizardProvider.select((s) => s.ruleset));

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.wizardStepSystem,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Choisissez la version des règles pour ce personnage.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        _SystemCard(
          title: l10n.systemDnd2014,
          subtitle:
              'Règles originales D&D 5e (Player\'s Handbook 2014). SRD 5.1.',
          version: RulesetVersion.dnd2014,
          selected: ruleset == RulesetVersion.dnd2014,
          onTap: () => ref
              .read(wizardProvider.notifier)
              .setRuleset(RulesetVersion.dnd2014),
        ),
        const SizedBox(height: 16),
        _SystemCard(
          title: l10n.systemDnd2024,
          subtitle:
              'Règles révisées 2024 (One D&D / PHB 2024). SRD 5.2.\n'
              '• L\'ASI vient du background (pas de la race)\n'
              '• Species sans bonus de caractéristique\n'
              '• Maîtrise des armes (Weapon Mastery)\n'
              '• Épuisement simplifié',
          version: RulesetVersion.dnd2024,
          selected: ruleset == RulesetVersion.dnd2024,
          onTap: () => ref
              .read(wizardProvider.notifier)
              .setRuleset(RulesetVersion.dnd2024),
        ),
      ],
    );
  }
}

class _SystemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final RulesetVersion version;
  final bool selected;
  final VoidCallback onTap;

  const _SystemCard({
    required this.title,
    required this.subtitle,
    required this.version,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: selected ? colorScheme.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: selected
            ? BorderSide(color: colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? colorScheme.primary : colorScheme.outline,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: selected
                                ? colorScheme.onPrimaryContainer
                                : null,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: selected
                                ? colorScheme.onPrimaryContainer
                                    .withValues(alpha: 0.8)
                                : colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
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
}
