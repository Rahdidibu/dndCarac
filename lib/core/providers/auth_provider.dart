import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_errors.dart';

/// Stream provider pour écouter la session d'authentification Supabase
final authSessionProvider = StreamProvider<Session?>((ref) {
  try {
    return Supabase.instance.client.auth.onAuthStateChange.map((event) => event.session);
  } catch (e, st) {
    AppErrors.log(e, st, context: 'authSessionProvider');
    return Stream.value(null);
  }
});

/// Provider simple pour récupérer l'ID de l'utilisateur connecté actuellement
final userIdProvider = Provider<String?>((ref) {
  final sessionAsync = ref.watch(authSessionProvider);
  return sessionAsync.when(
    data: (session) => session?.user.id,
    loading: () => null,
    error: (_, _) => null,
  );
});
