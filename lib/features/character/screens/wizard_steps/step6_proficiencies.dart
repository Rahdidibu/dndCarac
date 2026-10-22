import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/musical_instruments.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/utils/skills_catalog.dart';
import '../../providers/character_providers.dart';
import '../../providers/wizard_provider.dart';
import '../../../../core/widgets/async_error_view.dart';

const List<({String key, String name})> _artisanTools = [
  (key: 'alchemists_supplies', name: "Matériel d'alchimiste"),
  (key: 'brewers_supplies', name: 'Matériel de brasseur'),
  (key: 'calligraphers_supplies', name: 'Matériel de calligraphe'),
  (key: 'painters_supplies', name: 'Matériel de peintre'),
  (key: 'cartographers_tools', name: 'Outils de cartographe'),
  (key: 'carpenters_tools', name: 'Outils de charpentier'),
  (key: 'cobblers_tools', name: 'Outils de cordonnier'),
  (key: 'smiths_tools', name: 'Outils de forgeron'),
  (key: 'jewelers_tools', name: 'Outils de joaillier'),
  (key: 'masons_tools', name: 'Outils de maçon'),
  (key: 'potters_tools', name: 'Outils de potier'),
  (key: 'tinkers_tools', name: 'Outils de rétameur'),
  (key: 'woodcarvers_tools', name: 'Outils de sculpteur sur bois'),
  (key: 'glassblowers_tools', name: 'Outils de souffleur de verre'),
  (key: 'weavers_tools', name: 'Outils de tisserand'),
  (key: 'leatherworkers_tools', name: 'Outils de travail du cuir'),
  (key: 'cooks_utensils', name: 'Ustensiles de cuisinier'),
];


const List<({String key, String name})> _otherTools = [
  (key: 'disguise_kit', name: 'Matériel de déguisement'),
  (key: 'forgery_kit', name: 'Nécessaire de contrefaçon'),
  (key: 'poisoners_kit', name: 'Nécessaire d\'empoisonneur'),
  (key: 'herbalism_kit', name: 'Nécessaire d\'herboriste'),
  (key: 'navigators_tools', name: 'Outils de navigateur'),
  (key: 'thieves_tools', name: 'Outils de voleur'),
];

/// Available skill choices per class (DnD 5e 2024 rules)
const Map<String, List<String>> _classSkillChoices = {
  'barbarian': [
    'animal_handling',
    'athletics',
    'intimidation',
    'nature',
    'perception',
    'survival',
  ],
  'bard': [
    'acrobatics',
    'animal_handling',
    'arcana',
    'athletics',
    'deception',
    'history',
    'insight',
    'intimidation',
    'investigation',
    'medicine',
    'nature',
    'perception',
    'performance',
    'persuasion',
    'religion',
    'rose',
    'sleight_of_hand',
    'stealth',
    'survival',
  ],
  'cleric': ['history', 'insight', 'medicine', 'persuasion', 'religion'],
  'druid': [
    'arcana',
    'animal_handling',
    'insight',
    'medicine',
    'nature',
    'perception',
    'religion',
    'survival',
  ],
  'fighter': [
    'acrobatics',
    'animal_handling',
    'athletics',
    'history',
    'insight',
    'intimidation',
    'perception',
    'survival',
  ],
  'monk': [
    'acrobatics',
    'athletics',
    'history',
    'insight',
    'religion',
    'stealth',
  ],
  'paladin': [
    'athletics',
    'insight',
    'intimidation',
    'medicine',
    'persuasion',
    'religion',
  ],
  'ranger': [
    'animal_handling',
    'athletics',
    'insight',
    'investigation',
    'nature',
    'perception',
    'stealth',
    'survival',
  ],
  'rogue': [
    'acrobatics',
    'athletics',
    'deception',
    'insight',
    'intimidation',
    'investigation',
    'perception',
    'performance',
    'persuasion',
    'sleight_of_hand',
    'stealth',
  ],
  'sorcerer': [
    'arcana',
    'deception',
    'insight',
    'intimidation',
    'persuasion',
    'religion',
  ],
  'warlock': [
    'arcana',
    'deception',
    'history',
    'intimidation',
    'investigation',
    'nature',
    'religion',
  ],
  'wizard': [
    'arcana',
    'history',
    'insight',
    'investigation',
    'medicine',
    'religion',
  ],
};

class Step6Proficiencies extends ConsumerWidget {
  const Step6Proficiencies({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final allSkills = SkillsCatalog.sorted(l10n);
    final wizard = ref.watch(wizardProvider);
    final notifier = ref.read(wizardProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    final classesAsync = ref.watch(srdClassesProvider(wizard.ruleset));

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.wizardStepProficiencies,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        classesAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, st) =>
              AsyncErrorView(error: e, stackTrace: st, compact: true),
          data: (classes) {
            final primaryClassId = wizard.classes.firstOrNull?.classId ?? '';
            final maxSkills = _skillCountForClass(primaryClassId);
            final chosen = wizard.chosenSkillProficiencies.length;

            // Get available skill keys from the hardcoded list
            final availableSkillKeys = _classSkillChoices[primaryClassId];

            // Filter the full skill list to only show available ones for the class
            final displaySkills = availableSkillKeys != null
                ? allSkills
                      .where((s) => availableSkillKeys.contains(s.key))
                      .toList()
                : allSkills;

            // Build feat extra choices section
            final featId = wizard.chosenFeatId;
            final isSkilled = featId == 'skilled';
            final isCrafter = featId == 'crafter';
            final isMusician = featId == 'musician';

            Widget? extraSection;

            if (isSkilled || isCrafter || isMusician) {
              final chosenExtra = wizard.chosenFeatExtraProficiencies.length;
              const maxExtra = 3;

              List<({String key, String name, String subtitle})> eligibleItems =
                  [];
              String featName = '';

              if (isSkilled) {
                featName = 'Don "Qualifié" (Skilled)';
                eligibleItems.addAll(
                  allSkills
                      .where(
                        (s) => !wizard.chosenSkillProficiencies.contains(s.key),
                      )
                      .map(
                        (s) => (
                          key: 'skill_${s.key}',
                          name: s.name(l10n),
                          subtitle:
                              'Compétence (${SkillsCatalog.abilityName(s.ability, l10n)})',
                        ),
                      ),
                );
                eligibleItems.addAll(
                  _artisanTools.map(
                    (t) => (
                      key: 'tool_${t.key}',
                      name: t.name,
                      subtitle: 'Outil d\'artisan',
                    ),
                  ),
                );
                eligibleItems.addAll(
                  musicalInstruments.map(
                    (t) => (
                      key: 'tool_${t.key}',
                      name: t.name,
                      subtitle: 'Instrument de musique',
                    ),
                  ),
                );
                eligibleItems.addAll(
                  _otherTools.map(
                    (t) =>
                        (key: 'tool_${t.key}', name: t.name, subtitle: 'Outil'),
                  ),
                );
              } else if (isCrafter) {
                featName = 'Don "Artisan" (Crafter)';
                eligibleItems.addAll(
                  _artisanTools.map(
                    (t) => (
                      key: 'tool_${t.key}',
                      name: t.name,
                      subtitle: 'Outil d\'artisan',
                    ),
                  ),
                );
              } else if (isMusician) {
                featName = 'Don "Musicien" (Musician)';
                eligibleItems.addAll(
                  musicalInstruments.map(
                    (t) => (
                      key: 'tool_${t.key}',
                      name: t.name,
                      subtitle: 'Instrument de musique',
                    ),
                  ),
                );
              }

              final skillOrder = {
                for (var i = 0; i < allSkills.length; i++)
                  'skill_${allSkills[i].key}': i,
              };
              eligibleItems.sort((a, b) {
                final aOrder = skillOrder[a.key];
                final bOrder = skillOrder[b.key];
                if (aOrder != null || bOrder != null) {
                  return (aOrder ?? allSkills.length).compareTo(
                    bOrder ?? allSkills.length,
                  );
                }
                return StringUtils.compareAlphabetically(a.name, b.name);
              });

              extraSection = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    featName,
                    style: const TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choisissez 3 maîtrises ($chosenExtra/3 sélectionnées)',
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...eligibleItems.map((item) {
                    final isChecked = wizard.chosenFeatExtraProficiencies
                        .contains(item.key);
                    final canAdd = !isChecked && chosenExtra < maxExtra;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _ProficiencyCard(
                        title: item.name,
                        subtitle: item.subtitle,
                        selected: isChecked,
                        onTap: (canAdd || isChecked)
                            ? () =>
                                  notifier.toggleFeatExtraProficiency(item.key)
                            : null,
                      ),
                    );
                  }),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (availableSkillKeys != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Compétences de départ suggérées pour votre classe.',
                            style: TextStyle(
                              fontFamily: 'Lora',
                              fontSize: 12,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.85,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Text(
                  'Choisissez $maxSkills compétences ($chosen/$maxSkills sélectionnées)',
                  style: const TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...displaySkills.map((skill) {
                  final isChosen = wizard.chosenSkillProficiencies.contains(
                    skill.key,
                  );
                  final canAdd = !isChosen && chosen < maxSkills;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ProficiencyCard(
                      title: skill.name(l10n),
                      subtitle: SkillsCatalog.abilityName(skill.ability, l10n),
                      selected: isChosen,
                      onTap: (canAdd || isChosen)
                          ? () => notifier.toggleSkillProficiency(skill.key)
                          : null,
                    ),
                  );
                }),
                ?extraSection,
              ],
            );
          },
        ),
      ],
    );
  }

  int _skillCountForClass(String classId) {
    const counts = {'bard': 3, 'ranger': 3, 'rogue': 4};
    return counts[classId] ?? 2;
  }
}

class _ProficiencyCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback? onTap;

  const _ProficiencyCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_ProficiencyCard> createState() => _ProficiencyCardState();
}

class _ProficiencyCardState extends State<_ProficiencyCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final isDisabled = widget.onTap == null;

    return MouseRegion(
      onEnter: isDisabled ? null : (_) => setState(() => _isHovered = true),
      onExit: isDisabled ? null : (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (widget.selected || _isHovered)
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.1),
                blurRadius: 6,
                spreadRadius: 0.5,
              ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          color: widget.selected
              ? primaryColor.withValues(alpha: 0.15)
              : _isHovered
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
              : colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: widget.selected
                  ? primaryColor
                  : _isHovered
                  ? primaryColor.withValues(alpha: 0.5)
                  : colorScheme.outline.withValues(alpha: 0.1),
              width: widget.selected ? 1.5 : 1,
            ),
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Checked indicator
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.selected
                          ? primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: widget.selected
                            ? primaryColor
                            : colorScheme.onSurface.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: widget.selected
                        ? Icon(
                            Icons.check,
                            size: 14,
                            color: colorScheme.onPrimary,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: widget.selected
                                ? primaryColor
                                : colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontFamily: 'Lora',
                            fontSize: 11,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
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
