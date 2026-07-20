import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainTabNavigationProvider = StateProvider<int>((ref) => 0);
final forgeSelectedCharacterIdProvider = StateProvider<int?>((ref) => null);
