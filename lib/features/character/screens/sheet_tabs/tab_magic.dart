part of '../character_sheet_screen.dart';

class _MagicTab extends ConsumerWidget {
  final int characterId;
  final Character character;

  const _MagicTab({required this.characterId, required this.character});

  int _computePrepLimit(List<CharacterClassesData> classes, Map<String, int> scoreMap) {
    int limit = 0;
    bool hasPreparingClass = false;

    for (final c in classes) {
      final cid = c.classId;
      final lvl = c.level;
      if (cid == 'wizard') {
        hasPreparingClass = true;
        final score = scoreMap['int'] ?? 10;
        final mod = DndRules.modifier(score);
        limit += max(1, lvl + mod);
      } else if (cid == 'cleric') {
        hasPreparingClass = true;
        final score = scoreMap['wis'] ?? 10;
        final mod = DndRules.modifier(score);
        limit += max(1, lvl + mod);
      } else if (cid == 'druid') {
        hasPreparingClass = true;
        final score = scoreMap['wis'] ?? 10;
        final mod = DndRules.modifier(score);
        limit += max(1, lvl + mod);
      } else if (cid == 'paladin') {
        hasPreparingClass = true;
        final score = scoreMap['cha'] ?? 10;
        final mod = DndRules.modifier(score);
        limit += max(1, (lvl ~/ 2) + mod);
      }
    }

    return hasPreparingClass ? limit : -1;
  }

  String _determineSpellcastingAbility(List<CharacterClassesData> classes) {
    if (classes.isEmpty) return 'int';
    final firstClass = classes.first.classId;
    if (['cleric', 'druid', 'ranger'].contains(firstClass)) return 'wis';
    if (['bard', 'paladin', 'sorcerer', 'warlock'].contains(firstClass)) return 'cha';
    return 'int';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slotsAsync = ref.watch(characterSpellSlotsProvider(characterId));
    final spellsAsync = ref.watch(characterSpellsProvider(characterId));
    final srdSpellsAsync = ref.watch(srdSpellsProvider(character.ruleset));
    final classesAsync = ref.watch(characterClassesProvider(characterId));
    final scoresAsync = ref.watch(characterAbilityScoresProvider(characterId));
    final totalLevelAsync = ref.watch(characterTotalLevelProvider(characterId));
    final equipmentAsync = ref.watch(characterEquipmentProvider(characterId));
    final proficienciesAsync = ref.watch(characterProficienciesProvider(characterId));

    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Spell slots ───────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Emplacements de sorts',
                  style: Theme.of(context).textTheme.titleMedium),
              TextButton.icon(
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(l10n.restLongRest, style: const TextStyle(fontSize: 12)),
                onPressed: () => _longRest(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 8),
          slotsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Erreur: $e'),
            data: (slots) {
              if (slots.isEmpty) {
                return Text('Aucun emplacement de sort.',
                    style: TextStyle(color: colorScheme.onSurfaceVariant));
              }
              return Column(
                children: slots
                    .map((slot) => _SpellSlotRow(
                          slot: slot,
                          characterId: characterId,
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 16),

          // ── Spells list ───────────────────────────────────────────────────
          classesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Erreur: $e'),
            data: (classes) => scoresAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Erreur: $e'),
              data: (scores) => totalLevelAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Erreur: $e'),
                data: (totalLevel) {
                  final scoreMap = {
                    'str': scores?.strength ?? 10,
                    'dex': scores?.dexterity ?? 10,
                    'con': scores?.constitution ?? 10,
                    'int': scores?.intelligence ?? 10,
                    'wis': scores?.wisdom ?? 10,
                    'cha': scores?.charisma ?? 10,
                  };
                  final prepLimit = _computePrepLimit(classes, scoreMap);
                  final castingAbility = _determineSpellcastingAbility(classes);
                  final castingScore = scoreMap[castingAbility] ?? 10;
                  final castingMod = DndRules.modifier(castingScore);
                  final profBonus = DndRules.proficiencyBonus(totalLevel);
                  final spellAttackBonus = castingMod + profBonus;

                  // ── Armor proficiency check for spellcasting block ───────────
                  final equipment = equipmentAsync.value ?? [];
                  final profKeys = (proficienciesAsync.value ?? [])
                      .map((p) => p.proficiencyKey).toSet();
                  final hasArmorAll = profKeys.contains('armor_all');
                  String? badArmorName;
                  for (final item in equipment) {
                    if (!item.equipped) continue;
                    final kind = CharacterServiceHelper.parseEquipmentKind(item.itemName);
                    if (kind == null) continue;
                    final ok = switch (kind) {
                      'shield' => profKeys.contains('armor_shield') || hasArmorAll,
                      'light'  => profKeys.contains('armor_light')  || profKeys.contains('armor_medium') || hasArmorAll,
                      'medium' => profKeys.contains('armor_medium') || hasArmorAll,
                      'heavy'  => profKeys.contains('armor_heavy')  || hasArmorAll,
                      _        => true,
                    };
                    if (!ok) { badArmorName = item.itemName; break; }
                  }
                  final blockedByArmor = badArmorName != null;

                  return slotsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => const SizedBox(),
                    data: (slots) => spellsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Erreur: $e'),
                      data: (spells) {
                        final preparedSpells = spells.where((s) => s.prepared).toList();
                        // Cantrips do not count towards preparation limit
                        final preparedCount = spells.where((s) {
                          // Find level of spell to check if it's not a cantrip
                          final srdSpells = srdSpellsAsync.value;
                          if (srdSpells == null) return s.prepared;
                          final match = srdSpells.firstWhere((x) => x.id == s.spellId, orElse: () => const SrdSpell(
                            id: '', name: '', level: 0, school: '', castingTime: '', range: '',
                            components: '', duration: '', concentration: false, ritual: false, description: '', classes: '', ruleset: RulesetVersion.dnd2014, isCustom: false,
                          ));
                          return s.prepared && match.level > 0;
                        }).length;

                        final srdSpellsLoaded = srdSpellsAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Text('Erreur compendium: $e'),
                          data: (srdList) {
                            final srdMap = {for (final s in srdList) s.id: s};
                            final grouped = <int, List<({CharacterSpell charSpell, SrdSpell srdSpell})>>{};

                            for (final s in spells) {
                              final details = srdMap[s.spellId];
                              if (details != null) {
                                grouped.putIfAbsent(details.level, () => []).add((charSpell: s, srdSpell: details));
                              } else {
                                final dummySrd = SrdSpell(
                                  id: s.spellId,
                                  name: s.spellId,
                                  level: 0,
                                  school: '',
                                  castingTime: '',
                                  range: '',
                                  components: '[]',
                                  duration: '',
                                  concentration: false,
                                  ritual: false,
                                  classes: '[]',
                                  description: 'Description non disponible.',
                                  ruleset: character.ruleset,
                                  isCustom: false,
                                );
                                grouped.putIfAbsent(0, () => []).add((charSpell: s, srdSpell: dummySrd));
                              }
                            }

                            final sortedLevels = grouped.keys.toList()..sort();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: sortedLevels.map((lvl) {
                                final list = grouped[lvl]!;
                                final levelName = lvl == 0 ? 'Tours de magie (Niveau 0)' : 'Sorts de Niveau $lvl';

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                                      child: Text(
                                        levelName,
                                        style: const TextStyle(
                                          fontFamily: 'Cinzel',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppTheme.neonPurple,
                                        ),
                                      ),
                                    ),
                                    ...list.map((item) => _SpellListTile(
                                          charSpell: item.charSpell,
                                          srdSpell: item.srdSpell,
                                          characterId: characterId,
                                          slots: slots,
                                          prepLimit: prepLimit,
                                          preparedCount: preparedCount,
                                          spellAttackBonus: spellAttackBonus,
                                          blockedByArmor: blockedByArmor,
                                        )),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Sorts connus / préparés',
                                        style: Theme.of(context).textTheme.titleMedium),
                                    if (prepLimit != -1) ...[
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            'Sorts préparés : $preparedCount / $prepLimit',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: preparedCount > prepLimit ? AppTheme.neonRed : Colors.grey,
                                            ),
                                          ),
                                          if (preparedCount > prepLimit) ...[
                                            const SizedBox(width: 4),
                                            const Icon(Icons.warning_amber_rounded, size: 14, color: AppTheme.neonRed),
                                          ]
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.library_books, size: 16),
                                  label: const Text('Gérer', style: TextStyle(fontSize: 12)),
                                  onPressed: () => Navigator.of(context).pushNamed(
                                    '/spells',
                                    arguments: characterId,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (blockedByArmor)
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.neonRed.withValues(alpha: 0.12),
                                  border: Border.all(color: AppTheme.neonRed),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.block, color: AppTheme.neonRed, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '⚠️ Incantation impossible\n$badArmorName : armure/bouclier non maîtrisé',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.neonRed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (spells.isEmpty)
                              Text('Aucun sort. Utilisez "Gérer" pour en ajouter.',
                                  style: TextStyle(color: colorScheme.onSurfaceVariant))
                            else
                              srdSpellsLoaded,
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _longRest(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.restLongRest),
        content: Text(l10n.restLongRestConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.actionConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      final service = CharacterService(db);
      await service.longRest(characterId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.restSuccessMessage)),
        );
      }
    }
  }
}

class _SpellSlotRow extends ConsumerWidget {
  final CharacterSpellSlot slot;
  final int characterId;

  const _SpellSlotRow({required this.slot, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer,
              ),
              child: Text(
                '${slot.slotLevel}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: List.generate(slot.slotMax, (i) {
                  final used = i >= slot.slotCurrent;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: GestureDetector(
                      onTap: () => _toggleSlot(ref, i),
                      child: Icon(
                        used ? Icons.diamond_outlined : Icons.diamond,
                        size: 22,
                        color: used
                            ? Colors.white.withValues(alpha: 0.15)
                            : AppTheme.neonPurple,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Text('${slot.slotCurrent}/${slot.slotMax}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleSlot(WidgetRef ref, int index) async {
    final db = ref.read(databaseProvider);
    final newCurrent = index < slot.slotCurrent
        ? slot.slotCurrent - 1
        : slot.slotCurrent + 1;
    await db.characterDao.updateSpellSlot(
      CharacterSpellSlotsCompanion(
        id: Value(slot.id),
        characterId: Value(characterId),
        slotLevel: Value(slot.slotLevel),
        slotMax: Value(slot.slotMax),
        slotCurrent: Value(newCurrent.clamp(0, slot.slotMax)),
      ),
    );
  }
}

class _SpellListTile extends ConsumerWidget {
  final CharacterSpell charSpell;
  final SrdSpell srdSpell;
  final int characterId;
  final List<CharacterSpellSlot> slots;
  final int prepLimit;
  final int preparedCount;
  final int spellAttackBonus;
  final bool blockedByArmor;

  const _SpellListTile({
    required this.charSpell,
    required this.srdSpell,
    required this.characterId,
    required this.slots,
    required this.prepLimit,
    required this.preparedCount,
    required this.spellAttackBonus,
    this.blockedByArmor = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isCantrip = srdSpell.level == 0;
    final canCast = (isCantrip || charSpell.prepared) && !blockedByArmor;

    final descriptionLower = srdSpell.description.toLowerCase();
    final hasSpellAttack = descriptionLower.contains('spell attack') ||
                           descriptionLower.contains('attaque de sort') ||
                           descriptionLower.contains('jet d\'attaque de sort');

    final diceRegex = RegExp(r'(\d+d\d+)');
    final match = diceRegex.firstMatch(descriptionLower);
    final damageFormula = match?.group(1);

    return Card(
      child: ListTile(
        leading: isCantrip
            ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.star, color: Colors.amber, size: 16),
              )
            : IconButton(
                icon: Icon(
                  charSpell.prepared ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: charSpell.prepared ? AppTheme.neonPurple : Colors.grey,
                ),
                tooltip: charSpell.prepared ? 'Préparé (cliquer pour retirer)' : 'Non préparé (cliquer pour préparer)',
                onPressed: () => _togglePreparation(context, ref),
              ),
        title: Text(srdSpell.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(
          srdSpell.level == 0 ? 'Tour de magie • ${srdSpell.school}' : 'Niveau ${srdSpell.level} • ${srdSpell.school}',
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (blockedByArmor)
              const Tooltip(
                message: 'Incantation impossible : armure/bouclier non maîtrisé',
                child: Icon(Icons.block, color: AppTheme.neonRed, size: 20),
              ),
            if (canCast) ...[
              IconButton(
                icon: const Icon(Icons.bolt, color: AppTheme.neonCyan),
                tooltip: 'Lancer le sort',
                onPressed: () => _castSpell(context, ref),
              ),
              if (hasSpellAttack)
                IconButton(
                  icon: const Icon(Icons.gps_fixed, color: AppTheme.neonCyan, size: 20),
                  tooltip: 'Jet d\'attaque magique (d20 + $spellAttackBonus)',
                  onPressed: () {
                    RollResultDialog.show(
                      context,
                      characterId: characterId,
                      rollType: RollType.attack,
                      title: 'Attaque magique : ${srdSpell.name}',
                      bonus: spellAttackBonus,
                    );
                  },
                ),
              if (damageFormula != null)
                IconButton(
                  icon: const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                  tooltip: 'Dégâts ($damageFormula)',
                  onPressed: () {
                    RollResultDialog.show(
                      context,
                      characterId: characterId,
                      rollType: RollType.damage,
                      title: 'Dégâts : ${srdSpell.name}',
                      bonus: 0,
                      isD20: false,
                      diceExpression: damageFormula,
                    );
                  },
                ),
            ],
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: AppTheme.neonRed),
              tooltip: 'Supprimer',
              onPressed: () async {
                final db = ref.read(databaseProvider);
                await db.characterDao.deleteCharacterSpell(charSpell.id);
              },
            ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(srdSpell.name, style: const TextStyle(fontFamily: 'Cinzel')),
              content: SingleChildScrollView(
                child: Text(srdSpell.description),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Fermer'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _togglePreparation(BuildContext context, WidgetRef ref) async {
    // If not prepared and we are trying to prepare but reached the limit
    if (!charSpell.prepared && prepLimit != -1 && preparedCount >= prepLimit) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber),
              SizedBox(width: 8),
              Text('Limite de préparation'),
            ],
          ),
          content: Text('Vous avez déjà préparé le nombre maximum autorisé de sorts ($prepLimit). Retirez d\'abord un autre sort de votre préparation.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    await db.characterDao.updateCharacterSpell(
      CharacterSpellsCompanion(
        id: Value(charSpell.id),
        characterId: Value(characterId),
        spellId: Value(charSpell.spellId),
        ruleset: Value(charSpell.ruleset),
        prepared: Value(!charSpell.prepared),
      ),
    );
  }

  Future<void> _castSpell(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final level = srdSpell.level;

    if (level == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✨ Lancement de ${srdSpell.name} ! (Sort mineur)'),
          backgroundColor: AppTheme.neonCyan,
        ),
      );
      return;
    }

    final matchingSlot = slots.firstWhere(
      (s) => s.slotLevel == level,
      orElse: () => CharacterSpellSlot(
        id: -1,
        characterId: characterId,
        slotLevel: level,
        slotMax: 0,
        slotCurrent: 0,
      ),
    );

    if (matchingSlot.id != -1 && matchingSlot.slotCurrent > 0) {
      final db = ref.read(databaseProvider);
      await db.characterDao.updateSpellSlot(
        CharacterSpellSlotsCompanion(
          id: Value(matchingSlot.id),
          characterId: Value(characterId),
          slotLevel: Value(matchingSlot.slotLevel),
          slotMax: Value(matchingSlot.slotMax),
          slotCurrent: Value(matchingSlot.slotCurrent - 1),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🔥 Lancement de ${srdSpell.name} ! (Emplacement Niv. $level dépensé)'),
          backgroundColor: AppTheme.neonPurple,
        ),
      );
    } else {
      final higherSlots = slots.where((s) => s.slotLevel > level && s.slotCurrent > 0).toList();

      if (higherSlots.isEmpty) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: AppTheme.neonRed),
                SizedBox(width: 8),
                Text('Pas d\'emplacements'),
              ],
            ),
            content: Text('Vous n\'avez plus d\'emplacements de sort de niveau $level ou supérieur disponible pour lancer ${srdSpell.name}.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Surclasser ${srdSpell.name} ?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aucun emplacement de niveau $level disponible. Souhaitez-vous le lancer à un niveau supérieur ?'),
                const SizedBox(height: 12),
                ...higherSlots.map((slot) => ListTile(
                      title: Text('Niveau ${slot.slotLevel}'),
                      subtitle: Text('${slot.slotCurrent}/${slot.slotMax} disponibles'),
                      trailing: const Icon(Icons.bolt, color: AppTheme.neonCyan),
                      onTap: () async {
                        Navigator.of(ctx).pop();
                        final db = ref.read(databaseProvider);
                        await db.characterDao.updateSpellSlot(
                          CharacterSpellSlotsCompanion(
                            id: Value(slot.id),
                            characterId: Value(characterId),
                            slotLevel: Value(slot.slotLevel),
                            slotMax: Value(slot.slotMax),
                            slotCurrent: Value(slot.slotCurrent - 1),
                          ),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('🔥 Lancement de ${srdSpell.name} ! (Emplacement Niv. ${slot.slotLevel} dépensé)'),
                              backgroundColor: AppTheme.neonPurple,
                            ),
                          );
                        }
                      },
                    )),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.actionCancel),
              ),
            ],
          ),
        );
      }
    }
  }
}
