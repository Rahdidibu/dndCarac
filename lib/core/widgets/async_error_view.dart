import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../utils/app_errors.dart';

class AsyncErrorView extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final bool compact;

  const AsyncErrorView({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    AppErrors.log(error, stackTrace, context: 'AsyncErrorView');
    final colorScheme = Theme.of(context).colorScheme;
    final message = Text(
      AppErrors.userMessage(error, l10n),
      textAlign: TextAlign.center,
      style: TextStyle(color: colorScheme.error),
    );
    final retry = onRetry == null
        ? null
        : TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(l10n.actionRetry),
          );

    if (compact) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [message, ?retry],
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 32),
            const SizedBox(height: 8),
            message,
            ?retry,
          ],
        ),
      ),
    );
  }
}
