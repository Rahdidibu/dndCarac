import 'dart:convert';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/database/app_database.dart';
import '../../core/utils/dnd_rules.dart';

// ─── Palette ────────────────────────────────────────────────────────────────

const _red = PdfColor.fromInt(0xFF8B0000);
const _grey = PdfColor.fromInt(0xFF424242);
const _lightGrey = PdfColor.fromInt(0xFFEEEEEE);
const _white = PdfColors.white;

// ─── Public entry-point ─────────────────────────────────────────────────────

class PdfGenerator {
  /// Generates a complete character sheet as PDF bytes.
  static Future<List<int>> generate({
    required Character character,
    required List<CharacterClassesData> classes,
    required CharacterAbilityScore? abilityScores,
    required List<CharacterProficiency> proficiencies,
    required List<CharacterSpell> characterSpells,
    required List<SrdSpell> srdSpells,
    required List<CharacterAttack> attacks,
    required List<CharacterEquipmentData> equipment,
    List<CharacterFeat> feats = const [],
    List<SrdFeat> srdFeats = const [],
  }) async {
    final doc = pw.Document();

    final srdMap = {for (final s in srdSpells) s.id: s};
    final totalLevel = classes.fold(0, (sum, c) => sum + c.level);
    // Hardcode some translations for PDF export as we don't have an easy way to get AppLocalizations here
    // In a real app, we'd pass the locale or the AppLocalizations instance
    final classLine = classes
        .map((c) {
          final name = {
            'barbarian': 'Barbarian',
            'bard': 'Bard',
            'cleric': 'Cleric',
            'druid': 'Druid',
            'fighter': 'Fighter',
            'monk': 'Monk',
            'paladin': 'Paladin',
            'ranger': 'Ranger',
            'rogue': 'Rogue',
            'sorcerer': 'Sorcerer',
            'warlock': 'Warlock',
            'wizard': 'Wizard',
          }[c.classId] ?? c.classId;
          return '$name ${c.level}';
        })
        .join(' / ');
    final scores = abilityScores;

    // ── Page 1 : Identity + Stats + Combat ──────────────────────────────────
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (pw.Context ctx) => [
        _buildHeader(character, classLine, totalLevel),
        pw.SizedBox(height: 8),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Left column: ability scores + saving throws
            pw.Expanded(
              flex: 2,
              child: pw.Column(children: [
                _buildAbilityScores(scores),
                pw.SizedBox(height: 8),
                _buildSavingThrows(scores, proficiencies, totalLevel),
              ]),
            ),
            pw.SizedBox(width: 12),
            // Right column: combat stats + skills + attacks
            pw.Expanded(
              flex: 5,
              child: pw.Column(children: [
                _buildCombatStats(character, scores, totalLevel),
                pw.SizedBox(height: 8),
                _buildSkills(scores, proficiencies, totalLevel),
                if (attacks.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  _buildAttacks(attacks),
                ],
              ]),
            ),
          ],
        ),
      ],
    ));

    // ── Page 2 : Spells + Equipment + Profile ───────────────────────────────
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (pw.Context ctx) => [
        _sectionLabel('Sorts'),
        pw.SizedBox(height: 4),
        if (characterSpells.isEmpty)
          _buildBodyText('Aucun sort.')
        else
          _buildSpells(characterSpells, srdMap),
        pw.SizedBox(height: 10),
        _sectionLabel('Équipement'),
        pw.SizedBox(height: 4),
        if (equipment.isEmpty)
          _buildBodyText('Aucun équipement.')
        else
          _buildEquipment(equipment, character),
        if (feats.isNotEmpty) ...[
          pw.SizedBox(height: 10),
          _sectionLabel('Dons'),
          pw.SizedBox(height: 4),
          _buildFeats(feats, srdFeats),
        ],
        pw.SizedBox(height: 10),
        _sectionLabel('Profil'),
        pw.SizedBox(height: 4),
        _buildProfile(character),
      ],
    ));

    return doc.save();
  }

  // ─── Page 1 helpers ───────────────────────────────────────────────────────

  static pw.Widget _buildHeader(
      Character c, String classLine, int totalLevel) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: const pw.BoxDecoration(
        color: _red,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(c.name,
                    style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: _white)),
                pw.Text(classLine,
                    style: pw.TextStyle(fontSize: 12, color: _white)),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _headerChip('Niveau $totalLevel'),
              pw.SizedBox(height: 4),
              _headerChip('PV ${c.hpCurrent} / ${c.hpMax}'),
              pw.SizedBox(height: 4),
              _headerChip('CA ${c.armorClass}'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _headerChip(String label) => pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: pw.BoxDecoration(
          color: _white,
          borderRadius: pw.BorderRadius.circular(12),
        ),
        child: pw.Text(label,
            style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: _red)),
      );

  static pw.Widget _buildAbilityScores(CharacterAbilityScore? s) {
    final abilities = [
      ('FOR', s?.strength ?? 10),
      ('DEX', s?.dexterity ?? 10),
      ('CON', s?.constitution ?? 10),
      ('INT', s?.intelligence ?? 10),
      ('SAG', s?.wisdom ?? 10),
      ('CHA', s?.charisma ?? 10),
    ];
    return pw.Column(
      children: abilities.map((entry) {
        final abbr = entry.$1;
        final score = entry.$2;
        final mod = DndRules.modifier(score);
        final modStr = mod >= 0 ? '+$mod' : '$mod';
        return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 4),
          padding: const pw.EdgeInsets.all(6),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _red),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            children: [
              pw.Text(abbr,
                  style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: _grey)),
              pw.Text(modStr,
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text('$score', style: const pw.TextStyle(fontSize: 9)),
            ],
          ),
        );
      }).toList(),
    );
  }

  static pw.Widget _buildSavingThrows(CharacterAbilityScore? s,
      List<CharacterProficiency> proficiencies, int totalLevel) {
    final prof = DndRules.proficiencyBonus(totalLevel);
    final scores = {
      'strength': s?.strength ?? 10,
      'dexterity': s?.dexterity ?? 10,
      'constitution': s?.constitution ?? 10,
      'intelligence': s?.intelligence ?? 10,
      'wisdom': s?.wisdom ?? 10,
      'charisma': s?.charisma ?? 10,
    };
    final savingProfs = proficiencies
        .map((p) => p.proficiencyKey)
        .where((k) => k.startsWith('save_'))
        .toSet();

    // Map from save key format 'save_str' to ability key
    const saveKeyMap = {
      'strength': 'save_str',
      'dexterity': 'save_dex',
      'constitution': 'save_con',
      'intelligence': 'save_int',
      'wisdom': 'save_wis',
      'charisma': 'save_cha',
    };

    final items = [
      ('FOR', 'strength'),
      ('DEX', 'dexterity'),
      ('CON', 'constitution'),
      ('INT', 'intelligence'),
      ('SAG', 'wisdom'),
      ('CHA', 'charisma'),
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionLabel('Jets de sauvegarde'),
        ...items.map((e) {
          final hasPof = savingProfs.contains(saveKeyMap[e.$2]);
          final mod = DndRules.modifier(scores[e.$2]!);
          final total = mod + (hasPof ? prof : 0);
          final s2 = total >= 0 ? '+$total' : '$total';
          return _profRow(e.$1, s2, hasPof);
        }),
      ],
    );
  }

  static pw.Widget _buildCombatStats(
      Character c, CharacterAbilityScore? s, int totalLevel) {
    final dex = s?.dexterity ?? 10;
    final prof = DndRules.proficiencyBonus(totalLevel);
    final init = DndRules.modifier(dex);
    final initStr = init >= 0 ? '+$init' : '$init';
    final pp = DndRules.modifier(s?.wisdom ?? 10) + 10;

    final chips = [
      ('CA', '${c.armorClass}'),
      ('Initiative', initStr),
      ('Vitesse', '${c.speed} m'),
      ('PB', '+$prof'),
      ('PP', '$pp'),
    ];

    return pw.Wrap(
      spacing: 6,
      runSpacing: 6,
      children: chips.map((chip) => _statChip(chip.$1, chip.$2)).toList(),
    );
  }

  static pw.Widget _statChip(String label, String value) => pw.Container(
        padding:
            const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: pw.BoxDecoration(
          color: _lightGrey,
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Column(
          children: [
            pw.Text(value,
                style: pw.TextStyle(
                    fontSize: 13, fontWeight: pw.FontWeight.bold)),
            pw.Text(label, style: const pw.TextStyle(fontSize: 8)),
          ],
        ),
      );

  static pw.Widget _buildSkills(CharacterAbilityScore? s,
      List<CharacterProficiency> proficiencies, int totalLevel) {
    final prof = DndRules.proficiencyBonus(totalLevel);
    final scores = {
      'strength': s?.strength ?? 10,
      'dexterity': s?.dexterity ?? 10,
      'constitution': s?.constitution ?? 10,
      'intelligence': s?.intelligence ?? 10,
      'wisdom': s?.wisdom ?? 10,
      'charisma': s?.charisma ?? 10,
    };
    final skillProfs = {
      for (final p in proficiencies
          .where((p) => p.proficiencyKey.startsWith('skill_')))
        p.proficiencyKey.substring(6): p.hasExpertise,
    };

    const skillAbilityMap = {
      'acrobatics': 'dexterity',
      'animal_handling': 'wisdom',
      'arcana': 'intelligence',
      'athletics': 'strength',
      'deception': 'charisma',
      'history': 'intelligence',
      'insight': 'wisdom',
      'intimidation': 'charisma',
      'investigation': 'intelligence',
      'medicine': 'wisdom',
      'nature': 'intelligence',
      'perception': 'wisdom',
      'performance': 'charisma',
      'persuasion': 'charisma',
      'religion': 'intelligence',
      'sleight_of_hand': 'dexterity',
      'stealth': 'dexterity',
      'survival': 'wisdom',
    };
    const skillNames = {
      'acrobatics': 'Acrobaties',
      'animal_handling': 'Dressage',
      'arcana': 'Arcanes',
      'athletics': 'Athlétisme',
      'deception': 'Tromperie',
      'history': 'Histoire',
      'insight': 'Perspicacité',
      'intimidation': 'Intimidation',
      'investigation': 'Investigation',
      'medicine': 'Médecine',
      'nature': 'Nature',
      'perception': 'Perception',
      'performance': 'Représentation',
      'persuasion': 'Persuasion',
      'religion': 'Religion',
      'sleight_of_hand': 'Escamotage',
      'stealth': 'Discrétion',
      'survival': 'Survie',
    };

    final skillEntries = skillAbilityMap.entries.toList();
    // Build rows of 2 skills side by side
    final rows = <pw.Widget>[];
    for (int i = 0; i < skillEntries.length; i += 2) {
      final left = skillEntries[i];
      final right = i + 1 < skillEntries.length ? skillEntries[i + 1] : null;

      pw.Widget buildSkillCell(MapEntry<String, String> e) {
        final key = e.key;
        final ability = e.value;
        final hasProfEntry = skillProfs[key];
        final hasPof = hasProfEntry != null;
        final isExpertise = hasProfEntry ?? false;
        final mod = DndRules.modifier(scores[ability]!);
        final mult = isExpertise ? 2 : (hasPof ? 1 : 0);
        final total = mod + prof * mult;
        final s2 = total >= 0 ? '+$total' : '$total';
        return _profRow(skillNames[key] ?? key, s2, hasPof,
            isExpertise: isExpertise);
      }

      rows.add(pw.Row(
        children: [
          pw.Expanded(child: buildSkillCell(left)),
          pw.SizedBox(width: 8),
          pw.Expanded(
              child: right != null
                  ? buildSkillCell(right)
                  : pw.SizedBox()),
        ],
      ));
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionLabel('Compétences'),
        ...rows,
      ],
    );
  }

  static pw.Widget _buildAttacks(List<CharacterAttack> attacks) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionLabel('Attaques'),
        pw.Table(
          border: pw.TableBorder.all(color: _lightGrey),
          columnWidths: const {
            0: pw.FlexColumnWidth(3.5),
            1: pw.FlexColumnWidth(1.5),
            2: pw.FlexColumnWidth(2),
            3: pw.FlexColumnWidth(3),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: _lightGrey),
              children: ['Nom', 'Bonus atk', 'Dégâts', 'Notes']
                  .map((h) => _tableCell(h, header: true))
                  .toList(),
            ),
            ...attacks.map((a) => pw.TableRow(children: [
                  _tableCell(a.masteryProperty != null && a.masteryProperty!.isNotEmpty
                      ? '${a.name} (${a.masteryProperty})'
                      : a.name),
                  _tableCell(a.attackBonus),
                  _tableCell('${a.damageDice} ${a.damageType}'),
                  _tableCell(a.notes),
                ])),
          ],
        ),
      ],
    );
  }

  // ─── Page 2 helpers ───────────────────────────────────────────────────────

  static pw.Widget _buildSpells(
      List<CharacterSpell> charSpells, Map<String, SrdSpell> srdMap) {
    // Group by level
    final byLevel = <int, List<SrdSpell?>>{};
    for (final cs in charSpells) {
      final srd = srdMap[cs.spellId];
      final level = srd?.level ?? 0;
      byLevel.putIfAbsent(level, () => []).add(srd);
    }
    final levels = byLevel.keys.toList()..sort();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: levels.map((lvl) {
        final spellsAtLevel = byLevel[lvl]!;
        final label =
            lvl == 0 ? 'Tours de magie' : 'Niveau $lvl';
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _subsectionLabel(label),
            pw.Wrap(
              spacing: 6,
              runSpacing: 4,
              children: spellsAtLevel.map((s) {
                final name = s?.name ?? '?';
                return pw.Container(
                  padding:
                      const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: _red),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(name,
                      style: const pw.TextStyle(fontSize: 9)),
                );
              }).toList(),
            ),
            pw.SizedBox(height: 6),
          ],
        );
      }).toList(),
    );
  }

  static pw.Widget _buildEquipment(
      List<CharacterEquipmentData> items, Character c) {
    Map<String, int> currency = {};
    try {
      currency =
          (jsonDecode(c.currency) as Map<String, dynamic>)
              .map((k, v) => MapEntry(k, (v as num).toInt()));
    } catch (_) {}

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Currency
        if (currency.isNotEmpty)
          pw.Row(
            children: currency.entries.map((e) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(right: 8),
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const pw.BoxDecoration(color: _lightGrey),
                child: pw.Text('${e.value} ${e.key.toUpperCase()}',
                    style: const pw.TextStyle(fontSize: 9)),
              );
            }).toList(),
          ),
        pw.SizedBox(height: 4),
        pw.Table(
          border: pw.TableBorder.all(color: _lightGrey),
          columnWidths: const {
            0: pw.FlexColumnWidth(4),
            1: pw.FlexColumnWidth(2),
            2: pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: _lightGrey),
              children: ['Objet', 'Poids (kg)', 'Équipé']
                  .map((h) => _tableCell(h, header: true))
                  .toList(),
            ),
            ...items.map((item) => pw.TableRow(children: [
                  _tableCell(item.itemName),
                  _tableCell(item.weight.toStringAsFixed(1)),
                  _tableCell(item.equipped ? '✓' : ''),
                ])),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildProfile(Character c) {
    final fields = [
      ('Traits de personnalité', c.personalityTraits),
      ('Idéaux', c.ideals),
      ('Liens', c.bonds),
      ('Défauts', c.flaws),
      ('Apparence', c.appearance),
      ('Backstory', c.backstory),
    ];
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: fields
          .where((f) => f.$2.isNotEmpty)
          .map((f) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _subsectionLabel(f.$1),
                  pw.Text(f.$2, style: const pw.TextStyle(fontSize: 9)),
                  pw.SizedBox(height: 6),
                ],
              ))
          .toList(),
    );
  }

  // ─── Reusable widgets ────────────────────────────────────────────────────

  static pw.Widget _sectionLabel(String text) => pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 4),
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: const pw.BoxDecoration(color: _red),
        child: pw.Text(text,
            style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: _white)),
      );

  static pw.Widget _subsectionLabel(String text) => pw.Text(text,
      style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: _grey));

  static pw.Widget _profRow(String label, String value, bool hasPof,
      {bool isExpertise = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        children: [
          pw.Container(
            width: 8,
            height: 8,
            decoration: pw.BoxDecoration(
              shape: isExpertise
                  ? pw.BoxShape.rectangle
                  : pw.BoxShape.circle,
              color: hasPof ? _red : null,
              border: pw.Border.all(color: _grey),
            ),
          ),
          pw.SizedBox(width: 4),
          pw.Expanded(
              child:
                  pw.Text(label, style: const pw.TextStyle(fontSize: 9))),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 9, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static pw.Widget _tableCell(String text, {bool header = false}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(text,
            style: pw.TextStyle(
                fontSize: 9,
                fontWeight:
                    header ? pw.FontWeight.bold : pw.FontWeight.normal)),
      );

  static pw.Widget _buildBodyText(String text) =>
      pw.Text(text, style: const pw.TextStyle(fontSize: 10));

  static pw.Widget _buildFeats(List<CharacterFeat> characterFeats, List<SrdFeat> srdFeats) {
    final srdFeatsMap = {for (final f in srdFeats) f.id: f};
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: characterFeats.map((cf) {
        final detail = srdFeatsMap[cf.featId];
        final name = detail?.name ?? cf.featId;
        final desc = detail?.description ?? '';
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.SizedBox(height: 2),
              pw.Text(desc, style: const pw.TextStyle(fontSize: 8, color: _grey)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
