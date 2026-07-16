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
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    final c = widget.character;
    _traitsCtrl = TextEditingController(text: c.personalityTraits);
    _idealsCtrl = TextEditingController(text: c.ideals);
    _bondsCtrl = TextEditingController(text: c.bonds);
    _flawsCtrl = TextEditingController(text: c.flaws);
    _backstoryCtrl = TextEditingController(text: c.backstory);
    _appearanceCtrl = TextEditingController(text: c.appearance);
    for (final ctrl in [_traitsCtrl, _idealsCtrl, _bondsCtrl, _flawsCtrl, _backstoryCtrl, _appearanceCtrl]) {
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
    super.dispose();
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    await db.characterDao.updateCharacter(
      CharactersCompanion(
        id: Value(widget.characterId),
        personalityTraits: Value(_traitsCtrl.text),
        ideals: Value(_idealsCtrl.text),
        bonds: Value(_bondsCtrl.text),
        flaws: Value(_flawsCtrl.text),
        backstory: Value(_backstoryCtrl.text),
        appearance: Value(_appearanceCtrl.text),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
    if (mounted) setState(() => _dirty = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final featsAsync = ref.watch(characterFeatDetailsProvider(widget.characterId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ref.watch(characterProficienciesProvider(widget.characterId)).when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Erreur maîtrises: $e'),
            data: (profs) {
              return ref.watch(srdWeaponMasteriesProvider).when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
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
                  for (final l in speciesLangs) languagesSet.add(_translateLanguage(l.toString()));
                  for (final l in bgLangs) languagesSet.add(_translateLanguage(l.toString()));

                  if (armors.isEmpty && weapons.isEmpty && tools.isEmpty && activeMasteries.isEmpty && languagesSet.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
              if (feats.isEmpty) return const SizedBox.shrink();
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const Divider(),
                      ...feats.map((feat) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feat.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  feat.description,
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
  
  if (key == 'weapon_simple') return 'Armes simples';
  if (key == 'weapon_martial') return 'Armes de guerre';
  
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
    final tool = key.substring(5).replaceAll('_', ' ');
    return 'Outils : ${tool[0].toUpperCase()}${tool.substring(1)}';
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

