part of '../character_sheet_screen.dart';

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
      error: (e, st) => AsyncErrorView(
        error: e,
        stackTrace: st,
        onRetry: () =>
            ref.invalidate(characterAbilityScoresProvider(characterId)),
      ),
      data: (scores) {
        if (scores == null) {
          return Center(
            child: Text(AppLocalizations.of(context)!.sheetScoresNotFound),
          );
        }

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
          error: (e, st) => AsyncErrorView(error: e, stackTrace: st),
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
                      Text(
                        'Caractéristiques',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        tooltip: AppLocalizations.of(context)!.actionEdit,
                        onPressed: () =>
                            _showEditAbilitiesDialog(context, ref, scores),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _AbilityScoreGrid(
                    characterId: characterId,
                    scoreMap: scoreMap,
                  ),
                  const SizedBox(height: 16),

                  // ── Saving throws ────────────────────────────────
                  Text(
                    'Jets de sauvegarde',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
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
                      onRollPressed: () {
                        RollResultDialog.show(
                          context,
                          characterId: characterId,
                          rollType: RollType.save,
                          rollKey: key,
                          title: l10n.rollSaveCheck(label),
                          bonus: total,
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 16),

                  // ── Skills ───────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Compétences',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.edit_note,
                          size: 18,
                          color: AppTheme.neonCyan,
                        ),
                        label: const Text(
                          'Gérer',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.neonCyan,
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => _ManageProficienciesDialog(
                              characterId: characterId,
                              initialProfs: profs,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ...(() {
                    final l10n = AppLocalizations.of(context)!;
                    final sortedEntries = SkillsCatalog.sorted(l10n);
                    return sortedEntries.map((entry) {
                      final skill = entry.key;
                      final ability = entry.ability;
                      final isProficient = profKeys.contains('skill_$skill');
                      final hasExpertise = expertiseKeys.contains(
                        'skill_$skill',
                      );
                      final mod = DndRules.modifier(scoreMap[ability]!);
                      int total = mod;
                      if (hasExpertise) {
                        total += profBonus * 2;
                      } else if (isProficient) {
                        total += profBonus;
                      }
                      final skillLabel = entry.name(l10n);
                      return _ProficiencyRow(
                        label: skillLabel,
                        abbr: _abilityAbbr[ability]!,
                        bonus: total,
                        proficient: isProficient,
                        expertise: hasExpertise,
                        onRollPressed: () {
                          final l10n = AppLocalizations.of(context)!;
                          RollResultDialog.show(
                            context,
                            characterId: characterId,
                            rollType: RollType.skill,
                            rollKey: skill,
                            title: l10n.rollSkillCheck(skillLabel),
                            bonus: total,
                          );
                        },
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
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 8,
      runSpacing: 8,
      children: [
        _StatChip(label: l10n.sheetProficiencyBonus, value: '+$profBonus'),
        _StatChip(
          label: l10n.sheetPassivePerception,
          value: '$passivePerception',
        ),
        _StatChip(
          label: l10n.sheetInitiative,
          value: initiative >= 0 ? '+$initiative' : '$initiative',
        ),
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
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AbilityScoreGrid extends StatelessWidget {
  final int characterId;
  final Map<String, int> scoreMap;
  const _AbilityScoreGrid({required this.characterId, required this.scoreMap});

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
        return Container(
          margin: const EdgeInsets.all(4),
          decoration: AppTheme.neonBorderDecoration(
            accentColor: AppTheme.neonCyan,
            borderRadius: 12,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _abilityAbbr[key]!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neonCyan,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$score',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      modStr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: IconButton(
                  icon: const Icon(
                    Icons.casino,
                    size: 14,
                    color: AppTheme.neonCyan,
                  ),
                  tooltip: AppLocalizations.of(context)!.rollAbilityDieTooltip,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 16,
                  onPressed: () {
                    final l10n = AppLocalizations.of(context)!;
                    final abilityLabel = {
                      'str': l10n.abilityStr,
                      'dex': l10n.abilityDex,
                      'con': l10n.abilityCon,
                      'int': l10n.abilityInt,
                      'wis': l10n.abilityWis,
                      'cha': l10n.abilityCha,
                    }[key]!;
                    RollResultDialog.show(
                      context,
                      characterId: characterId,
                      rollType: RollType.ability,
                      rollKey: key,
                      title: l10n.rollAbilityCheck(abilityLabel),
                      bonus: mod,
                    );
                  },
                ),
              ),
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
  final VoidCallback? onRollPressed;

  const _ProficiencyRow({
    required this.label,
    required this.abbr,
    required this.bonus,
    required this.proficient,
    required this.expertise,
    this.onRollPressed,
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
                : Icon(
                    Icons.circle_outlined,
                    size: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 32,
            child: Text(
              bonusStr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(
            abbr,
            style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
          ),
          if (onRollPressed != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.casino,
                size: 16,
                color: AppTheme.neonCyan,
              ),
              tooltip: AppLocalizations.of(context)!.rollSaveTooltip,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 16,
              onPressed: onRollPressed,
            ),
          ],
        ],
      ),
    );
  }
}

class _EditAbilitiesDialog extends ConsumerStatefulWidget {
  final int characterId;
  final CharacterAbilityScore scores;
  final Character? character;

  const _EditAbilitiesDialog({
    required this.characterId,
    required this.scores,
    this.character,
  });

  @override
  ConsumerState<_EditAbilitiesDialog> createState() =>
      _EditAbilitiesDialogState();
}

class _EditAbilitiesDialogState extends ConsumerState<_EditAbilitiesDialog> {
  late TextEditingController _strCtrl;
  late TextEditingController _dexCtrl;
  late TextEditingController _conCtrl;
  late TextEditingController _intCtrl;
  late TextEditingController _wisCtrl;
  late TextEditingController _chaCtrl;
  late TextEditingController _hpMaxCtrl;
  late TextEditingController _speedCtrl;

  @override
  void initState() {
    super.initState();
    _strCtrl = TextEditingController(text: widget.scores.strength.toString());
    _dexCtrl = TextEditingController(text: widget.scores.dexterity.toString());
    _conCtrl = TextEditingController(
      text: widget.scores.constitution.toString(),
    );
    _intCtrl = TextEditingController(
      text: widget.scores.intelligence.toString(),
    );
    _wisCtrl = TextEditingController(text: widget.scores.wisdom.toString());
    _chaCtrl = TextEditingController(text: widget.scores.charisma.toString());
    _hpMaxCtrl = TextEditingController(
      text: (widget.character?.hpMax ?? 10).toString(),
    );
    _speedCtrl = TextEditingController(
      text: (widget.character?.speed ?? 30).toString(),
    );
  }

  @override
  void dispose() {
    _strCtrl.dispose();
    _dexCtrl.dispose();
    _conCtrl.dispose();
    _intCtrl.dispose();
    _wisCtrl.dispose();
    _chaCtrl.dispose();
    _hpMaxCtrl.dispose();
    _speedCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.sheetEditAbilitiesTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildField('${l10n.abilityStr} (STR)', _strCtrl),
            _buildField('${l10n.abilityDex} (DEX)', _dexCtrl),
            _buildField('${l10n.abilityCon} (CON)', _conCtrl),
            _buildField('${l10n.abilityInt} (INT)', _intCtrl),
            _buildField('${l10n.abilityWis} (WIS)', _wisCtrl),
            _buildField('${l10n.abilityCha} (CHA)', _chaCtrl),
            if (widget.character != null) ...[
              const Divider(),
              _buildField(l10n.sheetHpMax, _hpMaxCtrl),
              _buildField(l10n.sheetSpeed, _speedCtrl),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.actionSave)),
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
          isDense: true,
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

    if (widget.character != null) {
      final hpMax = int.tryParse(_hpMaxCtrl.text) ?? widget.character!.hpMax;
      final speed = int.tryParse(_speedCtrl.text) ?? widget.character!.speed;
      await db.characterDao.updateCharacter(
        CharactersCompanion(
          id: Value(widget.characterId),
          hpMax: Value(hpMax),
          speed: Value(speed),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );
    }

    await CharacterService(db).recalculateCharacterAc(widget.characterId);
    ref.invalidate(characterByIdProvider(widget.characterId));
    ref.invalidate(characterAbilityScoresProvider(widget.characterId));

    if (mounted) Navigator.of(context).pop();
  }
}

void _showEditAbilitiesDialog(
  BuildContext context,
  WidgetRef ref,
  CharacterAbilityScore scores, [
  Character? character,
]) {
  showDialog(
    context: context,
    builder: (context) {
      return _EditAbilitiesDialog(
        characterId: scores.characterId,
        scores: scores,
        character: character,
      );
    },
  );
}
