import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/tables/tables.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/character_providers.dart';
import '../../providers/wizard_provider.dart';

class Step4Origin extends ConsumerWidget {
  const Step4Origin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final wizard = ref.watch(wizardProvider);
    final notifier = ref.read(wizardProvider.notifier);

    final racesAsync = ref.watch(srdRacesProvider(wizard.ruleset));
    final backgroundsAsync = ref.watch(srdBackgroundsProvider(wizard.ruleset));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Text(
          l10n.wizardStepOrigin,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        if (wizard.ruleset == RulesetVersion.dnd2024)
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.step4AsiInfoText,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),

        // ── Species / Race ───────────────────────────────────────────────
        Text(
          wizard.ruleset == RulesetVersion.dnd2024 ? l10n.step4SpeciesLabel : l10n.step4RaceLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        racesAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Erreur: $e'),
          data: (races) => DropdownButtonFormField<String>(
            key: const ValueKey('species-dropdown'),
            decoration: InputDecoration(
              labelText: wizard.ruleset == RulesetVersion.dnd2024
                  ? l10n.step4SpeciesLabel
                  : l10n.step4RaceLabel,
              border: const OutlineInputBorder(),
            ),
            value: wizard.speciesId,
            items: races
                .map((r) => DropdownMenuItem(value: r.id, child: Text(r.name)))
                .toList(),
            onChanged: (v) => notifier.setSpecies(v),
          ),
        ),

        // Sub-race / subspecies (if species selected)
        if (wizard.speciesId != null) ...[
          const SizedBox(height: 12),
          _SubraceDropdown(
            speciesId: wizard.speciesId!,
            ruleset: wizard.ruleset,
            selectedSubraceId: wizard.subspeciesId,
            onChanged: notifier.setSubspecies,
          ),
        ],

        const SizedBox(height: 24),

        // ── Background ───────────────────────────────────────────────────
        Text(
          'Background',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        backgroundsAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Erreur: $e'),
          data: (backgrounds) => DropdownButtonFormField<String>(
            key: const ValueKey('background-dropdown'),
            decoration: const InputDecoration(
              labelText: 'Background',
              border: OutlineInputBorder(),
            ),
            value: wizard.backgroundId,
            items: backgrounds
                .map((b) =>
                    DropdownMenuItem(value: b.id, child: Text(b.name)))
                .toList(),
            onChanged: (v) {
              notifier.setBackground(v);
              if (wizard.ruleset == RulesetVersion.dnd2024 && v != null) {
                final bg = backgrounds.firstWhere((b) => b.id == v);
                notifier.setChosenFeatId(bg.originFeatId);
                notifier.setBackgroundAsi({});
              }
            },
          ),
        ),

        // 2024: Origin Feat display
        if (wizard.ruleset == RulesetVersion.dnd2024 &&
            wizard.chosenFeatId != null) ...[
          const SizedBox(height: 16),
          _OriginFeatCard(
            featId: wizard.chosenFeatId!,
            ruleset: wizard.ruleset,
          ),
        ],

        // 2024: ASI choice from background
        if (wizard.ruleset == RulesetVersion.dnd2024 &&
            wizard.backgroundId != null) ...[
          const SizedBox(height: 16),
          backgroundsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => const SizedBox.shrink(),
            data: (backgrounds) {
              final bg = backgrounds
                  .where((b) => b.id == wizard.backgroundId)
                  .firstOrNull;
              if (bg?.asiJson == null) return const SizedBox.shrink();
              final eligible = (json.decode(bg!.asiJson!) as List)
                  .cast<String>();
              return _BackgroundAsiPicker(
                eligibleAbilities: eligible,
                currentChoices: wizard.backgroundAsiChoices,
                onChanged: notifier.setBackgroundAsi,
              );
            },
          ),
        ],
        ],
      ),
    );
  }
}

class _OriginFeatCard extends ConsumerWidget {
  final String featId;
  final RulesetVersion ruleset;

  const _OriginFeatCard({required this.featId, required this.ruleset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featAsync = ref.watch(srdFeatByIdProvider((featId: featId, ruleset: ruleset)));
    return featAsync.when(
      loading: () => const SizedBox(height: 50, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => Text('Erreur chargement don: $e'),
      data: (feat) {
        if (feat == null) return const SizedBox.shrink();
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Don d\'origine : ${feat.name}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  feat.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SubraceDropdown extends ConsumerWidget {
  final String speciesId;
  final RulesetVersion ruleset;
  final String? selectedSubraceId;
  final void Function(String?) onChanged;

  const _SubraceDropdown({
    required this.speciesId,
    required this.ruleset,
    required this.selectedSubraceId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final subracesAsync = ref.watch(
      srdSubracesProvider((raceId: speciesId, ruleset: ruleset)),
    );

    return subracesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => const SizedBox.shrink(),
      data: (subraces) {
        if (subraces.isEmpty) return const SizedBox.shrink();
        return DropdownButtonFormField<String>(
          key: ValueKey(selectedSubraceId),
          decoration: InputDecoration(
            labelText: ruleset == RulesetVersion.dnd2024
                ? l10n.step4SubspeciesLabel
                : l10n.step4SubraceLabel,
            border: const OutlineInputBorder(),
          ),
          value: selectedSubraceId,
          items: [
            DropdownMenuItem(value: null, child: Text(l10n.step4NoneOption)),
            ...subraces.map(
              (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
            ),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}

class _BackgroundAsiPicker extends StatelessWidget {
  final List<String> eligibleAbilities;
  final Map<String, int> currentChoices;
  final void Function(Map<String, int>) onChanged;

  const _BackgroundAsiPicker({
    required this.eligibleAbilities,
    required this.currentChoices,
    required this.onChanged,
  });

  static const Map<String, String> _abilityLabels = {
    'str': 'Force',
    'dex': 'Dextérité',
    'con': 'Constitution',
    'int': 'Intelligence',
    'wis': 'Sagesse',
    'cha': 'Charisme',
  };

  int _totalAssigned() =>
      currentChoices.values.fold(0, (s, v) => s + v);

  @override
  Widget build(BuildContext context) {
    final total = _totalAssigned();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonus de background (ASI) — Répartissez +2 et +1',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              'Points attribués: $total / 3  (+2 sur une, +1 sur une autre)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            ...eligibleAbilities.map((ability) {
              final current = currentChoices[ability] ?? 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        _abilityLabels[ability] ?? ability,
                      ),
                    ),
                    const Spacer(),
                    _AsiChip(
                      label: '+2',
                      selected: current == 2,
                      onTap: () {
                        final updated = Map<String, int>.from(currentChoices);
                        // Remove +2 from any other ability
                        updated.removeWhere(
                            (k, v) => v == 2 && k != ability);
                        if (current == 2) {
                          updated.remove(ability);
                        } else {
                          updated[ability] = 2;
                        }
                        onChanged(updated);
                      },
                    ),
                    const SizedBox(width: 8),
                    _AsiChip(
                      label: '+1',
                      selected: current == 1,
                      onTap: () {
                        final updated = Map<String, int>.from(currentChoices);
                        updated.removeWhere(
                            (k, v) => v == 1 && k != ability);
                        if (current == 1) {
                          updated.remove(ability);
                        } else {
                          updated[ability] = 1;
                        }
                        onChanged(updated);
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AsiChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AsiChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
