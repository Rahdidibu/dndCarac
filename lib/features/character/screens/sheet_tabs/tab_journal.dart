part of '../character_sheet_screen.dart';

class _JournalTab extends ConsumerStatefulWidget {
  final int characterId;
  const _JournalTab({required this.characterId});

  @override
  ConsumerState<_JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends ConsumerState<_JournalTab> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<({String id, String label, IconData icon, Color color})> _categories = const [
    (id: 'all', label: 'Toutes', icon: Icons.all_inclusive, color: AppTheme.neonCyan),
    (id: 'journal', label: 'Journal', icon: Icons.book, color: Colors.blueAccent),
    (id: 'quest', label: 'Quêtes', icon: Icons.military_tech, color: Colors.amber),
    (id: 'npc', label: 'PNJ', icon: Icons.person, color: AppTheme.neonPurple),
    (id: 'location', label: 'Lieux', icon: Icons.map, color: Colors.teal),
    (id: 'treasure', label: 'Trésors', icon: Icons.diamond, color: Colors.orangeAccent),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(characterNotesProvider(widget.characterId));

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.neonCyan,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.note_add),
        label: const Text('Nouvelle Note', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => _openNoteDialog(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search Bar ───────────────────────────────────────────
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher une note, une quête, un PNJ...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.neonCyan),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
            ),
            const SizedBox(height: 12),

            // ── Category Filter Chips ────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      showCheckmark: false,
                      avatar: Icon(cat.icon, size: 14, color: isSelected ? Colors.black : cat.color),
                      label: Text(cat.label, style: const TextStyle(fontSize: 12)),
                      selected: isSelected,
                      selectedColor: cat.color,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedCategory = cat.id);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // ── Notes List ───────────────────────────────────────────
            notesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur: $e')),
              data: (notes) {
                final filtered = notes.where((note) {
                  final matchCategory = _selectedCategory == 'all' || note.category == _selectedCategory;
                  final matchSearch = _searchQuery.isEmpty ||
                      note.title.toLowerCase().contains(_searchQuery) ||
                      note.content.toLowerCase().contains(_searchQuery);
                  return matchCategory && matchSearch;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_stories, size: 48, color: Colors.white.withValues(alpha: 0.3)),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isNotEmpty || _selectedCategory != 'all'
                                ? 'Aucune note ne correspond à vos filtres.'
                                : 'Votre journal d\'aventure est vide.',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final note = filtered[index];
                    return _NoteCard(
                      note: note,
                      categoryConfig: _categories.firstWhere(
                        (c) => c.id == note.category,
                        orElse: () => _categories[1],
                      ),
                      onEdit: () => _openNoteDialog(context, note: note),
                      onTogglePin: () => _togglePin(note),
                      onDelete: () => _confirmDeleteNote(note),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _togglePin(CharacterNote note) async {
    final db = ref.read(databaseProvider);
    await db.characterDao.updateNote(note.id, {
      'is_pinned': !note.isPinned,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _confirmDeleteNote(CharacterNote note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la note ?'),
        content: Text('Voulez-vous supprimer "${note.title.isNotEmpty ? note.title : 'cette note'}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.neonRed),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await db.characterDao.deleteNote(note.id);
    }
  }

  Future<void> _openNoteDialog(BuildContext context, {CharacterNote? note}) async {
    await showDialog(
      context: context,
      builder: (ctx) => _AddEditNoteDialog(
        characterId: widget.characterId,
        note: note,
        categories: _categories.where((c) => c.id != 'all').toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Note Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class _NoteCard extends StatelessWidget {
  final CharacterNote note;
  final ({String id, String label, IconData icon, Color color}) categoryConfig;
  final VoidCallback onEdit;
  final VoidCallback onTogglePin;
  final VoidCallback onDelete;

  const _NoteCard({
    required this.note,
    required this.categoryConfig,
    required this.onEdit,
    required this.onTogglePin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: note.isPinned
              ? AppTheme.neonCyan.withValues(alpha: 0.6)
              : categoryConfig.color.withValues(alpha: 0.3),
          width: note.isPinned ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Row ───────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryConfig.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: categoryConfig.color.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(categoryConfig.icon, size: 12, color: categoryConfig.color),
                      const SizedBox(width: 4),
                      Text(
                        categoryConfig.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: categoryConfig.color,
                        ),
                      ),
                    ],
                  ),
                ),
                if (note.isPinned) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.push_pin, size: 14, color: AppTheme.neonCyan),
                ],
                const Spacer(),
                IconButton(
                  icon: Icon(
                    note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    size: 18,
                    color: note.isPinned ? AppTheme.neonCyan : Colors.white54,
                  ),
                  tooltip: note.isPinned ? 'Désépingler' : 'Épingler',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onTogglePin,
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white70),
                  tooltip: 'Modifier',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onEdit,
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.neonRed),
                  tooltip: 'Supprimer',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Title ────────────────────────────────────────────────
            if (note.title.isNotEmpty) ...[
              Text(
                note.title,
                style: const TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
            ],

            // ── Content (Markdown) ───────────────────────────────────
            if (note.content.isNotEmpty)
              MarkdownText(
                text: note.content,
                style: const TextStyle(fontFamily: 'Lora', fontSize: 13, height: 1.4, color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add / Edit Note Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _AddEditNoteDialog extends ConsumerStatefulWidget {
  final int characterId;
  final CharacterNote? note;
  final List<({String id, String label, IconData icon, Color color})> categories;

  const _AddEditNoteDialog({
    required this.characterId,
    this.note,
    required this.categories,
  });

  @override
  ConsumerState<_AddEditNoteDialog> createState() => _AddEditNoteDialogState();
}

class _AddEditNoteDialogState extends ConsumerState<_AddEditNoteDialog> {
  late String _selectedCategory;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late bool _isPinned;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.note?.category ?? 'journal';
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _isPinned = widget.note?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return AlertDialog(
      title: Text(
        isEditing ? 'Modifier la note' : 'Nouvelle entrée au journal',
        style: const TextStyle(fontFamily: 'Cinzel', fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Category Selector ──────────────────────────────────
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: widget.categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat.id,
                    child: Row(
                      children: [
                        Icon(cat.icon, size: 16, color: cat.color),
                        const SizedBox(width: 8),
                        Text(cat.label),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 12),

              // ── Title TextField ────────────────────────────────────
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre (ex. Rencontre avec le Bourgmestre)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // ── Content TextField ──────────────────────────────────
              TextField(
                controller: _contentController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Détails & Notes (Markdown supporté)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // ── Pinned Checkbox ────────────────────────────────────
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Épingler cette note en haut', style: TextStyle(fontSize: 13)),
                value: _isPinned,
                onChanged: (val) => setState(() => _isPinned = val ?? false),
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
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return;

    final db = ref.read(databaseProvider);
    final now = DateTime.now().toIso8601String();

    if (widget.note != null) {
      await db.characterDao.updateNote(widget.note!.id, {
        'category': _selectedCategory,
        'title': title,
        'content': content,
        'is_pinned': _isPinned,
        'updated_at': now,
      });
    } else {
      await db.characterDao.insertNote({
        'character_id': widget.characterId,
        'category': _selectedCategory,
        'title': title,
        'content': content,
        'is_pinned': _isPinned,
        'created_at': now,
        'updated_at': now,
      });
    }

    if (mounted) Navigator.of(context).pop();
  }
}
