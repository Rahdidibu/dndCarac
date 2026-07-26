import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column, Row, Table;

import '../../l10n/app_localizations.dart';
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../theme/app_theme.dart';
import '../../../features/character/providers/character_providers.dart';
import '../utils/character_service.dart';

class ShortRestDialog extends ConsumerStatefulWidget {
  final int characterId;
  final int conMod;

  const ShortRestDialog({
    super.key,
    required this.characterId,
    required this.conMod,
  });

  static Future<void> show(BuildContext context, {required int characterId, required int conMod}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ShortRestDialog(
        characterId: characterId,
        conMod: conMod,
      ),
    );
  }

  @override
  ConsumerState<ShortRestDialog> createState() => _ShortRestDialogState();
}

class _ShortRestDialogState extends ConsumerState<ShortRestDialog> {
  final List<String> _rollLogs = [];
  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final charAsync = ref.watch(characterByIdProvider(widget.characterId));
    final resourcesAsync = ref.watch(characterResourcesProvider(widget.characterId));

    return AlertDialog(
      title: Text(l10n.shortRestTitle),
      content: charAsync.when(
        loading: () => const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Text('Erreur: $e'),
        data: (char) {
          if (char == null) return const Text('Personnage introuvable');

          return resourcesAsync.when(
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Erreur: $e'),
            data: (resources) {
              final hitDice = resources
                  .where((r) => r.resourceName.startsWith('hitDice_d'))
                  .toList();

              final isHpFull = char.hpCurrent >= char.hpMax;

              return SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // HP Status
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade800),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${char.hpCurrent} / ${char.hpMax} PV',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: char.hpMax > 0 ? (char.hpCurrent / char.hpMax) : 0,
                              backgroundColor: Colors.grey.shade800,
                              color: Colors.green,
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Log of rolls
                    if (_rollLogs.isNotEmpty) ...[
                      const Text(
                        'Historique des soins',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 100),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _rollLogs.length,
                          itemBuilder: (ctx, idx) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              _rollLogs[idx],
                              style: const TextStyle(fontSize: 13, color: Colors.greenAccent),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Roll hit dice buttons
                    if (hitDice.isEmpty)
                      Text(l10n.shortRestNoDice, textAlign: TextAlign.center)
                    else ...[
                      ...hitDice.map((d) {
                        final dieSizeStr = d.resourceName.replaceAll('hitDice_d', '');
                        final dieSize = int.tryParse(dieSizeStr) ?? 8;
                        final canRoll = d.current > 0 && !isHpFull;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.casino),
                            label: Text(
                              l10n.shortRestRollButton(dieSizeStr, d.current),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.neonCyan.withValues(alpha: 0.12),
                              foregroundColor: AppTheme.neonCyan,
                              side: BorderSide(
                                color: AppTheme.neonCyan.withValues(alpha: canRoll ? 0.4 : 0.1),
                              ),
                            ),
                            onPressed: canRoll
                                ? () => _rollHitDie(char, d, dieSize)
                                : null,
                          ),
                        );
                      }),
                    ],

                    if (isHpFull)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          l10n.shortRestHpFull,
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.shortRestClose),
        ),
      ],
    );
  }

  Future<void> _rollHitDie(Character char, CharacterResource resource, int dieSize) async {
    final roll = _random.nextInt(dieSize) + 1;
    final totalHeal = max(1, roll + widget.conMod);
    final newHp = min(char.hpMax, char.hpCurrent + totalHeal);

    final db = ref.read(databaseProvider);

    await db.characterDao.upsertResource(
      CharacterResourcesCompanion(
        id: Value(resource.id),
        characterId: Value(resource.characterId),
        resourceName: Value(resource.resourceName),
        current: Value(resource.current - 1),
        maximum: Value(resource.maximum),
      ),
    );

    await db.characterDao.updateCharacter(
      CharactersCompanion(
        id: Value(widget.characterId),
        hpCurrent: Value(newHp),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );

    final logText = AppLocalizations.of(context)!
        .shortRestRollResult(roll, widget.conMod, totalHeal);
    setState(() {
      _rollLogs.insert(0, logText);
    });
  }
}
