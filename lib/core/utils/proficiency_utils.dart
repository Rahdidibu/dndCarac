/// Garde une seule entrée par clé de maîtrise ; l'expertise l'emporte en cas de doublon.
List<T> dedupeProficiencies<T>(
  Iterable<T> items, {
  required String Function(T item) keyOf,
  required bool Function(T item) hasExpertise,
}) {
  final byKey = <String, T>{};
  for (final item in items) {
    final key = keyOf(item);
    final existing = byKey[key];
    if (existing == null || (hasExpertise(item) && !hasExpertise(existing))) {
      byKey[key] = item;
    }
  }
  return byKey.values.toList();
}
