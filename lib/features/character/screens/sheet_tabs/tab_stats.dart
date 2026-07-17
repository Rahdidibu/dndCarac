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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Caractéristiques',
                          style: Theme.of(context).textTheme.titleMedium),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        tooltip: 'Modifier les caractéristiques',
                        onPressed: () => _showEditAbilitiesDialog(context, ref, scores),
                      ),
                    ],
                  ),
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
                  ...(() {
                    final sortedEntries = _skillAbilityMap.entries.toList()
                      ..sort((a, b) {
                        const abilityOrder = ['str', 'dex', 'con', 'int', 'wis', 'cha'];
                        final orderA = abilityOrder.indexOf(a.value);
                        final orderB = abilityOrder.indexOf(b.value);
                        if (orderA != orderB) {
                          return orderA.compareTo(orderB);
                        }
                        final nameA = _skillNames[a.key]!;
                        final nameB = _skillNames[b.key]!;
                        return nameA.compareTo(nameB);
                      });
                    return sortedEntries.map((entry) {
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
                    });
                  })(),
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

class _EditAbilitiesDialog extends ConsumerStatefulWidget {
  final int characterId;
  final CharacterAbilityScore scores;

  const _EditAbilitiesDialog({required this.characterId, required this.scores});

  @override
  ConsumerState<_EditAbilitiesDialog> createState() => _EditAbilitiesDialogState();
}

class _EditAbilitiesDialogState extends ConsumerState<_EditAbilitiesDialog> {
  late final TextEditingController _strCtrl;
  late final TextEditingController _dexCtrl;
  late final TextEditingController _conCtrl;
  late final TextEditingController _intCtrl;
  late final TextEditingController _wisCtrl;
  late final TextEditingController _chaCtrl;

  @override
  void initState() {
    super.initState();
    _strCtrl = TextEditingController(text: '${widget.scores.strength}');
    _dexCtrl = TextEditingController(text: '${widget.scores.dexterity}');
    _conCtrl = TextEditingController(text: '${widget.scores.constitution}');
    _intCtrl = TextEditingController(text: '${widget.scores.intelligence}');
    _wisCtrl = TextEditingController(text: '${widget.scores.wisdom}');
    _chaCtrl = TextEditingController(text: '${widget.scores.charisma}');
  }

  @override
  void dispose() {
    _strCtrl.dispose();
    _dexCtrl.dispose();
    _conCtrl.dispose();
    _intCtrl.dispose();
    _wisCtrl.dispose();
    _chaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier les caractéristiques'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildField('Force (STR)', _strCtrl),
            _buildField('Dextérité (DEX)', _dexCtrl),
            _buildField('Constitution (CON)', _conCtrl),
            _buildField('Intelligence (INT)', _intCtrl),
            _buildField('Sagesse (WIS)', _wisCtrl),
            _buildField('Charisme (CHA)', _chaCtrl),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    final str = int.tryParse(_strCtrl.text) ?? widget.scores.strength;
    final dex = int.tryParse(_dexCtrl.text) ?? widget.scores.dexterity;
    final con = int.tryParse(_conCtrl.text) ?? widget.scores.constitution;
    final valInt = int.tryParse(_intCtrl.text) ?? widget.scores.intelligence;
    final wis = int.tryParse(_wisCtrl.text) ?? widget.scores.wisdom;
    final cha = int.tryParse(_chaCtrl.text) ?? widget.scores.charisma;

    await db.characterDao.upsertAbilityScores(
      CharacterAbilityScoresCompanion(
        characterId: Value(widget.characterId),
        strength: Value(str),
        dexterity: Value(dex),
        constitution: Value(con),
        intelligence: Value(valInt),
        wisdom: Value(wis),
        charisma: Value(cha),
      ),
    );

    ref.invalidate(characterAbilityScoresProvider(widget.characterId));

    if (mounted) Navigator.of(context).pop();
  }
}

void _showEditAbilitiesDialog(
    BuildContext context, WidgetRef ref, CharacterAbilityScore scores) {
  showDialog(
    context: context,
    builder: (context) {
      return _EditAbilitiesDialog(characterId: scores.characterId, scores: scores);
    },
  );
}
