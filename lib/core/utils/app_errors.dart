import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/app_localizations.dart';

class AppErrors {
  const AppErrors._();

  static void log(Object error, StackTrace? stack, {String? context}) {
    debugPrint('[AppError]${context == null ? '' : ' $context'}: $error');
    if (stack != null && kDebugMode) debugPrintStack(stackTrace: stack);
  }

  /// Message lisible pour l'utilisateur ; ne révèle jamais le détail technique.
  static String userMessage(Object error, AppLocalizations l10n) {
    if (error is TimeoutException ||
        error is AuthRetryableFetchException) {
      return l10n.errorNetwork;
    }
    if (error is PostgrestException) {
      if (error.code == '42501') return l10n.errorPermission;
      if (error.code == null && _looksLikeNetwork(error.message)) {
        return l10n.errorNetwork;
      }
      return l10n.errorGeneric;
    }
    if (_looksLikeNetwork(error.toString())) return l10n.errorNetwork;
    return l10n.errorGeneric;
  }

  static bool _looksLikeNetwork(String text) {
    final lower = text.toLowerCase();
    return lower.contains('failed host lookup') ||
        lower.contains('clientexception') ||
        lower.contains('xmlhttprequest') ||
        lower.contains('socketexception') ||
        lower.contains('connection');
  }
}
