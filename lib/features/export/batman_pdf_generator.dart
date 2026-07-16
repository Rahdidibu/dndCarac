import 'dart:convert';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/database/app_database.dart';
import '../batman/providers/batman_providers.dart';

// ─── Palette Batman ─────────────────────────────────────────────────────────

const _black = PdfColor.fromInt(0xFF1A1A2E);
const _amber = PdfColor.fromInt(0xFFFFB300);
const _dark = PdfColor.fromInt(0xFF2C2C3E);
const _grey = PdfColor.fromInt(0xFF616161);
const _lightGrey = PdfColor.fromInt(0xFFEEEEEE);
const _white = PdfColors.white;
const _red = PdfColor.fromInt(0xFFB71C1C);

// ─── Entry-point ─────────────────────────────────────────────────────────────

class BatmanPdfGenerator {
  /// Génère la fiche Batman RPG au format PDF.
  static Future<List<int>> generate({
    required Character character,
    required BatmanCharacter batman,
    required BatmanProfile? profile,
    required List<BatmanCharacterWay> charWays,
    required List<BatmanWay> allWays,
  }) async {
    final doc = pw.Document();

    // ── Page 1 : Identité + Caractéristiques + Combat ───────────────────────
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (ctx) => [
        _buildHeader(character, batman, profile),
        pw.SizedBox(height: 10),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Colonne gauche : caracs
            pw.Expanded(
              flex: 3,
              child: pw.Column(children: [
                _buildAbilities(batman),
                pw.SizedBox(height: 8),
                _buildEthics(batman),
              ]),
            ),
            pw.SizedBox(width: 12),
            // Colonne droite : combat + niveau de vie
            pw.Expanded(
              flex: 5,
              child: pw.Column(children: [
                _buildCombatStats(character, batman),
                pw.SizedBox(height: 8),
                _buildLivingStandard(batman),
                if (profile != null) ...[
                  pw.SizedBox(height: 8),
                  _buildProfileInfo(profile),
                ],
              ]),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        _buildHpBar(character),
        if (batman.exploitPointsMax > 0) ...[
          pw.SizedBox(height: 8),
          _buildExploitPoints(batman),
        ],
      ],
    ));

    // ── Page 2 : Voies ───────────────────────────────────────────────────────
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (ctx) => [
        _sectionLabel('Voies acquises'),
        pw.SizedBox(height: 8),
        if (charWays.isEmpty)
          pw.Text('Aucune voie acquise.',
              style: const pw.TextStyle(fontSize: 10)),
        ...charWays.map((cw) {
          final way = allWays.where((w) => w.id == cw.wayId).firstOrNull;
          if (way == null) return pw.SizedBox();
          return _buildWayBlock(way, cw.rankAcquired);
        }),
      ],
    ));

    return doc.save();
  }

  // ─── Helpers page 1 ───────────────────────────────────────────────────────

  static pw.Widget _buildHeader(
      Character c, BatmanCharacter bat, BatmanProfile? profile) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: const pw.BoxDecoration(
        color: _black,
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
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: _amber)),
                if (bat.secretIdentity.isNotEmpty)
                  pw.Text(bat.secretIdentity,
                      style: const pw.TextStyle(fontSize: 11, color: _white)),
                if (profile != null)
                  pw.Text(profile.name,
                      style: pw.TextStyle(
                          fontSize: 11,
                          color: _amber,
                          fontStyle: pw.FontStyle.italic)),
                pw.SizedBox(height: 4),
                pw.Text(_modeLabel(bat.mode),
                    style: const pw.TextStyle(fontSize: 10, color: _white)),
                if (c.playerName.isNotEmpty)
                  pw.Text('Joueur : ${c.playerName}',
                      style: const pw.TextStyle(fontSize: 9, color: _white)),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _chip('PV ${c.hpCurrent} / ${c.hpMax}'),
              pw.SizedBox(height: 4),
              _chip('DEF ${bat.defense}'),
              pw.SizedBox(height: 4),
              _chip('INIT ${bat.initiative >= 0 ? '+${bat.initiative}' : '${bat.initiative}'}'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _chip(String label) => pw.Container(
        padding:
            const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: pw.BoxDecoration(
          color: _amber,
          borderRadius: pw.BorderRadius.circular(12),
        ),
        child: pw.Text(label,
            style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: _black)),
      );

  static pw.Widget _buildAbilities(BatmanCharacter bat) {
    final abilities = [
      ('FOR', bat.force),
      ('CON', bat.constitution),
      ('DEX', bat.dexterite),
      ('INT', bat.intelligence),
      ('PER', bat.perception),
      ('VOL', bat.volonte),
    ];
    return pw.Column(
      children: [
        _sectionLabel('Caractéristiques'),
        pw.SizedBox(height: 4),
        ...abilities.map((entry) {
          final mod = abilityModifier(entry.$2);
          final modStr = mod >= 0 ? '+$mod' : '$mod';
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 3),
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: _amber),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(entry.$1,
                    style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: _grey)),
                pw.Text('${entry.$2}',
                    style: const pw.TextStyle(fontSize: 9)),
                pw.Text(modStr,
                    style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        color: _black)),
              ],
            ),
          );
        }),
      ],
    );
  }

  static pw.Widget _buildEthics(BatmanCharacter bat) {
    final axes = [
      ('Ordre', bat.ethicsOrder),
      ('Justice', bat.ethicsJustice),
      ('Anarchie', bat.ethicsAnarchy),
      ('Crime', bat.ethicsCrime),
    ];
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionLabel('Éthique'),
        pw.SizedBox(height: 4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: axes.map((e) {
            return pw.Column(
              children: [
                pw.Text('${e.$2}',
                    style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: _amber)),
                pw.Text(e.$1,
                    style: const pw.TextStyle(fontSize: 8, color: _grey)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  static pw.Widget _buildCombatStats(Character c, BatmanCharacter bat) {
    final atcStr =
        bat.atcTotal >= 0 ? '+${bat.atcTotal}' : '${bat.atcTotal}';
    final atdStr =
        bat.atdTotal >= 0 ? '+${bat.atdTotal}' : '${bat.atdTotal}';
    final iniStr =
        bat.initiative >= 0 ? '+${bat.initiative}' : '${bat.initiative}';

    final stats = [
      ('ATC', atcStr),
      ('ATD', atdStr),
      ('Défense', '${bat.defense}'),
      ('Initiative', iniStr),
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionLabel('Combat'),
        pw.SizedBox(height: 4),
        pw.Wrap(
          spacing: 6,
          runSpacing: 6,
          children: stats.map((s) => _statChip(s.$1, s.$2)).toList(),
        ),
      ],
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

  static pw.Widget _buildLivingStandard(BatmanCharacter bat) {
    const labels = {
      'miserable': 'Misérable',
      'pauvre': 'Pauvre',
      'modeste': 'Modeste',
      'aise': 'Aisé',
      'fortun': 'Fortuné',
      'millionnaire': 'Millionnaire',
      'milliardaire': 'Milliardaire',
    };
    return pw.Row(
      children: [
        pw.Text('Niveau de vie : ',
            style: pw.TextStyle(
                fontSize: 10, fontWeight: pw.FontWeight.bold)),
        pw.Text(labels[bat.livingStandard] ?? bat.livingStandard,
            style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  static pw.Widget _buildProfileInfo(BatmanProfile profile) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: _lightGrey,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(profile.name,
              style: pw.TextStyle(
                  fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 2),
          pw.Text(profile.description,
              style: const pw.TextStyle(fontSize: 8)),
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              _infoPill('Dé : ${profile.hitDie}'),
              pw.SizedBox(width: 4),
              if (profile.atcBonus > 0)
                _infoPill('ATC +${profile.atcBonus}'),
              pw.SizedBox(width: 4),
              if (profile.atdBonus > 0)
                _infoPill('ATD +${profile.atdBonus}'),
              pw.SizedBox(width: 4),
              if (profile.exploitPoints > 0)
                _infoPill('PE: ${profile.exploitPoints}'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _infoPill(String text) => pw.Container(
        padding:
            const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: pw.BoxDecoration(
          color: _dark,
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Text(text,
            style: const pw.TextStyle(fontSize: 8, color: _white)),
      );

  static pw.Widget _buildHpBar(Character c) {
    final ratio = c.hpMax > 0 ? c.hpCurrent / c.hpMax : 0.0;
    final barWidth = 200.0;
    final filledWidth = barWidth * ratio;
    final barColor = ratio > 0.5 ? _green : (ratio > 0.25 ? _orange : _red);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionLabel('Points de vie'),
        pw.SizedBox(height: 4),
        pw.Row(
          children: [
            pw.Text('${c.hpCurrent} / ${c.hpMax}',
                style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(width: 16),
            pw.Stack(
              children: [
                pw.Container(
                  width: barWidth,
                  height: 12,
                  decoration: pw.BoxDecoration(
                    color: _lightGrey,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                ),
                pw.Container(
                  width: filledWidth.clamp(0.0, barWidth),
                  height: 12,
                  decoration: pw.BoxDecoration(
                    color: barColor,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildExploitPoints(BatmanCharacter bat) {
    return pw.Row(
      children: [
        _sectionLabel("Points d'exploit"),
        pw.SizedBox(width: 8),
        pw.Text(
          '${bat.exploitPointsCurrent} / ${bat.exploitPointsMax}',
          style: pw.TextStyle(
              fontSize: 13, fontWeight: pw.FontWeight.bold, color: _amber),
        ),
      ],
    );
  }

  // ─── Helpers page 2 ───────────────────────────────────────────────────────

  static pw.Widget _buildWayBlock(BatmanWay way, int rankAcquired) {
    List<dynamic> ranks = [];
    try {
      ranks = json.decode(way.ranksJson) as List<dynamic>;
    } catch (_) {}

    final acquiredRanks =
        ranks.where((r) => (r['rank'] as int) <= rankAcquired).toList();

    // Stars
    final stars = List.generate(5, (i) => i < rankAcquired ? '★' : '☆').join();

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _amber),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(way.name,
                  style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: _amber)),
              pw.Text(stars,
                  style: pw.TextStyle(fontSize: 11, color: _amber)),
            ],
          ),
          pw.Text(_typeLabel(way.type),
              style: const pw.TextStyle(fontSize: 8, color: _grey)),
          pw.SizedBox(height: 6),
          ...acquiredRanks.map<pw.Widget>((rank) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 16,
                    height: 16,
                    margin: const pw.EdgeInsets.only(right: 6),
                    decoration: const pw.BoxDecoration(
                      color: _amber,
                      shape: pw.BoxShape.circle,
                    ),
                    child: pw.Center(
                      child: pw.Text('${rank['rank']}',
                          style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: _black)),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(rank['name'] ?? '',
                            style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Text(rank['description'] ?? '',
                            style: const pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── Shared ───────────────────────────────────────────────────────────────

  static pw.Widget _sectionLabel(String text) => pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 4),
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: const pw.BoxDecoration(color: _black),
        child: pw.Text(text,
            style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: _amber)),
      );

  static String _modeLabel(String mode) {
    switch (mode) {
      case 'rues':
        return 'Rues de Gotham City';
      case 'ombres':
        return 'Ombres de Gotham City';
      case 'prodiges':
        return 'Prodiges de Gotham City';
      default:
        return mode;
    }
  }

  static String _typeLabel(String type) {
    switch (type) {
      case 'commune':
        return 'Voie commune';
      case 'ombre':
        return 'Voie des ombres';
      case 'prodige':
        return 'Voie des prodiges';
      default:
        return type;
    }
  }
}

const _green = PdfColor.fromInt(0xFF388E3C);
const _orange = PdfColor.fromInt(0xFFF57C00);

