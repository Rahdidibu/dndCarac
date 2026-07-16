import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../providers/batman_providers.dart';

/// Écran de montée en rang pour un personnage Batman RPG.
/// Permet :
///   - d'augmenter le rang d'une voie existante
///   - d'acquérir une nouvelle voie
///   - de recalculer les PV
class BatmanLevelUpScreen extends ConsumerStatefulWidget {
  final int characterId;
  const BatmanLevelUpScreen({super.key, required this.characterId});

  @override
  ConsumerState<BatmanLevelUpScreen> createState() =>
      _BatmanLevelUpScreenState();
}

class _BatmanLevelUpScreenState extends ConsumerState<BatmanLevelUpScreen> {
  // null = aucune sélection, sinon wayId
  String? _selectedWayId;
  bool _addNew = false; // true = acquérir une nouvelle voie

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final batAsync = ref.watch(batmanCharacterProvider(widget.characterId));
    final charWaysAsync =
        ref.watch(batmanCharacterWaysProvider(widget.characterId));
    final allWaysAsync = ref.watch(batmanWaysProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        title: const Text('Montée en rang'),
      ),
      body: batAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (bat) {
          if (bat == null) {
            return const Center(
                child: Text('Données Batman introuvables',
                    style: TextStyle(color: Colors.white)));
          }
          return charWaysAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (charWays) => allWaysAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (allWays) => _buildBody(bat, charWays, allWays),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BatmanCharacter bat,
    List<BatmanCharacterWay> charWays,
    List<BatmanWay> allWays,
  ) {
    // Voies déjà acquises avec rank < 5 (can still progress)
    final upgradeable = charWays
        .where((cw) => cw.rankAcquired < 5)
        .toList();

    // Voies non acquises filtrées par mode
    final acquiredIds = charWays.map((cw) => cw.wayId).toSet();
    final allowedTypes = bat.mode == 'rues'
        ? ['commune']
        : bat.mode == 'ombres'
            ? ['commune', 'ombre']
            : ['commune', 'ombre', 'prodige'];
    final available = allWays
        .where((w) => !acquiredIds.contains(w.id) && allowedTypes.contains(w.type))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Info banner ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade900.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade700),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Choisissez une voie à faire progresser ou une nouvelle voie à acquérir.',
                    style: TextStyle(color: Colors.amber.shade200, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Toggle ──────────────────────────────────────────────────────
          SegmentedButton<bool>(
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: Colors.amber.shade900,
              selectedForegroundColor: Colors.amber,
              foregroundColor: Colors.grey,
            ),
            segments: const [
              ButtonSegment(value: false, label: Text('Progresser')),
              ButtonSegment(value: true, label: Text('Acquérir')),
            ],
            selected: {_addNew},
            onSelectionChanged: (s) => setState(() {
              _addNew = s.first;
              _selectedWayId = null;
            }),
          ),
          const SizedBox(height: 16),

          if (!_addNew) ...[
            // ── Existing ways to upgrade ─────────────────────────────────
            const _SectionHeader(title: 'Voies à faire progresser'),
            const SizedBox(height: 8),
            if (upgradeable.isEmpty)
              _empty('Toutes vos voies sont au rang maximum (5).')
            else
              ...upgradeable.map((cw) {
                final way =
                    allWays.where((w) => w.id == cw.wayId).firstOrNull;
                if (way == null) return const SizedBox.shrink();
                final nextRank = cw.rankAcquired + 1;
                final nextAbility = _nextRankName(way.ranksJson, nextRank);
                final isSelected = _selectedWayId == cw.wayId;
                return _WaySelectionCard(
                  isSelected: isSelected,
                  wayName: way.name,
                  wayType: way.type,
                  subtitle:
                      'Rang ${cw.rankAcquired} → $nextRank : $nextAbility',
                  onTap: () =>
                      setState(() => _selectedWayId = isSelected ? null : cw.wayId),
                );
              }),
          ] else ...[
            // ── New ways to acquire ──────────────────────────────────────
            const _SectionHeader(title: 'Nouvelles voies disponibles'),
            const SizedBox(height: 8),
            if (available.isEmpty)
              _empty('Aucune nouvelle voie disponible.')
            else
              ...available.map((way) {
                final isSelected = _selectedWayId == way.id;
                final firstAbility = _nextRankName(way.ranksJson, 1);
                return _WaySelectionCard(
                  isSelected: isSelected,
                  wayName: way.name,
                  wayType: way.type,
                  subtitle: 'Rang 1 : $firstAbility',
                  onTap: () =>
                      setState(() => _selectedWayId = isSelected ? null : way.id),
                );
              }),
          ],

          // ── Preview of gained rank ────────────────────────────────────
          if (_selectedWayId != null) ...[
            const SizedBox(height: 20),
            _buildRankPreview(
              allWays: allWays,
              charWays: charWays,
            ),
          ],

          // ── Confirm ──────────────────────────────────────────────────
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                disabledBackgroundColor: Colors.grey.shade800,
              ),
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.black))
                  : const Icon(Icons.arrow_upward),
              label: const Text('Confirmer la progression',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: (_selectedWayId != null && !_saving)
                  ? () => _confirm(charWays, allWays, bat)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankPreview({
    required List<BatmanWay> allWays,
    required List<BatmanCharacterWay> charWays,
  }) {
    final way = allWays.where((w) => w.id == _selectedWayId).firstOrNull;
    if (way == null) return const SizedBox.shrink();

    final charWay =
        charWays.where((cw) => cw.wayId == _selectedWayId).firstOrNull;
    final rank = _addNew ? 1 : ((charWay?.rankAcquired ?? 0) + 1);
    final rankData = _getRankData(way.ranksJson, rank);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  way.name,
                  style: const TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Rang $rank',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          if (rankData != null) ...[
            const SizedBox(height: 8),
            Text(
              rankData['name'] ?? '',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              rankData['description'] ?? '',
              style:
                  TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  String _nextRankName(String ranksJson, int rank) {
    try {
      final ranks = json.decode(ranksJson) as List<dynamic>;
      final found =
          ranks.firstWhere((r) => r['rank'] == rank, orElse: () => null);
      return found != null ? (found['name'] as String? ?? '?') : '?';
    } catch (_) {
      return '?';
    }
  }

  Map<String, dynamic>? _getRankData(String ranksJson, int rank) {
    try {
      final ranks = json.decode(ranksJson) as List<dynamic>;
      return ranks.firstWhere((r) => r['rank'] == rank,
          orElse: () => null) as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  Widget _empty(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(text, style: const TextStyle(color: Colors.grey)),
      );

  Future<void> _confirm(
    List<BatmanCharacterWay> charWays,
    List<BatmanWay> allWays,
    BatmanCharacter bat,
  ) async {
    if (_selectedWayId == null) return;
    setState(() => _saving = true);
    try {
      final db = ref.read(databaseProvider);
      final charWay = charWays.where((cw) => cw.wayId == _selectedWayId).firstOrNull;

      if (charWay == null) {
        // Acquérir une nouvelle voie au rang 1
        await db.batmanDao.insertCharacterWay(
          BatmanCharacterWaysCompanion.insert(
            characterId: widget.characterId,
            wayId: _selectedWayId!,
            rankAcquired: const Value(1),
          ),
        );
      } else {
        // Monter en rang
        final newRank = charWay.rankAcquired + 1;
        await db.batmanDao.updateCharacterWay(
          BatmanCharacterWaysCompanion(
            id: Value(charWay.id),
            rankAcquired: Value(newRank),
          ),
        );
      }

      // Recalculer les HP si le dé de vie change (on relit le profil)
      final profile = await db.batmanDao.getProfileById(bat.profileId);
      if (profile != null) {
        final newHp =
            computeBatmanHP(profile.hitDie, bat.constitution);
        await db.characterDao.updateCharacter(
          CharactersCompanion(
            id: Value(widget.characterId),
            hpMax: Value(newHp),
            updatedAt: Value(DateTime.now().toIso8601String()),
          ),
        );
      }

      if (mounted) {
        final wayName = allWays
            .where((w) => w.id == _selectedWayId)
            .firstOrNull
            ?.name ?? _selectedWayId!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"$wayName" a progressé !'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ─── Widgets helpers ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(
            color: Colors.amber,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      );
}

class _WaySelectionCard extends StatelessWidget {
  final bool isSelected;
  final String wayName;
  final String wayType;
  final String subtitle;
  final VoidCallback onTap;

  const _WaySelectionCard({
    required this.isSelected,
    required this.wayName,
    required this.wayType,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.amber.shade900 : Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? const BorderSide(color: Colors.amber, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Colors.amber,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(wayName,
                        style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 12)),
                    Text(
                      _typeLabel(wayType),
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'commune':
        return 'Voie commune';
      case 'ombre':
        return 'Voie des ombres';
      case 'prodige':
        return 'Voie des prodiges';
      default:
        return type;
    }
  }
}


