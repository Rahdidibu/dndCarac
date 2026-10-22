import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/tables.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_errors.dart';
import '../../../core/utils/character_edit_rules.dart';
import '../../../core/utils/character_service.dart';
import '../../../core/utils/dnd_rules.dart';
import '../../../core/utils/string_utils.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/character_providers.dart';
import '../widgets/avatar_upload.dart';
import 'wizard_steps/step4_origin.dart' show BackgroundAsiPicker;

/// Édition d'un personnage existant : identité, caractéristiques et origine.
class CharacterEditScreen extends ConsumerWidget {
  final int characterId;

  const CharacterEditScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final characterAsync = ref.watch(characterByIdProvider(characterId));
    final scoresAsync = ref.watch(characterAbilityScoresProvider(characterId));
    final bonusAsync = ref.watch(characterOriginBonusProvider(characterId));

    final error = characterAsync.error ?? scoresAsync.error ?? bonusAsync.error;
    final character = characterAsync.valueOrNull;

    Widget body;
    if (error != null) {
      body = AsyncErrorView(error: error);
    } else if (characterAsync.isLoading ||
        scoresAsync.isLoading ||
        bonusAsync.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (character == null) {
      body = Center(child: Text(l10n.characterNotFound));
    } else {
      body = _CharacterEditForm(
        character: character,
        scores: scoresAsync.valueOrNull,
        initialOriginBonus: bonusAsync.valueOrNull ?? const {},
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editCharacterTitle)),
      body: body,
    );
  }
}

class _CharacterEditForm extends ConsumerStatefulWidget {
  final Character character;
  final CharacterAbilityScore? scores;
  final Map<String, int> initialOriginBonus;

  const _CharacterEditForm({
    required this.character,
    required this.scores,
    required this.initialOriginBonus,
  });

  @override
  ConsumerState<_CharacterEditForm> createState() => _CharacterEditFormState();
}

class _CharacterEditFormState extends ConsumerState<_CharacterEditForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _playerCtrl;
  late final Map<String, TextEditingController> _baseCtrls;
  late final String? _initialSpeciesId;
  late final String? _initialSubspeciesId;
  late final String? _initialBackgroundId;
  late String _alignment;
  late String? _speciesId;
  late String? _subspeciesId;
  late String? _backgroundId;
  late Map<String, int> _asi;
  bool _editOrigin = false;
  bool _saving = false;

  Character get _character => widget.character;
  bool get _is2024 => _character.ruleset == RulesetVersion.dnd2024;

  @override
  void initState() {
    super.initState();
    final c = _character;
    _nameCtrl = TextEditingController(text: c.name);
    _playerCtrl = TextEditingController(text: c.playerName);
    _alignment = c.alignment;
    _initialSpeciesId = c.speciesId;
    _initialSubspeciesId = c.subspeciesId;
    _initialBackgroundId = c.backgroundId;
    _speciesId = c.speciesId;
    _subspeciesId = c.subspeciesId;
    _backgroundId = c.backgroundId;
    _asi = _is2024 ? Map.of(widget.initialOriginBonus) : {};

    final finals = _storedScores();
    _baseCtrls = {
      for (final key in DndRules.abilityKeys)
        key: TextEditingController(
          text: CharacterEditRules.baseFromFinal(
            finals[key]!,
            widget.initialOriginBonus[key] ?? 0,
          ).toString(),
        ),
    };
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _playerCtrl.dispose();
    for (final c in _baseCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, int> _storedScores() {
    final s = widget.scores;
    return {
      'str': s?.strength ?? 10,
      'dex': s?.dexterity ?? 10,
      'con': s?.constitution ?? 10,
      'int': s?.intelligence ?? 10,
      'wis': s?.wisdom ?? 10,
      'cha': s?.charisma ?? 10,
    };
  }

  /// Bonus d'origine courants, ou null tant que les données compendium de la
  /// nouvelle espèce ne sont pas chargées.
  Map<String, int>? _currentBonus() {
    if (_is2024) return _asi;
    if (_speciesId == _initialSpeciesId &&
        _subspeciesId == _initialSubspeciesId) {
      return widget.initialOriginBonus;
    }
    if (_speciesId == null) return const {};

    final ruleset = _character.ruleset;
    final races = ref.watch(srdRacesProvider(ruleset)).valueOrNull;
    final subraces = ref
        .watch(srdSubracesProvider((raceId: _speciesId!, ruleset: ruleset)))
        .valueOrNull;
    if (races == null || subraces == null) return null;

    final race = races.where((r) => r.id == _speciesId).firstOrNull;
    final subrace = subraces.where((s) => s.id == _subspeciesId).firstOrNull;
    return CharacterEditRules.sumBonuses([
      CharacterEditRules.parseAbilityBonuses(race?.abilityBonuses),
      CharacterEditRules.parseAbilityBonuses(subrace?.abilityBonuses),
    ]);
  }

  /// Valeurs finales (base + bonus), ou null si une base est invalide / hors bornes.
  Map<String, int>? _finalScores(Map<String, int> bonus) {
    final result = <String, int>{};
    for (final key in DndRules.abilityKeys) {
      final base = int.tryParse(_baseCtrls[key]!.text.trim());
      if (base == null) return null;
      final b = bonus[key] ?? 0;
      if (!CharacterEditRules.isValidBase(base, b)) return null;
      result[key] = CharacterEditRules.finalFromBase(base, b);
    }
    return result;
  }

  void _onSpeciesChanged(String? id) => setState(() {
    _speciesId = id;
    _subspeciesId = null;
  });

  /// Même historique : déclarer/corriger le bonus recalcule la base pour que le
  /// total reste inchangé (le bonus existait déjà dans la valeur finale).
  bool get _asiKeepsTotal => _is2024 && _backgroundId == _initialBackgroundId;

  void _onAsiChanged(Map<String, int> next) => setState(() {
    if (_asiKeepsTotal) {
      for (final key in DndRules.abilityKeys) {
        final delta = (next[key] ?? 0) - (_asi[key] ?? 0);
        final base = int.tryParse(_baseCtrls[key]!.text.trim());
        if (delta != 0 && base != null) {
          _baseCtrls[key]!.text = (base - delta).toString();
        }
      }
    }
    _asi = next;
  });

  void _onBackgroundChanged(String? id) => setState(() {
    _backgroundId = id;
    _asi = {};
  });

  Future<String> _featName(String featId) async {
    final feat = await ref
        .read(databaseProvider)
        .compendiumDao
        .getFeatById(featId, _character.ruleset);
    return feat?.name ?? featId;
  }

  Future<void> _save(Map<String, int> finalScores, Map<String, int> bonus) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final service = CharacterService(ref.read(databaseProvider));
    final request = CharacterEditRequest(
      name: _nameCtrl.text,
      playerName: _playerCtrl.text,
      alignment: _alignment,
      finalScores: finalScores,
      speciesId: _speciesId,
      subspeciesId: _subspeciesId,
      backgroundId: _backgroundId,
      originBonus: bonus,
    );

    setState(() => _saving = true);
    try {
      final preview = await service.previewEdit(_character.id, request);
      if (preview.hasConsequences || preview.originChanged) {
        final addedFeat = preview.origin.addedFeatId;
        final removedFeat = preview.origin.removedFeatId;
        final addedFeatName =
            addedFeat == null ? null : await _featName(addedFeat);
        final removedFeatName =
            removedFeat == null ? null : await _featName(removedFeat);
        if (!mounted) return;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => _ConfirmEditDialog(
            preview: preview,
            addedFeatName: addedFeatName,
            removedFeatName: removedFeatName,
          ),
        );
        if (confirmed != true) return;
      }

      await service.applyEdit(_character.id, request);
      invalidateCharacterAfterEdit(ref, _character.id);
      messenger.showSnackBar(SnackBar(content: Text(l10n.editSaved)));
      navigator.pop();
    } catch (e, st) {
      AppErrors.log(e, st, context: 'CharacterEdit.save');
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.editSaveError(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bonus = _currentBonus();
    final finalScores = bonus == null ? null : _finalScores(bonus);
    final canSave =
        !_saving && finalScores != null && _nameCtrl.text.trim().isNotEmpty;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _IdentitySection(
                    characterId: _character.id,
                    imageUrl: _character.imageUrl,
                    nameCtrl: _nameCtrl,
                    playerCtrl: _playerCtrl,
                    alignment: _alignment,
                    onChanged: () => setState(() {}),
                    onAlignmentChanged: (v) => setState(() => _alignment = v),
                  ),
                  _AbilitiesSection(
                    controllers: _baseCtrls,
                    bonus: bonus,
                    onChanged: () => setState(() {}),
                  ),
                  _OriginSection(
                    ruleset: _character.ruleset,
                    expanded: _editOrigin,
                    speciesId: _speciesId,
                    subspeciesId: _subspeciesId,
                    backgroundId: _backgroundId,
                    asi: _asi,
                    onExpand: () => setState(() => _editOrigin = true),
                    onSpeciesChanged: _onSpeciesChanged,
                    onSubspeciesChanged: (v) =>
                        setState(() => _subspeciesId = v),
                    onBackgroundChanged: _onBackgroundChanged,
                    onAsiChanged: _onAsiChanged,
                    asiKeepsTotal: _asiKeepsTotal,
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text(l10n.actionCancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: canSave
                            ? () => _save(finalScores, bonus!)
                            : null,
                        child: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(l10n.actionSave),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _IdentitySection extends ConsumerWidget {
  final int characterId;
  final String? imageUrl;
  final TextEditingController nameCtrl;
  final TextEditingController playerCtrl;
  final String alignment;
  final VoidCallback onChanged;
  final ValueChanged<String> onAlignmentChanged;

  const _IdentitySection({
    required this.characterId,
    required this.imageUrl,
    required this.nameCtrl,
    required this.playerCtrl,
    required this.alignment,
    required this.onChanged,
    required this.onAlignmentChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final alignments = [
      l10n.alignmentLG,
      l10n.alignmentNG,
      l10n.alignmentCG,
      l10n.alignmentLN,
      l10n.alignmentTN,
      l10n.alignmentCN,
      l10n.alignmentLE,
      l10n.alignmentNE,
      l10n.alignmentCE,
      l10n.alignmentU,
    ];

    return _SectionCard(
      icon: Icons.badge_outlined,
      title: l10n.editSectionIdentity,
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: AppTheme.cardDark,
                backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
                child: hasImage
                    ? null
                    : const Icon(Icons.person, size: 40, color: AppTheme.neonCyan),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: AppTheme.neonCyan,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () =>
                        pickAndUploadCharacterAvatar(context, ref, characterId),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.camera_alt, size: 16, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: nameCtrl,
          onChanged: (_) => onChanged(),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: l10n.fieldName,
            errorText:
                nameCtrl.text.trim().isEmpty ? l10n.editNameRequired : null,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: playerCtrl,
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            labelText: l10n.fieldPlayerName,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.editAlignmentLabel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final a in alignments)
              ChoiceChip(
                label: Text(a),
                selected: alignment == a,
                onSelected: (selected) => onAlignmentChanged(selected ? a : ''),
              ),
          ],
        ),
      ],
    );
  }
}

class _AbilitiesSection extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final Map<String, int>? bonus;
  final VoidCallback onChanged;

  const _AbilitiesSection({
    required this.controllers,
    required this.bonus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = {
      'str': l10n.abilityStr,
      'dex': l10n.abilityDex,
      'con': l10n.abilityCon,
      'int': l10n.abilityInt,
      'wis': l10n.abilityWis,
      'cha': l10n.abilityCha,
    };

    return _SectionCard(
      icon: Icons.fitness_center,
      title: l10n.editSectionAbilities,
      children: [
        Text(
          l10n.editAbilityHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        for (final key in DndRules.abilityKeys)
          _AbilityRow(
            label: labels[key]!,
            controller: controllers[key]!,
            originBonus: bonus?[key] ?? 0,
            bonusReady: bonus != null,
            onChanged: onChanged,
          ),
      ],
    );
  }
}

class _AbilityRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int originBonus;
  final bool bonusReady;
  final VoidCallback onChanged;

  const _AbilityRow({
    required this.label,
    required this.controller,
    required this.originBonus,
    required this.bonusReady,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final base = int.tryParse(controller.text.trim());
    final total =
        base == null ? null : CharacterEditRules.finalFromBase(base, originBonus);
    final valid = total != null &&
        total >= CharacterEditRules.minScore &&
        total <= CharacterEditRules.maxScore;
    final mod = total == null ? null : DndRules.modifier(total);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: theme.textTheme.bodyLarge),
          ),
          SizedBox(
            width: 84,
            child: TextField(
              controller: controller,
              onChanged: (_) => onChanged(),
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: l10n.editAbilityBase,
                isDense: true,
                border: const OutlineInputBorder(),
                enabledBorder: valid
                    ? null
                    : OutlineInputBorder(
                        borderSide: BorderSide(color: theme.colorScheme.error),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Tooltip(
              message: l10n.editAbilityOriginBonus,
              child: Text(
                bonusReady
                    ? (originBonus >= 0 ? '+ $originBonus' : '− ${-originBonus}')
                    : '…',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: originBonus != 0 ? AppTheme.neonCyan : null,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              valid
                  ? '= $total (${mod! >= 0 ? '+' : ''}$mod)'
                  : l10n.editAbilityOutOfRange,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valid ? null : theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OriginSection extends StatelessWidget {
  final RulesetVersion ruleset;
  final bool expanded;
  final String? speciesId;
  final String? subspeciesId;
  final String? backgroundId;
  final Map<String, int> asi;
  final VoidCallback onExpand;
  final ValueChanged<String?> onSpeciesChanged;
  final ValueChanged<String?> onSubspeciesChanged;
  final ValueChanged<String?> onBackgroundChanged;
  final ValueChanged<Map<String, int>> onAsiChanged;
  final bool asiKeepsTotal;

  const _OriginSection({
    required this.ruleset,
    required this.expanded,
    required this.speciesId,
    required this.subspeciesId,
    required this.backgroundId,
    required this.asi,
    required this.onExpand,
    required this.onSpeciesChanged,
    required this.onSubspeciesChanged,
    required this.onBackgroundChanged,
    required this.onAsiChanged,
    required this.asiKeepsTotal,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SectionCard(
      icon: Icons.public,
      title: l10n.editSectionOrigin,
      children: [
        if (!expanded)
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: onExpand,
              icon: const Icon(Icons.edit_outlined),
              label: Text(l10n.editModifyOrigin),
            ),
          )
        else ...[
          _OriginWarning(text: l10n.editOriginWarning),
          const SizedBox(height: 16),
          _SpeciesDropdown(
            ruleset: ruleset,
            value: speciesId,
            onChanged: onSpeciesChanged,
          ),
          if (speciesId != null) ...[
            const SizedBox(height: 12),
            _SubspeciesDropdown(
              ruleset: ruleset,
              speciesId: speciesId!,
              value: subspeciesId,
              onChanged: onSubspeciesChanged,
            ),
          ],
          const SizedBox(height: 12),
          _BackgroundDropdown(
            ruleset: ruleset,
            value: backgroundId,
            onChanged: onBackgroundChanged,
          ),
          if (ruleset == RulesetVersion.dnd2024 && backgroundId != null) ...[
            if (asiKeepsTotal)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  l10n.editAsiKeepsTotalHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            _BackgroundAsiSection(
              backgroundId: backgroundId!,
              asi: asi,
              onChanged: onAsiChanged,
            ),
          ],
        ],
      ],
    );
  }
}

class _OriginWarning extends StatelessWidget {
  final String text;

  const _OriginWarning({required this.text});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.tertiary;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _SpeciesDropdown extends ConsumerWidget {
  final RulesetVersion ruleset;
  final String? value;
  final ValueChanged<String?> onChanged;

  const _SpeciesDropdown({
    required this.ruleset,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final label = ruleset == RulesetVersion.dnd2024
        ? l10n.step4SpeciesLabel
        : l10n.step4RaceLabel;

    return ref.watch(srdRacesProvider(ruleset)).when(
          loading: () => const LinearProgressIndicator(),
          error: (e, st) =>
              AsyncErrorView(error: e, stackTrace: st, compact: true),
          data: (races) {
            final sorted = races.toList()
              ..sort((a, b) => StringUtils.compareAlphabetically(a.name, b.name));
            return DropdownButtonFormField<String>(
              key: ValueKey('edit-species-$value'),
              isExpanded: true,
              initialValue: sorted.any((r) => r.id == value) ? value : null,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              items: [
                for (final r in sorted)
                  DropdownMenuItem(value: r.id, child: Text(r.name)),
              ],
              onChanged: onChanged,
            );
          },
        );
  }
}

class _SubspeciesDropdown extends ConsumerWidget {
  final RulesetVersion ruleset;
  final String speciesId;
  final String? value;
  final ValueChanged<String?> onChanged;

  const _SubspeciesDropdown({
    required this.ruleset,
    required this.speciesId,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final label = ruleset == RulesetVersion.dnd2024
        ? l10n.step4SubspeciesLabel
        : l10n.step4SubraceLabel;

    return ref
        .watch(srdSubracesProvider((raceId: speciesId, ruleset: ruleset)))
        .when(
          loading: () => const LinearProgressIndicator(),
          error: (e, st) =>
              AsyncErrorView(error: e, stackTrace: st, compact: true),
          data: (subraces) {
            if (subraces.isEmpty) return const SizedBox.shrink();
            return DropdownButtonFormField<String?>(
              key: ValueKey('edit-subspecies-$speciesId-$value'),
              isExpanded: true,
              initialValue: subraces.any((s) => s.id == value) ? value : null,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(l10n.step4NoneOption),
                ),
                for (final s in subraces)
                  DropdownMenuItem<String?>(value: s.id, child: Text(s.name)),
              ],
              onChanged: onChanged,
            );
          },
        );
  }
}

class _BackgroundDropdown extends ConsumerWidget {
  final RulesetVersion ruleset;
  final String? value;
  final ValueChanged<String?> onChanged;

  const _BackgroundDropdown({
    required this.ruleset,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ref.watch(srdBackgroundsProvider(ruleset)).when(
          loading: () => const LinearProgressIndicator(),
          error: (e, st) =>
              AsyncErrorView(error: e, stackTrace: st, compact: true),
          data: (backgrounds) {
            final sorted = backgrounds.toList()
              ..sort((a, b) => StringUtils.compareAlphabetically(a.name, b.name));
            return DropdownButtonFormField<String>(
              key: ValueKey('edit-background-$value'),
              isExpanded: true,
              initialValue: sorted.any((b) => b.id == value) ? value : null,
              decoration: InputDecoration(
                labelText: l10n.editBackgroundLabel,
                border: const OutlineInputBorder(),
              ),
              items: [
                for (final b in sorted)
                  DropdownMenuItem(value: b.id, child: Text(b.name)),
              ],
              onChanged: onChanged,
            );
          },
        );
  }
}

class _BackgroundAsiSection extends ConsumerWidget {
  final String backgroundId;
  final Map<String, int> asi;
  final ValueChanged<Map<String, int>> onChanged;

  const _BackgroundAsiSection({
    required this.backgroundId,
    required this.asi,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgrounds =
        ref.watch(srdBackgroundsProvider(RulesetVersion.dnd2024)).valueOrNull;
    final background =
        backgrounds?.where((b) => b.id == backgroundId).firstOrNull;
    final eligible = CharacterEditRules.parseEligibleAsi(background?.asiJson);
    if (eligible.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: BackgroundAsiPicker(
        eligibleAbilities: eligible,
        currentChoices: asi,
        onChanged: onChanged,
      ),
    );
  }
}

class _ConfirmEditDialog extends StatelessWidget {
  final CharacterEditPreview preview;
  final String? addedFeatName;
  final String? removedFeatName;

  const _ConfirmEditDialog({
    required this.preview,
    required this.addedFeatName,
    required this.removedFeatName,
  });

  static String _profLabel(String key) {
    final i = key.indexOf('_');
    return i < 0 ? key : key.substring(i + 1).replaceAll('-', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final abilities = preview.abilities;
    final origin = preview.origin;

    final lines = <String>[
      if (abilities.hpMaxBefore != abilities.hpMaxAfter)
        l10n.editConfirmHpMax(abilities.hpMaxBefore, abilities.hpMaxAfter),
      if (abilities.acBefore != abilities.acAfter)
        l10n.editConfirmAc(abilities.acBefore, abilities.acAfter),
      if (origin.addedProficiencies.isNotEmpty)
        l10n.editConfirmProfsAdded(
          origin.addedProficiencies.map(_profLabel).join(', '),
        ),
      if (origin.removedProficiencies.isNotEmpty)
        l10n.editConfirmProfsRemoved(
          origin.removedProficiencies.map(_profLabel).join(', '),
        ),
      if (addedFeatName != null) l10n.editConfirmFeatAdded(addedFeatName!),
      if (removedFeatName != null) l10n.editConfirmFeatRemoved(removedFeatName!),
    ];

    return AlertDialog(
      title: Text(l10n.editConfirmTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lines.isEmpty)
            Text(l10n.editConfirmNoConsequence)
          else
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(line)),
                  ],
                ),
              ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.actionSave),
        ),
      ],
    );
  }
}
