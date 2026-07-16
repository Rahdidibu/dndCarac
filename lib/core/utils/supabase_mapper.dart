import 'package:drift/drift.dart';

class SupabaseMapper {
  static String _toCamelCase(String snake) {
    final parts = snake.split('_');
    if (parts.isEmpty) return '';
    final first = parts.first;
    final rest = parts.skip(1).map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1)).join();
    return '$first$rest';
  }

  static String _toSnakeCase(String camel) {
    final exp = RegExp(r'(?<=[a-z0-9])([A-Z])');
    return camel.replaceAllMapped(exp, (Match m) => '_${m.group(0)!.toLowerCase()}').toLowerCase();
  }

  static Map<String, dynamic> toCamelCaseMap(Map<String, dynamic> snakeMap) {
    return snakeMap.map((key, value) {
      return MapEntry(_toCamelCase(key), value);
    });
  }

  static Map<String, dynamic> toSnakeCaseMap(Map<String, dynamic> camelMap) {
    return camelMap.map((key, value) {
      return MapEntry(_toSnakeCase(key), value);
    });
  }

  static Map<String, dynamic> insertableToMap(Insertable insertable) {
    final columns = insertable.toColumns(true);
    final map = <String, dynamic>{};
    columns.forEach((key, expr) {
      if (expr is Variable) {
        map[key] = expr.value;
      }
    });
    return map;
  }
}
