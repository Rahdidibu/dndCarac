import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column, Row, Table;

import '../../l10n/app_localizations.dart';
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../theme/app_theme.dart';
import '../../../features/character/providers/character_providers.dart';

class ConditionsDialog extends ConsumerWidget {
  final int characterId;

  const ConditionsDialog({
    super.key,
    required this.characterId,
  });

  static Future<void> show(
    BuildContext context, {
    required int characterId,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => ConditionsDialog(
        characterId: characterId,
      ),
    );
  }

  static final List<String> _conditions = [
    'blinded',
    'charmed',
    'deafened',
    'frightened',
    'grappled',
    'incapacitated',
    'invisible',
    'paralyzed',
    'petrified',
    'poisoned',
    'prone',
    'restrained',
    'stunned',
    'unconscious',
  ];

  static String resolveConditionName(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'blinded': return l10n.conditionBlinded;
      case 'charmed': return l10n.conditionCharmed;
      case 'deafened': return l10n.conditionDeafened;
      case 'frightened': return l10n.conditionFrightened;
      case 'grappled': return l10n.conditionGrappled;
      case 'incapacitated': return l10n.conditionIncapacitated;
      case 'invisible': return l10n.conditionInvisible;
      case 'paralyzed': return l10n.conditionParalyzed;
      case 'petrified': return l10n.conditionPetrified;
      case 'poisoned': return l10n.conditionPoisoned;
      case 'prone': return l10n.conditionProne;
      case 'restrained': return l10n.conditionRestrained;
      case 'stunned': return l10n.conditionStunned;
      case 'unconscious': return l10n.conditionUnconscious;
      default: return key;
    }
  }

  static String resolveConditionDesc(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'blinded': return l10n.conditionBlindedDesc;
      case 'charmed': return l10n.conditionCharmedDesc;
      case 'deafened': return l10n.conditionDeafenedDesc;
      case 'frightened': return l10n.conditionFrightenedDesc;
      case 'grappled': return l10n.conditionGrappledDesc;
      case 'incapacitated': return l10n.conditionIncapacitatedDesc;
      case 'invisible': return l10n.conditionInvisibleDesc;
      case 'paralyzed': return l10n.conditionParalyzedDesc;
      case 'petrified': return l10n.conditionPetrifiedDesc;
      case 'poisoned': return l10n.conditionPoisonedDesc;
      case 'prone': return l10n.conditionProneDesc;
      case 'restrained': return l10n.conditionRestrainedDesc;
      case 'stunned': return l10n.conditionStunnedDesc;
      case 'unconscious': return l10n.conditionUnconsciousDesc;
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final db = ref.read(databaseProvider);

    final charAsync = ref.watch(characterByIdProvider(characterId));
    final resourcesAsync = ref.watch(characterResourcesProvider(characterId));

    return charAsync.when(
      loading: () => const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => AlertDialog(
        content: Text('Erreur: $e'),
      ),
      data: (char) {
        if (char == null) {
          return const AlertDialog(
            content: Text('Personnage introuvable'),
          );
        }

        return resourcesAsync.when(
          loading: () => const AlertDialog(
            content: SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (e, _) => AlertDialog(
            content: Text('Erreur: $e'),
          ),
          data: (resources) {
            final activeMap = <String, CharacterResource>{};
            for (final r in resources) {
              if (r.resourceName.startsWith('condition_')) {
                final key = r.resourceName.replaceFirst('condition_', '');
                activeMap[key] = r;
              }
            }

            return AlertDialog(
              title: Text(l10n.conditionsEditTitle),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.conditionExhaustion,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.conditionsExhaustionLabel(char.exhaustionLevel),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          DropdownButton<int>(
                            value: char.exhaustionLevel,
                            dropdownColor: Colors.grey.shade900,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            items: List.generate(7, (i) => DropdownMenuItem(
                              value: i,
                              child: Text(i.toString()),
                            )),
                            onChanged: (val) async {
                              if (val != null) {
                                await db.characterDao.updateCharacter(
                                  CharactersCompanion(
                                    id: Value(characterId),
                                    exhaustionLevel: Value(val),
                                    updatedAt: Value(DateTime.now().toIso8601String()),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(),
                      ),
                      Text(
                        l10n.conditionsSectionTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber),
                      ),
                      const SizedBox(height: 8),
                      ..._conditions.map((cond) {
                        final resource = activeMap[cond];
                        final isActive = (resource?.current ?? 0) > 0;

                        return SwitchListTile(
                          title: Text(
                            resolveConditionName(context, cond),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: Text(
                            resolveConditionDesc(context, cond),
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                          ),
                          value: isActive,
                          activeColor: AppTheme.neonRed,
                          onChanged: (val) async {
                            if (val) {
                              await db.characterDao.upsertResource(
                                CharacterResourcesCompanion(
                                  id: resource != null ? Value(resource.id) : const Value.absent(),
                                  characterId: Value(characterId),
                                  resourceName: Value('condition_$cond'),
                                  current: const Value(1),
                                  maximum: const Value(1),
                                ),
                              );
                            } else {
                              if (resource != null) {
                                await db.characterDao.upsertResource(
                                  CharacterResourcesCompanion(
                                    id: Value(resource.id),
                                    characterId: Value(characterId),
                                    resourceName: Value(resource.resourceName),
                                    current: const Value(0),
                                    maximum: const Value(1),
                                  ),
                                );
                              }
                            }
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
