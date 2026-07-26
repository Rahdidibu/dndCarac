import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/tables/tables.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/markdown_text.dart';
import '../../../../core/utils/string_utils.dart';
import '../../providers/character_providers.dart';
import '../../providers/wizard_provider.dart';

class Step4Origin extends ConsumerStatefulWidget {
  const Step4Origin({super.key});

  @override
  ConsumerState<Step4Origin> createState() => _Step4OriginState();
}

class _Step4OriginState extends ConsumerState<Step4Origin> {
  String? _selectedFilterAbility;

  String _abilityLabel(String key) {
    const labels = {
      'str': 'FOR',
      'dex': 'DEX',
      'con': 'CON',
      'int': 'INT',
      'wis': 'SAG',
      'cha': 'CHA',
    };
    return labels[key] ?? key.toUpperCase();
  }

  String _formatAsiAbilities(String? asiJson) {
    if (asiJson == null) return '';
    try {
      final List<dynamic> list = json.decode(asiJson);
      return list.map((a) => _abilityLabel(a.toString())).join(', ');
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final wizard = ref.watch(wizardProvider);
    final notifier = ref.read(wizardProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    final racesAsync = ref.watch(srdRacesProvider(wizard.ruleset));
    final backgroundsAsync = ref.watch(srdBackgroundsProvider(wizard.ruleset));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.wizardStepOrigin,
            style: const TextStyle(fontFamily: 'Cinzel', fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (wizard.ruleset == RulesetVersion.dnd2024)
            Card(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.step4AsiInfoText,
                        style: TextStyle(fontFamily: 'Lora', fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.8)),
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
            style: const TextStyle(fontFamily: 'Cinzel', fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          racesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Erreur: $e'),
            data: (races) {
              final sortedRaces = races.toList()
                ..sort((a, b) => StringUtils.compareAlphabetically(a.name, b.name));
              return DropdownButtonFormField<String>(
                key: const ValueKey('species-dropdown'),
                style: TextStyle(fontFamily: 'Lora', color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: wizard.ruleset == RulesetVersion.dnd2024
                      ? l10n.step4SpeciesLabel
                      : l10n.step4RaceLabel,
                  labelStyle: const TextStyle(fontFamily: 'Cinzel', fontSize: 13),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  ),
                ),
                initialValue: wizard.speciesId,
                items: sortedRaces
                    .map((r) => DropdownMenuItem<String>(value: r.id, child: Text(r.name)))
                    .toList(),
                onChanged: (v) => notifier.setSpecies(v),
              );
            },
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
            style: const TextStyle(fontFamily: 'Cinzel', fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          backgroundsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Erreur: $e'),
            data: (backgrounds) {
              // Calculate counts per ability for filters
              final Map<String, int> counts = {};
              for (final bg in backgrounds) {
                if (bg.asiJson != null) {
                  try {
                    final List<dynamic> list = json.decode(bg.asiJson!);
                    for (final a in list.cast<String>()) {
                      counts[a] = (counts[a] ?? 0) + 1;
                    }
                  } catch (_) {}
                }
              }

              var filteredBackgrounds = backgrounds.toList();
              if (wizard.ruleset == RulesetVersion.dnd2024 && _selectedFilterAbility != null) {
                filteredBackgrounds = filteredBackgrounds.where((bg) {
                  if (bg.asiJson == null) return false;
                  try {
                    final List<dynamic> list = json.decode(bg.asiJson!);
                    return list.cast<String>().contains(_selectedFilterAbility);
                  } catch (_) {
                    return false;
                  }
                }).toList();
              }

              filteredBackgrounds.sort((a, b) => StringUtils.compareAlphabetically(a.name, b.name));

              final currentVal = filteredBackgrounds.any((b) => b.id == wizard.backgroundId)
                  ? wizard.backgroundId
                  : null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (wizard.ruleset == RulesetVersion.dnd2024) ...[
                    Text(
                      'Filtrer par bonus de caractéristique',
                      style: TextStyle(fontFamily: 'Lora', fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.6)),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Toutes', 'str', 'dex', 'con', 'int', 'wis', 'cha'
                        ].map((ability) {
                          final isAll = ability == 'Toutes';
                          final isSelected = isAll 
                              ? _selectedFilterAbility == null 
                              : _selectedFilterAbility == ability;
                          final count = isAll ? backgrounds.length : (counts[ability] ?? 0);
                          final label = isAll ? 'Toutes ($count)' : '${_abilityLabel(ability)} ($count)';
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(label, style: const TextStyle(fontFamily: 'Cinzel', fontSize: 11)),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilterAbility = isAll ? null : (selected ? ability : null);
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  DropdownButtonFormField<String>(
                    key: ValueKey('background-dropdown-${_selectedFilterAbility ?? "all"}'),
                    style: TextStyle(fontFamily: 'Lora', color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Background',
                      labelStyle: const TextStyle(fontFamily: 'Cinzel', fontSize: 13),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.primary, width: 2),
                      ),
                    ),
                    initialValue: currentVal,
                    items: filteredBackgrounds.map((b) {
                      final asiBadge = _formatAsiAbilities(b.asiJson);
                      return DropdownMenuItem<String>(
                        value: b.id,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(b.name),
                            if (asiBadge.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  '($asiBadge)',
                                  style: TextStyle(
                                    fontFamily: 'Cinzel',
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      notifier.setBackground(v);
                      if (wizard.ruleset == RulesetVersion.dnd2024 && v != null) {
                        final bg = backgrounds.firstWhere((b) => b.id == v);
                        notifier.setChosenFeatId(bg.originFeatId);
                        notifier.setBackgroundAsi({});
                      }
                    },
                  ),
                ],
              );
            },
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
    final colorScheme = Theme.of(context).colorScheme;

    return featAsync.when(
      loading: () => const SizedBox(height: 50, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => Text('Erreur chargement don: $e'),
      data: (feat) {
        if (feat == null) return const SizedBox.shrink();
        return Card(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Don d\'origine : ${feat.name}',
                      style: const TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MarkdownText(
                  text: feat.description,
                  style: const TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 12.5,
                    height: 1.4,
                  ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return subracesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => const SizedBox.shrink(),
      data: (subraces) {
        if (subraces.isEmpty) return const SizedBox.shrink();
        return DropdownButtonFormField<String>(
          key: ValueKey(selectedSubraceId),
          style: TextStyle(fontFamily: 'Lora', color: colorScheme.onSurface),
          decoration: InputDecoration(
            labelText: ruleset == RulesetVersion.dnd2024
                ? l10n.step4SubspeciesLabel
                : l10n.step4SubraceLabel,
            labelStyle: const TextStyle(fontFamily: 'Cinzel', fontSize: 13),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
          initialValue: selectedSubraceId,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bonus de background (ASI)',
              style: TextStyle(fontFamily: 'Cinzel', fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Répartissez +2 et +1 sur les caractéristiques éligibles.\n'
              'Points attribués: $total / 3',
              style: TextStyle(fontFamily: 'Lora', fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 16),
            ...eligibleAbilities.map((ability) {
              final current = currentChoices[ability] ?? 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Text(
                      _abilityLabels[ability] ?? ability,
                      style: const TextStyle(fontFamily: 'Lora', fontSize: 13.5, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    _AsiChip(
                      label: '+2',
                      selected: current == 2,
                      onTap: () {
                        final updated = Map<String, int>.from(currentChoices);
                        updated.removeWhere((k, v) => v == 2 && k != ability);
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
                        updated.removeWhere((k, v) => v == 1 && k != ability);
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.white.withValues(alpha: 0.5) : colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Cinzel',
            color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
