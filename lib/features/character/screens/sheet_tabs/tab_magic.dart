part of '../character_sheet_screen.dart';

class _MagicTab extends ConsumerWidget {
  final int characterId;
  final Character character;

  const _MagicTab({required this.characterId, required this.character});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slotsAsync = ref.watch(characterSpellSlotsProvider(characterId));
    final spellsAsync = ref.watch(characterSpellsProvider(characterId));
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Spell slots ───────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Emplacements de sorts',
                  style: Theme.of(context).textTheme.titleMedium),
              TextButton.icon(
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Repos long', style: TextStyle(fontSize: 12)),
                onPressed: () => _longRest(ref),
              ),
            ],
          ),
          const SizedBox(height: 8),
          slotsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Erreur: $e'),
            data: (slots) {
              if (slots.isEmpty) {
                return Text('Aucun emplacement de sort.',
                    style: TextStyle(color: colorScheme.onSurfaceVariant));
              }
              return Column(
                children: slots
                    .map((slot) => _SpellSlotRow(
                          slot: slot,
                          characterId: characterId,
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 16),

          // ── Spells list ───────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sorts connus / préparés',
                  style: Theme.of(context).textTheme.titleMedium),
              TextButton.icon(
                icon: const Icon(Icons.library_books, size: 16),
                label: const Text('Gérer', style: TextStyle(fontSize: 12)),
                onPressed: () => Navigator.of(context).pushNamed(
                  '/spells',
                  arguments: characterId,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          spellsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Erreur: $e'),
            data: (spells) {
              if (spells.isEmpty) {
                return Text('Aucun sort. Utilisez "Gérer" pour en ajouter.',
                    style: TextStyle(color: colorScheme.onSurfaceVariant));
              }

              // Group by level
              final byLevel = <int, List<CharacterSpell>>{};
              for (final s in spells) {
                // We show spells grouped — we need SRD data for level
                // For now, list all with prepared status
                byLevel.putIfAbsent(0, () => []).add(s);
              }

              return Column(
                children: spells
                    .map((s) => _SpellListTile(
                          spell: s,
                          characterId: characterId,
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _longRest(WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final slots = await db.characterDao
        .watchSpellSlots(characterId)
        .first;
    final restored = slots
        .map((s) => CharacterSpellSlotsCompanion(
              id: Value(s.id),
              characterId: Value(characterId),
              slotLevel: Value(s.slotLevel),
              slotMax: Value(s.slotMax),
              slotCurrent: Value(s.slotMax),
            ))
        .toList();
    for (final r in restored) {
      await db.characterDao.updateSpellSlot(r);
    }

    // Restore resources too
    final resources = await db.characterDao.watchResources(characterId).first;
    for (final r in resources) {
      await db.characterDao.upsertResource(
        CharacterResourcesCompanion(
          id: Value(r.id),
          characterId: Value(characterId),
          resourceName: Value(r.resourceName),
          current: Value(r.maximum),
          maximum: Value(r.maximum),
        ),
      );
    }
  }
}

class _SpellSlotRow extends ConsumerWidget {
  final CharacterSpellSlot slot;
  final int characterId;

  const _SpellSlotRow({required this.slot, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer,
              ),
              child: Text(
                '${slot.slotLevel}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: List.generate(slot.slotMax, (i) {
                  final used = i >= slot.slotCurrent;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: GestureDetector(
                      onTap: () => _toggleSlot(ref, i),
                      child: Icon(
                        used ? Icons.radio_button_unchecked : Icons.circle,
                        size: 20,
                        color: used
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.primary,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Text('${slot.slotCurrent}/${slot.slotMax}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleSlot(WidgetRef ref, int index) async {
    final db = ref.read(databaseProvider);
    final newCurrent = index < slot.slotCurrent
        ? slot.slotCurrent - 1
        : slot.slotCurrent + 1;
    await db.characterDao.updateSpellSlot(
      CharacterSpellSlotsCompanion(
        id: Value(slot.id),
        characterId: Value(characterId),
        slotLevel: Value(slot.slotLevel),
        slotMax: Value(slot.slotMax),
        slotCurrent: Value(newCurrent.clamp(0, slot.slotMax)),
      ),
    );
  }
}

class _SpellListTile extends ConsumerWidget {
  final CharacterSpell spell;
  final int characterId;

  const _SpellListTile({required this.spell, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: spell.prepared
            ? const Icon(Icons.auto_fix_high, size: 18)
            : const Icon(Icons.auto_fix_off, size: 18),
        title: Text(spell.spellId,
            style: const TextStyle(fontSize: 13)),
        subtitle: Text(spell.prepared ? 'Préparé' : 'Non préparé',
            style: const TextStyle(fontSize: 11)),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () async {
            final db = ref.read(databaseProvider);
            await db.characterDao.deleteCharacterSpell(spell.id);
          },
        ),
        onTap: () async {
          final db = ref.read(databaseProvider);
          await db.characterDao.updateCharacterSpell(
            CharacterSpellsCompanion(
              id: Value(spell.id),
              characterId: Value(characterId),
              spellId: Value(spell.spellId),
              ruleset: Value(spell.ruleset),
              prepared: Value(!spell.prepared),
            ),
          );
        },
      ),
    );
  }
}
