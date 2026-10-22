/// Ordre divin (Clerc) et ordre primordial (Druide) du D&D 2024.
class ClassOrderOption {
  final String id;
  final String classId;
  final String orderName;
  final String name;
  final String description;

  const ClassOrderOption({
    required this.id,
    required this.classId,
    required this.orderName,
    required this.name,
    required this.description,
  });
}

class ClassOrders {
  ClassOrders._();

  static const all = [
    ClassOrderOption(
      id: 'protector',
      classId: 'cleric',
      orderName: 'Ordre divin',
      name: 'Protecteur',
      description:
          "Entraîné au combat, vous gagnez la maîtrise des armes de guerre et l'entraînement à l'armure lourde.",
    ),
    ClassOrderOption(
      id: 'thaumaturge',
      classId: 'cleric',
      orderName: 'Ordre divin',
      name: 'Thaumaturge',
      description:
          "Vous connaissez un sort mineur supplémentaire de la liste de sorts du Clerc. De plus, vous ajoutez votre modificateur de Sagesse (minimum +1) à vos tests d'Intelligence (Arcanes ou Religion).",
    ),
    ClassOrderOption(
      id: 'magician',
      classId: 'druid',
      orderName: 'Ordre primordial',
      name: 'Magicien',
      description:
          "Vous connaissez un sort mineur supplémentaire de la liste de sorts de Druide. De plus, vous ajoutez votre modificateur de Sagesse (minimum +1) à vos tests d'Intelligence (Arcanes ou Nature).",
    ),
    ClassOrderOption(
      id: 'warden',
      classId: 'druid',
      orderName: 'Ordre primordial',
      name: 'Gardien',
      description:
          "Entraîné au combat, vous obtenez la maîtrise des armes de guerre et l'entraînement au port des armures intermédiaires.",
    ),
  ];

  /// Maîtrises accordées par l'ordre (clés de `character_proficiencies`).
  static List<String> proficiencyKeys(String id) => switch (id) {
    'protector' => ['armor_heavy', 'weapon_martial'],
    'warden' => ['armor_medium', 'weapon_martial'],
    _ => const [],
  };

  static ClassOrderOption? find(String classId, String? id) {
    if (id == null) return null;
    for (final o in all) {
      if (o.classId == classId && o.id == id) return o;
    }
    return null;
  }

  /// Ordre choisi à la création pour [classId] (null pour les autres classes).
  static String? chosenFor(
    String classId, {
    required String? divineOrder,
    required String? primalOrder,
  }) => switch (classId) {
    'cleric' => divineOrder,
    'druid' => primalOrder,
    _ => null,
  };
}
