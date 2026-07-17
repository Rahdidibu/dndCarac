import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../providers/character_providers.dart';
import '../../providers/wizard_provider.dart';

// All SRD skills with associated ability
const List<({String key, String name, String ability})> _allSkills = [
  (key: 'athletics', name: 'Athlétisme', ability: 'str'),
  (key: 'acrobatics', name: 'Acrobaties', ability: 'dex'),
  (key: 'sleight_of_hand', name: 'Escamotage', ability: 'dex'),
  (key: 'stealth', name: 'Discrétion', ability: 'dex'),
  (key: 'arcana', name: 'Arcanes', ability: 'int'),
  (key: 'history', name: 'Histoire', ability: 'int'),
  (key: 'investigation', name: 'Investigation', ability: 'int'),
  (key: 'nature', name: 'Nature', ability: 'int'),
  (key: 'religion', name: 'Religion', ability: 'int'),
  (key: 'animal_handling', name: 'Dressage', ability: 'wis'),
  (key: 'insight', name: 'Perspicacité', ability: 'wis'),
  (key: 'medicine', name: 'Médecine', ability: 'wis'),
  (key: 'perception', name: 'Perception', ability: 'wis'),
  (key: 'survival', name: 'Survie', ability: 'wis'),
  (key: 'deception', name: 'Tromperie', ability: 'cha'),
  (key: 'intimidation', name: 'Intimidation', ability: 'cha'),
  (key: 'performance', name: 'Représentation', ability: 'cha'),
  (key: 'persuasion', name: 'Persuasion', ability: 'cha'),
];

const List<({String key, String name})> _artisanTools = [
  (key: 'alchemists_supplies', name: "Matériel d'alchimiste"),
  (key: 'brewers_supplies', name: 'Matériel de brasseur'),
  (key: 'calligraphers_supplies', name: 'Matériel de calligraphe'),
  (key: 'carpenters_tools', name: 'Outils de charpentier'),
  (key: 'cartographers_tools', name: 'Outils de cartographe'),
  (key: 'cobblers_tools', name: 'Outils de cordonnier'),
  (key: 'cooks_utensils', name: 'Ustensiles de cuisinier'),
  (key: 'glassblowers_tools', name: 'Outils de souffleur de verre'),
  (key: 'jewelers_tools', name: 'Outils de joaillier'),
  (key: 'leatherworkers_tools', name: 'Outils de travail du cuir'),
  (key: 'masons_tools', name: 'Outils de maçon'),
  (key: 'painters_supplies', name: 'Matériel de peintre'),
  (key: 'potters_tools', name: 'Outils de potier'),
  (key: 'smiths_tools', name: 'Outils de forgeron'),
  (key: 'tinkers_tools', name: 'Outils de rétameur'),
  (key: 'weavers_tools', name: 'Outils de tisserand'),
  (key: 'woodcarvers_tools', name: 'Outils de sculpteur sur bois'),
];

const List<({String key, String name})> _musicalInstruments = [
  (key: 'bagpipes', name: 'Cornemuse'),
  (key: 'drum', name: 'Tambour'),
  (key: 'flute', name: 'Flûte'),
  (key: 'lute', name: 'Luth'),
  (key: 'lyre', name: 'Lyre'),
  (key: 'horn', name: 'Cor'),
  (key: 'pan_flute', name: 'Flûte de Pan'),
  (key: 'dulcimer', name: 'Tympanon'),
  (key: 'viol', name: 'Viole'),
  (key: 'shawm', name: 'Chalemie'),
];

const List<({String key, String name})> _otherTools = [
  (key: 'disguise_kit', name: 'Matériel de déguisement'),
  (key: 'forgery_kit', name: 'Nécessaire de contrefaçon'),
  (key: 'herbalism_kit', name: 'Nécessaire d\'herboriste'),
  (key: 'navigators_tools', name: 'Outils de navigateur'),
  (key: 'poisoners_kit', name: 'Nécessaire d\'empoisonneur'),
  (key: 'thieves_tools', name: 'Outils de voleur'),
];

/// Available skill choices per class (DnD 5e 2024 rules)
const Map<String, List<String>> _classSkillChoices = {
  'barbarian': ['animal_handling', 'athletics', 'intimidation', 'nature', 'perception', 'survival'],
  'bard': ['acrobatics', 'animal_handling', 'arcana', 'athletics', 'deception', 'history', 'insight', 'intimidation', 'investigation', 'medicine', 'nature', 'perception', 'performance', 'persuasion', 'religion', 'rose', 'sleight_of_hand', 'stealth', 'survival'],
  'cleric': ['history', 'insight', 'medicine', 'persuasion', 'religion'],
  'druid': ['arcana', 'animal_handling', 'insight', 'medicine', 'nature', 'perception', 'religion', 'survival'],
  'fighter': ['acrobatics', 'animal_handling', 'athletics', 'history', 'insight', 'intimidation', 'perception', 'survival'],
  'monk': ['acrobatics', 'athletics', 'history', 'insight', 'religion', 'stealth'],
  'paladin': ['athletics', 'insight', 'intimidation', 'medicine', 'persuasion', 'religion'],
  'ranger': ['animal_handling', 'athletics', 'insight', 'investigation', 'nature', 'perception', 'stealth', 'survival'],
  'rogue': ['acrobatics', 'athletics', 'deception', 'insight', 'intimidation', 'investigation', 'perception', 'performance', 'persuasion', 'sleight_of_hand', 'stealth'],
  'sorcerer': ['arcana', 'deception', 'insight', 'intimidation', 'persuasion', 'religion'],
  'warlock': ['arcana', 'deception', 'history', 'intimidation', 'investigation', 'nature', 'religion'],
  'wizard': ['arcana', 'history', 'insight', 'investigation', 'medicine', 'religion'],
};

class Step6Proficiencies extends ConsumerWidget {
  const Step6Proficiencies({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final wizard = ref.watch(wizardProvider);
    final notifier = ref.read(wizardProvider.notifier);

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
          error: (e, _) => Text('Erreur: $e'),
          data: (classes) {
            final primaryClassId = wizard.classes.firstOrNull?.classId ?? '';
            final maxSkills = _skillCountForClass(primaryClassId);
            final chosen = wizard.chosenSkillProficiencies.length;

            // Get available skill keys from the hardcoded list
            final availableSkillKeys = _classSkillChoices[primaryClassId];

            // Filter the full skill list to only show available ones for the class
            final displaySkills = availableSkillKeys != null
                ? _allSkills.where((s) => availableSkillKeys.contains(s.key)).toList()
                : _allSkills;

            // Build feat extra choices section
            final featId = wizard.chosenFeatId;
            final isSkilled = featId == 'skilled';
            final isCrafter = featId == 'crafter';
            final isMusician = featId == 'musician';

            Widget? extraSection;

            if (isSkilled || isCrafter || isMusician) {
              final chosenExtra = wizard.chosenFeatExtraProficiencies.length;
              const maxExtra = 3;
              
              List<({String key, String name, String subtitle})> eligibleItems = [];
              String featName = '';
              
              if (isSkilled) {
                featName = 'Don "Qualifié" (Skilled)';
                eligibleItems.addAll(_allSkills
                    .where((s) => !wizard.chosenSkillProficiencies.contains(s.key))
                    .map((s) => (key: 'skill_${s.key}', name: s.name, subtitle: 'Compétence (${_abilityLabel(s.ability)})')));
                eligibleItems.addAll(_artisanTools.map((t) => (key: 'tool_${t.key}', name: t.name, subtitle: 'Outil d\'artisan')));
                eligibleItems.addAll(_musicalInstruments.map((t) => (key: 'tool_${t.key}', name: t.name, subtitle: 'Instrument de musique')));
                eligibleItems.addAll(_otherTools.map((t) => (key: 'tool_${t.key}', name: t.name, subtitle: 'Outil')));
              } else if (isCrafter) {
                featName = 'Don "Artisan" (Crafter)';
                eligibleItems.addAll(_artisanTools.map((t) => (key: 'tool_${t.key}', name: t.name, subtitle: 'Outil d\'artisan')));
              } else if (isMusician) {
                featName = 'Don "Musicien" (Musician)';
                eligibleItems.addAll(_musicalInstruments.map((t) => (key: 'tool_${t.key}', name: t.name, subtitle: 'Instrument de musique')));
              }

              eligibleItems.sort((a, b) => a.name.compareTo(b.name));

              extraSection = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    featName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choisissez 3 maîtrises ($chosenExtra/3 sélectionnées)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  ...eligibleItems.map((item) {
                    final isChecked = wizard.chosenFeatExtraProficiencies.contains(item.key);
                    final canAdd = !isChecked && chosenExtra < maxExtra;
                    return CheckboxListTile(
                      title: Text(item.name),
                      subtitle: Text(item.subtitle),
                      value: isChecked,
                      onChanged: (canAdd || isChecked)
                          ? (v) => notifier.toggleFeatExtraProficiency(item.key)
                          : null,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
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
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Theme.of(context).colorScheme.onSecondaryContainer),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Compétences disponibles pour votre classe',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Text(
                  'Choisissez $maxSkills compétences ($chosen/$maxSkills sélectionnées)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ...displaySkills.map((skill) {
                  final isChosen = wizard.chosenSkillProficiencies.contains(skill.key);
                  final canAdd = !isChosen && chosen < maxSkills;
                  return CheckboxListTile(
                    title: Text(skill.name),
                    subtitle: Text(
                      _abilityLabel(skill.ability),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    value: isChosen,
                    onChanged: (canAdd || isChosen)
                        ? (v) => notifier.toggleSkillProficiency(skill.key)
                        : null,
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                  );
                }),
                if (extraSection != null) extraSection,
              ],
            );
          },
        ),
      ],
    );
  }

  int _skillCountForClass(String classId) {
    const counts = {
      'bard': 3,
      'ranger': 3,
      'rogue': 4,
    };
    return counts[classId] ?? 2;
  }
}

String _abilityLabel(String key) {
  const labels = {
    'str': 'FOR',
    'dex': 'DEX',
    'con': 'CON',
    'int': 'INT',
    'wis': 'SAG',
    'cha': 'CHA',
  };
  return labels[key] ?? key;
}
