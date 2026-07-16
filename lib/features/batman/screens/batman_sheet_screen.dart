import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../../character/providers/character_providers.dart';
import '../../export/batman_pdf_generator.dart';
import '../providers/batman_providers.dart';
import 'batman_level_up_screen.dart';

class BatmanSheetScreen extends ConsumerWidget {
  final int characterId;
  const BatmanSheetScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(characterByIdProvider(characterId));
    final batmanAsync = ref.watch(batmanCharacterProvider(characterId));

    return characterAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (character) {
        if (character == null) {
          return const Scaffold(
              body: Center(child: Text('Personnage introuvable')));
        }
        return batmanAsync.when(
          loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
          data: (batman) {
            if (batman == null) {
              return const Scaffold(
                  body: Center(
                      child: Text('Données Batman introuvables')));
            }
            return _BatmanSheetView(
                character: character, batman: batman);
          },
        );
      },
    );  }
}

class _BatmanSheetView extends ConsumerStatefulWidget {
  final Character character;
  final BatmanCharacter batman;

  const _BatmanSheetView({required this.character, required this.batman});

  @override
  ConsumerState<_BatmanSheetView> createState() => _BatmanSheetViewState();
}

class _BatmanSheetViewState extends ConsumerState<_BatmanSheetView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _updateHP(int delta) async {
    final db = ref.read(databaseProvider);
    final newHP = (widget.character.hpCurrent + delta).clamp(0, widget.character.hpMax);
    await db.characterDao.updateCharacter(
      CharactersCompanion(
        id: Value(widget.character.id),
        hpCurrent: Value(newHP),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  Future<void> _updateExploits(int delta) async {
    final db = ref.read(databaseProvider);
    final newVal = (widget.batman.exploitPointsCurrent + delta)
        .clamp(0, widget.batman.exploitPointsMax);
    await db.batmanDao.updateBatmanCharacter(
      BatmanCharactersCompanion(
        characterId: Value(widget.batman.characterId),
        exploitPointsCurrent: Value(newVal),
      ),
    );
  }

  Future<void> _exportPdf() async {
    final db = ref.read(databaseProvider);
    final profile = await db.batmanDao.getProfileById(widget.batman.profileId);
    final charWays = await db.batmanDao.getCharacterWays(widget.batman.characterId);
    final allWays = await db.batmanDao.getAllWays();

    final bytes = await BatmanPdfGenerator.generate(
      character: widget.character,
      batman: widget.batman,
      profile: profile,
      charWays: charWays,
      allWays: allWays,
    );

    await Printing.layoutPdf(
      onLayout: (_) async => Uint8List.fromList(bytes),
    );
  }

  Future<void> _goLevelUp() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BatmanLevelUpScreen(characterId: widget.character.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final char = widget.character;
    final bat = widget.batman;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        title: Text(char.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            tooltip: 'Monter en rang',
            onPressed: _goLevelUp,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Exporter en PDF',
            onPressed: _exportPdf,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Supprimer',
            onPressed: () => _confirmDelete(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Héros'),
            Tab(text: 'Combat'),
            Tab(text: 'Voies'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _HeroTab(char: char, bat: bat),
          _CombatTab(
              char: char,
              bat: bat,
              onHPChange: _updateHP,
              onExploitChange: _updateExploits),
          _WaysTab(characterId: char.id),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer le personnage ?'),
        content: Text('Supprimer "${widget.character.name}" définitivement ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final db = ref.read(databaseProvider);
      await db.characterDao.deleteCharacter(widget.character.id);
      if (mounted) Navigator.of(context).pop();
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Tab Héros
// ─────────────────────────────────────────────────────────────

class _HeroTab extends ConsumerWidget {
  final Character char;
  final BatmanCharacter bat;

  const _HeroTab({required this.char, required this.bat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(batmanProfilesProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        Card(
          color: Colors.grey.shade900,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.amber.shade900,
                      child: Text(
                        char.name[0].toUpperCase(),
                        style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(char.name,
                              style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          if (bat.secretIdentity.isNotEmpty)
                            Text(bat.secretIdentity,
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14)),
                          profileAsync.when(
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                            data: (profiles) {
                              final profile = profiles
                                  .where((p) => p.id == bat.profileId)
                                  .firstOrNull;
                              return profile != null
                                  ? Text(profile.name,
                                      style: TextStyle(
                                          color: Colors.amber.shade300,
                                          fontSize: 13))
                                  : const SizedBox.shrink();
                            },
                          ),
                          _modeChip(bat.mode),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Ability scores
        const _SectionHeader(title: 'Caractéristiques primaires'),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.0,
          children: [
            _AbilityCard('FOR', bat.force),
            _AbilityCard('CON', bat.constitution),
            _AbilityCard('DEX', bat.dexterite),
            _AbilityCard('INT', bat.intelligence),
            _AbilityCard('PER', bat.perception),
            _AbilityCard('VOL', bat.volonte),
          ],
        ),
        const SizedBox(height: 16),
        // Ethics
        const _SectionHeader(title: 'Éthique'),
        const SizedBox(height: 8),
        Card(
          color: Colors.grey.shade900,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _EthicBox('Ordre', bat.ethicsOrder),
                _EthicBox('Justice', bat.ethicsJustice),
                _EthicBox('Anarchie', bat.ethicsAnarchy),
                _EthicBox('Crime', bat.ethicsCrime),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Living standard
        Card(
          color: Colors.grey.shade900,
          child: ListTile(
            leading: const Icon(Icons.home, color: Colors.amber),
            title: const Text('Niveau de vie',
                style: TextStyle(color: Colors.grey)),
            subtitle: Text(
              _livingStandardLabel(bat.livingStandard),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _modeChip(String mode) => Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _modeLabel(mode),
          style: const TextStyle(color: Colors.amber, fontSize: 11),
        ),
      );

  String _modeLabel(String mode) {
    switch (mode) {
      case 'rues': return 'Rues de Gotham';
      case 'ombres': return 'Ombres de Gotham';
      case 'prodiges': return 'Prodiges de Gotham';
      default: return mode;
    }
  }

  String _livingStandardLabel(String ls) {
    const labels = {
      'miserable': 'Misérable', 'pauvre': 'Pauvre',
      'modeste': 'Modeste', 'aise': 'Aisé',
      'fortun': 'Fortuné', 'millionnaire': 'Millionnaire',
      'milliardaire': 'Milliardaire',
    };
    return labels[ls] ?? ls;
  }
}

class _AbilityCard extends StatelessWidget {
  final String name;
  final int value;

  const _AbilityCard(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    final mod = abilityModifier(value);
    final modStr = mod >= 0 ? '+$mod' : '$mod';
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade900),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(modStr,
              style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          Text('$value',
              style: TextStyle(color: Colors.grey.shade300, fontSize: 14)),
          Text(name,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        ],
      ),
    );
  }
}

class _EthicBox extends StatelessWidget {
  final String name;
  final int value;

  const _EthicBox(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value',
            style: const TextStyle(
                color: Colors.amber,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        Text(name,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Tab Combat
// ─────────────────────────────────────────────────────────────

class _CombatTab extends StatelessWidget {
  final Character char;
  final BatmanCharacter bat;
  final Future<void> Function(int delta) onHPChange;
  final Future<void> Function(int delta) onExploitChange;

  const _CombatTab({
    required this.char,
    required this.bat,
    required this.onHPChange,
    required this.onExploitChange,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // HP
        Card(
          color: Colors.grey.shade900,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Points de vie',
                    style: TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => onHPChange(-1),
                      icon: const Icon(Icons.remove_circle,
                          color: Colors.red, size: 32),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        Text(
                          '${char.hpCurrent}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '/ ${char.hpMax}',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => onHPChange(1),
                      icon: const Icon(Icons.add_circle,
                          color: Colors.green, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: char.hpMax > 0
                      ? char.hpCurrent / char.hpMax
                      : 0,
                  backgroundColor: Colors.grey.shade700,
                  color: _hpColor(char.hpCurrent, char.hpMax),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Combat stats grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2,
          children: [
            _statCard('ATC', _signed(bat.atcTotal)),
            _statCard('ATD', _signed(bat.atdTotal)),
            _statCard('Défense', '${bat.defense}'),
            _statCard('Initiative', _signed(bat.initiative)),
          ],
        ),
        const SizedBox(height: 12),
        // Exploit points
        if (bat.exploitPointsMax > 0) ...[
          Card(
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Points d\'exploit',
                      style: TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => onExploitChange(-1),
                        icon: const Icon(Icons.remove_circle,
                            color: Colors.amber),
                      ),
                      Text(
                        '${bat.exploitPointsCurrent} / ${bat.exploitPointsMax}',
                        style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => onExploitChange(1),
                        icon: const Icon(Icons.add_circle,
                            color: Colors.amber),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _hpColor(int current, int max) {
    if (max == 0) return Colors.grey;
    final ratio = current / max;
    if (ratio > 0.5) return Colors.green;
    if (ratio > 0.25) return Colors.orange;
    return Colors.red;
  }

  String _signed(int v) => v >= 0 ? '+$v' : '$v';

  Widget _statCard(String label, String value) => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.amber.shade900),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────
// Tab Voies
// ─────────────────────────────────────────────────────────────

class _WaysTab extends ConsumerWidget {
  final int characterId;

  const _WaysTab({required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charWaysAsync = ref.watch(batmanCharacterWaysProvider(characterId));
    final allWaysAsync = ref.watch(batmanWaysProvider);

    return charWaysAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (charWays) => allWaysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (allWays) {
          if (charWays.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Aucune voie acquise.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: charWays.length,
            itemBuilder: (context, i) {
              final cw = charWays[i];
              final way =
                  allWays.where((w) => w.id == cw.wayId).firstOrNull;
              if (way == null) return const SizedBox.shrink();
              return _WayCard(charWay: cw, way: way);
            },
          );
        },
      ),
    );
  }
}

class _WayCard extends StatelessWidget {
  final BatmanCharacterWay charWay;
  final BatmanWay way;

  const _WayCard({required this.charWay, required this.way});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> ranks = json.decode(way.ranksJson);
    final acquired = charWay.rankAcquired;

    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        iconColor: Colors.amber,
        collapsedIconColor: Colors.amber,
        title: Row(
          children: [
            Expanded(
              child: Text(way.name,
                  style: const TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold)),
            ),
            Row(
              children: List.generate(
                  5,
                  (i) => Icon(
                        i < acquired ? Icons.star : Icons.star_outline,
                        color: Colors.amber,
                        size: 14,
                      )),
            ),
          ],
        ),
        subtitle: Text(
          _typeLabel(way.type),
          style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
        ),
        children: ranks.take(acquired).map<Widget>((rank) {
          return ListTile(
            leading: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.amber.shade900,
              child: Text(
                '${rank['rank']}',
                style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              rank['name'],
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              rank['description'],
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'commune': return 'Voie commune';
      case 'ombre': return 'Voie des ombres';
      default: return type;
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Commons
// ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(
            color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
      );
}





