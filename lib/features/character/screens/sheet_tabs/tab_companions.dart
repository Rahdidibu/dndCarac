import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/models/character_companion.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/roll_result_dialog.dart';
import '../../providers/character_providers.dart';

class TabCompanions extends ConsumerWidget {
  final int characterId;
  final Character character;

  const TabCompanions({
    super.key,
    required this.characterId,
    required this.character,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companionsAsync = ref.watch(characterCompanionsProvider(characterId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Compagnons & Familiers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cinzel',
                    color: AppTheme.neonCyan,
                  ),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Ajouter'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.neonCyan,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => _openCompanionDialog(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 16),
            companionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  'Erreur lors du chargement des compagnons : $e',
                  style: const TextStyle(color: AppTheme.neonRed),
                ),
              ),
              data: (companions) {
                if (companions.isEmpty) {
                  return _buildEmptyState(context, ref);
                }
                return Column(
                  children: companions
                      .map((c) => _CompanionCard(
                            companion: c,
                            characterId: characterId,
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        children: [
          const Icon(Icons.pets, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          const Text(
            'Aucun compagnon ou familier',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ajoutez votre familier arcanique, votre compagnon animal, votre monture ou vos invocations de combat.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ActionChip(
                avatar: const Text('🦉'),
                label: const Text('Chouette (Familier)'),
                onPressed: () => _createPresetCompanion(context, ref, 'owl'),
              ),
              ActionChip(
                avatar: const Text('🐺'),
                label: const Text('Loup (Compagnon)'),
                onPressed: () => _createPresetCompanion(context, ref, 'wolf'),
              ),
              ActionChip(
                avatar: const Text('🐎'),
                label: const Text('Cheval de selle (Monture)'),
                onPressed: () => _createPresetCompanion(context, ref, 'horse'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _createPresetCompanion(BuildContext context, WidgetRef ref, String presetKey) async {
    final db = ref.read(databaseProvider);
    Map<String, dynamic> data;

    switch (presetKey) {
      case 'owl':
        data = {
          'character_id': characterId,
          'name': 'Chouette arcanique',
          'type': 'Familier',
          'hp_current': 1,
          'hp_max': 1,
          'armor_class': 11,
          'speed': '1,5 m, vol 18 m',
          'attacks': jsonEncode([
            {'name': 'Serres', 'bonus': 3, 'damage': '1d1', 'notes': 'Attaque de familier'}
          ]),
          'notes': 'Vol furtif : ne provoque pas d\'attaque d\'opportunité en quittant l\'allonge d\'un ennemi.\nPerception aiguë (+3 à la Perception avec avantage aux jets basés sur la vue/ouïe).',
        };
        break;
      case 'wolf':
        data = {
          'character_id': characterId,
          'name': 'Loup de combat',
          'type': 'Compagnon',
          'hp_current': 11,
          'hp_max': 11,
          'armor_class': 13,
          'speed': '12 m',
          'attacks': jsonEncode([
            {'name': 'Morsure', 'bonus': 4, 'damage': '2d4+2', 'notes': 'Cible jet de sauvegarde FOR DD 11 ou tombe à terre'}
          ]),
          'notes': 'Tactique de meute : avantage aux jets d\'attaque contre une cible à portée d\'un allié conscient.',
        };
        break;
      case 'horse':
        data = {
          'character_id': characterId,
          'name': 'Cheval de selle',
          'type': 'Monture',
          'hp_current': 13,
          'hp_max': 13,
          'armor_class': 10,
          'speed': '18 m',
          'attacks': jsonEncode([
            {'name': 'Sabots', 'bonus': 5, 'damage': '2d4+3', 'notes': 'Attaque de monture'}
          ]),
          'notes': 'Monture rapide capable de porter jusqu\'à 240 kg.',
        };
        break;
      default:
        return;
    }

    await db.characterDao.insertCompanion(data);
    ref.invalidate(characterCompanionsProvider(characterId));
  }

  void _openCompanionDialog(BuildContext context, WidgetRef ref, {CharacterCompanion? companion}) {
    showDialog(
      context: context,
      builder: (ctx) => _AddEditCompanionDialog(
        characterId: characterId,
        companion: companion,
      ),
    );
  }
}

class _CompanionCard extends ConsumerStatefulWidget {
  final CharacterCompanion companion;
  final int characterId;

  const _CompanionCard({
    required this.companion,
    required this.characterId,
  });

  @override
  ConsumerState<_CompanionCard> createState() => _CompanionCardState();
}

class _CompanionCardState extends ConsumerState<_CompanionCard> {
  late int _hpCurrent;

  @override
  void initState() {
    super.initState();
    _hpCurrent = widget.companion.hpCurrent;
  }

  @override
  void didUpdateWidget(covariant _CompanionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.companion.hpCurrent != widget.companion.hpCurrent) {
      _hpCurrent = widget.companion.hpCurrent;
    }
  }

  Future<void> _updateHp(int delta) async {
    final newHp = (_hpCurrent + delta).clamp(0, widget.companion.hpMax);
    setState(() {
      _hpCurrent = newHp;
    });

    final db = ref.read(databaseProvider);
    await db.characterDao.updateCompanion(widget.companion.id, {'hp_current': newHp});
    ref.invalidate(characterCompanionsProvider(widget.characterId));
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.companion;
    final hpRatio = c.hpMax > 0 ? (_hpCurrent / c.hpMax) : 0.0;
    final hpColor = _hpCurrent == 0
        ? AppTheme.neonRed
        : (hpRatio < 0.3 ? Colors.orange : AppTheme.neonGreen);

    List<dynamic> attacksList = [];
    try {
      attacksList = jsonDecode(c.attacks) as List<dynamic>;
    } catch (_) {}

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey.shade900.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _hpCurrent == 0 ? AppTheme.neonRed.withValues(alpha: 0.5) : Colors.grey.shade800,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Text(
                  _getTypeEmoji(c.type),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.neonCyan.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          c.type.toUpperCase(),
                          style: const TextStyle(fontSize: 9, color: AppTheme.neonCyan, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                  onPressed: () => _showMenu(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Stats row (CA, Speed, HP)
            Row(
              children: [
                _statBadge('CA', '${c.armorClass}', Icons.shield, AppTheme.neonCyan),
                const SizedBox(width: 8),
                _statBadge('Vitesse', c.speed, Icons.directions_run, Colors.amber),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppTheme.neonRed, size: 20),
                            onPressed: () => _updateHp(-1),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '$_hpCurrent / ${c.hpMax} PV',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: hpColor,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppTheme.neonGreen, size: 20),
                            onPressed: () => _updateHp(1),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: hpRatio.clamp(0.0, 1.0),
                          backgroundColor: Colors.grey.shade800,
                          color: hpColor,
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Attacks section
            if (attacksList.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 8),
              const Text(
                'Attaques & Actions',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              ...attacksList.map((atk) {
                final name = atk['name'] ?? 'Attaque';
                final bonus = atk['bonus'] as int? ?? 0;
                final damage = atk['damage'] as String? ?? '1d6';
                final notes = atk['notes'] as String? ?? '';

                final bonusStr = bonus >= 0 ? '+$bonus' : '$bonus';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$name ($bonusStr au touché, $damage)',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                            if (notes.isNotEmpty)
                              Text(
                                notes,
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                      FilledButton.icon(
                        icon: const Icon(Icons.casino, size: 14),
                        label: const Text('Touché', style: TextStyle(fontSize: 11)),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          backgroundColor: AppTheme.neonCyan.withValues(alpha: 0.2),
                          foregroundColor: AppTheme.neonCyan,
                        ),
                        onPressed: () {
                          RollResultDialog.show(
                            context,
                            characterId: widget.characterId,
                            rollType: RollType.attack,
                            title: '${c.name} : $name',
                            bonus: bonus,
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.local_fire_department, color: Colors.orange, size: 18),
                        tooltip: 'Dégâts',
                        onPressed: () {
                          RollResultDialog.show(
                            context,
                            characterId: widget.characterId,
                            rollType: RollType.damage,
                            title: '${c.name} : Dégâts $name',
                            bonus: 0,
                            isD20: false,
                            diceExpression: damage,
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],

            // Notes section
            if (c.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  c.notes,
                  style: const TextStyle(fontSize: 12, color: Colors.white70, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statBadge(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 8, color: color, fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  String _getTypeEmoji(String type) {
    switch (type.toLowerCase()) {
      case 'familier':
        return '🦉';
      case 'compagnon':
        return '🐺';
      case 'monture':
        return '🐎';
      case 'invocation':
        return '✨';
      default:
        return '🐉';
    }
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: AppTheme.neonCyan),
              title: const Text('Éditer le compagnon'),
              onTap: () {
                Navigator.of(ctx).pop();
                showDialog(
                  context: context,
                  builder: (_) => _AddEditCompanionDialog(
                    characterId: widget.characterId,
                    companion: widget.companion,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppTheme.neonRed),
              title: const Text('Supprimer', style: TextStyle(color: AppTheme.neonRed)),
              onTap: () async {
                Navigator.of(ctx).pop();
                final db = ref.read(databaseProvider);
                await db.characterDao.deleteCompanion(widget.companion.id);
                ref.invalidate(characterCompanionsProvider(widget.characterId));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AddEditCompanionDialog extends ConsumerStatefulWidget {
  final int characterId;
  final CharacterCompanion? companion;

  const _AddEditCompanionDialog({
    required this.characterId,
    this.companion,
  });

  @override
  ConsumerState<_AddEditCompanionDialog> createState() => _AddEditCompanionDialogState();
}

class _AddEditCompanionDialogState extends ConsumerState<_AddEditCompanionDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _hpMaxController;
  late TextEditingController _acController;
  late TextEditingController _speedController;
  late TextEditingController _atkNameController;
  late TextEditingController _atkBonusController;
  late TextEditingController _atkDamageController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final c = widget.companion;
    _nameController = TextEditingController(text: c?.name ?? '');
    _typeController = TextEditingController(text: c?.type ?? 'Familier');
    _hpMaxController = TextEditingController(text: '${c?.hpMax ?? 5}');
    _acController = TextEditingController(text: '${c?.armorClass ?? 11}');
    _speedController = TextEditingController(text: c?.speed ?? '9 m');
    
    List<dynamic> attacks = [];
    if (c != null) {
      try { attacks = jsonDecode(c.attacks); } catch (_) {}
    }
    final firstAtk = attacks.isNotEmpty ? attacks.first : {};
    _atkNameController = TextEditingController(text: firstAtk['name'] ?? '');
    _atkBonusController = TextEditingController(text: '${firstAtk['bonus'] ?? 2}');
    _atkDamageController = TextEditingController(text: firstAtk['damage'] ?? '1d6');
    _notesController = TextEditingController(text: c?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _hpMaxController.dispose();
    _acController.dispose();
    _speedController.dispose();
    _atkNameController.dispose();
    _atkBonusController.dispose();
    _atkDamageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.companion != null;

    return AlertDialog(
      title: Text(
        isEdit ? 'Éditer le compagnon' : 'Nouveau compagnon / familier',
        style: const TextStyle(fontFamily: 'Cinzel'),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom (Ex: Chouette, Loup, Ombre)'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: ['Familier', 'Compagnon', 'Invocation', 'Monture'].contains(_typeController.text)
                    ? _typeController.text
                    : 'Familier',
                decoration: const InputDecoration(labelText: 'Type'),
                items: ['Familier', 'Compagnon', 'Invocation', 'Monture']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _typeController.text = v!),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _hpMaxController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'PV Max'),
                      validator: (v) => int.tryParse(v ?? '') == null ? 'Valide' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _acController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Classe d\'Armure (CA)'),
                      validator: (v) => int.tryParse(v ?? '') == null ? 'Valide' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _speedController,
                decoration: const InputDecoration(labelText: 'Vitesse (Ex: 9 m, vol 18 m)'),
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Attaque principale (optionnelle)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _atkNameController,
                decoration: const InputDecoration(labelText: 'Nom de l\'attaque (Ex: Morsure, Griffe)'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _atkBonusController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Bonus au touché (+4)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _atkDamageController,
                      decoration: const InputDecoration(labelText: 'Dégâts (Ex: 1d6+2, 2d4)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Notes & Capacités spéciales'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final db = ref.read(databaseProvider);
    final hpMax = int.parse(_hpMaxController.text);
    final ac = int.parse(_acController.text);

    List<Map<String, dynamic>> attacks = [];
    if (_atkNameController.text.trim().isNotEmpty) {
      attacks.add({
        'name': _atkNameController.text.trim(),
        'bonus': int.tryParse(_atkBonusController.text) ?? 0,
        'damage': _atkDamageController.text.trim().isEmpty ? '1d6' : _atkDamageController.text.trim(),
        'notes': '',
      });
    }

    final data = {
      'character_id': widget.characterId,
      'name': _nameController.text.trim(),
      'type': _typeController.text,
      'hp_current': widget.companion?.hpCurrent ?? hpMax,
      'hp_max': hpMax,
      'armor_class': ac,
      'speed': _speedController.text.trim(),
      'attacks': jsonEncode(attacks),
      'notes': _notesController.text.trim(),
    };

    if (widget.companion != null) {
      await db.characterDao.updateCompanion(widget.companion!.id, data);
    } else {
      await db.characterDao.insertCompanion(data);
    }

    ref.invalidate(characterCompanionsProvider(widget.characterId));
    if (mounted) Navigator.of(context).pop();
  }
}
