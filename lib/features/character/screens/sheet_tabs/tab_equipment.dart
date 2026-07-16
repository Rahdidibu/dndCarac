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
          Text('Monnaie', style: Theme.of(context).textTheme.titleMedium),
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(
                controller: qtyCtrl,
                decoration: const InputDecoration(labelText: 'Quantité'),
                keyboardType: TextInputType.number),
            TextField(
                controller: weightCtrl,
                decoration: const InputDecoration(labelText: 'Poids (kg)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true)),
          ],
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
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Ajouter'),
          ),
        ],
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
        CircleAvatar(
          radius: 16,
          backgroundColor: color.withAlpha(60),
          child: Text(label,
              style: TextStyle(
                  fontSize: 9, fontWeight: FontWeight.bold, color: color)),
        ),
        const SizedBox(height: 4),
        Text('$value', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
    return Card(
      child: ListTile(
        leading: item.equipped
            ? const Icon(Icons.shield, size: 18)
            : const Icon(Icons.backpack_outlined, size: 18),
        title: Text(item.itemName, style: const TextStyle(fontSize: 13)),
        subtitle: Text('x${item.quantity} — ${item.weight.toStringAsFixed(1)} kg',
            style: const TextStyle(fontSize: 11)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.attuned)
              const Icon(Icons.auto_awesome, size: 14, color: Colors.amber),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              onPressed: () async {
                final db = ref.read(databaseProvider);
                await db.characterDao.deleteEquipment(item.id);
                await CharacterService(db).recalculateCharacterAc(characterId);
              },
            ),
          ],
        ),
        onTap: () async {
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
        },
      ),
    );
  }
}
