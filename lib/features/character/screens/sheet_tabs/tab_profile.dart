part of '../character_sheet_screen.dart';

class _ProfileTab extends ConsumerStatefulWidget {
  final int characterId;
  final Character character;

  const _ProfileTab({required this.characterId, required this.character});

  @override
  ConsumerState<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<_ProfileTab> {
  late final TextEditingController _traitsCtrl;
  late final TextEditingController _idealsCtrl;
  late final TextEditingController _bondsCtrl;
  late final TextEditingController _flawsCtrl;
  late final TextEditingController _backstoryCtrl;
  late final TextEditingController _appearanceCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _playerNameCtrl;
  late String _alignment;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    final c = widget.character;
    _alignment = c.alignment;
    _traitsCtrl = TextEditingController(text: c.personalityTraits);
    _idealsCtrl = TextEditingController(text: c.ideals);
    _bondsCtrl = TextEditingController(text: c.bonds);
    _flawsCtrl = TextEditingController(text: c.flaws);
    _backstoryCtrl = TextEditingController(text: c.backstory);
    _appearanceCtrl = TextEditingController(text: c.appearance);
    _nameCtrl = TextEditingController(text: c.name);
    _playerNameCtrl = TextEditingController(text: c.playerName);
    for (final ctrl in [
      _traitsCtrl,
      _idealsCtrl,
      _bondsCtrl,
      _flawsCtrl,
      _backstoryCtrl,
      _appearanceCtrl,
      _nameCtrl,
      _playerNameCtrl,
    ]) {
      ctrl.addListener(() => setState(() => _dirty = true));
    }
  }

  @override
  void dispose() {
    _traitsCtrl.dispose();
    _idealsCtrl.dispose();
    _bondsCtrl.dispose();
    _flawsCtrl.dispose();
    _backstoryCtrl.dispose();
    _appearanceCtrl.dispose();
    _nameCtrl.dispose();
    _playerNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    await db.characterDao.updateCharacter(
      CharactersCompanion(
        id: Value(widget.characterId),
        name: Value(_nameCtrl.text.trim()),
        playerName: Value(_playerNameCtrl.text.trim()),
        alignment: Value(_alignment),
        personalityTraits: Value(_traitsCtrl.text),
        ideals: Value(_idealsCtrl.text),
        bonds: Value(_bondsCtrl.text),
        flaws: Value(_flawsCtrl.text),
        backstory: Value(_backstoryCtrl.text),
        appearance: Value(_appearanceCtrl.text),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
    // Invalidate profile query to update app bar title
    ref.invalidate(characterByIdProvider(widget.characterId));
    if (mounted) setState(() => _dirty = false);
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image == null) return;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Téléchargement de la photo...')),
      );

      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) throw Exception('Utilisateur non connecté');

      final bytes = await image.readAsBytes();
      final extension = image.name.split('.').last;
      final fileName = '$userId/${widget.characterId}_${DateTime.now().millisecondsSinceEpoch}.$extension';

      // Upload to Supabase Storage
      await client.storage.from('character-avatars').uploadBinary(
        fileName,
        bytes,
        fileOptions: FileOptions(
          contentType: 'image/$extension',
          upsert: true,
        ),
      );

      // Get public URL
      final imageUrl = client.storage.from('character-avatars').getPublicUrl(fileName);

      // Update character in DB
      final db = ref.read(databaseProvider);
      await db.characterDao.updateCharacter(
        CharactersCompanion(
          id: Value(widget.characterId),
          imageUrl: Value(imageUrl),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

      // Invalidate provider to refresh UI
      ref.invalidate(characterByIdProvider(widget.characterId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo mise à jour avec succès !')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du téléchargement: $e')),
        );
      }
    }
  }

  Future<void> _deleteFeat(String featId) async {
    final db = ref.read(databaseProvider);
    await db.characterDao.deleteCharacterFeat(widget.characterId, featId);
    ref.invalidate(characterFeatDetailsProvider(widget.characterId));
  }

  void _showAddFeatDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return _AddFeatDialog(
          characterId: widget.characterId,
          ruleset: widget.character.ruleset,
        );
      },
    );
  }

  void _showManageProficienciesDialog(
      BuildContext context, WidgetRef ref, List<CharacterProficiency> profs) {
    showDialog(
      context: context,
      builder: (context) {
        return _ManageProficienciesDialog(
          characterId: widget.characterId,
          initialProfs: profs,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final featsAsync = ref.watch(characterFeatDetailsProvider(widget.characterId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _AvatarPicker(
            imageUrl: widget.character.imageUrl,
            characterName: widget.character.name,
            onPick: _pickAndUploadImage,
          ),
          const SizedBox(height: 16),
          _ProfileField(
            label: 'Nom du personnage',
            controller: _nameCtrl,
            minLines: 1,
          ),
          _ProfileField(
            label: 'Nom du joueur',
            controller: _playerNameCtrl,
            minLines: 1,
          ),
          const SizedBox(height: 8),

          // ── Alignment 3x3 Grid ───────────────────────────────────────────
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.balance, color: Theme.of(context).colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Alignement',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.3,
                    children: [
                      (key: 'alignmentLG', label: l10n.alignmentLG),
                      (key: 'alignmentNG', label: l10n.alignmentNG),
                      (key: 'alignmentCG', label: l10n.alignmentCG),
                      (key: 'alignmentLN', label: l10n.alignmentLN),
                      (key: 'alignmentTN', label: l10n.alignmentTN),
                      (key: 'alignmentCN', label: l10n.alignmentCN),
                      (key: 'alignmentLE', label: l10n.alignmentLE),
                      (key: 'alignmentNE', label: l10n.alignmentNE),
                      (key: 'alignmentCE', label: l10n.alignmentCE),
                    ].map((a) {
                      final isSelected = _alignment == a.label;
                      return _AlignmentChip(
                        label: a.label,
                        selected: isSelected,
                        onTap: () => setState(() {
                          _alignment = isSelected ? '' : a.label;
                          _dirty = true;
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: SizedBox(
                      width: 180,
                      child: _AlignmentChip(
                        label: l10n.alignmentU,
                        selected: _alignment == l10n.alignmentU,
                        onTap: () => setState(() {
                          _alignment = _alignment == l10n.alignmentU ? '' : l10n.alignmentU;
                          _dirty = true;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Stats & Abilities Edit Card ───────────────────────────────────
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bar_chart, color: AppTheme.neonPurple, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Caractéristiques & Stats',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        tooltip: 'Modifier les caractéristiques et stats',
                        onPressed: () {
                          final scoresAsync = ref.read(characterAbilityScoresProvider(widget.characterId));
                          final scores = scoresAsync.value;
                          if (scores != null) {
                            _showEditAbilitiesDialog(context, ref, scores, widget.character);
                          }
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  ref.watch(characterAbilityScoresProvider(widget.characterId)).when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (scores) {
                      if (scores == null) return const SizedBox.shrink();
                      return Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _ProfileStatChip(label: 'PV Max', value: '${widget.character.hpMax}'),
                          _ProfileStatChip(label: 'Vitesse', value: '${widget.character.speed} m'),
                          _ProfileStatChip(label: 'FOR', value: '${scores.strength}'),
                          _ProfileStatChip(label: 'DEX', value: '${scores.dexterity}'),
                          _ProfileStatChip(label: 'CON', value: '${scores.constitution}'),
                          _ProfileStatChip(label: 'INT', value: '${scores.intelligence}'),
                          _ProfileStatChip(label: 'SAG', value: '${scores.wisdom}'),
                          _ProfileStatChip(label: 'CHA', value: '${scores.charisma}'),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          ref.watch(characterProficienciesProvider(widget.characterId)).when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Erreur maîtrises: $e'),
            data: (profs) {
              return ref.watch(srdWeaponMasteriesProvider).when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (masteries) {
                  final racesAsync = ref.watch(srdRacesProvider(widget.character.ruleset));
                  final backgroundsAsync = ref.watch(srdBackgroundsProvider(widget.character.ruleset));

                  final species = racesAsync.whenOrNull(data: (list) => list.where((r) => r.id == widget.character.speciesId).firstOrNull);
                  final background = backgroundsAsync.whenOrNull(data: (list) => list.where((b) => b.id == widget.character.backgroundId).firstOrNull);

                  final armors = <String>[];
                  final weapons = <String>[];
                  final tools = <String>[];
                  final activeMasteries = <String>[];
                  
                  for (final p in profs) {
                    final key = p.proficiencyKey;
                    if (key.startsWith('armor_')) {
                      armors.add(_translateProficiency(key, masteries));
                    } else if (key.startsWith('weapon_')) {
                      weapons.add(_translateProficiency(key, masteries));
                    } else if (key.startsWith('tool_')) {
                      tools.add(_translateProficiency(key, masteries));
                    } else if (key.startsWith('mastery_')) {
                      activeMasteries.add(_translateProficiency(key, masteries));
                    }
                  }

                  final List<dynamic> speciesLangs = (species != null && species.languages.isNotEmpty) ? json.decode(species.languages) : [];
                  final List<dynamic> bgLangs = (background != null && background.languages.isNotEmpty) ? json.decode(background.languages) : [];
                  final languagesSet = <String>{};
                  for (final l in speciesLangs) {
                    languagesSet.add(_translateLanguage(l.toString()));
                  }
                  for (final l in bgLangs) {
                    languagesSet.add(_translateLanguage(l.toString()));
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.shield_outlined, color: Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Maîtrises et Langues',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                tooltip: 'Gérer les maîtrises',
                                onPressed: () => _showManageProficienciesDialog(context, ref, profs),
                              ),
                            ],
                          ),
                          const Divider(),
                          if (armors.isNotEmpty) ...[
                            _ProfGroup(title: 'Armures', items: armors),
                            const SizedBox(height: 8),
                          ],
                          if (weapons.isNotEmpty) ...[
                            _ProfGroup(title: 'Armes', items: weapons),
                            const SizedBox(height: 8),
                          ],
                          if (activeMasteries.isNotEmpty) ...[
                            _ProfGroup(title: 'Maîtrises d\'armes (2024)', items: activeMasteries),
                            const SizedBox(height: 8),
                          ],
                          if (tools.isNotEmpty) ...[
                            _ProfGroup(title: 'Outils', items: tools),
                            const SizedBox(height: 8),
                          ],
                          if (languagesSet.isNotEmpty) ...[
                            _ProfGroup(title: 'Langues', items: languagesSet.toList()),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          featsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Erreur dons: $e'),
            data: (feats) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber[700]),
                              const SizedBox(width: 8),
                              Text(
                                'Dons du personnage',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 20),
                            tooltip: 'Ajouter un don',
                            onPressed: () => _showAddFeatDialog(context, ref),
                          ),
                        ],
                      ),
                      const Divider(),
                      if (feats.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Aucun don enregistré',
                            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                          ),
                        ),
                      ...feats.map((feat) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        feat.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => _deleteFeat(feat.id),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                MarkdownText(
                                  text: feat.description,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              );
            },
          ),
          _ProfileField(
            label: 'Traits de personnalité',
            controller: _traitsCtrl,
            minLines: 2,
          ),
          _ProfileField(
            label: 'Idéaux',
            controller: _idealsCtrl,
            minLines: 2,
          ),
          _ProfileField(
            label: 'Liens',
            controller: _bondsCtrl,
            minLines: 2,
          ),
          _ProfileField(
            label: 'Défauts',
            controller: _flawsCtrl,
            minLines: 2,
          ),
          _ProfileField(
            label: 'Apparence',
            controller: _appearanceCtrl,
            minLines: 2,
          ),
          _ProfileField(
            label: 'Histoire du personnage',
            controller: _backstoryCtrl,
            minLines: 4,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.save),
              label: Text(l10n.actionSave),
              onPressed: _dirty ? _save : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int minLines;

  const _ProfileField({
    required this.label,
    required this.controller,
    this.minLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        minLines: minLines,
        maxLines: null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

class _ProfGroup extends StatelessWidget {
  final String title;
  final List<String> items;

  const _ProfGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: items.map((item) {
            return Chip(
              label: Text(item, style: const TextStyle(fontSize: 11)),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
      ],
    );
  }
}

String _translateProficiency(String key, List<SrdWeaponMastery> weaponMasteries) {
  if (key == 'armor_all') return 'Toutes les armures';
  if (key == 'armor_light') return 'Armures légères';
  if (key == 'armor_medium') return 'Armures moyennes';
  if (key == 'armor_heavy') return 'Armures lourdes';
  if (key == 'armor_shield') return 'Boucliers';
  
  if (key.startsWith('weapon_')) {
    final weapon = key.substring(7);
    if (weapon == 'simple') return 'Armes simples';
    if (weapon == 'martial') return 'Armes de guerre';
    
    const weaponMap = {
      'longsword': 'Épée longue',
      'shortsword': 'Épée courte',
      'greatsword': 'Épée à deux mains',
      'rapier': 'Rapière',
      'dagger': 'Dague',
      'hand_crossbow': 'Arbalète de poing',
      'heavy_crossbow': 'Arbalète lourde',
      'light_crossbow': 'Arbalète légère',
      'shortbow': 'Arc court',
      'longbow': 'Arc long',
      'halberd': 'Hallebarde',
      'glaive': 'Glaive',
      'greataxe': 'Grande hache',
      'battleaxe': 'Hache d\'armes',
      'handaxe': 'Hachette',
      'mace': 'Massue',
      'quarterstaff': 'Bâton',
      'spear': 'Lance',
      'javelin': 'Javelot',
      'warhammer': 'Marteau de guerre',
      'maul': 'Grand marteau',
      'whip': 'Fouet',
      'blowgun': 'Sarbacane',
      'flail': 'Fléau',
      'lance': 'Lance d\'arçon',
      'morningstar': 'Matin de fer (Morgensztern)',
      'pike': 'Pique',
      'scimitar': 'Cimeterre',
      'sickle': 'Faucille',
      'trident': 'Trident',
      'club': 'Gourdin',
      'greatclub': 'Grand gourdin',
      'light_hammer': 'Marteau léger',
      'dart': 'Fléchette',
      'sling': 'Fronde',
    };
    return weaponMap[weapon.toLowerCase()] ?? 'Arme : ${weapon[0].toUpperCase()}${weapon.substring(1).replaceAll('_', ' ')}';
  }
  
  if (key.startsWith('save_')) {
    final stat = key.substring(5);
    const map = {
      'str': 'Force',
      'dex': 'Dextérité',
      'con': 'Constitution',
      'int': 'Intelligence',
      'wis': 'Sagesse',
      'cha': 'Charisme',
    };
    return 'Sauvegarde : ${map[stat] ?? stat.toUpperCase()}';
  }
  
  if (key.startsWith('tool_')) {
    final tool = key.substring(5);
    const toolMap = {
      'thieves_tools': 'Outils de voleur',
      'artisan_tools': 'Outils d\'artisan',
      'artisan-tools': 'Outils d\'artisan',
      'disguise_kit': 'Nécessaire de déguisement',
      'forgery_kit': 'Nécessaire de faussaire',
      'herbalism_kit': 'Nécessaire d\'herboriste',
      'poisoners_kit': 'Nécessaire de poisonnier',
      'alchemists_supplies': 'Matériel d\'alchimiste',
      'brewers_supplies': 'Matériel de brasseur',
      'calligraphers_supplies': 'Matériel de calligraphe',
      'carpenters_tools': 'Outils de charpentier',
      'cartographers_tools': 'Outils de cartographe',
      'cobblers_tools': 'Outils de cordonnier',
      'cooks_utensils': 'Ustensiles de cuisinier',
      'glassblowers_tools': 'Outils de souffleur de verre',
      'jewelers_tools': 'Outils de joaillier',
      'leatherworkers_tools': 'Outils de travail du cuir',
      'masons_tools': 'Outils de maçon',
      'painters_supplies': 'Matériel de peintre',
      'potters_tools': 'Outils de potier',
      'smiths_tools': 'Outils de forgeron',
      'tinkers_tools': 'Outils de raccommodeur',
      'weavers_tools': 'Outils de tisserand',
      'woodcarvers_tools': 'Outils de sculpteur sur bois',
      'bagpipes': 'Cornemuse',
      'drum': 'Tambour',
      'flute': 'Flûte',
      'lute': 'Luth',
      'lyre': 'Lyre',
      'horn': 'Cor',
      'pan_flute': 'Flûte de Pan',
      'dulcimer': 'Tympanon',
      'viol': 'Viole',
      'shawm': 'Chalémie',
      'playing_card_set': 'Jeu de cartes',
      'dice_set': 'Jeu de dés',
      'three_dragon_ante_set': 'Jeu des trois dragons',
      'chess_set': 'Jeu d\'échecs',
      'navigators_tools': 'Outils de navigateur',
    };
    return toolMap[tool.toLowerCase()] ?? 'Outils : ${tool[0].toUpperCase()}${tool.substring(1).replaceAll('_', ' ')}';
  }
  
  if (key.startsWith('mastery_')) {
    final masteryId = key.substring(8);
    final m = weaponMasteries.where((element) => element.id == masteryId).firstOrNull;
    return 'Maîtrise d\'arme : ${m?.name ?? masteryId.toUpperCase()}';
  }
  
  return key;
}

String _translateLanguage(String lang) {
  const map = {
    'common': 'Commun',
    'elvish': 'Elfique',
    'dwarvish': 'Nain',
    'giant': 'Géant',
    'gnomish': 'Gnomique',
    'halfling': 'Halfelin',
    'orc': 'Orc',
    'undercommon': 'Profond commun',
    'abyssal': 'Abyssal',
    'celestial': 'Céleste',
    'draconic': 'Draconique',
    'infernal': 'Infernal',
    'sylvan': 'Sylvestre',
  };
  return map[lang.toLowerCase()] ?? (lang.isEmpty ? '' : '${lang[0].toUpperCase()}${lang.substring(1)}');
}

class _AddFeatDialog extends ConsumerStatefulWidget {
  final int characterId;
  final RulesetVersion ruleset;

  const _AddFeatDialog({required this.characterId, required this.ruleset});

  @override
  ConsumerState<_AddFeatDialog> createState() => _AddFeatDialogState();
}

class _AddFeatDialogState extends ConsumerState<_AddFeatDialog> {
  String _searchQuery = '';
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allFeatsAsync = ref.watch(srdFeatsProvider(widget.ruleset));
    final currentFeatsAsync = ref.watch(characterFeatDetailsProvider(widget.characterId));

    return AlertDialog(
      title: const Text('Ajouter un don'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                labelText: 'Rechercher un don',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: allFeatsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Erreur: $e')),
                data: (allFeats) {
                  return currentFeatsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Erreur: $e')),
                    data: (currentFeats) {
                      final currentIds = currentFeats.map((f) => f.id).toSet();
                      final availableFeats = allFeats
                          .where((f) => !currentIds.contains(f.id))
                          .where((f) => f.name.toLowerCase().contains(_searchQuery) || f.description.toLowerCase().contains(_searchQuery))
                          .toList();

                      if (availableFeats.isEmpty) {
                        return const Center(child: Text('Aucun don disponible.'));
                      }

                      return ListView.builder(
                        itemCount: availableFeats.length,
                        itemBuilder: (context, index) {
                          final feat = availableFeats[index];
                          return ListTile(
                            title: Text(feat.name),
                            subtitle: MarkdownText(
                               text: feat.description,
                               maxLines: 2,
                               overflow: TextOverflow.ellipsis,
                               style: const TextStyle(fontSize: 11, color: Colors.white70),
                             ),
                            onTap: () => _addFeat(feat.id),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fermer'),
        ),
      ],
    );
  }

  Future<void> _addFeat(String featId) async {
    final db = ref.read(databaseProvider);
    await db.characterDao.insertCharacterFeat(
      CharacterFeatsCompanion.insert(
        characterId: widget.characterId,
        featId: featId,
        ruleset: widget.ruleset,
      ),
    );
    ref.invalidate(characterFeatDetailsProvider(widget.characterId));
    if (mounted) Navigator.of(context).pop();
  }
}

const List<({String key, String name})> _allSkillsList = [
  (key: 'athletics', name: 'Athlétisme'),
  (key: 'acrobatics', name: 'Acrobaties'),
  (key: 'sleight_of_hand', name: 'Escamotage'),
  (key: 'stealth', name: 'Discrétion'),
  (key: 'arcana', name: 'Arcanes'),
  (key: 'history', name: 'Histoire'),
  (key: 'investigation', name: 'Investigation'),
  (key: 'nature', name: 'Nature'),
  (key: 'religion', name: 'Religion'),
  (key: 'animal_handling', name: 'Dressage'),
  (key: 'insight', name: 'Perspicacité'),
  (key: 'medicine', name: 'Médecine'),
  (key: 'perception', name: 'Perception'),
  (key: 'survival', name: 'Survie'),
  (key: 'deception', name: 'Tromperie'),
  (key: 'intimidation', name: 'Intimidation'),
  (key: 'performance', name: 'Représentation'),
  (key: 'persuasion', name: 'Persuasion'),
];

const List<({String key, String name})> _allToolsList = [
  (key: 'alchemists_supplies', name: "Matériel d'alchimiste"),
  (key: 'brewers_supplies', name: 'Matériel de brasseur'),
  (key: 'calligraphers_supplies', name: 'Matériel de calligraphe'),
  (key: 'carpenters_tools', name: 'Outils de charpentier'),
  (key: 'cartographers_tools', name: 'Outils de cartographe'),
  (key: 'cobblers_tools', name: 'Outils de cordonnier'),
  (key: 'cooks_utensils', name: 'Ustensiles de cuisinier'),
  (key: 'glassblowers_tools', name: 'Outils de souffleur de verre'),
  (key: 'jewelers_tools', name: 'Outils de joaillier'),
  (key: 'leatherworkers_tools', name: 'Outils de travail du cuir'),
  (key: 'masons_tools', name: 'Outils de maçon'),
  (key: 'painters_supplies', name: 'Matériel de peintre'),
  (key: 'potters_tools', name: 'Outils de potier'),
  (key: 'smiths_tools', name: 'Outils de forgeron'),
  (key: 'tinkers_tools', name: 'Outils de rétameur'),
  (key: 'weavers_tools', name: 'Outils de tisserand'),
  (key: 'woodcarvers_tools', name: 'Outils de sculpteur sur bois'),
  (key: 'bagpipes', name: 'Cornemuse'),
  (key: 'drum', name: 'Tambour'),
  (key: 'flute', name: 'Flûte'),
  (key: 'lute', name: 'Luth'),
  (key: 'lyre', name: 'Lyre'),
  (key: 'horn', name: 'Cor'),
  (key: 'pan_flute', name: 'Flûte de Pan'),
  (key: 'dulcimer', name: 'Tympanon'),
  (key: 'viol', name: 'Viole'),
  (key: 'shawm', name: 'Chalemie'),
  (key: 'disguise_kit', name: 'Matériel de déguisement'),
  (key: 'forgery_kit', name: 'Nécessaire de contrefaçon'),
  (key: 'herbalism_kit', name: 'Nécessaire d\'herboriste'),
  (key: 'navigators_tools', name: 'Outils de navigateur'),
  (key: 'poisoners_kit', name: 'Nécessaire d\'empoisonneur'),
  (key: 'thieves_tools', name: 'Outils de voleur'),
];

// _ManageProficienciesDialog definition below

class _ManageProficienciesDialog extends ConsumerStatefulWidget {
  final int characterId;
  final List<CharacterProficiency> initialProfs;

  const _ManageProficienciesDialog({
    required this.characterId,
    required this.initialProfs,
  });

  @override
  ConsumerState<_ManageProficienciesDialog> createState() => _ManageProficienciesDialogState();
}

class _ManageProficienciesDialogState extends ConsumerState<_ManageProficienciesDialog> {
  late Set<String> _currentKeys;
  late Set<String> _initialKeys;

  @override
  void initState() {
    super.initState();
    _initialKeys = widget.initialProfs.map((p) => p.proficiencyKey).toSet();
    _currentKeys = Set.from(_initialKeys);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AlertDialog(
        title: const Text('Gérer les maîtrises'),
        content: SizedBox(
          width: double.maxFinite,
          height: 450,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Compétences'),
                  Tab(text: 'Outils'),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView(
                      children: _allSkillsList.map((s) {
                        final key = 'skill_${s.key}';
                        final isChecked = _currentKeys.contains(key);
                        return CheckboxListTile(
                          title: Text(s.name),
                          value: isChecked,
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                _currentKeys.add(key);
                              } else {
                                _currentKeys.remove(key);
                              }
                            });
                          },
                          dense: true,
                        );
                      }).toList(),
                    ),
                    ListView(
                      children: _allToolsList.map((t) {
                        final key = 'tool_${t.key}';
                        final isChecked = _currentKeys.contains(key);
                        return CheckboxListTile(
                          title: Text(t.name),
                          value: isChecked,
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                _currentKeys.add(key);
                              } else {
                                _currentKeys.remove(key);
                              }
                            });
                          },
                          dense: true,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
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
      ),
    );
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);

    final added = _currentKeys.difference(_initialKeys);
    final removed = _initialKeys.difference(_currentKeys);

    for (final key in added) {
      await db.characterDao.insertProficiency(
        CharacterProficienciesCompanion.insert(
          characterId: widget.characterId,
          proficiencyKey: key,
        ),
      );
    }

    for (final key in removed) {
      if (key.startsWith('skill_') || key.startsWith('tool_')) {
        await db.characterDao.deleteProficiency(widget.characterId, key);
      }
    }

    ref.invalidate(characterProficienciesProvider(widget.characterId));

    if (mounted) Navigator.of(context).pop();
  }
}

class _AvatarPicker extends ConsumerWidget {
  final String? imageUrl;
  final String characterName;
  final VoidCallback onPick;

  const _AvatarPicker({
    required this.imageUrl,
    required this.characterName,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.neonCyan, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.neonCyan.withValues(alpha: 0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.cardDark,
              backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
              child: hasImage
                  ? null
                  : Text(
                      characterName.isNotEmpty ? characterName[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neonCyan,
                      ),
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Material(
              color: AppTheme.neonCyan,
              shape: const CircleBorder(),
              elevation: 4,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
                onPressed: onPick,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlignmentChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AlignmentChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.neonCyan.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppTheme.neonCyan : Colors.white24,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? AppTheme.neonCyan : Colors.white70,
          ),
        ),
      ),
    );
  }
}

class _ProfileStatChip extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

