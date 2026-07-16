import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/utils/character_service.dart';
import '../../../core/utils/dnd_rules.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/character_providers.dart';

class LevelUpScreen extends ConsumerStatefulWidget {
  final int characterId;
  const LevelUpScreen({super.key, required this.characterId});

  @override
  ConsumerState<LevelUpScreen> createState() => _LevelUpScreenState();
}

class _LevelUpScreenState extends ConsumerState<LevelUpScreen> {
  // Selected class to level up (existing or new)
  String? _selectedClassId;
  bool _addNewClass = false;
  String? _selectedSubclassId;

  // HP choice
  int? _rolledHp;
  bool _useAverage = true;

  final _random = Random();

  @override
  Widget build(BuildContext context) {
    final charAsync = ref.watch(characterByIdProvider(widget.characterId));
    final classesAsync = ref.watch(characterClassesProvider(widget.characterId));
    final totalLevelAsync = ref.watch(characterTotalLevelProvider(widget.characterId));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.levelUp),
      ),
      body: charAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (character) {
          if (character == null) return const Center(child: Text('Personnage introuvable'));

          final totalLevel = totalLevelAsync.whenData((v) => v).valueOrNull ?? 1;

          return classesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Erreur: $e')),
            data: (classes) {
              final hitDie = _getHitDie(_selectedClassId ?? (classes.isNotEmpty ? classes.first.classId : null));

              return _buildBody(context, character, classes, totalLevel, hitDie, l10n);
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    Character character,
    List<CharacterClassesData> classes,
    int totalLevel,
    int hitDie,
    AppLocalizations l10n,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final scoresAsync = ref.watch(characterAbilityScoresProvider(widget.characterId));
    final conMod = scoresAsync.maybeWhen(
      data: (s) => s != null ? DndRules.modifier(s.constitution) : 0,
      orElse: () => 0,
    );
    final newLevel = totalLevel + 1;

    // Existing class IDs
    final existingClassIds = classes.map((c) => c.classId).toSet();
    final allClassIds = DndRules.abilityKeys.isEmpty ? <String>[] : _allSrdClassIds;
    final availableNew = allClassIds.where((id) => !existingClassIds.contains(id)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Current state ─────────────────────────────────────────────────
          Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    Text('Niveau actuel', style: const TextStyle(fontSize: 12)),
                    Text('$totalLevel',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ]),
                  const Icon(Icons.arrow_forward, size: 28),
                  Column(children: [
                    Text('Nouveau niveau', style: const TextStyle(fontSize: 12)),
                    Text('$newLevel',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary)),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Class choice ─────────────────────────────────────────────────
          Text('Classe à faire progresser',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          // Toggle existing vs new class
          if (availableNew.isNotEmpty && totalLevel >= 1)
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Classe existante')),
                ButtonSegment(value: true, label: Text('Nouvelle classe')),
              ],
              selected: {_addNewClass},
              onSelectionChanged: (s) => setState(() {
                _addNewClass = s.first;
                _selectedClassId = null;
                _selectedSubclassId = null;
                _rolledHp = null;
              }),
            ),
          const SizedBox(height: 12),

          if (!_addNewClass) ...[
            // Existing classes
            ...classes.map((cls) {
              final isSelected = _selectedClassId == cls.classId;
              return Card(
                color: isSelected ? colorScheme.secondaryContainer : null,
                child: ListTile(
                  title: Text(CharacterService.classDisplayName(cls.classId, l10n)),
                  subtitle: Text('Niveau actuel : ${cls.level}'),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: colorScheme.primary)
                      : const Icon(Icons.radio_button_unchecked),
                  onTap: () => setState(() {
                    _selectedClassId = cls.classId;
                    _selectedSubclassId = cls.subclassId;
                    _rolledHp = null;
                  }),
                ),
              );
            }),
          ] else ...[
            // New class dropdown
            DropdownButtonFormField<String>(
              key: ValueKey(_selectedClassId),
              decoration: const InputDecoration(
                labelText: 'Choisir une nouvelle classe',
                border: OutlineInputBorder(),
              ),
              value: _selectedClassId,
              items: availableNew
                  .map((id) => DropdownMenuItem(
                        value: id,
                        child: Text(CharacterService.classDisplayName(id, l10n)),
                      ))
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedClassId = v;
                _selectedSubclassId = null;
                _rolledHp = null;
              }),
            ),
          ],

          // ── Subclass picker (from level 3) ────────────────────────────────
          if (_selectedClassId != null) ...[
            const SizedBox(height: 16),
            _SubclassPicker(
              characterId: widget.characterId,
              classId: _selectedClassId!,
              currentClasses: classes,
              ruleset: ref
                  .read(characterByIdProvider(widget.characterId))
                  .valueOrNull
                  ?.ruleset,
              selectedSubclassId: _selectedSubclassId,
              onChanged: (v) => setState(() => _selectedSubclassId = v),
            ),
          ],

          // ── HP choice ────────────────────────────────────────────────────
          if (_selectedClassId != null) ...[
            const SizedBox(height: 20),
            Text(l10n.sheetHp, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _HpChoiceWidget(
              hitDie: _getHitDie(_selectedClassId),
              useAverage: _useAverage,
              rolledHp: _rolledHp,
              averageHp: _averageHp,
              conMod: conMod,
              onToggle: (v) => setState(() => _useAverage = v),
              onRoll: () => setState(() {
                _rolledHp = _random.nextInt(_getHitDie(_selectedClassId)) + 1;
                _useAverage = false;
              }),
              onAverageSelected: () => setState(() {
                _useAverage = true;
              }),
            ),
          ],

          // ── Confirm button ────────────────────────────────────────────────
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.arrow_upward),
              label: Text(l10n.levelUp),
              onPressed: _canConfirm() ? () => _confirm(context, l10n) : null,
            ),
          ),
        ],
      ),
    );
  }

  bool _canConfirm() {
    final hp = _useAverage ? _averageHp : _rolledHp;
    return _selectedClassId != null && hp != null;
  }

  int? get _averageHp {
    if (_selectedClassId == null) return null;
    final hitDie = _getHitDie(_selectedClassId);
    final scores = ref.read(characterAbilityScoresProvider(widget.characterId)).value;
    final conMod = scores != null ? DndRules.modifier(scores.constitution) : 0;
    return (hitDie ~/ 2) + 1 + conMod;
  }

  Future<void> _confirm(BuildContext context, AppLocalizations l10n) async {
    final navigator = Navigator.of(context);
    final db = ref.read(databaseProvider);

    // Get actual CON modifier
    final scores = await db.characterDao.getAbilityScores(widget.characterId);
    final conMod = scores != null ? DndRules.modifier(scores.constitution) : 0;

    final hitDie = _getHitDie(_selectedClassId);
    final baseHp = _useAverage
        ? (hitDie ~/ 2) + 1
        : (_rolledHp ?? ((hitDie ~/ 2) + 1));
    final totalHp = (baseHp + conMod).clamp(1, 999);

    await CharacterService(db).levelUp(
      characterId: widget.characterId,
      classId: _selectedClassId!,
      hpGained: totalHp,
      subclassId: _selectedSubclassId,
      addNewClass: _addNewClass,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${CharacterService.classDisplayName(_selectedClassId!, l10n)} a gagné un niveau !'),
          backgroundColor: Colors.green,
        ),
      );
      navigator.pop();
    }
  }

  int _getHitDie(String? classId) {
    const hitDice = {
      'barbarian': 12,
      'fighter': 10,
      'paladin': 10,
      'ranger': 10,
      'bard': 8,
      'cleric': 8,
      'druid': 8,
      'monk': 8,
      'rogue': 8,
      'warlock': 8,
      'sorcerer': 6,
      'wizard': 6,
    };
    return hitDice[classId] ?? 8;
  }

  static const List<String> _allSrdClassIds = [
    'barbarian', 'bard', 'cleric', 'druid', 'fighter',
    'monk', 'paladin', 'ranger', 'rogue', 'sorcerer', 'warlock', 'wizard',
  ];
}

// ─────────────────────────────────────────────────────────────────────────────

class _SubclassPicker extends ConsumerWidget {
  final int characterId;
  final String classId;
  final List<CharacterClassesData> currentClasses;
  final RulesetVersion? ruleset;
  final String? selectedSubclassId;
  final ValueChanged<String?> onChanged;

  const _SubclassPicker({
    required this.characterId,
    required this.classId,
    required this.currentClasses,
    required this.ruleset,
    required this.selectedSubclassId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classEntry = currentClasses.where((c) => c.classId == classId).firstOrNull;
    final level = classEntry?.level ?? 0; // 0 if adding new class (will be 1)
    final nextLevel = level + 1;

    // Subclass typically unlocked at level 3 (varies: Cleric/Sorcerer/Warlock at 1)
    final subclassLevel = ['cleric', 'sorcerer', 'warlock'].contains(classId) ? 1 : 3;
    if (nextLevel < subclassLevel) return const SizedBox.shrink();
    // Already has subclass
    if (classEntry?.subclassId != null && !['', null].contains(classEntry?.subclassId)) {
      return const SizedBox.shrink();
    }

    if (ruleset == null) return const SizedBox.shrink();

    final subclassesAsync = ref.watch(
      srdSubclassesProvider((classId: classId, ruleset: ruleset!)),
    );

    return subclassesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (subclasses) {
        if (subclasses.isEmpty) return const SizedBox.shrink();
        final selectedSubclass = subclasses.where((s) => s.id == selectedSubclassId).firstOrNull;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Archétype / Sous-classe',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              key: ValueKey(selectedSubclassId),
              decoration: const InputDecoration(
                labelText: 'Choisir un archétype',
                border: OutlineInputBorder(),
              ),
              value: selectedSubclassId,
              items: [
                const DropdownMenuItem(value: null, child: Text('— Aucun pour l\'instant —')),
                ...subclasses.map((s) => DropdownMenuItem(
                      value: s.id,
                      child: Text(s.name),
                    )),
              ],
              onChanged: onChanged,
            ),
            if (selectedSubclass != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedSubclass.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedSubclass.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _HpChoiceWidget extends StatelessWidget {
  final int hitDie;
  final bool useAverage;
  final int? rolledHp;
  final int? averageHp;
  final int conMod;
  final ValueChanged<bool> onToggle;
  final VoidCallback onRoll;
  final VoidCallback onAverageSelected;

  const _HpChoiceWidget({
    required this.hitDie,
    required this.useAverage,
    required this.rolledHp,
    required this.averageHp,
    required this.conMod,
    required this.onToggle,
    required this.onRoll,
    required this.onAverageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avg = averageHp ?? ((hitDie ~/ 2) + 1 + conMod);
    final rolledTotal = rolledHp != null ? (rolledHp! + conMod).clamp(1, 999) : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Dé de vie : d$hitDie',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                // Average option
                Expanded(
                  child: InkWell(
                    onTap: onAverageSelected,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: useAverage
                              ? colorScheme.primary
                              : colorScheme.outline,
                          width: useAverage ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.calculate,
                              color: useAverage ? colorScheme.primary : null),
                          const SizedBox(height: 4),
                          Text('Moyenne',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: useAverage ? colorScheme.primary : null)),
                          Text('$avg PV',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: useAverage ? colorScheme.primary : null)),
                          const SizedBox(height: 4),
                          Text(
                            '(Moy. ${hitDie ~/ 2 + 1} + $conMod Con)',
                            style: const TextStyle(fontSize: 9, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Roll option
                Expanded(
                  child: InkWell(
                    onTap: onRoll,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: !useAverage && rolledHp != null
                              ? colorScheme.primary
                              : colorScheme.outline,
                          width: !useAverage && rolledHp != null ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.casino,
                              color: !useAverage && rolledHp != null
                                  ? colorScheme.primary
                                  : null),
                          const SizedBox(height: 4),
                          Text('Lancer le dé',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: !useAverage && rolledHp != null
                                      ? colorScheme.primary
                                      : null)),
                          Text(
                            rolledTotal != null ? '$rolledTotal PV' : '?',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: !useAverage && rolledHp != null
                                    ? colorScheme.primary
                                    : null),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            rolledHp != null ? '(Jet $rolledHp + $conMod Con)' : '(Jet d$hitDie + $conMod Con)',
                            style: const TextStyle(fontSize: 9, color: Colors.grey),
                          ),
                        ],
                      ),
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
