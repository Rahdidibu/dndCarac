class StringUtils {
  static const _withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÝÿñ';
  static const _woutDia = 'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeCcIIIIiiiiUUUUuuuuYyn';

  /// Removes accents/diacritics from a string (e.g. 'Épée' -> 'Epee').
  static String removeDiacritics(String str) {
    var res = str;
    for (int i = 0; i < _withDia.length; i++) {
      res = res.replaceAll(_withDia[i], _woutDia[i]);
    }
    return res;
  }

  /// Compares two strings alphabetically ignoring accents and case.
  static int compareAlphabetically(String a, String b) {
    final normA = removeDiacritics(a).toLowerCase();
    final normB = removeDiacritics(b).toLowerCase();
    final cmp = normA.compareTo(normB);
    if (cmp != 0) return cmp;
    return a.compareTo(b);
  }
}
