import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/character_service.dart';
import '../../../../core/utils/dnd_rules.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/database/tables/tables.dart';
import '../../../../core/utils/markdown_text.dart';
import '../../providers/character_providers.dart';
import '../../providers/wizard_provider.dart';

class Step7Summary extends ConsumerWidget {
  const Step7Summary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final wizard = ref.watch(wizardProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final modifiersAsync = ref.watch(wizardAbilityModifiersProvider);
    final modifiers = modifiersAsync.maybeWhen(
      data: (map) => map,
      orElse: () => <String, int>{},
    );

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.wizardStepSummary,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),

        // ── Identity ──────────────────────────────────────────────────────
        _SectionCard(
          title: 'Identité',
          children: [
            _SummaryRow('Nom', wizard.name.isEmpty ? '—' : wizard.name),
            _SummaryRow(
                'Joueur',
                wizard.playerName.isEmpty ? '—' : wizard.playerName),
            _SummaryRow(
                'Système',
                wizard.ruleset == RulesetVersion.dnd2014
                    ? l10n.systemDnd2014
                    : l10n.systemDnd2024),
            if (wizard.alignment.isNotEmpty)
              _SummaryRow('Alignement', wizard.alignment),
          ],
        ),
        const SizedBox(height: 12),

        // ── Classes ───────────────────────────────────────────────────────
        _SectionCard(
          title: 'Classes (Niveau total : ${wizard.totalLevel})',
          children: wizard.classes.isEmpty
              ? [const _SummaryRow('—', '')]
              : wizard.classes
                  .map((c) => _SummaryRow(
                        CharacterService.classDisplayName(c.classId, l10n),
                        'Niveau ${c.level}${c.subclassId != null ? ' (${c.subclassId})' : ''}',
                      ))
                  .toList(),
        ),
        const SizedBox(height: 12),

        // ── Origin ────────────────────────────────────────────────────────
        _OriginSummary(wizard: wizard),
        const SizedBox(height: 12),

        // ── Origin Feat (D&D 2024 only) ──────────────────────────────────
        if (wizard.ruleset == RulesetVersion.dnd2024 && wizard.chosenFeatId != null) ...[
          _OriginFeatSummaryRow(featId: wizard.chosenFeatId!, ruleset: wizard.ruleset),
          const SizedBox(height: 12),
        ],

        // ── Warlock Pact (D&D 2024 only) ──────────────────────────────────
        if (wizard.ruleset == RulesetVersion.dnd2024 && wizard.chosenWarlockPact != null) ...[
          _OriginFeatSummaryRow(featId: wizard.chosenWarlockPact!, ruleset: wizard.ruleset),
          const SizedBox(height: 12),
        ],

        // ── Fighting Style (D&D 2024 only) ────────────────────────────────
        if (wizard.ruleset == RulesetVersion.dnd2024 && wizard.chosenFightingStyle != null) ...[
          _OriginFeatSummaryRow(featId: wizard.chosenFightingStyle!, ruleset: wizard.ruleset),
          const SizedBox(height: 12),
        ],

        // ── Divine Order (D&D 2024 only) ──────────────────────────────────
        if (wizard.ruleset == RulesetVersion.dnd2024 && wizard.chosenDivineOrder != null) ...[
          _SectionCard(
            title: 'Ordre Divin (Clerc)',
            children: [
              _SummaryRow(
                wizard.chosenDivineOrder == 'protector'
                    ? 'Protecteur (Protector)'
                    : 'Thaumaturge',
                wizard.chosenDivineOrder == 'protector'
                    ? 'Armures lourdes & Armes de guerre'
                    : 'Tour de magie supplémentaire & bonus aux compétences',
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        // ── Primal Order (D&D 2024 only) ──────────────────────────────────
        if (wizard.ruleset == RulesetVersion.dnd2024 && wizard.chosenPrimalOrder != null) ...[
          _SectionCard(
            title: 'Ordre Primal (Druide)',
            children: [
              _SummaryRow(
                wizard.chosenPrimalOrder == 'magician'
                    ? 'Magicien (Magician)'
                    : 'Protecteur sauvage (Warden)',
                wizard.chosenPrimalOrder == 'magician'
                    ? 'Tour de magie supplémentaire & bonus aux compétences'
                    : 'Armures moyennes & Armes de guerre',
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        // ── Ability scores ────────────────────────────────────────────────
        _SectionCard(
          title: 'Caractéristiques',
          children: DndRules.abilityKeys.map((key) {
            final base = wizard.abilityScores[key] ?? 10;
            final bonus = modifiers[key] ?? 0;
            final score = base + bonus;
            final mod = DndRules.modifier(score);
            return _SummaryRow(
              _abilityLabel(key, l10n),
              '$score (${mod >= 0 ? '+' : ''}$mod)${bonus > 0 ? ' [Base $base +$bonus]' : ''}',
            );
          }).toList(),
        ),
        const SizedBox(height: 12),

        // ── Proficiencies ─────────────────────────────────────────────────
        if (wizard.chosenSkillProficiencies.isNotEmpty)
          _SectionCard(
            title: 'Compétences maîtrisées',
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: wizard.chosenSkillProficiencies
                    .map((key) => Chip(
                          label: Text(_skillName(key)),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
            ],
          ),

        if (wizard.ruleset == RulesetVersion.dnd2024 && wizard.chosenWeaponMasteries.isNotEmpty) ...[
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Maîtrises d\'armes choisies',
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final masteriesAsync = ref.watch(srdWeaponMasteriesProvider);
                  return masteriesAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Erreur: $e'),
                    data: (masteries) {
                      final masteryMap = {for (final m in masteries) m.id: m.name};
                      return Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: wizard.chosenWeaponMasteries.map((id) {
                          final name = masteryMap[id] ?? id;
                          return Chip(
                            label: Text(name),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],

        const SizedBox(height: 24),


        // Validation banner
        if (!wizard.isStep2Valid || !wizard.isStep3Valid)
          Card(
            color: colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.warning_outlined,
                      color: colorScheme.onErrorContainer),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Veuillez remplir les étapes obligatoires : '
                      '${!wizard.isStep2Valid ? 'nom, ' : ''}'
                      '${!wizard.isStep3Valid ? 'classe' : ''}',
                      style: TextStyle(color: colorScheme.onErrorContainer),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _OriginFeatSummaryRow extends ConsumerWidget {
  final String featId;
  final RulesetVersion ruleset;

  const _OriginFeatSummaryRow({required this.featId, required this.ruleset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featAsync = ref.watch(srdFeatByIdProvider((featId: featId, ruleset: ruleset)));
    return featAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (feat) {
        if (feat == null) return const SizedBox.shrink();
        return _SectionCard(
          title: 'Don d\'origine',
          children: [
            _SummaryRow(feat.name, feat.description),
          ],
        );
      },
    );
  }
}

class _OriginSummary extends ConsumerWidget {
  final WizardState wizard;
  const _OriginSummary({required this.wizard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final racesAsync = ref.watch(srdRacesProvider(wizard.ruleset));
    final backgroundsAsync = ref.watch(srdBackgroundsProvider(wizard.ruleset));

    return racesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (races) {
        final l10n = AppLocalizations.of(context)!;
        final raceName = races
            .where((r) => r.id == wizard.speciesId)
            .firstOrNull
            ?.name;
        return backgroundsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => const SizedBox.shrink(),
          data: (backgrounds) {
            final bgName = backgrounds
                .where((b) => b.id == wizard.backgroundId)
                .firstOrNull
                ?.name;
            return _SectionCard(
              title: 'Origine',
              children: [
                _SummaryRow(
                    wizard.ruleset == RulesetVersion.dnd2024
                        ? 'Species'
                        : 'Race',
                    raceName ?? '—'),
                _SummaryRow('Background', bgName ?? '—'),
                if (wizard.ruleset == RulesetVersion.dnd2024 &&
                    wizard.backgroundAsiChoices.isNotEmpty)
                  _SummaryRow(
                    'ASI (background)',
                    wizard.backgroundAsiChoices.entries
                        .map((e) => '+${e.value} ${_abilityLabel(e.key, l10n)}')
                        .join(', '),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.35), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Divider(color: colorScheme.primary.withValues(alpha: 0.2)),
            const SizedBox(height: 6),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ),
          Expanded(
            child: MarkdownText(
              text: value,
              style: const TextStyle(
                fontFamily: 'Lora',
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _abilityLabel(String key, AppLocalizations l10n) {
  final labels = {
    'str': l10n.abilityStr,
    'dex': l10n.abilityDex,
    'con': l10n.abilityCon,
    'int': l10n.abilityInt,
    'wis': l10n.abilityWis,
    'cha': l10n.abilityCha,
  };
  return labels[key] ?? key;
}

String _skillName(String key) {
  const names = {
    'athletics': 'Athlétisme',
    'acrobatics': 'Acrobaties',
    'sleight_of_hand': 'Escamotage',
    'stealth': 'Discrétion',
    'arcana': 'Arcanes',
    'history': 'Histoire',
    'investigation': 'Investigation',
    'nature': 'Nature',
    'religion': 'Religion',
    'animal_handling': 'Dressage',
    'insight': 'Perspicacité',
    'medicine': 'Médecine',
    'perception': 'Perception',
    'survival': 'Survie',
    'deception': 'Tromperie',
    'intimidation': 'Intimidation',
    'performance': 'Représentation',
    'persuasion': 'Persuasion',
  };
  return names[key] ?? key;
}
