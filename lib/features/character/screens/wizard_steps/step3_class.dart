import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/character_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/character_providers.dart';
import '../../providers/wizard_provider.dart';

class Step3Class extends ConsumerWidget {
  const Step3Class({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final wizard = ref.watch(wizardProvider);
    final classesAsync = ref.watch(srdClassesProvider(wizard.ruleset));
    final notifier = ref.read(wizardProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.wizardStepClass,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Ajoutez une ou plusieurs classes (multiclasse).',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),

        // Current class entries
        ...wizard.classes.asMap().entries.map((e) {
          return _ClassEntryTile(
            index: e.key,
            entry: e.value,
            ruleset: wizard.ruleset,
            onRemove: () => notifier.removeClass(e.key),
            onUpdate: (updated) => notifier.updateClass(e.key, updated),
          );
        }),

        const SizedBox(height: 16),

        // Add class button
        classesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Erreur: $e'),
          data: (classes) {
            final usedClassIds =
                wizard.classes.map((c) => c.classId).toSet();
            final available =
                classes.where((c) => !usedClassIds.contains(c.id)).toList();

            if (available.isEmpty) return const SizedBox.shrink();

            return OutlinedButton.icon(
              onPressed: () => _showAddClassDialog(
                  context, ref, available, wizard, notifier, l10n),
              icon: const Icon(Icons.add),
              label: const Text('Ajouter une classe'),
            );
          },
        ),

        if (wizard.totalLevel > 1) ...[
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Niveau total : ${wizard.totalLevel}. '
                      'Réservé aux personnages expérimentés. '
                      'Assurez-vous de respecter les prérequis de multiclasse.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        // ── Weapon Masteries (DnD 2024 only) ────────────────────────────
        if (wizard.ruleset.name == 'dnd2024' && wizard.classes.isNotEmpty) ...[
          const SizedBox(height: 24),
          _WeaponMasteriesPanel(wizard: wizard, notifier: notifier),
        ],
      ],
    );
  }

  Future<void> _showAddClassDialog(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> available,
    WizardState wizard,
    WizardNotifier notifier,
    AppLocalizations l10n,
  ) async {
    String? selectedClassId;
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Choisir une classe'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: available.map((cls) {
                final isSelected = selectedClassId == cls.id;
                return ListTile(
                  title: Text(CharacterService.classDisplayName(cls.id as String, l10n)),
                  subtitle: Text('Dé de vie : d${cls.hitDie}'),
                  leading: Radio<String>(
                    value: cls.id as String,
                    groupValue: selectedClassId,
                    onChanged: (v) => setState(() => selectedClassId = v),
                  ),
                  onTap: () =>
                      setState(() => selectedClassId = cls.id as String),
                  selected: isSelected,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.actionCancel),
            ),
            FilledButton(
              onPressed: selectedClassId == null
                  ? null
                  : () {
                      notifier.addClass(
                        WizardClassEntry(classId: selectedClassId!),
                      );
                      Navigator.of(ctx).pop();
                    },
              child: Text(l10n.actionAdd),
            ),
          ],
        ),
      ),
    );
  }
}


class _ClassEntryTile extends ConsumerWidget {
  final int index;
  final WizardClassEntry entry;
  final dynamic ruleset;
  final VoidCallback onRemove;
  final void Function(WizardClassEntry) onUpdate;

  const _ClassEntryTile({
    required this.index,
    required this.entry,
    required this.ruleset,
    required this.onRemove,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final subclassesAsync = ref.watch(
      srdSubclassesProvider((classId: entry.classId, ruleset: ruleset)),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    CharacterService.classDisplayName(entry.classId, l10n),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onRemove,
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Niveau :'),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: entry.level <= 1
                      ? null
                      : () => onUpdate(entry.copyWith(level: entry.level - 1)),
                ),
                Text(
                  '${entry.level}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: entry.level >= 20
                      ? null
                      : () => onUpdate(entry.copyWith(level: entry.level + 1)),
                ),
              ],
            ),
            // Subclass (available from level 3 for most classes)
            if (entry.level >= 3)
              subclassesAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => const SizedBox.shrink(),
                data: (subclasses) {
                  if (subclasses.isEmpty) return const SizedBox.shrink();
                  final selectedSubclass = subclasses.where((s) => s.id == entry.subclassId).firstOrNull;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        key: ValueKey(entry.subclassId),
                        decoration: const InputDecoration(
                          labelText: 'Sous-classe',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        value: entry.subclassId,
                        items: [
                          const DropdownMenuItem(
                              value: null, child: Text('— Choisir plus tard —')),
                          ...subclasses.map((s) => DropdownMenuItem(
                                value: s.id,
                                child: Text(s.name),
                              )),
                        ],
                        onChanged: (v) => onUpdate(entry.copyWith(subclassId: v)),
                      ),
                      if (selectedSubclass != null) ...[
                        const SizedBox(height: 8),
                        Container(
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
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

/// Panel for choosing Weapon Masteries (DnD 2024 only, shown in Step 3)
class _WeaponMasteriesPanel extends ConsumerWidget {
  final WizardState wizard;
  final WizardNotifier notifier;

  const _WeaponMasteriesPanel({required this.wizard, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masteriesAsync = ref.watch(srdWeaponMasteriesProvider);
    final primaryClassId = wizard.classes.firstOrNull?.classId ?? '';
    final maxMasteries = WizardNotifier.weaponMasteryCountForClass(primaryClassId);
    final chosen = wizard.chosenWeaponMasteries.length;

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.gavel, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Maîtrises d\'armes (DnD 2024)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Choisissez $maxMasteries maîtrise(s) d\'arme ($chosen/$maxMasteries sélectionnées)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            masteriesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Erreur: $e'),
              data: (masteries) => Wrap(
                spacing: 8,
                runSpacing: 4,
                children: masteries.map((m) {
                  final isChosen = wizard.chosenWeaponMasteries.contains(m.id);
                  final canAdd = !isChosen && chosen < maxMasteries;
                  return FilterChip(
                    label: Text(m.name, style: const TextStyle(fontSize: 12)),
                    selected: isChosen,
                    onSelected: (canAdd || isChosen)
                        ? (_) => notifier.toggleWeaponMastery(m.id)
                        : null,
                    tooltip: m.description.length > 80
                        ? m.description.substring(0, 80) + '...'
                        : m.description,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
