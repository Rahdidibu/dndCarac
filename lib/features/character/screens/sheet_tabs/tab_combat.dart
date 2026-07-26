part of '../character_sheet_screen.dart';

class _CombatTab extends ConsumerStatefulWidget {
  final int characterId;
  final Character character;
  final int totalLevel;

  const _CombatTab({
    required this.characterId,
    required this.character,
    required this.totalLevel,
  });

  @override
  ConsumerState<_CombatTab> createState() => _CombatTabState();
}

class _CombatTabState extends ConsumerState<_CombatTab> {
  late int _hpCurrent;
  late int _hpTemp;

  // Advanced combat state (session only, not persisted)
  CharacterAttack? _activeWeapon;
  CharacterEquipmentData? _selectedAmmo; // Selected ammo for ranged weapon
  final List<String> _combatLog = [];
  int _rollMode = 0; // -1 = disadvantage, 0 = normal, 1 = advantage

  final _random = Random();

  @override
  void initState() {
    super.initState();
    _hpCurrent = widget.character.hpCurrent;
    _hpTemp = widget.character.hpTemp;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final db = ref.read(databaseProvider);
      await CharacterService(db).ensureHitDiceResourcesExist(widget.characterId);
    });
  }

  Future<void> _saveHp() async {
    final db = ref.read(databaseProvider);
    await db.characterDao.updateCharacter(
      CharactersCompanion(
        id: Value(widget.characterId),
        hpCurrent: Value(_hpCurrent),
        hpTemp: Value(_hpTemp),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  Future<void> _confirmShortRest(BuildContext context) async {
    final db = ref.read(databaseProvider);
    final service = CharacterService(db);
    
    // Recharge les capacités de repos court immédiatement
    await service.shortRest(widget.characterId);

    // Calcul du modificateur de constitution
    final scores = ref.read(characterAbilityScoresProvider(widget.characterId)).value;
    final conScore = scores?.constitution ?? 10;
    final conMod = DndRules.modifier(conScore);

    if (context.mounted) {
      await ShortRestDialog.show(
        context,
        characterId: widget.characterId,
        conMod: conMod,
      );
      
      // Met à jour les PV locaux suite au dialogue
      final updatedChar = await db.characterDao.getCharacterById(widget.characterId);
      if (updatedChar != null && mounted) {
        setState(() {
          _hpCurrent = updatedChar.hpCurrent;
          _hpTemp = updatedChar.hpTemp;
        });
      }
    }
  }

  Future<void> _confirmLongRest(BuildContext context) async {
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

    if (confirmed == true && mounted) {
      final db = ref.read(databaseProvider);
      final service = CharacterService(db);
      await service.longRest(widget.characterId);
      final updatedChar = await db.characterDao.getCharacterById(widget.characterId);
      if (updatedChar != null && mounted) {
        setState(() {
          _hpCurrent = updatedChar.hpCurrent;
          _hpTemp = updatedChar.hpTemp;
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.restSuccessMessage)),
        );
      }
    }
  }

  Future<void> _toggleInspiration(bool value) async {
    final db = ref.read(databaseProvider);
    await db.characterDao.updateCharacter(
      CharactersCompanion(
        id: Value(widget.characterId),
        heroicInspiration: Value(value),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  Future<void> _updateDeathSaves(int successes, int failures) async {
    final db = ref.read(databaseProvider);
    await db.characterDao.updateCharacter(
      CharactersCompanion(
        id: Value(widget.characterId),
        deathSaveSuccesses: Value(successes),
        deathSaveFailures: Value(failures),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  // ── Dice rolling ─────────────────────────────────────────────────────────

  int _rollDie(int sides) => _random.nextInt(sides) + 1;

  int _rollD20() {
    final r1 = _rollDie(20);
    if (_rollMode == 0) return r1;
    final r2 = _rollDie(20);
    if (_rollMode == 1) return r1 > r2 ? r1 : r2;
    return r1 < r2 ? r1 : r2;
  }

  ({int total, String breakdown}) _parseDiceExpression(String expr, {bool crit = false}) {
    // Parse expressions like "1d8+3", "2d6", "1d10-1"
    final pattern = RegExp(r'(\d+)d(\d+)([+-]\d+)?');
    final match = pattern.firstMatch(expr.toLowerCase().replaceAll(' ', ''));
    if (match == null) return (total: 0, breakdown: '??');

    int numDice = int.tryParse(match.group(1) ?? '1') ?? 1;
    final dieSides = int.tryParse(match.group(2) ?? '6') ?? 6;
    final modifier = int.tryParse(match.group(3) ?? '0') ?? 0;

    if (crit) numDice *= 2; // Double dice on crit

    final rolls = List.generate(numDice, (_) => _rollDie(dieSides));
    final diceTotal = rolls.fold(0, (s, r) => s + r);
    final total = diceTotal + modifier;
    final diceStr = rolls.join('+');
    final modStr = modifier != 0 ? (modifier > 0 ? '+$modifier' : '$modifier') : '';
    return (
      total: total,
      breakdown: '${numDice}d$dieSides[$diceStr]$modStr=${total > 0 ? total : 0}',
    );
  }

  void _rollAttack() {
    if (_activeWeapon == null) return;
    final weaponStats = StartingEquipmentHelper.getWeaponStats(_activeWeapon!.name);
    final requiresAmmo = weaponStats?.requiresAmmo ?? false;

    // Block if ranged weapon has no ammo selected or ammo is exhausted
    if (requiresAmmo) {
      if (_selectedAmmo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Choisissez des munitions avant de tirer !'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      if (_selectedAmmo!.quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Plus de ${_selectedAmmo!.itemName} !'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    final ammoBonus = (requiresAmmo && _selectedAmmo != null)
        ? StartingEquipmentHelper.parseAmmoBonus(_selectedAmmo!.itemName, _selectedAmmo!.notes)
        : 0;

    final bonusStr = _activeWeapon!.attackBonus;
    final bonusNum = int.tryParse(bonusStr.replaceAll('+', '')) ?? 0;
    final totalAttackBonus = bonusNum + ammoBonus;
    final l10n = AppLocalizations.of(context)!;
    final ammoName = _selectedAmmo?.itemName;

    RollResultDialog.show(
      context,
      characterId: widget.characterId,
      rollType: RollType.attack,
      title: l10n.rollAttackCheck(_activeWeapon!.name),
      bonus: totalAttackBonus,
      isD20: true,
      onRollCompleted: (total, breakdown) async {
        // Consume 1 ammo
        if (requiresAmmo && _selectedAmmo != null && _selectedAmmo!.quantity > 0) {
          final db = ref.read(databaseProvider);
          final newQty = _selectedAmmo!.quantity - 1;
          await db.characterDao.updateEquipment(
            CharacterEquipmentCompanion(
              id: Value(_selectedAmmo!.id),
              characterId: Value(widget.characterId),
              itemName: Value(_selectedAmmo!.itemName),
              quantity: Value(newQty),
              weight: Value(_selectedAmmo!.weight),
              equipped: Value(_selectedAmmo!.equipped),
              attuned: Value(_selectedAmmo!.attuned),
              notes: Value(_selectedAmmo!.notes),
            ),
          );
          if (newQty == 0 && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('⚠️ Dernière ${ammoName ?? 'munition'} utilisée !'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
        final isCrit = breakdown.contains('d20(20)');
        final isFumble = breakdown.contains('d20(1)');
        final icon = isCrit ? '🎯' : isFumble ? '💀' : '⚔️';
        final suffix = isCrit ? ' CRITIQUE !' : isFumble ? ' FUMBLE !' : '';
        final ammoBonusStr = ammoBonus != 0 ? ' (${ammoBonus >= 0 ? "+$ammoBonus" : "$ammoBonus"})' : '';
        final ammoSuffix = ammoName != null ? ' [$ammoName$ammoBonusStr]' : '';
        setState(() {
          _combatLog.insert(0,
            '$icon [${_activeWeapon!.name}]$ammoSuffix Attaque: $breakdown$suffix'
          );
        });
      },
    );
  }

  void _rollDamage({bool crit = false}) {
    if (_activeWeapon == null) return;

    final weaponStats = StartingEquipmentHelper.getWeaponStats(_activeWeapon!.name);
    final requiresAmmo = weaponStats?.requiresAmmo ?? false;
    final ammoBonus = (requiresAmmo && _selectedAmmo != null)
        ? StartingEquipmentHelper.parseAmmoBonus(_selectedAmmo!.itemName, _selectedAmmo!.notes)
        : 0;

    final damageDice = _activeWeapon!.damageDice;
    final damageType = _activeWeapon!.damageType;
    final l10n = AppLocalizations.of(context)!;

    String expr = damageDice;
    if (crit) {
      final pattern = RegExp(r'(\d+)d(\d+)(.*)');
      final match = pattern.firstMatch(damageDice.toLowerCase().replaceAll(' ', ''));
      if (match != null) {
        final numDice = int.tryParse(match.group(1) ?? '1') ?? 1;
        final dieSides = match.group(2);
        final rest = match.group(3) ?? '';
        expr = '${numDice * 2}d$dieSides$rest';
      }
    }

    RollResultDialog.show(
      context,
      characterId: widget.characterId,
      rollType: RollType.damage,
      title: l10n.rollDamageCheck(_activeWeapon!.name) + (crit ? ' (CRITIQUE)' : ''),
      bonus: ammoBonus,
      isD20: false,
      diceExpression: expr,
      onRollCompleted: (total, breakdown) {
        final ammoName = _selectedAmmo?.itemName;
        final ammoBonusStr = ammoBonus != 0 ? ' (${ammoBonus >= 0 ? "+$ammoBonus" : "$ammoBonus"})' : '';
        final ammoSuffix = ammoName != null ? ' [$ammoName$ammoBonusStr]' : '';
        setState(() {
          _combatLog.insert(0,
            '💥 [${_activeWeapon!.name}]$ammoSuffix Dégâts: $breakdown $damageType'
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final char = widget.character;
    final resourcesAsync = ref.watch(characterResourcesProvider(widget.characterId));
    final attacksAsync = ref.watch(characterAttacksProvider(widget.characterId));
    final equipmentAsync = ref.watch(characterEquipmentProvider(widget.characterId));
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HP tracker ───────────────────────────────────────────────────
          _SectionTitle('Points de vie'),
          const SizedBox(height: 8),
          _HpTracker(
            hpCurrent: _hpCurrent,
            hpMax: char.hpMax,
            hpTemp: _hpTemp,
            onCurrentChanged: (v) {
              setState(() => _hpCurrent = v.clamp(0, char.hpMax + _hpTemp));
              _saveHp();
            },
            onTempChanged: (v) {
              setState(() => _hpTemp = v.clamp(0, 999));
              _saveHp();
            },
          ),
          const SizedBox(height: 16),

          // ── Repos ────────────────────────────────────────────────────────
          _SectionTitle(l10n.restSectionTitle),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.self_improvement, size: 20),
                  label: Text(l10n.restShortRest),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.neonPurple.withValues(alpha: 0.12),
                    foregroundColor: AppTheme.neonPurple,
                    side: BorderSide(color: AppTheme.neonPurple.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _confirmShortRest(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.bedtime, size: 20),
                  label: Text(l10n.restLongRest),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.neonCyan.withValues(alpha: 0.12),
                    foregroundColor: AppTheme.neonCyan,
                    side: BorderSide(color: AppTheme.neonCyan.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _confirmLongRest(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── États & Conditions ───────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionTitle(l10n.conditionsSectionTitle),
              IconButton(
                icon: const Icon(Icons.edit, size: 20, color: AppTheme.neonCyan),
                onPressed: () {
                  ConditionsDialog.show(
                    context,
                    characterId: widget.characterId,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          resourcesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (resources) {
              final activeConditions = resources
                  .where((r) => r.resourceName.startsWith('condition_') && r.current > 0)
                  .toList();

              final hasExhaustion = char.exhaustionLevel > 0;

              if (activeConditions.isEmpty && !hasExhaustion) {
                return Text(
                  l10n.conditionsNoneActive,
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13, fontStyle: FontStyle.italic),
                );
              }

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (hasExhaustion)
                    ActionChip(
                      label: Text('${l10n.conditionExhaustion} (Niv. ${char.exhaustionLevel})'),
                      backgroundColor: AppTheme.neonRed.withValues(alpha: 0.12),
                      side: BorderSide(color: AppTheme.neonRed.withValues(alpha: 0.3)),
                      labelStyle: const TextStyle(color: AppTheme.neonRed, fontWeight: FontWeight.bold, fontSize: 12),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(l10n.conditionExhaustion),
                            content: Text(l10n.conditionExhaustionDesc),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ...activeConditions.map((r) {
                    final key = r.resourceName.replaceFirst('condition_', '');
                    final condName = ConditionsDialog.resolveConditionName(context, key);
                    final condDesc = ConditionsDialog.resolveConditionDesc(context, key);

                    return ActionChip(
                      label: Text(condName),
                      backgroundColor: Colors.amber.withValues(alpha: 0.12),
                      side: BorderSide(color: Colors.amber.withValues(alpha: 0.3)),
                      labelStyle: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(condName),
                            content: Text(condDesc),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // ── Combat stats ─────────────────────────────────────────────────
          _SectionTitle('Combat'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HexagonStatBadge(
                label: 'CA',
                value: '${char.armorClass}',
                icon: Icons.shield_outlined,
                glowColor: AppTheme.neonCyan,
              ),
              HexagonStatBadge(
                label: 'Vitesse',
                value: '${char.speed}m',
                icon: Icons.directions_run_outlined,
                glowColor: AppTheme.neonPurple,
              ),
              HexagonStatBadge(
                label: 'Épuisement',
                value: '${char.exhaustionLevel}/6',
                icon: Icons.warning_amber_outlined,
                glowColor: AppTheme.neonRed,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Inspiration
           Card(
            child: SwitchListTile(
              title: const Text('Inspiration héroïque'),
              value: char.heroicInspiration,
              onChanged: _toggleInspiration,
            ),
          ),
          const SizedBox(height: 16),

          // ── Armor & AC Management ─────────────────────────────────────────
          equipmentAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Erreur équipements: $e'),
            data: (equipment) {
              final armorsAndShields = <({CharacterEquipmentData data, ArmorInfo info})>[];
              for (final item in equipment) {
                final info = CharacterService.parseEquipmentAsArmor(item);
                if (info != null) {
                  armorsAndShields.add((data: item, info: info));
                }
              }

              final scoresAsync = ref.watch(characterAbilityScoresProvider(widget.characterId));
              final classesAsync = ref.watch(characterClassesProvider(widget.characterId));

              return scoresAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (scores) {
                  return classesAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (classes) {
                      final dexScore = scores?.dexterity ?? 10;
                      final conScore = scores?.constitution ?? 10;
                      final wisScore = scores?.wisdom ?? 10;
                      final dexMod = DndRules.modifier(dexScore);
                      final conMod = DndRules.modifier(conScore);
                      final wisMod = DndRules.modifier(wisScore);

                      ArmorInfo? equippedArmor;
                      final equippedShields = <ArmorInfo>[];
                      for (final item in armorsAndShields) {
                        if (item.data.equipped) {
                          if (item.info.type == 'shield') {
                            equippedShields.add(item.info);
                          } else {
                            equippedArmor = item.info;
                          }
                        }
                      }

                      String formula = 'Sans armure';
                      int baseAc = 10;
                      int? maxDex;

                      if (equippedArmor != null) {
                        baseAc = equippedArmor.baseAc;
                        formula = '${equippedArmor.name} (CA base $baseAc)';
                        maxDex = equippedArmor.maxDex;
                      } else {
                        bool isBarbarian = classes.any((c) => c.classId == 'barbarian');
                        bool isMonk = classes.any((c) => c.classId == 'monk');
                        if (isBarbarian) {
                          baseAc = 10 + conMod;
                          formula = 'Défense sans armure (Barbare : 10 + $conMod Con)';
                        } else if (isMonk) {
                          if (equippedShields.isEmpty) {
                            baseAc = 10 + wisMod;
                            formula = 'Défense sans armure (Moine : 10 + $wisMod Sag)';
                          } else {
                            formula = 'Sans armure (Moine, mais bouclier équipé)';
                          }
                        }
                      }

                      int dexBonus = dexMod;
                      String dexText = '${dexMod >= 0 ? "+" : ""}$dexMod Dex';
                      if (maxDex != null) {
                        if (dexBonus > maxDex) {
                          dexBonus = maxDex;
                          dexText = '+ $dexBonus Dex (max $maxDex)';
                        }
                      }

                      String shieldText = '';
                      int shieldBonus = 0;
                      for (final s in equippedShields) {
                        shieldBonus += s.baseAc;
                      }
                      if (shieldBonus > 0) {
                        shieldText = ' + $shieldBonus (Bouclier)';
                      }

                      final finalAc = baseAc + dexBonus + shieldBonus;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.shield, color: Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Gestion de l\'Armure & CA',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Formule : $baseAc ($formula) + $dexText$shieldText = $finalAc CA',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                              const SizedBox(height: 12),

                              if (armorsAndShields.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.info_outline, size: 16),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Aucune armure ou bouclier dans l\'inventaire. Créez-en dans la forge ou ajoutez-en dans l\'onglet Équipement.',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                ...armorsAndShields.map((item) {
                                  return SwitchListTile(
                                    title: Text(item.data.itemName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                      item.info.type == 'shield' ? 'Bouclier (+${item.info.baseAc} CA)' : 'Armure (CA base ${item.info.baseAc})',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    value: item.data.equipped,
                                    dense: true,
                                    onChanged: (val) async {
                                      final db = ref.read(databaseProvider);
                                      if (val && item.info.type != 'shield') {
                                        for (final other in armorsAndShields) {
                                          if (other.data.id != item.data.id && other.info.type != 'shield' && other.data.equipped) {
                                            await db.characterDao.updateEquipment(
                                              CharacterEquipmentCompanion(
                                                id: Value(other.data.id),
                                                characterId: Value(widget.characterId),
                                                itemName: Value(other.data.itemName),
                                                quantity: Value(other.data.quantity),
                                                weight: Value(other.data.weight),
                                                equipped: const Value(false),
                                                attuned: Value(other.data.attuned),
                                                notes: Value(other.data.notes),
                                              ),
                                            );
                                          }
                                        }
                                      }

                                      await db.characterDao.updateEquipment(
                                        CharacterEquipmentCompanion(
                                          id: Value(item.data.id),
                                          characterId: Value(widget.characterId),
                                          itemName: Value(item.data.itemName),
                                          quantity: Value(item.data.quantity),
                                          weight: Value(item.data.weight),
                                          equipped: Value(val),
                                          attuned: Value(item.data.attuned),
                                          notes: Value(item.data.notes),
                                        ),
                                      );
                                      await CharacterService(db).recalculateCharacterAc(widget.characterId);
                                    },
                                  );
                                }),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // ── Death saves ──────────────────────────────────────────────────
          _SectionTitle('Jets de mort'),
          const SizedBox(height: 8),
          _DeathSaveRow(
            successes: char.deathSaveSuccesses,
            failures: char.deathSaveFailures,
            onChanged: _updateDeathSaves,
          ),
          const SizedBox(height: 16),

          // ── Class resources ──────────────────────────────────────────────
          resourcesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (resources) {
              final classResources = resources.where((r) => !r.resourceName.startsWith('condition_')).toList();
              if (classResources.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('Ressources de classe'),
                  const SizedBox(height: 8),
                  ...classResources.map((r) => _ResourceRow(resource: r, characterId: widget.character.id)),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),

          // ── ADVANCED COMBAT MODULE ────────────────────────────────────────
          attacksAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (dbAttacks) {
              final equipment = equipmentAsync.value ?? <CharacterEquipmentData>[];
              final scoresAsync = ref.watch(characterAbilityScoresProvider(widget.characterId));
              final scores = scoresAsync.value;

              final int strScore = scores?.strength ?? 10;
              final int dexScore = scores?.dexterity ?? 10;
              final int strMod = DndRules.modifier(strScore);
              final int dexMod = DndRules.modifier(dexScore);

              // Helper: returns true if an attack name and an equipment item name
              // refer to the same weapon (bidirectional partial match).
              bool nameMatchesItem(String attackName, String itemName) {
                final a = attackName.toLowerCase();
                final b = itemName.toLowerCase();
                return a == b || a.contains(b) || b.contains(a);
              }

              // Determine which inventory item names are UNEQUIPPED weapons.
              // We need to suppress any dbAttack whose name fuzzy-matches an
              // unequipped item (regardless of whether the item was recognised
              // by getWeaponStats — the user might have manually named the weapon).
              final List<CharacterAttack> combinedAttacks = dbAttacks.where((a) {
                // Find a matching inventory item for this attack.
                final matchingItem = equipment.where(
                  (e) => nameMatchesItem(a.name, e.itemName),
                ).firstOrNull;
                // If no inventory item matches, it's a manually-added attack — always show.
                if (matchingItem == null) return true;
                // Otherwise only show if that inventory item is equipped.
                return matchingItem.equipped;
              }).toList();

              // Add virtual attacks for equipped inventory weapons that are not
              // already represented in combinedAttacks.
              for (final item in equipment) {
                if (!item.equipped) continue;
                final weapon = StartingEquipmentHelper.getWeaponStats(item.itemName);
                if (weapon != null) {
                  final nameLower = weapon.name.toLowerCase();
                  final itemLower = item.itemName.toLowerCase();
                  final alreadyExists = combinedAttacks.any((a) =>
                      a.name.toLowerCase() == nameLower ||
                      a.name.toLowerCase() == itemLower);
                  if (!alreadyExists) {
                    int abilityMod;
                    if (weapon.scalingAbility == 'str') {
                      abilityMod = strMod;
                    } else if (weapon.scalingAbility == 'dex') {
                      abilityMod = dexMod;
                    } else { // finesse
                      abilityMod = strMod > dexMod ? strMod : dexMod;
                    }

                    final int totalAttackBonus = abilityMod + 2; // Level 1 is +2
                    final String attackBonusStr = totalAttackBonus >= 0 ? '+$totalAttackBonus' : '$totalAttackBonus';
                    final String damageDiceStr = abilityMod != 0
                        ? '${weapon.baseDice}${abilityMod > 0 ? '+$abilityMod' : '$abilityMod'}'
                        : weapon.baseDice;

                    combinedAttacks.add(
                      CharacterAttack(
                        id: -999 - item.id, // Virtual negative id
                        characterId: widget.characterId,
                        name: item.itemName,
                        attackBonus: attackBonusStr,
                        damageDice: damageDiceStr,
                        damageType: weapon.damageType,
                        masteryProperty: widget.character.ruleset == RulesetVersion.dnd2024 ? weapon.mastery : null,
                        notes: 'Depuis l\'inventaire',
                      ),
                    );
                  }
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionTitle('Armes & Attaques'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Ajouter une attaque',
                        onPressed: () => _showAddAttackDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (combinedAttacks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('Aucune attaque configurée.',
                          style: TextStyle(color: colorScheme.onSurfaceVariant)),
                    )
                  else ...[
                    // Weapon selection cards
                    ...combinedAttacks.map((a) => _WeaponCard(
                      attack: a,
                      isActive: _activeWeapon?.id == a.id,
                      character: widget.character,
                      onTap: () => setState(() {
                        if (_activeWeapon?.id == a.id) {
                          _activeWeapon = null;
                          _selectedAmmo = null;
                        } else {
                          _activeWeapon = a;
                          _selectedAmmo = null; // Reset ammo when switching weapon
                        }
                      }),
                      onDelete: () async {
                        final db = ref.read(databaseProvider);
                        await db.characterDao.deleteAttack(a.id);
                        if (_activeWeapon?.id == a.id) {
                          setState(() => _activeWeapon = null);
                        }
                      },
                    )),

                    // Ammo selector — shown when active weapon requires ammo
                    if (_activeWeapon != null) ...[
                      () {
                        final wStats = StartingEquipmentHelper.getWeaponStats(_activeWeapon!.name);
                        if (wStats?.requiresAmmo != true) return const SizedBox.shrink();
                        final ammoItems = equipment
                            .where((e) => StartingEquipmentHelper.isAmmunitionItem(e.itemName))
                            .toList();
                        if (ammoItems.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber, size: 14, color: Colors.orange),
                                const SizedBox(width: 6),
                                Text(
                                  'Aucune munition dans l\'inventaire',
                                  style: TextStyle(fontSize: 12, color: Colors.orange.shade300),
                                ),
                              ],
                            ),
                          );
                        }
                        return _AmmoSelector(
                          ammoItems: ammoItems,
                          selectedAmmo: _selectedAmmo,
                          onSelected: (ammo) => setState(() => _selectedAmmo = ammo),
                        );
                      }(),
                    ],

                    // Quick combat panel when weapon is active
                    if (_activeWeapon != null) ...[
                      const SizedBox(height: 12),
                      _QuickCombatPanel(
                        activeWeapon: _activeWeapon!,
                        rollMode: _rollMode,
                        onRollModeChanged: (m) => setState(() => _rollMode = m),
                        onRollAttack: _rollAttack,
                        onRollDamage: () => _rollDamage(crit: false),
                        onRollCrit: () => _rollDamage(crit: true),
                      ),
                    ],
                  ],
                  const SizedBox(height: 16),

                  // Combat log
                  if (_combatLog.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SectionTitle('Journal de combat'),
                        TextButton.icon(
                          icon: const Icon(Icons.clear_all, size: 16),
                          label: const Text('Effacer', style: TextStyle(fontSize: 12)),
                          onPressed: () => setState(() => _combatLog.clear()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _combatLog.length,
                        separatorBuilder: (_, _) => const Divider(height: 4),
                        itemBuilder: (_, i) => Text(
                          _combatLog[i],
                          style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: colorScheme.onSurface),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddAttackDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final bonusCtrl = TextEditingController();
    final diceCtrl = TextEditingController();
    final typeCtrl = TextEditingController();
    String? selectedMastery;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter une attaque'),
        content: Consumer(
          builder: (context, ref, child) {
            final masteriesAsync = ref.watch(srdWeaponMasteriesProvider);
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom')),
                  TextField(controller: bonusCtrl, decoration: const InputDecoration(labelText: 'Bonus (ex: +5)')),
                  TextField(controller: diceCtrl, decoration: const InputDecoration(labelText: 'Dégâts (ex: 1d8+3)')),
                  TextField(controller: typeCtrl, decoration: const InputDecoration(labelText: 'Type (ex: perforants)')),
                  if (widget.character.ruleset == RulesetVersion.dnd2024) ...[
                    const SizedBox(height: 16),
                    masteriesAsync.when(
                      loading: () => const SizedBox(
                        height: 40,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Text('Erreur maîtrises: $e'),
                      data: (list) => DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Maîtrise d\'arme (2024)',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: selectedMastery,
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Aucune')),
                          ...list.map((m) => DropdownMenuItem(
                                value: m.id,
                                child: Text(m.name),
                              )),
                        ],
                        onChanged: (v) {
                          selectedMastery = v;
                        },
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Annuler')),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              final db = ref.read(databaseProvider);
              await db.characterDao.insertAttack(CharacterAttacksCompanion.insert(
                characterId: widget.characterId,
                name: nameCtrl.text.trim(),
                attackBonus: bonusCtrl.text.trim().isEmpty ? '+0' : bonusCtrl.text.trim(),
                damageDice: diceCtrl.text.trim().isEmpty ? '—' : diceCtrl.text.trim(),
                damageType: typeCtrl.text.trim().isEmpty ? '—' : typeCtrl.text.trim(),
                masteryProperty: Value(selectedMastery),
              ));
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Advanced Combat Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _WeaponCard extends ConsumerWidget {
  final CharacterAttack attack;
  final bool isActive;
  final Character character;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _WeaponCard({
    required this.attack,
    required this.isActive,
    required this.character,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final scoresAsync = ref.watch(characterAbilityScoresProvider(character.id));
    final totalLevelAsync = ref.watch(characterTotalLevelProvider(character.id));

    String? breakdown;
    if (scoresAsync.hasValue && totalLevelAsync.hasValue) {
      final scores = scoresAsync.value;
      final totalLevel = totalLevelAsync.value ?? 1;
      final profBonus = DndRules.proficiencyBonus(totalLevel);
      final bonusVal = int.tryParse(attack.attackBonus.replaceAll('+', '').replaceAll(' ', '')) ?? 0;

      if (scores != null) {
        final strMod = DndRules.modifier(scores.strength);
        final dexMod = DndRules.modifier(scores.dexterity);
        final conMod = DndRules.modifier(scores.constitution);

        final strSign = strMod >= 0 ? '+$strMod' : '$strMod';
        final dexSign = dexMod >= 0 ? '+$dexMod' : '$dexMod';
        final conSign = conMod >= 0 ? '+$conMod' : '$conMod';
        final profSign = '+$profBonus';

        if (bonusVal == strMod + profBonus) {
          breakdown = 'Force ($strSign) + Maîtrise ($profSign)';
        } else if (bonusVal == dexMod + profBonus) {
          breakdown = 'Dextérité ($dexSign) + Maîtrise ($profSign)';
        } else if (bonusVal == conMod + profBonus) {
          breakdown = 'Constitution ($conSign) + Maîtrise ($profSign)';
        } else if (bonusVal == strMod) {
          breakdown = 'Force ($strSign)';
        } else if (bonusVal == dexMod) {
          breakdown = 'Dextérité ($dexSign)';
        } else {
          final diffStr = bonusVal - strMod - profBonus;
          final diffDex = bonusVal - dexMod - profBonus;
          final diffCon = bonusVal - conMod - profBonus;
          if (diffStr > 0) {
            breakdown = 'Force ($strSign) + Maîtrise ($profSign) + Magie (+$diffStr)';
          } else if (diffDex > 0) {
            breakdown = 'Dextérité ($dexSign) + Maîtrise ($profSign) + Magie (+$diffDex)';
          } else if (diffCon > 0) {
            breakdown = 'Constitution ($conSign) + Maîtrise ($profSign) + Magie (+$diffCon)';
          }
        }
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
          width: isActive ? 2 : 1,
        ),
        color: isActive ? colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                isActive ? Icons.gavel : Icons.gavel_outlined,
                size: 20,
                color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            attack.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isActive ? colorScheme.primary : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('ACTIVE', style: TextStyle(fontSize: 8, color: colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${attack.attackBonus} • ${attack.damageDice} ${attack.damageType}',
                      style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                    ),
                    if (breakdown != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          'Détail : $breakdown',
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    if (character.ruleset == RulesetVersion.dnd2024 && attack.masteryProperty != null && attack.masteryProperty!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: _WeaponMasteryBadge(masteryId: attack.masteryProperty!),
                      ),
                  ],
                ),
              ),
              if (attack.id >= 0)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  onPressed: onDelete,
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.backpack_outlined,
                    size: 18,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickCombatPanel extends StatelessWidget {
  final CharacterAttack activeWeapon;
  final int rollMode;
  final ValueChanged<int> onRollModeChanged;
  final VoidCallback onRollAttack;
  final VoidCallback onRollDamage;
  final VoidCallback onRollCrit;

  const _QuickCombatPanel({
    required this.activeWeapon,
    required this.rollMode,
    required this.onRollModeChanged,
    required this.onRollAttack,
    required this.onRollDamage,
    required this.onRollCrit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.primaryContainer.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Combat rapide — ${activeWeapon.name}',
                style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary, fontSize: 13)),
            const SizedBox(height: 10),
            // Roll mode selector
            Row(
              children: [
                const Text('Mode:', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 8),
                Expanded(
                  child: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: -1, label: Text('Désavantage', style: TextStyle(fontSize: 10))),
                      ButtonSegment(value: 0, label: Text('Normal', style: TextStyle(fontSize: 10))),
                      ButtonSegment(value: 1, label: Text('Avantage', style: TextStyle(fontSize: 10))),
                    ],
                    selected: {rollMode},
                    onSelectionChanged: (s) => onRollModeChanged(s.first),
                    style: const ButtonStyle(
                      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Action buttons
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: onRollAttack,
                    icon: const Text('🎲', style: TextStyle(fontSize: 14)),
                    label: const Text('Attaque (d20)', style: TextStyle(fontSize: 11)),
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRollDamage,
                    icon: const Text('💥', style: TextStyle(fontSize: 12)),
                    label: Text(activeWeapon.damageDice, style: const TextStyle(fontSize: 10)),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onRollCrit,
                    icon: const Text('🎯', style: TextStyle(fontSize: 12)),
                    label: const Text('Critique!', style: TextStyle(fontSize: 10)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withValues(alpha: 0.15),
                      foregroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class _WeaponMasteryBadge extends ConsumerWidget {
  final String masteryId;

  const _WeaponMasteryBadge({required this.masteryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masteryAsync = ref.watch(srdWeaponMasteryByIdProvider(masteryId));

    return masteryAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (mastery) {
        if (mastery == null) return const SizedBox.shrink();
        return InkWell(
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Maîtrise d\'arme : ${mastery.name}'),
                content: Text(mastery.description),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Fermer'),
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 10,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 4),
                Text(
                  mastery.name,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
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

// ─────────────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _HpTracker extends StatelessWidget {
  final int hpCurrent;
  final int hpMax;
  final int hpTemp;
  final ValueChanged<int> onCurrentChanged;
  final ValueChanged<int> onTempChanged;

  const _HpTracker({
    required this.hpCurrent,
    required this.hpMax,
    required this.hpTemp,
    required this.onCurrentChanged,
    required this.onTempChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hpPct = hpMax > 0 ? (hpCurrent / hpMax).clamp(0.0, 1.0) : 0.0;
    final hpColor = hpPct > 0.5
        ? Colors.green
        : hpPct > 0.25
            ? Colors.orange
            : Colors.red;

    return GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      border: Border.all(color: AppTheme.neonRed.withValues(alpha: 0.2), width: 1.2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Minus HP button
              Column(
                children: [
                  Material(
                    color: AppTheme.neonRed.withValues(alpha: 0.12),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.remove, color: AppTheme.neonRed, size: 28),
                      onPressed: () => onCurrentChanged(hpCurrent - 1),
                      tooltip: 'Dégâts (-1 PV)',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Dégâts', style: TextStyle(fontSize: 11, color: AppTheme.neonRed)),
                ],
              ),
              
              // Circular progress
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: CircularProgressIndicator(
                      value: hpPct,
                      strokeWidth: 8,
                      color: hpColor,
                      backgroundColor: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(65),
                    onTap: () {
                      HpModifierDialog.show(
                        context,
                        hpCurrent: hpCurrent,
                        hpMax: hpMax,
                        hpTemp: hpTemp,
                        onHPChanged: onCurrentChanged,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$hpCurrent',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'sur $hpMax',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                          if (hpTemp > 0) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.neonCyan.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.neonCyan.withValues(alpha: 0.3), width: 0.8),
                              ),
                              child: Text(
                                '+$hpTemp Temp',
                                style: const TextStyle(fontSize: 10, color: AppTheme.neonCyan, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Plus HP button
              Column(
                children: [
                  Material(
                    color: AppTheme.neonCyan.withValues(alpha: 0.12),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: AppTheme.neonCyan, size: 28),
                      onPressed: () => onCurrentChanged(hpCurrent + 1),
                      tooltip: 'Soins (+1 PV)',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Soins', style: TextStyle(fontSize: 11, color: AppTheme.neonCyan)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          
          // Temp HP management
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Points de vie temporaires : ',
                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
              ),
              const SizedBox(width: 8),
              Text(
                '$hpTemp',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.neonCyan),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.remove, size: 18, color: AppTheme.neonRed),
                onPressed: () => onTempChanged((hpTemp - 1).clamp(0, 99)),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18, color: AppTheme.neonCyan),
                onPressed: () => onTempChanged(hpTemp + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeathSaveRow extends StatelessWidget {
  final int successes;
  final int failures;
  final void Function(int successes, int failures) onChanged;

  const _DeathSaveRow({
    required this.successes,
    required this.failures,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Text('Succès', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 8),
            ...List.generate(3, (i) => GestureDetector(
                  onTap: () {
                    final newVal = i < successes ? i : i + 1;
                    onChanged(newVal.clamp(0, 3), failures);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      i < successes ? Icons.favorite : Icons.favorite_border,
                      color: Colors.green,
                      size: 22,
                    ),
                  ),
                )),
            const Spacer(),
            const Text('Échecs', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 8),
            ...List.generate(3, (i) => GestureDetector(
                  onTap: () {
                    final newVal = i < failures ? i : i + 1;
                    onChanged(successes, newVal.clamp(0, 3));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      i < failures ? Icons.close : Icons.circle_outlined,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _ResourceRow extends ConsumerWidget {
  final CharacterResource resource;
  final int characterId;

  const _ResourceRow({required this.resource, required this.characterId});

  static String _resolveResourceName(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'resourceRage': return l10n.resourceRage;
      case 'resourceKi': return l10n.resourceKi;
      case 'resourceSorceryPoints': return l10n.resourceSorceryPoints;
      case 'resourceChannelDivinity': return l10n.resourceChannelDivinity;
      case 'resourceWildShape': return l10n.resourceWildShape;
      case 'resourceActionSurge': return l10n.resourceActionSurge;
      case 'resourceLucky': return 'Points de chance (Lucky)';
      case 'hitDice_d6': return l10n.resourceHitDiceD6;
      case 'hitDice_d8': return l10n.resourceHitDiceD8;
      case 'hitDice_d10': return l10n.resourceHitDiceD10;
      case 'hitDice_d12': return l10n.resourceHitDiceD12;
      default: return key;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_resolveResourceName(context, resource.resourceName),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('${resource.current} / ${resource.maximum}',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove, size: 18),
              onPressed: resource.current <= 0
                  ? null
                  : () async {
                      final db = ref.read(databaseProvider);
                      await db.characterDao.upsertResource(
                        CharacterResourcesCompanion(
                          id: Value(resource.id),
                          characterId: Value(characterId),
                          resourceName: Value(resource.resourceName),
                          current: Value(resource.current - 1),
                          maximum: Value(resource.maximum),
                        ),
                      );
                    },
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 18),
              onPressed: resource.current >= resource.maximum
                  ? null
                  : () async {
                      final db = ref.read(databaseProvider);
                      await db.characterDao.upsertResource(
                        CharacterResourcesCompanion(
                          id: Value(resource.id),
                          characterId: Value(characterId),
                          resourceName: Value(resource.resourceName),
                          current: Value(resource.current + 1),
                          maximum: Value(resource.maximum),
                        ),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class HexagonStatBadge extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color glowColor;

  const HexagonStatBadge({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.glowColor = AppTheme.neonCyan,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 105,
      child: CustomPaint(
        painter: _HexagonPainter(color: glowColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: glowColor.withValues(alpha: 0.8), size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.5),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HexagonPainter extends CustomPainter {
  final Color color;

  _HexagonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.cardDark.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Hexagon vertices
    path.moveTo(w * 0.5, 0);
    path.lineTo(w, h * 0.25);
    path.lineTo(w, h * 0.75);
    path.lineTo(w * 0.5, h);
    path.lineTo(0, h * 0.75);
    path.lineTo(0, h * 0.25);
    path.close();

    // Draw shadow/glow
    canvas.drawShadow(path.shift(const Offset(0, 2)), color.withValues(alpha: 0.1), 6, true);
    
    // Draw fill
    canvas.drawPath(path, paint);
    
    // Draw border
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Ammo Selector ────────────────────────────────────────────────────────────

class _AmmoSelector extends StatelessWidget {
  final List<CharacterEquipmentData> ammoItems;
  final CharacterEquipmentData? selectedAmmo;
  final void Function(CharacterEquipmentData) onSelected;

  const _AmmoSelector({
    required this.ammoItems,
    required this.selectedAmmo,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.my_location, size: 14, color: Colors.amber),
              const SizedBox(width: 6),
              const Text(
                'Munitions',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: ammoItems.map((ammo) {
              final isSelected = selectedAmmo?.id == ammo.id;
              final outOfStock = ammo.quantity <= 0;
              final ammoBonus = StartingEquipmentHelper.parseAmmoBonus(ammo.itemName, ammo.notes);
              return GestureDetector(
                onTap: outOfStock ? null : () => onSelected(ammo),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.amber.withValues(alpha: 0.25)
                        : outOfStock
                            ? Colors.red.withValues(alpha: 0.08)
                            : Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.amber
                          : outOfStock
                              ? Colors.red.withValues(alpha: 0.4)
                              : Colors.white24,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(Icons.check, size: 12, color: Colors.amber),
                        ),
                      Text(
                        ammo.itemName,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.amber
                              : outOfStock
                                  ? Colors.red.shade300
                                  : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          decoration: outOfStock ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (ammoBonus != 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: (ammoBonus > 0 ? AppTheme.neonCyan : AppTheme.neonRed).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: (ammoBonus > 0 ? AppTheme.neonCyan : AppTheme.neonRed).withValues(alpha: 0.5),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            ammoBonus > 0 ? '+$ammoBonus' : '$ammoBonus',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: ammoBonus > 0 ? AppTheme.neonCyan : AppTheme.neonRed,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: outOfStock
                              ? Colors.red.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${ammo.quantity}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: outOfStock ? Colors.red : Colors.white54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (selectedAmmo == null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '← Sélectionnez des munitions pour tirer',
                style: TextStyle(fontSize: 10, color: Colors.orange.shade300, fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }
}
