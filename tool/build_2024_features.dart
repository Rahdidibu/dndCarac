// Génère assets/data/2024/features.json et levels.json à partir du SRD 5.2
// publié par 5e-bits (https://github.com/5e-bits/5e-database).
//
// Usage : dart run tool/build_2024_features.dart [--from-dir <dossier>]
//   --from-dir : lit 5e-SRD-Features.json / 5e-SRD-Levels.json localement
//                au lieu de les télécharger.
//
// Le schéma de features.json est celui de assets/data/2014/features.json
// (index, class, subclass?, name, level, prerequisites, desc[]).
import 'dart:convert';
import 'dart:io';

const _baseUrl =
    'https://raw.githubusercontent.com/5e-bits/5e-database/main/src/2024/en';

Future<List<dynamic>> _load(String file, String? dir) async {
  if (dir != null) {
    return json.decode(await File('$dir/$file').readAsString()) as List;
  }
  final client = HttpClient();
  try {
    final req = await client.getUrl(Uri.parse('$_baseUrl/$file'));
    final res = await req.close();
    if (res.statusCode != 200) {
      throw HttpException('HTTP ${res.statusCode}', uri: req.uri);
    }
    return json.decode(await utf8.decodeStream(res)) as List;
  } finally {
    client.close();
  }
}

int _levelOf(dynamic level) {
  if (level is int) return level;
  final label = level is Map
      ? (level['name'] ?? level['index'] ?? '').toString()
      : level.toString();
  final m = RegExp(r'(\d+)\s*$').firstMatch(label);
  if (m == null) throw FormatException('Niveau illisible : $level');
  return int.parse(m.group(1)!);
}

// La source contient des césures de PDF ("at- tack") : on recolle les mots,
// sauf quand le mot suivant est un mot-outil ("Strength- with").
final _hyphenBreak = RegExp(
  r'(?<=[A-Za-z]{2})- (?!(?:the|with|or|and|to|a|of)\b)(?=[a-z])',
);

List<String> _paragraphs(String text) => text
    .split('\n')
    .map((l) => l.trim().replaceAll(_hyphenBreak, ''))
    .where((l) => l.isNotEmpty)
    .toList();

Map<String, dynamic> _ref(Map<String, dynamic> r) => {
  'index': r['index'],
  'name': r['name'],
  'url': r['url'],
};

int _byClassThenLevel(Map<String, dynamic> a, Map<String, dynamic> b) {
  final c = (a['class']['index'] as String).compareTo(
    b['class']['index'] as String,
  );
  if (c != 0) return c;
  final l = (a['level'] as int).compareTo(b['level'] as int);
  if (l != 0) return l;
  return (a['index'] as String).compareTo(b['index'] as String);
}

Future<void> main(List<String> args) async {
  final dirIdx = args.indexOf('--from-dir');
  final dir = dirIdx >= 0 ? args[dirIdx + 1] : null;

  final rawFeatures = await _load('5e-SRD-Features.json', dir);
  final rawLevels = await _load('5e-SRD-Levels.json', dir);

  final features = rawFeatures.map((f) {
    final sub = f['subclass'] as Map<String, dynamic>?;
    return <String, dynamic>{
      'index': f['index'],
      'class': _ref(f['class'] as Map<String, dynamic>),
      if (sub != null) 'subclass': _ref(sub),
      'name': f['name'],
      'level': _levelOf(f['level']),
      'prerequisites': <dynamic>[],
      'desc': _paragraphs((f['description'] ?? '') as String),
      'url': f['url'],
    };
  }).toList()..sort(_byClassThenLevel);

  // Les niveaux de sous-classe (ex. champion-3) font doublon avec le niveau
  // de classe : leurs capacités sont déjà dans features.json (clé subclass).
  final levels =
      rawLevels
          .where((l) => ((l['url'] ?? '') as String).contains('/classes/'))
          .map((l) {
            return <String, dynamic>{
              'index': l['index'],
              'class': _ref(l['class'] as Map<String, dynamic>),
              'level': _levelOf(l['level']),
              'prof_bonus': l['prof_bonus'],
              'features': l['features'],
              'class_specific': l['class_specific'] ?? <String, dynamic>{},
              if (l['spellcasting'] != null) 'spellcasting': l['spellcasting'],
              'url': l['url'],
            };
          })
          .toList()
        ..sort(_byClassThenLevel);

  const encoder = JsonEncoder.withIndent('  ');
  await File(
    'assets/data/2024/features.json',
  ).writeAsString('${encoder.convert(features)}\n');
  await File(
    'assets/data/2024/levels.json',
  ).writeAsString('${encoder.convert(levels)}\n');
  stdout.writeln(
    'features.json : ${features.length} capacités, '
    'levels.json : ${levels.length} niveaux',
  );
}
