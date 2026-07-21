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

class _SystemCard extends StatefulWidget {
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
  State<_SystemCard> createState() => _SystemCardState();
}

class _SystemCardState extends State<_SystemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (widget.selected || _isHovered)
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.15),
                blurRadius: 10,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          color: widget.selected
              ? colorScheme.primaryContainer.withValues(alpha: 0.25)
              : _isHovered
                  ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
                  : colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: widget.selected
                  ? primaryColor
                  : _isHovered
                      ? primaryColor.withValues(alpha: 0.5)
                      : primaryColor.withValues(alpha: 0.15),
              width: widget.selected ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    widget.selected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: widget.selected ? primaryColor : colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontSize: 16,
                            color: widget.selected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontFamily: 'Lora',
                            fontSize: 12.5,
                            height: 1.4,
                            color: widget.selected
                                ? colorScheme.onSurface
                                : colorScheme.onSurface.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
