part of '../character_sheet_screen.dart';

// ── Skills list (18 SRD skills mapped to their ability) ──────────────────────
const _skillAbilityMap = {
  'acrobatics': 'dex',
  'animal_handling': 'wis',
  'arcana': 'int',
  'athletics': 'str',
  'deception': 'cha',
  'history': 'int',
  'insight': 'wis',
  'intimidation': 'cha',
  'investigation': 'int',
  'medicine': 'wis',
  'nature': 'int',
  'perception': 'wis',
  'performance': 'cha',
  'persuasion': 'cha',
  'religion': 'int',
  'sleight_of_hand': 'dex',
  'stealth': 'dex',
  'survival': 'wis',
};

const _skillNames = {
  'acrobatics': 'Acrobaties',
  'animal_handling': 'Dressage',
  'arcana': 'Arcanes',
  'athletics': 'Athlétisme',
  'deception': 'Tromperie',
  'history': 'Histoire',
  'insight': 'Perspicacité',
  'intimidation': 'Intimidation',
  'investigation': 'Investigation',
  'medicine': 'Médecine',
  'nature': 'Nature',
  'perception': 'Perception',
  'performance': 'Représentation',
  'persuasion': 'Persuasion',
  'religion': 'Religion',
  'sleight_of_hand': 'Escamotage',
  'stealth': 'Discrétion',
  'survival': 'Survie',
};

const _abilityAbbr = {
  'str': 'FOR',
  'dex': 'DEX',
  'con': 'CON',
  'int': 'INT',
  'wis': 'SAG',
  'cha': 'CHA',
};

class _StatsTab extends ConsumerWidget {
  final int characterId;
  final Character character;
  final int totalLevel;

  const _StatsTab({
    required this.characterId,
    required this.character,
    required this.totalLevel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresAsync = ref.watch(characterAbilityScoresProvider(characterId));
    final profsAsync = ref.watch(characterProficienciesProvider(characterId));
    final profBonus = DndRules.proficiencyBonus(totalLevel);

    return scoresAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur: $e')),
      data: (scores) {
        if (scores == null) return const Center(child: Text('Scores non trouvés'));

        final scoreMap = {
          'str': scores.strength,
          'dex': scores.dexterity,
          'con': scores.constitution,
          'int': scores.intelligence,
          'wis': scores.wisdom,
          'cha': scores.charisma,
        };

        return profsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erreur: $e')),
          data: (profs) {
            final profKeys = profs.map((p) => p.proficiencyKey).toSet();
            final expertiseKeys = profs
                .where((p) => p.hasExpertise)
                .map((p) => p.proficiencyKey)
                .toSet();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Quick stats row ───────────────────────────────
                  _QuickStats(
                    profBonus: profBonus,
                    passivePerception: DndRules.passivePerception(
                      scoreMap['wis']!,
                      profBonus,
                      proficient: profKeys.contains('skill_perception'),
                      expertise: expertiseKeys.contains('skill_perception'),
                    ),
                    initiative: DndRules.initiative(scoreMap['dex']!),
                  ),
                  const SizedBox(height: 16),

                  // ── 6 ability scores ─────────────────────────────
                  Text('Caractéristiques',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _AbilityScoreGrid(scoreMap: scoreMap),
                  const SizedBox(height: 16),

                  // ── Saving throws ────────────────────────────────
                  Text('Jets de sauvegarde',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  ...DndRules.abilityKeys.map((key) {
                    final hasProficiency = profKeys.contains('save_$key');
                    final mod = DndRules.modifier(scoreMap[key]!);
                    final total = mod + (hasProficiency ? profBonus : 0);
                    final l10n = AppLocalizations.of(context)!;
                    final label = {
                      'str': l10n.abilityStr,
                      'dex': l10n.abilityDex,
                      'con': l10n.abilityCon,
                      'int': l10n.abilityInt,
                      'wis': l10n.abilityWis,
                      'cha': l10n.abilityCha,
                    }[key]!;
                    return _ProficiencyRow(
                      label: label,
                      abbr: _abilityAbbr[key]!,
                      bonus: total,
                      proficient: hasProficiency,
                      expertise: false,
                    );
                  }),
                  const SizedBox(height: 16),

                  // ── Skills ───────────────────────────────────────
                  Text('Compétences',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  ..._skillAbilityMap.entries.map((entry) {
                    final skill = entry.key;
                    final ability = entry.value;
                    final isProficient = profKeys.contains('skill_$skill');
                    final hasExpertise = expertiseKeys.contains('skill_$skill');
                    final mod = DndRules.modifier(scoreMap[ability]!);
                    int total = mod;
                    if (hasExpertise) {
                      total += profBonus * 2;
                    } else if (isProficient) {
                      total += profBonus;
                    }
                    return _ProficiencyRow(
                      label: _skillNames[skill]!,
                      abbr: _abilityAbbr[ability]!,
                      bonus: total,
                      proficient: isProficient,
                      expertise: hasExpertise,
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _QuickStats extends StatelessWidget {
  final int profBonus;
  final int passivePerception;
  final int initiative;

  const _QuickStats({
    required this.profBonus,
    required this.passivePerception,
    required this.initiative,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatChip(label: 'Bonus maîtrise', value: '+$profBonus'),
        _StatChip(label: 'Perception passive', value: '$passivePerception'),
        _StatChip(
            label: 'Initiative',
            value: initiative >= 0 ? '+$initiative' : '$initiative'),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary)),
          Text(label,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _AbilityScoreGrid extends StatelessWidget {
  final Map<String, int> scoreMap;
  const _AbilityScoreGrid({required this.scoreMap});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.1,
      children: DndRules.abilityKeys.map((key) {
        final score = scoreMap[key]!;
        final mod = DndRules.modifier(score);
        final modStr = mod >= 0 ? '+$mod' : '$mod';
        final colorScheme = Theme.of(context).colorScheme;
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_abilityAbbr[key]!,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary)),
              Text('$score',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Text(modStr, style: const TextStyle(fontSize: 13)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ProficiencyRow extends StatelessWidget {
  final String label;
  final String abbr;
  final int bonus;
  final bool proficient;
  final bool expertise;

  const _ProficiencyRow({
    required this.label,
    required this.abbr,
    required this.bonus,
    required this.proficient,
    required this.expertise,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bonusStr = bonus >= 0 ? '+$bonus' : '$bonus';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: expertise
                ? Icon(Icons.star, size: 14, color: colorScheme.primary)
                : proficient
                    ? Icon(Icons.circle, size: 10, color: colorScheme.primary)
                    : Icon(Icons.circle_outlined,
                        size: 10,
                        color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 8),
          SizedBox(
              width: 32,
              child: Text(bonusStr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13))),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(abbr,
              style: TextStyle(
                  fontSize: 10, color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
