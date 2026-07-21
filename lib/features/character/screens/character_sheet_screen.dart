import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/utils/character_service.dart';
import '../../../core/utils/dnd_rules.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/starting_equipment_helper.dart';
import '../../export/pdf_generator.dart';
import '../providers/character_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/forge_navigation_provider.dart';
import '../../../core/utils/markdown_text.dart';

part 'sheet_tabs/tab_stats.dart';
part 'sheet_tabs/tab_combat.dart';
part 'sheet_tabs/tab_magic.dart';
part 'sheet_tabs/tab_equipment.dart';
part 'sheet_tabs/tab_profile.dart';

class CharacterSheetScreen extends ConsumerWidget {
  final int characterId;
  const CharacterSheetScreen({super.key, required this.characterId});

  Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final character = await db.characterDao.getCharacterById(characterId);
    if (character == null) return;
    final classes = await db.characterDao.getCharacterClasses(characterId);
    final abilityScores = await db.characterDao.getAbilityScores(characterId);
    final proficiencies = await db.characterDao.getProficiencies(characterId);
    final charSpells = await db.characterDao.getCharacterSpells(characterId);
    final srdSpells =
        await db.compendiumDao.getAllSpells(character.ruleset);
    final attacks =
        await db.characterDao.watchAttacks(characterId).first;
    final equipment =
        await db.characterDao.watchEquipment(characterId).first;
    final feats = await db.characterDao.getCharacterFeats(characterId);
    final srdFeats = await db.compendiumDao.getAllFeats(character.ruleset);

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
    );

    await Printing.layoutPdf(
      onLayout: (_) async => Uint8List.fromList(bytes),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charAsync = ref.watch(characterByIdProvider(characterId));
    final classesAsync = ref.watch(characterClassesProvider(characterId));
    final totalLevelAsync = ref.watch(characterTotalLevelProvider(characterId));
    final l10n = AppLocalizations.of(context)!;

    return charAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur: $e'))),
      data: (character) {
        if (character == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Personnage introuvable')),
            body: const Center(child: Text('Ce personnage n\'existe plus.')),
          );
        }

        final totalLevel = totalLevelAsync.whenData((v) => v).valueOrNull ?? 1;
        final classLine = classesAsync.whenData((list) {
          return list.map((c) {
            final name = CharacterService.classDisplayName(c.classId, l10n);
            return '$name ${c.level}';
          }).join(' / ');
        }).valueOrNull ?? '';

        final speciesName = ref.watch(characterSpeciesNameProvider(characterId)).valueOrNull;
        final subspeciesName = ref.watch(characterSubspeciesNameProvider(characterId)).valueOrNull;
        final backgroundName = ref.watch(characterBackgroundNameProvider(characterId)).valueOrNull;

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
                if (character.imageUrl != null && character.imageUrl!.isNotEmpty) ...[
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
                      Text(character.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      if (subtitleText.isNotEmpty)
                        Text(subtitleText, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.gavel, color: AppTheme.neonCyan),
                tooltip: 'Accéder à la Forge',
                onPressed: () {
                  ref.read(forgeSelectedCharacterIdProvider.notifier).state = character.id;
                  ref.read(mainTabNavigationProvider.notifier).state = 1;
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_upward, color: AppTheme.neonPurple),
                tooltip: l10n.levelUp,
                onPressed: () => Navigator.of(context).pushNamed(
                  '/character/levelup',
                  arguments: characterId,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.neonRed),
                tooltip: l10n.characterDelete,
                onPressed: () => _confirmDelete(context, ref, character),
              ),
              IconButton(
                icon: const Icon(Icons.picture_as_pdf, color: AppTheme.neonCyan),
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
                    ],
                  ),
          ),
          body: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _StatsTab(characterId: characterId, character: character, totalLevel: totalLevel),
                    ),
                    VerticalDivider(width: 1, color: Colors.white.withValues(alpha: 0.08)),
                    Expanded(
                      flex: 4,
                      child: _CombatTab(characterId: characterId, character: character, totalLevel: totalLevel),
                    ),
                    VerticalDivider(width: 1, color: Colors.white.withValues(alpha: 0.08)),
                    Expanded(
                      flex: 4,
                      child: _RightTabbedPanel(characterId: characterId, character: character),
                    ),
                  ],
                )
              : TabBarView(
                  children: [
                    _StatsTab(characterId: characterId, character: character, totalLevel: totalLevel),
                    _CombatTab(characterId: characterId, character: character, totalLevel: totalLevel),
                    _MagicTab(characterId: characterId, character: character),
                    _EquipmentTab(characterId: characterId, character: character),
                    _ProfileTab(characterId: characterId, character: character),
                  ],
                ),
        );

        return isDesktop
            ? mainScaffold
            : DefaultTabController(
                length: 5,
                child: mainScaffold,
              );
      },
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Character character) async {
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

class _RightTabbedPanelState extends State<_RightTabbedPanel> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _MagicTab(characterId: widget.characterId, character: widget.character),
              _EquipmentTab(characterId: widget.characterId, character: widget.character),
              _ProfileTab(characterId: widget.characterId, character: widget.character),
            ],
          ),
        ),
      ],
    );
  }
}

