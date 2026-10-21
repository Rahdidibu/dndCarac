import 'package:flutter/material.dart';

void showUndoSnackBar(
  BuildContext context, {
  required String message,
  required String undoLabel,
  required Future<void> Function() onUndo,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: undoLabel,
          onPressed: () async => onUndo(),
        ),
      ),
    );
}
