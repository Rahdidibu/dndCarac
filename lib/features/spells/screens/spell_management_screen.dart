import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../character/providers/character_providers.dart';
import '../../../core/utils/dnd_rules.dart';
import '../../../core/utils/character_service.dart';
import '../../../core/utils/string_utils.dart';

class SpellManagementScreen extends ConsumerStatefulWidget {
  final int characterId;
  const SpellManagementScreen({super.key, required this.characterId});

  @override
  ConsumerState<SpellManagementScreen> createState() =>
      _SpellManagementScreenState();
}

class _SpellManagementScreenState
    extends ConsumerState<SpellManagementScreen> {
  String _searchQuery = '';
  int? _filterLevel;
  String? _filterSchool;
  bool? _filterConcentration;
  bool? _filterRitual;
  bool? _filterVocal;
  bool? _filterSomatic;
  bool? _filterMaterial;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final charAsync = ref.watch(characterByIdProvider(widget.characterId));
    final mySpellsAsync = ref.watch(characterSpellsProvider(widget.characterId));

    return charAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur: $e'))),
      data: (character) {
        if (character == null) return const Scaffold(body: SizedBox());

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Sorts'),
              bottom: TabBar(
                onTap: (_) {},
                tabs: [
                  Tab(text: l10n.spellsCompendium),
                  Tab(text: l10n.spellsMySpells),
                ],
              ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // ── Tab 0: Compendium ──────────────────────────────────────
                _CompendiumTab(
                  characterId: widget.characterId,
                  ruleset: character.ruleset,
                  searchQuery: _searchQuery,
                  filterLevel: _filterLevel,
                  filterSchool: _filterSchool,
                  filterConcentration: _filterConcentration,
                  filterRitual: _filterRitual,
                  filterVocal: _filterVocal,
                  filterSomatic: _filterSomatic,
                  filterMaterial: _filterMaterial,
                  onSearchChanged: (v) => setState(() => _searchQuery = v),
                  onLevelChanged: (v) => setState(() => _filterLevel = v),
                  onSchoolChanged: (v) => setState(() => _filterSchool = v),
                  onConcentrationChanged: (v) => setState(() => _filterConcentration = v),
                  onRitualChanged: (v) => setState(() => _filterRitual = v),
                  onVocalChanged: (v) => setState(() => _filterVocal = v),
                  onSomaticChanged: (v) => setState(() => _filterSomatic = v),
                  onMaterialChanged: (v) => setState(() => _filterMaterial = v),
                  onResetFilters: () => setState(() {
                    _searchQuery = '';
                    _filterLevel = null;
                    _filterSchool = null;
                    _filterConcentration = null;
                    _filterRitual = null;
                    _filterVocal = null;
                    _filterSomatic = null;
                    _filterMaterial = null;
                  }),
                ),
                // ── Tab 1: My spells ───────────────────────────────────────
                mySpellsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Erreur: $e')),
                  data: (mySpells) => _MySpellsTab(
                    characterId: widget.characterId,
                    mySpells: mySpells,
                    ruleset: character.ruleset,
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

class _CompendiumTab extends ConsumerWidget {
  final int characterId;
  final RulesetVersion ruleset;
  final String searchQuery;
  final int? filterLevel;
  final String? filterSchool;
  final bool? filterConcentration;
  final bool? filterRitual;
  final bool? filterVocal;
  final bool? filterSomatic;
  final bool? filterMaterial;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int?> onLevelChanged;
  final ValueChanged<String?> onSchoolChanged;
  final ValueChanged<bool?> onConcentrationChanged;
  final ValueChanged<bool?> onRitualChanged;
  final ValueChanged<bool?> onVocalChanged;
  final ValueChanged<bool?> onSomaticChanged;
  final ValueChanged<bool?> onMaterialChanged;
  final VoidCallback onResetFilters;

  const _CompendiumTab({
    required this.characterId,
    required this.ruleset,
    required this.searchQuery,
    required this.filterLevel,
    required this.filterSchool,
    required this.filterConcentration,
    required this.filterRitual,
    required this.filterVocal,
    required this.filterSomatic,
    required this.filterMaterial,
    required this.onSearchChanged,
    required this.onLevelChanged,
    required this.onSchoolChanged,
    required this.onConcentrationChanged,
    required this.onRitualChanged,
    required this.onVocalChanged,
    required this.onSomaticChanged,
    required this.onMaterialChanged,
    required this.onResetFilters,
  });

  bool _matchesComponent(SrdSpell spell, String compChar) {
    try {
      final decoded = jsonDecode(spell.components);
      if (decoded is List) {
        return decoded.any((element) => element.toString().toUpperCase().contains(compChar));
      }
    } catch (_) {}
    return spell.components.toUpperCase().contains(compChar);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mySpellsAsync = ref.watch(characterSpellsProvider(characterId));
    final classesAsync = ref.watch(characterClassesProvider(characterId));
    final colorScheme = Theme.of(context).colorScheme;

    return mySpellsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur: $e')),
      data: (mySpells) {
        final mySpellIds = mySpells.map((s) => s.spellId).toSet();

        return classesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erreur: $e')),
          data: (classes) {
            return FutureBuilder<List<SrdSpell>>(
              future: ref.read(databaseProvider).compendiumDao.getAllSpells(ruleset),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var spells = snap.data!;

                // Compute allowed classes and their max levels
                final allowedClasses = <String, int>{};
                for (final c in classes) {
                  final cid = c.classId;
                  final lvl = c.level;
                  if (cid == 'wizard' ||
                      cid == 'sorcerer' ||
                      cid == 'warlock' ||
                      cid == 'bard' ||
                      cid == 'cleric' ||
                      cid == 'druid' ||
                      cid == 'paladin' ||
                      cid == 'ranger') {
                    final maxL = DndRules.maxSpellLevelForClass(cid, lvl);
                    final existingMax = allowedClasses[cid];
                    allowedClasses[cid] = (existingMax == null || maxL > existingMax) ? maxL : existingMax;
                  } else if (cid == 'rogue' && c.subclassId == 'arcane-trickster') {
                    final maxL = DndRules.maxSpellLevelForClass('rogue', lvl);
                    final existingMax = allowedClasses['wizard'];
                    allowedClasses['wizard'] = (existingMax == null || maxL > existingMax) ? maxL : existingMax;
                  } else if (cid == 'fighter' && c.subclassId == 'eldritch-knight') {
                    final maxL = DndRules.maxSpellLevelForClass('fighter', lvl);
                    final existingMax = allowedClasses['wizard'];
                    allowedClasses['wizard'] = (existingMax == null || maxL > existingMax) ? maxL : existingMax;
                  }
                }

                if (allowedClasses.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 48, color: colorScheme.error),
                          const SizedBox(height: 16),
                          Text(
                            "Votre personnage n'a pas de classe ou de sous-classe lui permettant d'apprendre des sorts.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Filter spells list
                spells = spells.where((s) {
                  try {
                    final spellClassesList = jsonDecode(s.classes) as List;
                    for (final sc in spellClassesList) {
                      final scStr = sc.toString();
                      if (allowedClasses.containsKey(scStr)) {
                        if (s.level <= allowedClasses[scStr]!) {
                          return true;
                        }
                      }
                    }
                  } catch (_) {}
                  return false;
                }).toList();

                // Apply filters
                if (searchQuery.isNotEmpty) {
                  final q = searchQuery.toLowerCase();
                  spells = spells
                      .where((s) => s.name.toLowerCase().contains(q))
                      .toList();
                }
                if (filterLevel != null) {
                  spells = spells.where((s) => s.level == filterLevel).toList();
                }
                if (filterSchool != null) {
                  spells = spells
                      .where((s) =>
                          s.school.toLowerCase() == filterSchool!.toLowerCase())
                      .toList();
                }
                if (filterConcentration == true) {
                  spells = spells.where((s) => s.concentration).toList();
                }
                if (filterRitual == true) {
                  spells = spells.where((s) => s.ritual).toList();
                }
                if (filterVocal == true) {
                  spells = spells.where((s) => _matchesComponent(s, 'V')).toList();
                }
                if (filterSomatic == true) {
                  spells = spells.where((s) => _matchesComponent(s, 'S')).toList();
                }
                if (filterMaterial == true) {
                  spells = spells.where((s) => _matchesComponent(s, 'M')).toList();
                }

                // Sort by level ascending, then name ascending (accent insensitive)
                spells.sort((a, b) {
                  final levelCmp = a.level.compareTo(b.level);
                  if (levelCmp != 0) return levelCmp;
                  return StringUtils.compareAlphabetically(a.name, b.name);
                });

                // Schools list for filter
                final allSchools = snap.data!
                    .map((s) => s.school)
                    .toSet()
                    .toList()
                  ..sort();

                final hasAnyActiveFilter = filterLevel != null ||
                    filterSchool != null ||
                    filterConcentration == true ||
                    filterRitual == true ||
                    filterVocal == true ||
                    filterSomatic == true ||
                    filterMaterial == true;

                return Column(
                  children: [
                    // ── Filter bar ──────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Rechercher un sort…',
                                prefixIcon: Icon(Icons.search, size: 18),
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: onSearchChanged,
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: Icon(
                              Icons.tune,
                              color: hasAnyActiveFilter ? AppTheme.neonCyan : null,
                            ),
                            tooltip: 'Filtres avancés',
                            onPressed: () => _showAdvancedFiltersSheet(
                              context,
                              allSchools: allSchools,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Active filter chips
                    if (hasAnyActiveFilter)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (filterLevel != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: FilterChip(
                                    label: Text(filterLevel == 0 ? 'Tour de magie' : 'Niv. $filterLevel'),
                                    onSelected: (_) => onLevelChanged(null),
                                    selected: true,
                                  ),
                                ),
                              if (filterSchool != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: FilterChip(
                                    label: Text(filterSchool!),
                                    onSelected: (_) => onSchoolChanged(null),
                                    selected: true,
                                  ),
                                ),
                              if (filterConcentration == true)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: FilterChip(
                                    avatar: const Icon(Icons.center_focus_strong, size: 14),
                                    label: const Text('Concentration'),
                                    onSelected: (_) => onConcentrationChanged(null),
                                    selected: true,
                                  ),
                                ),
                              if (filterRitual == true)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: FilterChip(
                                    avatar: const Icon(Icons.menu_book, size: 14),
                                    label: const Text('Rituel'),
                                    onSelected: (_) => onRitualChanged(null),
                                    selected: true,
                                  ),
                                ),
                              if (filterVocal == true)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: FilterChip(
                                    label: const Text('🗣️ Vocale (V)'),
                                    onSelected: (_) => onVocalChanged(null),
                                    selected: true,
                                  ),
                                ),
                              if (filterSomatic == true)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: FilterChip(
                                    label: const Text('🖐️ Somatique (S)'),
                                    onSelected: (_) => onSomaticChanged(null),
                                    selected: true,
                                  ),
                                ),
                              if (filterMaterial == true)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: FilterChip(
                                    label: const Text('💎 Matérielle (M)'),
                                    onSelected: (_) => onMaterialChanged(null),
                                    selected: true,
                                  ),
                                ),
                              ActionChip(
                                label: const Text('Effacer filtres'),
                                avatar: const Icon(Icons.close, size: 14),
                                onPressed: onResetFilters,
                              ),
                            ],
                          ),
                        ),
                      ),
                    const Divider(height: 1),
                    // ── Spell list ───────────────────────────────────────
                    Expanded(
                      child: spells.isEmpty
                          ? Center(
                              child: Text('Aucun sort trouvé.',
                                  style: TextStyle(
                                      color: colorScheme.onSurfaceVariant)),
                            )
                          : ListView.builder(
                              itemCount: spells.length,
                              itemBuilder: (context, index) {
                                final spell = spells[index];
                                final alreadyAdded = mySpellIds.contains(spell.id);
                                return _CompendiumSpellTile(
                                  spell: spell,
                                  alreadyAdded: alreadyAdded,
                                  characterId: characterId,
                                  ruleset: ruleset,
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _showAdvancedFiltersSheet(BuildContext context, {required List<String> allSchools}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filtres de Sorts',
                        style: TextStyle(fontFamily: 'Cinzel', fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          onResetFilters();
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Tout réinitialiser'),
                      ),
                    ],
                  ),
                  const Divider(),

                  // ── Niveau de Sort ──────────────────────────────────
                  const Text('Niveau de sort', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ChoiceChip(
                        label: const Text('Tous'),
                        selected: filterLevel == null,
                        onSelected: (val) {
                          onLevelChanged(null);
                          setModalState(() {});
                        },
                      ),
                      ...List.generate(10, (i) => ChoiceChip(
                        label: Text(i == 0 ? 'Tour de magie' : 'Niv. $i'),
                        selected: filterLevel == i,
                        onSelected: (val) {
                          onLevelChanged(val ? i : null);
                          setModalState(() {});
                        },
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── École de Magie ──────────────────────────────────
                  const Text('École de magie', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ChoiceChip(
                        label: const Text('Toutes'),
                        selected: filterSchool == null,
                        onSelected: (val) {
                          onSchoolChanged(null);
                          setModalState(() {});
                        },
                      ),
                      ...allSchools.map((school) => ChoiceChip(
                        label: Text(school),
                        selected: filterSchool?.toLowerCase() == school.toLowerCase(),
                        onSelected: (val) {
                          onSchoolChanged(val ? school : null);
                          setModalState(() {});
                        },
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Propriétés Spéciales ──────────────────────────────
                  const Text('Propriétés du sort', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        avatar: const Icon(Icons.center_focus_strong, size: 14),
                        label: const Text('Concentration'),
                        selected: filterConcentration == true,
                        onSelected: (val) {
                          onConcentrationChanged(val ? true : null);
                          setModalState(() {});
                        },
                      ),
                      FilterChip(
                        avatar: const Icon(Icons.menu_book, size: 14),
                        label: const Text('Rituel'),
                        selected: filterRitual == true,
                        onSelected: (val) {
                          onRitualChanged(val ? true : null);
                          setModalState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Composantes ──────────────────────────────────────
                  const Text('Composantes requises', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('🗣️ Vocale (V)'),
                        selected: filterVocal == true,
                        onSelected: (val) {
                          onVocalChanged(val ? true : null);
                          setModalState(() {});
                        },
                      ),
                      FilterChip(
                        label: const Text('🖐️ Somatique (S)'),
                        selected: filterSomatic == true,
                        onSelected: (val) {
                          onSomaticChanged(val ? true : null);
                          setModalState(() {});
                        },
                      ),
                      FilterChip(
                        label: const Text('💎 Matérielle (M)'),
                        selected: filterMaterial == true,
                        onSelected: (val) {
                          onMaterialChanged(val ? true : null);
                          setModalState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Afficher les résultats'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CompendiumSpellTile extends ConsumerWidget {
  final SrdSpell spell;
  final bool alreadyAdded;
  final int characterId;
  final RulesetVersion ruleset;

  const _CompendiumSpellTile({
    required this.spell,
    required this.alreadyAdded,
    required this.characterId,
    required this.ruleset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final levelLabel =
        spell.level == 0 ? 'Tour de magie' : 'Niveau ${spell.level}';

    return ListTile(
      dense: true,
      title: Row(
        children: [
          Expanded(
            child: Text(spell.name, style: const TextStyle(fontSize: 14)),
          ),
          if (spell.concentration)
            Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.5), width: 0.8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.center_focus_strong, size: 10, color: Colors.amber),
                  SizedBox(width: 3),
                  Text('Conc.', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.amber)),
                ],
              ),
            ),
          if (spell.ritual)
            Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: AppTheme.neonPurple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.neonPurple.withValues(alpha: 0.5), width: 0.8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book, size: 10, color: AppTheme.neonPurple),
                  SizedBox(width: 3),
                  Text('Rituel', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppTheme.neonPurple)),
                ],
              ),
            ),
        ],
      ),
      subtitle: Text('$levelLabel • ${spell.school}',
          style: const TextStyle(fontSize: 11)),
      trailing: alreadyAdded
          ? Icon(Icons.check_circle, color: colorScheme.primary, size: 20)
          : IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: () async {
                final db = ref.read(databaseProvider);
                await db.characterDao.insertCharacterSpell(
                  CharacterSpellsCompanion.insert(
                    characterId: characterId,
                    spellId: spell.id,
                    ruleset: ruleset,
                  ),
                );
              },
            ),
      onTap: () => _showSpellDetail(context, spell),
    );
  }

  void _showSpellDetail(BuildContext context, SrdSpell spell) {
    final levelLabel =
        spell.level == 0 ? 'Tour de magie' : 'Sort de niveau ${spell.level}';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollCtrl,
            children: [
              Text(spell.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('$levelLabel • ${spell.school}',
                  style: const TextStyle(fontSize: 13)),
              const Divider(),
              _SpellDetailRow('Temps d\'incantation', spell.castingTime),
              _SpellDetailRow('Portée', spell.range),
              _SpellDetailRow('Durée', spell.duration),
              _SpellDetailRow(
                  'Composantes',
                  (jsonDecode(spell.components) as List)
                      .join(', ')),
              if (spell.concentration)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Chip(label: Text('Concentration')),
                ),
              if (spell.ritual)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Chip(label: Text('Rituel')),
                ),
              const SizedBox(height: 8),
              Text(spell.description),
              if (spell.higherLevel != null) ...[
                const SizedBox(height: 8),
                const Text('À plus haut niveau :',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(spell.higherLevel!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SpellDetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _SpellDetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text('$label :',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _MySpellsTab extends ConsumerWidget {
  final int characterId;
  final List<CharacterSpell> mySpells;
  final RulesetVersion ruleset;

  const _MySpellsTab({
    required this.characterId,
    required this.mySpells,
    required this.ruleset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    if (mySpells.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_fix_off, size: 48,
                color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('Aucun sort. Ajoutez-en depuis le Compendium.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return FutureBuilder<List<SrdSpell>>(
      future: ref.read(databaseProvider).compendiumDao.getAllSpells(ruleset),
      builder: (context, snap) {
        final srdMap = <String, SrdSpell>{};
        for (final s in snap.data ?? []) {
          srdMap[s.id] = s;
        }
        final sortedMySpells = List<CharacterSpell>.from(mySpells);
        sortedMySpells.sort((a, b) {
          final srdA = srdMap[a.spellId];
          final srdB = srdMap[b.spellId];
          final levelA = srdA?.level ?? 0;
          final levelB = srdB?.level ?? 0;
          final levelCmp = levelA.compareTo(levelB);
          if (levelCmp != 0) return levelCmp;
          final nameA = srdA?.name ?? a.spellId;
          final nameB = srdB?.name ?? b.spellId;
          return StringUtils.compareAlphabetically(nameA, nameB);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: sortedMySpells.length,
          itemBuilder: (context, i) {
            final cs = sortedMySpells[i];
            final srd = srdMap[cs.spellId];
            final name = srd?.name ?? cs.spellId;
            final levelLabel = srd == null
                ? ''
                : srd.level == 0
                    ? 'Tour de magie'
                    : 'Niv. ${srd.level}';
            final school = srd?.school ?? '';

            return Card(
              child: ListTile(
                leading: Icon(
                  cs.prepared
                      ? Icons.auto_fix_high
                      : Icons.auto_fix_off,
                  color: cs.prepared ? colorScheme.primary : null,
                  size: 20,
                ),
                title: Text(name, style: const TextStyle(fontSize: 14)),
                subtitle: Text(
                    [levelLabel, school]
                        .where((s) => s.isNotEmpty)
                        .join(' • '),
                    style: const TextStyle(fontSize: 11)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Toggle prepared
                    if (srd != null && srd.level > 0)
                      IconButton(
                        icon: Icon(
                          cs.prepared
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          size: 18,
                        ),
                        tooltip: cs.prepared ? 'Non préparé' : 'Préparer',
                        onPressed: () async {
                          final db = ref.read(databaseProvider);
                          await db.characterDao.updateCharacterSpell(
                            CharacterSpellsCompanion(
                              id: Value(cs.id),
                              characterId: Value(characterId),
                              spellId: Value(cs.spellId),
                              ruleset: Value(cs.ruleset),
                              prepared: Value(!cs.prepared),
                            ),
                          );
                        },
                      ),
                    // Remove
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 18),
                      tooltip: 'Retirer',
                      onPressed: () async {
                        final db = ref.read(databaseProvider);
                        await db.characterDao.deleteCharacterSpell(cs.id);
                      },
                    ),
                  ],
                ),
                onTap: srd != null
                    ? () => _showSpellDetail(context, srd)
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  void _showSpellDetail(BuildContext context, SrdSpell spell) {
    final levelLabel =
        spell.level == 0 ? 'Tour de magie' : 'Sort de niveau ${spell.level}';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollCtrl,
            children: [
              Text(spell.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text('$levelLabel • ${spell.school}',
                  style: const TextStyle(fontSize: 13)),
              const Divider(),
              _SpellDetailRow('Temps d\'incantation', spell.castingTime),
              _SpellDetailRow('Portée', spell.range),
              _SpellDetailRow('Durée', spell.duration),
              _SpellDetailRow(
                  'Composantes',
                  (jsonDecode(spell.components) as List).join(', ')),
              const SizedBox(height: 8),
              Text(spell.description),
              if (spell.higherLevel != null) ...[
                const SizedBox(height: 8),
                const Text('À plus haut niveau :',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(spell.higherLevel!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
