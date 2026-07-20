import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';
import '../../../core/providers/database_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/character_providers.dart';


class CharacterListScreen extends ConsumerWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final charactersAsync = ref.watch(charactersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navCharacters),
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'create_batman',
            onPressed: () => Navigator.of(context).pushNamed('/batman/create'),
            icon: const Icon(Icons.local_police_outlined),
            label: const Text('Batman RPG'),
            backgroundColor: Colors.black,
            foregroundColor: Colors.amber,
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'create_dnd',
            onPressed: () => _openCreationWizard(context),
            icon: const Icon(Icons.add),
            label: Text(l10n.characterCreate),
          ),
        ],
      ),
      body: charactersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (characters) {
          if (characters.isEmpty) {
            return _EmptyState(l10n: l10n);
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              return _CharacterCard(character: characters[index]);
            },
          );
        },
      ),
    );
  }

  void _openCreationWizard(BuildContext context) {
    Navigator.of(context).pushNamed('/character/create');
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shield_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.charactersEmptyTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.charactersEmptySubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterCard extends ConsumerWidget {
  final Character character;
  const _CharacterCard({required this.character});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classesAsync = ref.watch(characterClassesProvider(character.id));
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;


    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          final route = character.ruleset == RulesetVersion.batman
              ? '/batman/sheet'
              : '/character/sheet';
          Navigator.of(context).pushNamed(route, arguments: character.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: (character.imageUrl != null && character.imageUrl!.isNotEmpty)
                    ? NetworkImage(character.imageUrl!)
                    : null,
                child: (character.imageUrl != null && character.imageUrl!.isNotEmpty)
                    ? null
                    : Text(
                        character.name.isNotEmpty
                            ? character.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    classesAsync.when(
                      loading: () => const SizedBox(
                          height: 16,
                          width: 80,
                          child: LinearProgressIndicator()),
                      error: (e, stack) => const SizedBox.shrink(),
                      data: (classes) => Text(
                        _buildClassLine(classes),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _RulesetChip(ruleset: character.ruleset),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
                onSelected: (value) {
                  if (value == 'delete') {
                    _confirmDelete(context, ref);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: colorScheme.error, size: 20),
                        const SizedBox(width: 8),
                        Text(l10n.actionDelete, style: TextStyle(color: colorScheme.error)),
                      ],
                    ),
                  ),
                ],
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  String _buildClassLine(List<CharacterClassesData> classes) {
    if (classes.isEmpty) return '—';
    return classes
        .map((c) => '${_capitalize(c.classId)} ${c.level}')
        .join(' / ');
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
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
    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await db.characterDao.deleteCharacter(character.id);
      ref.invalidate(charactersProvider);
    }
  }
}


class _RulesetChip extends StatelessWidget {
  final RulesetVersion ruleset;
  const _RulesetChip({required this.ruleset});

  @override
  Widget build(BuildContext context) {
    final label = switch (ruleset) {
      RulesetVersion.dnd2014 => '5e 2014',
      RulesetVersion.dnd2024 => '5e 2024',
      RulesetVersion.batman => 'Batman RPG',
    };
    final bgColor = ruleset == RulesetVersion.batman
        ? Colors.amber.shade900
        : Theme.of(context).colorScheme.secondaryContainer;
    final fgColor = ruleset == RulesetVersion.batman
        ? Colors.amber
        : Theme.of(context).colorScheme.onSecondaryContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fgColor,
            ),
      ),
    );
  }
}
