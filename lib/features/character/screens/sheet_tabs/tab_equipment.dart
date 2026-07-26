part of '../character_sheet_screen.dart';

class _EquipmentTab extends ConsumerWidget {
  final int characterId;
  final Character character;

  const _EquipmentTab({required this.characterId, required this.character});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipAsync = ref.watch(characterEquipmentProvider(characterId));
    final colorScheme = Theme.of(context).colorScheme;

    Map<String, int> currency = {'cp': 0, 'sp': 0, 'ep': 0, 'gp': 0, 'pp': 0};
    try {
      final decoded = jsonDecode(character.currency) as Map<String, dynamic>;
      currency = decoded.map((k, v) => MapEntry(k, (v as num).toInt()));
    } catch (_) {}

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Currency ─────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monnaie', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                tooltip: 'Gérer la monnaie',
                onPressed: () => _showEditCurrencyDialog(context, ref, currency),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CoinBadge(label: 'PC', value: currency['cp'] ?? 0, color: Colors.brown),
                  _CoinBadge(label: 'PA', value: currency['sp'] ?? 0, color: Colors.grey),
                  _CoinBadge(label: 'PE', value: currency['ep'] ?? 0, color: Colors.blueGrey),
                  _CoinBadge(label: 'PO', value: currency['gp'] ?? 0, color: Colors.amber),
                  _CoinBadge(label: 'PP', value: currency['pp'] ?? 0, color: Colors.white70),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Equipment list ────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Inventaire', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddItemDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 8),
          equipAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Erreur: $e'),
            data: (items) {
              if (items.isEmpty) {
                return Text('Aucun objet.',
                    style: TextStyle(color: colorScheme.onSurfaceVariant));
              }
              final totalWeight = items.fold<double>(
                  0, (sum, i) => sum + i.weight * i.quantity);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...items.map((item) => _EquipmentTile(
                        item: item,
                        characterId: characterId,
                      )),
                  const SizedBox(height: 8),
                  Text('Poids total : ${totalWeight.toStringAsFixed(1)} kg',
                      style: TextStyle(
                          fontSize: 12, color: colorScheme.onSurfaceVariant)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');
    final weightCtrl = TextEditingController(text: '0.0');

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter un objet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Autocomplete<DndItemPreset>(
                displayStringForOption: (DndItemPreset option) => option.name,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<DndItemPreset>.empty();
                  }
                  return _dndItemPresets.where((DndItemPreset option) {
                    return option.name
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (DndItemPreset selection) {
                  nameCtrl.text = selection.name;
                  weightCtrl.text = selection.weight.toString();
                },
                fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                  // Synchronize autocomplete input with nameCtrl
                  if (nameCtrl.text.isNotEmpty && textEditingController.text.isEmpty) {
                    textEditingController.text = nameCtrl.text;
                  }
                  textEditingController.addListener(() {
                    nameCtrl.text = textEditingController.text;
                  });
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Nom de l\'objet',
                      hintText: 'Ex: Épée longue, Rations...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              TextField(
                  controller: qtyCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Quantité',
                    prefixIcon: Icon(Icons.unfold_more),
                  ),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextField(
                  controller: weightCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Poids total (kg)',
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Annuler')),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              final db = ref.read(databaseProvider);
              await db.characterDao.insertEquipment(CharacterEquipmentCompanion.insert(
                characterId: characterId,
                itemName: nameCtrl.text.trim(),
                quantity: Value(int.tryParse(qtyCtrl.text) ?? 1),
                weight: Value(double.tryParse(weightCtrl.text) ?? 0.0),
              ));
              await CharacterService(db).recalculateCharacterAc(characterId);
              ref.invalidate(characterByIdProvider(characterId));
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showEditCurrencyDialog(BuildContext context, WidgetRef ref, Map<String, int> currentCurrency) {
    final cpCtrl = TextEditingController(text: currentCurrency['cp']?.toString() ?? '0');
    final spCtrl = TextEditingController(text: currentCurrency['sp']?.toString() ?? '0');
    final epCtrl = TextEditingController(text: currentCurrency['ep']?.toString() ?? '0');
    final gpCtrl = TextEditingController(text: currentCurrency['gp']?.toString() ?? '0');
    final ppCtrl = TextEditingController(text: currentCurrency['pp']?.toString() ?? '0');

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Gérer la monnaie'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCoinField('Pièces de Cuivre (PC)', cpCtrl, Colors.brown),
                const SizedBox(height: 8),
                _buildCoinField('Pièces d\'Argent (PA)', spCtrl, Colors.grey),
                const SizedBox(height: 8),
                _buildCoinField('Pièces d\'Électrum (PE)', epCtrl, Colors.blueGrey),
                const SizedBox(height: 8),
                _buildCoinField('Pièces d\'Or (PO)', gpCtrl, Colors.amber),
                const SizedBox(height: 8),
                _buildCoinField('Pièces de Platine (PP)', ppCtrl, Colors.white70),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () async {
                final cp = int.tryParse(cpCtrl.text) ?? 0;
                final sp = int.tryParse(spCtrl.text) ?? 0;
                final ep = int.tryParse(epCtrl.text) ?? 0;
                final gp = int.tryParse(gpCtrl.text) ?? 0;
                final pp = int.tryParse(ppCtrl.text) ?? 0;

                final newMap = {
                  'cp': cp,
                  'sp': sp,
                  'ep': ep,
                  'gp': gp,
                  'pp': pp,
                };

                final db = ref.read(databaseProvider);
                await db.characterDao.updateCharacter(
                  CharactersCompanion(
                    id: Value(characterId),
                    currency: Value(jsonEncode(newMap)),
                  ),
                );

                ref.invalidate(characterByIdProvider(characterId));
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCoinField(String label, TextEditingController ctrl, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.monetization_on, color: color),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}

class _CoinBadge extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _CoinBadge({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _EquipmentTile extends ConsumerWidget {
  final CharacterEquipmentData item;
  final int characterId;

  const _EquipmentTile({required this.item, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAmmo = StartingEquipmentHelper.isAmmunitionItem(item.itemName);
    return isAmmo ? _buildAmmoTile(context, ref) : _buildGearTile(context, ref);
  }

  Widget _buildAmmoTile(BuildContext context, WidgetRef ref) {
    final outOfStock = item.quantity <= 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: outOfStock
              ? Colors.red.withValues(alpha: 0.4)
              : Colors.amber.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: outOfStock
                    ? Colors.red.withValues(alpha: 0.12)
                    : Colors.amber.withValues(alpha: 0.12),
              ),
              child: Icon(
                Icons.my_location,
                size: 18,
                color: outOfStock ? Colors.red : Colors.amber,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: outOfStock ? Colors.red.shade300 : Colors.white,
                    ),
                  ),
                  Text(
                    '${item.weight.toStringAsFixed(2)} kg/unité',
                    style: const TextStyle(fontSize: 10, color: Colors.white38),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepperButton(
                  icon: Icons.remove,
                  color: item.quantity > 0 ? Colors.red.shade300 : Colors.grey,
                  onTap: item.quantity > 0 ? () => _adjustQuantity(ref, -1) : null,
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 36),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '${item.quantity}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: outOfStock ? Colors.red : Colors.amber,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: Icons.add,
                  color: Colors.green.shade300,
                  onTap: () => _adjustQuantity(ref, 1),
                ),
              ],
            ),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () async {
                final db = ref.read(databaseProvider);
                await db.characterDao.deleteEquipment(item.id);
                await CharacterService(db).recalculateCharacterAc(characterId);
                ref.invalidate(characterByIdProvider(characterId));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGearTile(BuildContext context, WidgetRef ref) {
    final equipped = item.equipped;
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: equipped ? AppTheme.neonCyan.withValues(alpha: 0.5) : Colors.transparent,
          width: equipped ? 1.5 : 0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: equipped
                    ? AppTheme.neonCyan.withValues(alpha: 0.15)
                    : Colors.grey.withValues(alpha: 0.1),
              ),
              child: Icon(
                equipped ? Icons.shield : Icons.backpack_outlined,
                size: 18,
                color: equipped ? AppTheme.neonCyan : Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: equipped ? Colors.white : Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'x${item.quantity}  •  ${item.weight.toStringAsFixed(1)} kg',
                        style: const TextStyle(fontSize: 11, color: Colors.white54),
                      ),
                      if (item.attuned) ...const [
                        SizedBox(width: 6),
                        Icon(Icons.auto_awesome, size: 12, color: Colors.amber),
                        Text(' Syntonie', style: TextStyle(fontSize: 10, color: Colors.amber)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _toggleEquipped(ref),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: equipped
                      ? AppTheme.neonCyan.withValues(alpha: 0.2)
                      : Colors.grey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: equipped ? AppTheme.neonCyan : Colors.grey,
                    width: 1,
                  ),
                ),
                child: Text(
                  equipped ? '✓ Équipé' : 'Ranger',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: equipped ? AppTheme.neonCyan : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () async {
                final db = ref.read(databaseProvider);
                await db.characterDao.deleteEquipment(item.id);
                await CharacterService(db).recalculateCharacterAc(characterId);
                ref.invalidate(characterByIdProvider(characterId));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _adjustQuantity(WidgetRef ref, int delta) async {
    final newQty = (item.quantity + delta).clamp(0, 9999);
    final db = ref.read(databaseProvider);
    await db.characterDao.updateEquipment(
      CharacterEquipmentCompanion(
        id: Value(item.id),
        characterId: Value(characterId),
        itemName: Value(item.itemName),
        quantity: Value(newQty),
        weight: Value(item.weight),
        equipped: Value(item.equipped),
        attuned: Value(item.attuned),
        notes: Value(item.notes),
      ),
    );
    await CharacterService(db).recalculateCharacterAc(characterId);
    ref.invalidate(characterByIdProvider(characterId));
  }

  Future<void> _toggleEquipped(WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    await db.characterDao.updateEquipment(
      CharacterEquipmentCompanion(
        id: Value(item.id),
        characterId: Value(characterId),
        itemName: Value(item.itemName),
        quantity: Value(item.quantity),
        weight: Value(item.weight),
        equipped: Value(!item.equipped),
        attuned: Value(item.attuned),
        notes: Value(item.notes),
      ),
    );
    await CharacterService(db).recalculateCharacterAc(characterId);
    ref.invalidate(characterByIdProvider(characterId));
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap != null
              ? color.withValues(alpha: 0.15)
              : Colors.grey.withValues(alpha: 0.05),
          border: Border.all(
            color: onTap != null ? color.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(icon, size: 16, color: onTap != null ? color : Colors.grey),
      ),
    );
  }
}

class DndItemPreset {
  final String name;
  final double weight; // in kg
  
  const DndItemPreset(this.name, this.weight);
}

const List<DndItemPreset> _dndItemPresets = [
  // Armes
  DndItemPreset('Dague', 0.5),
  DndItemPreset('Épée courte', 1.0),
  DndItemPreset('Épée longue', 1.5),
  DndItemPreset('Rapière', 1.0),
  DndItemPreset('Cimeterre', 1.5),
  DndItemPreset('Espadon', 3.0),
  DndItemPreset('Grande hache', 3.5),
  DndItemPreset('Hache d\'armes', 2.0),
  DndItemPreset('Hachette', 1.0),
  DndItemPreset('Masse', 2.0),
  DndItemPreset('Marteau de guerre', 1.0),
  DndItemPreset('Marteau léger', 1.0),
  DndItemPreset('Lance', 1.5),
  DndItemPreset('Javelot', 1.0),
  DndItemPreset('Bâton', 2.0),
  DndItemPreset('Arc court', 1.0),
  DndItemPreset('Arc long', 1.0),
  DndItemPreset('Arbalète légère', 2.5),
  DndItemPreset('Arbalète lourde', 8.0),
  DndItemPreset('Fronde', 0.0),
  
  // Armures & Boucliers
  DndItemPreset('Armure de rembourrage', 4.0),
  DndItemPreset('Armure de cuir', 5.0),
  DndItemPreset('Cuir clouté', 6.0),
  DndItemPreset('Chemise de mailles', 10.0),
  DndItemPreset('Cotte de mailles', 25.0),
  DndItemPreset('Cuirasse', 10.0),
  DndItemPreset('Demi-harnois', 20.0),
  DndItemPreset('Harnois', 30.0),
  DndItemPreset('Bouclier', 3.0),
  
  // Équipement d'aventure
  DndItemPreset('Sac à dos', 2.5),
  DndItemPreset('Sac de couchage', 3.5),
  DndItemPreset('Gourde (pleine)', 2.5),
  DndItemPreset('Rations (1 jour)', 1.0),
  DndItemPreset('Corde en chanvre (15m)', 5.0),
  DndItemPreset('Corde en soie (15m)', 2.5),
  DndItemPreset('Torche', 0.5),
  DndItemPreset('Lanterne sourde', 1.0),
  DndItemPreset('Huile (flacon)', 0.5),
  DndItemPreset('Pied-de-biche', 2.5),
  DndItemPreset('Trousse de soins', 1.5),
  DndItemPreset('Outils de voleur', 0.5),
  DndItemPreset('Symbole sacré', 0.5),
  DndItemPreset('Livre d\'instructions', 2.5),
  DndItemPreset('Vêtements communs', 1.5),
  DndItemPreset('Vêtements de voyage', 2.0),
  DndItemPreset('Vêtements fins', 3.0),
  DndItemPreset('Focalisateur arcanique', 1.5),
  DndItemPreset('Grimoire', 1.5),
  DndItemPreset('Coffre', 12.5),
  DndItemPreset('Cadenas', 0.5),
  DndItemPreset('Pelle', 2.5),
  DndItemPreset('Miroir en acier', 0.2),
];
