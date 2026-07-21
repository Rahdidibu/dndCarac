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

        // ── Warlock Pact (DnD 2024 only) ────────────────────────────────
        if (wizard.ruleset.name == 'dnd2024' &&
            wizard.classes.any((c) => c.classId == 'warlock')) ...[
          const SizedBox(height: 24),
          _WarlockPactPanel(wizard: wizard, notifier: notifier),
        ],

        // ── Divine Order (Cleric Level 1, DnD 2024 only) ────────────────
        if (wizard.ruleset.name == 'dnd2024' &&
            wizard.classes.any((c) => c.classId == 'cleric' && c.level >= 1)) ...[
          const SizedBox(height: 24),
          _DivineOrderPanel(wizard: wizard, notifier: notifier),
        ],

        // ── Primal Order (Druid Level 1, DnD 2024 only) ─────────────────
        if (wizard.ruleset.name == 'dnd2024' &&
            wizard.classes.any((c) => c.classId == 'druid' && c.level >= 1)) ...[
          const SizedBox(height: 24),
          _PrimalOrderPanel(wizard: wizard, notifier: notifier),
        ],

        // ── Fighting Style (Fighter lvl 1, Ranger lvl 2, Paladin lvl 2, DnD 2024 only)
        if (wizard.ruleset.name == 'dnd2024' &&
            wizard.classes.any((c) =>
                (c.classId == 'fighter' && c.level >= 1) ||
                (c.classId == 'ranger' && c.level >= 2) ||
                (c.classId == 'paladin' && c.level >= 2))) ...[
          const SizedBox(height: 24),
          _FightingStylePanel(wizard: wizard, notifier: notifier),
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

    IconData getClassIcon(String classId) {
      switch (classId) {
        case 'barbarian':
          return Icons.gavel;
        case 'bard':
          return Icons.music_note;
        case 'cleric':
          return Icons.favorite;
        case 'druid':
          return Icons.nature;
        case 'fighter':
          return Icons.shield;
        case 'monk':
          return Icons.sports_martial_arts;
        case 'paladin':
          return Icons.workspace_premium;
        case 'ranger':
          return Icons.explore;
        case 'rogue':
          return Icons.vpn_key;
        case 'sorcerer':
          return Icons.bolt;
        case 'warlock':
          return Icons.auto_awesome;
        case 'wizard':
          return Icons.menu_book;
        default:
          return Icons.help_outline;
      }
    }

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final colorScheme = Theme.of(context).colorScheme;
          final isLarge = MediaQuery.of(context).size.width > 600;

          return AlertDialog(
            title: const Text('Choisir une classe', style: TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: 600,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isLarge ? 3 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.15,
                ),
                itemCount: available.length,
                itemBuilder: (context, index) {
                  final cls = available[index];
                  final isSelected = selectedClassId == cls.id;
                  final classIcon = getClassIcon(cls.id as String);
                  final className = CharacterService.classDisplayName(cls.id as String, l10n);

                  return _ClassSelectCard(
                    className: className,
                    hitDie: cls.hitDie as int,
                    icon: classIcon,
                    selected: isSelected,
                    onTap: () => setState(() => selectedClassId = cls.id as String),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.actionCancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                onPressed: selectedClassId == null
                    ? null
                    : () {
                        notifier.addClass(
                          WizardClassEntry(classId: selectedClassId!),
                        );
                        Navigator.of(ctx).pop();
                      },
                child: Text(l10n.actionAdd, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ClassSelectCard extends StatefulWidget {
  final String className;
  final int hitDie;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ClassSelectCard({
    required this.className,
    required this.hitDie,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_ClassSelectCard> createState() => _ClassSelectCardState();
}

class _ClassSelectCardState extends State<_ClassSelectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (widget.selected || _isHovered)
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.15),
                blurRadius: 8,
                spreadRadius: 0.5,
              ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          color: widget.selected
              ? primaryColor.withValues(alpha: 0.2)
              : _isHovered
                  ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                  : colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: widget.selected
                  ? primaryColor
                  : _isHovered
                      ? primaryColor.withValues(alpha: 0.5)
                      : colorScheme.outline.withValues(alpha: 0.15),
              width: widget.selected ? 1.5 : 1,
            ),
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 24,
                    color: widget.selected ? primaryColor : colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.className,
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: widget.selected ? primaryColor : colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'd${widget.hitDie} PV',
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 10,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                        initialValue: entry.subclassId,
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
                        ? '${m.description.substring(0, 80)}...'
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

class _WarlockPactPanel extends ConsumerWidget {
  final WizardState wizard;
  final WizardNotifier notifier;

  const _WarlockPactPanel({required this.wizard, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosenPact = wizard.chosenWarlockPact;

    final pacts = [
      (
        id: 'pact-of-the-blade',
        name: 'Pacte de la Lame (Pact of the Blade)',
        desc: 'Vous pouvez invoquer une arme magique ou lier une arme existante. Vous maîtrisez cette arme et utilisez votre modificateur de Charisme pour les jets d\'attaque et de dégâts.'
      ),
      (
        id: 'pact-of-the-chain',
        name: 'Pacte de la Chaîne (Pact of the Chain)',
        desc: 'Vous apprenez le sort Appel de familier avec des formes spéciales (diablotin, pseudodragon, quasit, sprite). Votre familier peut également attaquer.'
      ),
      (
        id: 'pact-of-the-tome',
        name: 'Pacte du Grimoire (Pact of the Tome)',
        desc: 'Vous obtenez un Livre des Ombres contenant 3 tours de magie de n\'importe quelle classe et 2 emplacements de sorts de warlock de niveau 1 supplémentaires.'
      ),
    ];

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
                Icon(Icons.auto_stories, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pacte de Démoniste (Niveau 1)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...pacts.map((pact) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<String>(
                  title: Text(pact.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(pact.desc, style: const TextStyle(fontSize: 12)),
                  value: pact.id,
                  groupValue: chosenPact,
                  onChanged: (val) => notifier.setWarlockPact(val),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DivineOrderPanel extends ConsumerWidget {
  final WizardState wizard;
  final WizardNotifier notifier;

  const _DivineOrderPanel({required this.wizard, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosen = wizard.chosenDivineOrder;

    final options = [
      (
        id: 'protector',
        name: 'Protecteur (Protector)',
        desc: 'Vous gagnez la maîtrise des armures lourdes et des armes de guerre.'
      ),
      (
        id: 'thaumaturge',
        name: 'Thaumaturge',
        desc: 'Vous apprenez un tour de magie de clerc supplémentaire. De plus, vous ajoutez votre modificateur de Sagesse à vos tests d\'Arcanes et de Religion.'
      ),
    ];

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
                Icon(Icons.shield, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ordre Divin (Divine Order - Niveau 1)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...options.map((opt) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<String>(
                  title: Text(opt.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(opt.desc, style: const TextStyle(fontSize: 12)),
                  value: opt.id,
                  groupValue: chosen,
                  onChanged: (val) => notifier.setDivineOrder(val),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PrimalOrderPanel extends ConsumerWidget {
  final WizardState wizard;
  final WizardNotifier notifier;

  const _PrimalOrderPanel({required this.wizard, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosen = wizard.chosenPrimalOrder;

    final options = [
      (
        id: 'magician',
        name: 'Magicien (Magician)',
        desc: 'Vous apprenez un tour de magie de druide supplémentaire. De plus, vous ajoutez votre modificateur de Sagesse à vos tests d\'Arcanes et de Nature.'
      ),
      (
        id: 'warden',
        name: 'Protecteur sauvage (Warden)',
        desc: 'Vous gagnez la maîtrise des armures moyennes et des armes de guerre.'
      ),
    ];

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
                Icon(Icons.forest, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ordre Primal (Primal Order - Niveau 1)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...options.map((opt) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<String>(
                  title: Text(opt.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(opt.desc, style: const TextStyle(fontSize: 12)),
                  value: opt.id,
                  groupValue: chosen,
                  onChanged: (val) => notifier.setPrimalOrder(val),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FightingStylePanel extends ConsumerWidget {
  final WizardState wizard;
  final WizardNotifier notifier;

  const _FightingStylePanel({required this.wizard, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosen = wizard.chosenFightingStyle;

    final styles = [
      (
        id: 'archery',
        name: 'Archerie (Archery)',
        desc: 'Vous gagnez un bonus de +2 aux jets d\'attaque avec des armes à distance.'
      ),
      (
        id: 'defense',
        name: 'Défense (Defense)',
        desc: 'Tant que vous portez une armure, vous gagnez un bonus de +1 à votre classe d\'armure (CA).'
      ),
      (
        id: 'great-weapon-fighting',
        name: 'Armes à deux mains (Great Weapon Fighting)',
        desc: 'Lorsque vous lancez les dégâts d\'une attaque au corps à corps avec une arme à deux mains, vous pouvez remplacer tout résultat de 1 ou 2 par un 3.'
      ),
      (
        id: 'two-weapon-fighting',
        name: 'Combat à deux armes (Two-Weapon Fighting)',
        desc: 'Lorsque vous effectuez l\'attaque supplémentaire du combat à deux armes, vous pouvez ajouter votre modificateur de caractéristique aux dégâts de cette attaque.'
      ),
    ];

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
                Icon(Icons.fitness_center, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Style de Combat (Fighting Style)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...styles.map((opt) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<String>(
                  title: Text(opt.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(opt.desc, style: const TextStyle(fontSize: 12)),
                  value: opt.id,
                  groupValue: chosen,
                  onChanged: (val) => notifier.setFightingStyle(val),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}


