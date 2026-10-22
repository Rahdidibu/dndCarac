import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';
import '../../../core/models/character_note.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/utils/character_service.dart';
import '../../../core/utils/dnd_rules.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/starting_equipment_helper.dart';
import '../../../core/utils/string_utils.dart';
import '../../../core/utils/skills_catalog.dart';
import '../../export/pdf_generator.dart';
import '../providers/character_providers.dart';
import '../providers/character_features_provider.dart';
import '../providers/level_up_provider.dart' show sheetTabRequestProvider;
import '../widgets/avatar_upload.dart';
import '../widgets/features_section.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/forge_navigation_provider.dart';
import '../../../core/utils/markdown_text.dart';
import '../../../core/widgets/hp_modifier_dialog.dart';
import '../../../core/widgets/short_rest_dialog.dart';
import '../../../core/widgets/undo_snackbar.dart';
import '../../../core/widgets/conditions_dialog.dart';
import '../../../core/widgets/roll_result_dialog.dart';
import '../../../core/widgets/universal_dice_roller.dart';
import '../../../core/widgets/currency_manager_dialog.dart';
import '../../../core/widgets/combat_attack_dialog.dart';
import '../../../core/utils/armor_class_helper.dart';
import 'sheet_tabs/tab_companions.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/utils/app_errors.dart';

part 'sheet_tabs/tab_stats.dart';
part 'sheet_tabs/tab_combat.dart';
part 'sheet_tabs/tab_magic.dart';
part 'sheet_tabs/tab_equipment.dart';
part 'sheet_tabs/tab_profile.dart';
part 'sheet_tabs/tab_journal.dart';

/// Ouvre l'onglet demandé par `sheetTabRequestProvider` (liens du résumé de
/// montée de niveau) sur la disposition mobile, puis efface la demande.
class _SheetTabRequestListener extends ConsumerWidget {
  final Widget child;
  const _SheetTabRequestListener({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<int?>(sheetTabRequestProvider, (_, tab) {
      if (tab == null) return;
      DefaultTabController.maybeOf(context)?.animateTo(tab);
      ref.read(sheetTabRequestProvider.notifier).state = null;
    });
    return child;
  }
}

class CharacterSheetScreen extends ConsumerWidget {
  final int characterId;
  const CharacterSheetScreen({super.key, required this.characterId});

  void _returnToCharacters(BuildContext context, WidgetRef ref) {
    ref.read(mainTabNavigationProvider.notifier).state = 0;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final character = await db.characterDao.getCharacterById(characterId);
    if (character == null) return;
    final classes = await db.characterDao.getCharacterClasses(characterId);
    final abilityScores = await db.characterDao.getAbilityScores(characterId);
    final proficiencies = await db.characterDao.getProficiencies(characterId);
    final charSpells = await db.characterDao.getCharacterSpells(characterId);
    final srdSpells = await db.compendiumDao.getAllSpells(character.ruleset);
    final attacks = await db.characterDao.watchAttacks(characterId).first;
    final equipment = await db.characterDao.watchEquipment(characterId).first;
    final feats = await db.characterDao.getCharacterFeats(characterId);
    final srdFeats = await db.compendiumDao.getAllFeats(character.ruleset);
    final notes = await db.characterDao.getCharacterNotes(characterId);
    final features = await ref.read(
      characterFeaturesProvider(characterId).future,
    );

    final bytes = await PdfGenerator.generate(
      character: character,
      classes: classes,
      abilityScores: abilityScores,
      proficiencies: proficiencies,
      characterSpells: charSpells,
      srdSpells: srdSpells,
      attacks: attacks,
      equipment: equipment,
      feats: feats,
      srdFeats: srdFeats,
      features: features,
      notes: notes,
    );

    await Printing.layoutPdf(onLayout: (_) async => Uint8List.fromList(bytes));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charAsync = ref.watch(characterByIdProvider(characterId));
    final classesAsync = ref.watch(characterClassesProvider(characterId));
    final totalLevelAsync = ref.watch(characterTotalLevelProvider(characterId));
    final l10n = AppLocalizations.of(context)!;

    return charAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: AsyncErrorView(
                  error: e,
                  stackTrace: st,
                  onRetry: () =>
                      ref.invalidate(characterByIdProvider(characterId)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: FilledButton.icon(
                  onPressed: () => _returnToCharacters(context, ref),
                  icon: const Icon(Icons.people_outline),
                  label: Text(l10n.navCharacters),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (character) {
        if (character == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.characterNotFound)),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_search_outlined,
                      size: 40,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 12),
                    Text(l10n.characterNotFound, textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => _returnToCharacters(context, ref),
                      icon: const Icon(Icons.people_outline),
                      label: Text(l10n.navCharacters),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final totalLevel = totalLevelAsync.whenData((v) => v).valueOrNull ?? 1;
        final classLine =
            classesAsync.whenData((list) {
              return list
                  .map((c) {
                    final name = CharacterService.classDisplayName(
                      c.classId,
                      l10n,
                    );
                    return '$name ${c.level}';
                  })
                  .join(' / ');
            }).valueOrNull ??
            '';

        final speciesName = ref
            .watch(characterSpeciesNameProvider(characterId))
            .valueOrNull;
        final subspeciesName = ref
            .watch(characterSubspeciesNameProvider(characterId))
            .valueOrNull;
        final backgroundName = ref
            .watch(characterBackgroundNameProvider(characterId))
            .valueOrNull;

        final speciesPart = speciesName != null
            ? '$speciesName${subspeciesName != null ? ' ($subspeciesName)' : ''}'
            : '';
        final backgroundPart = backgroundName ?? '';

        final parts = <String>[];
        if (speciesPart.isNotEmpty) parts.add(speciesPart);
        if (backgroundPart.isNotEmpty) parts.add(backgroundPart);
        if (classLine.isNotEmpty) parts.add(classLine);

        final subtitleText = parts.join(' • ');

        final isDesktop = MediaQuery.of(context).size.width > 1100;

        final mainScaffold = Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                if (character.imageUrl != null &&
                    character.imageUrl!.isNotEmpty) ...[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.neonCyan.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(character.imageUrl!),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitleText.isNotEmpty)
                        Text(
                          subtitleText,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppTheme.neonCyan),
                tooltip: l10n.editCharacterTooltip,
                onPressed: () => Navigator.of(
                  context,
                ).pushNamed('/character/edit', arguments: characterId),
              ),
              IconButton(
                icon: const Icon(Icons.gavel, color: AppTheme.neonCyan),
                tooltip: l10n.navForge,
                onPressed: () {
                  ref.read(forgeSelectedCharacterIdProvider.notifier).state =
                      character.id;
                  ref.read(mainTabNavigationProvider.notifier).state = 1;
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_upward,
                  color: AppTheme.neonPurple,
                ),
                tooltip: l10n.levelUp,
                onPressed: () => Navigator.of(
                  context,
                ).pushNamed('/character/levelup', arguments: characterId),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.neonRed),
                tooltip: l10n.characterDelete,
                onPressed: () => _confirmDelete(context, ref, character),
              ),
              IconButton(
                icon: const Icon(
                  Icons.picture_as_pdf,
                  color: AppTheme.neonCyan,
                ),
                tooltip: l10n.exportCharacterSheet,
                onPressed: () => _exportPdf(context, ref),
              ),
            ],
            bottom: isDesktop
                ? null
                : TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: [
                      Tab(text: l10n.sheetTabStats),
                      Tab(text: l10n.sheetTabCombat),
                      Tab(text: l10n.sheetTabMagic),
                      Tab(text: l10n.sheetTabEquipment),
                      Tab(text: l10n.sheetTabProfile),
                      Tab(text: l10n.sheetTabJournalShort),
                      Tab(text: l10n.sheetTabCompanionsShort),
                    ],
                  ),
          ),
          body: _SheetTabRequestListener(
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _StatsTab(
                          characterId: characterId,
                          character: character,
                          totalLevel: totalLevel,
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      Expanded(
                        flex: 4,
                        child: _CombatTab(
                          characterId: characterId,
                          character: character,
                          totalLevel: totalLevel,
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      Expanded(
                        flex: 4,
                        child: _RightTabbedPanel(
                          characterId: characterId,
                          character: character,
                        ),
                      ),
                    ],
                  )
                : TabBarView(
                    children: [
                      _StatsTab(
                        characterId: characterId,
                        character: character,
                        totalLevel: totalLevel,
                      ),
                      _CombatTab(
                        characterId: characterId,
                        character: character,
                        totalLevel: totalLevel,
                      ),
                      _MagicTab(characterId: characterId, character: character),
                      _EquipmentTab(
                        characterId: characterId,
                        character: character,
                      ),
                      _ProfileTab(
                        characterId: characterId,
                        character: character,
                      ),
                      _JournalTab(characterId: characterId),
                      TabCompanions(
                        characterId: characterId,
                        character: character,
                      ),
                    ],
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppTheme.neonCyan,
            foregroundColor: Colors.black,
            child: const Icon(Icons.casino),
            onPressed: () => UniversalDiceRoller.show(context),
          ),
        );

        return isDesktop
            ? mainScaffold
            : DefaultTabController(length: 7, child: mainScaffold);
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Character character,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.characterDelete),
        content: Text(l10n.characterDeleteConfirm(character.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final db = ref.read(databaseProvider);
      await db.characterDao.deleteCharacter(character.id);
      ref.invalidate(charactersProvider);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class _RightTabbedPanel extends StatefulWidget {
  final int characterId;
  final Character character;
  const _RightTabbedPanel({required this.characterId, required this.character});

  @override
  State<_RightTabbedPanel> createState() => _RightTabbedPanelState();
}

class _RightTabbedPanelState extends State<_RightTabbedPanel>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.sheetTabMagic),
            Tab(text: l10n.sheetTabEquipment),
            Tab(text: l10n.sheetTabProfile),
            Tab(text: l10n.sheetTabJournalShort),
            Tab(text: l10n.sheetTabCompanionsShort),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _MagicTab(
                characterId: widget.characterId,
                character: widget.character,
              ),
              _EquipmentTab(
                characterId: widget.characterId,
                character: widget.character,
              ),
              _ProfileTab(
                characterId: widget.characterId,
                character: widget.character,
              ),
              _JournalTab(characterId: widget.characterId),
              TabCompanions(
                characterId: widget.characterId,
                character: widget.character,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
