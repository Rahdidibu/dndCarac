import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/widgets/image_cropper_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/character_providers.dart';

/// Choisit, recadre et téléverse l'avatar d'un personnage, puis met à jour
/// `imageUrl`. Retourne la nouvelle URL, ou null si annulé / en erreur.
Future<String?> pickAndUploadCharacterAvatar(
  BuildContext context,
  WidgetRef ref,
  int characterId,
) async {
  final l10n = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  try {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
    );
    if (image == null) return null;

    final rawBytes = await image.readAsBytes();
    if (!context.mounted) return null;

    final croppedBytes = await ImageCropperDialog.show(context, rawBytes);
    if (croppedBytes == null) return null;

    messenger.showSnackBar(SnackBar(content: Text(l10n.profilePhotoUploading)));

    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté');

    final fileName =
        '$userId/${characterId}_${DateTime.now().millisecondsSinceEpoch}.png';

    await client.storage.from('character-avatars').uploadBinary(
          fileName,
          croppedBytes,
          fileOptions: const FileOptions(contentType: 'image/png', upsert: true),
        );

    final imageUrl =
        client.storage.from('character-avatars').getPublicUrl(fileName);

    await ref.read(databaseProvider).characterDao.updateCharacter(
          CharactersCompanion(
            id: Value(characterId),
            imageUrl: Value(imageUrl),
            updatedAt: Value(DateTime.now().toIso8601String()),
          ),
        );

    ref.invalidate(characterByIdProvider(characterId));
    messenger.showSnackBar(SnackBar(content: Text(l10n.profilePhotoUpdated)));
    return imageUrl;
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.profilePhotoUploadError(e.toString()))),
    );
    return null;
  }
}
