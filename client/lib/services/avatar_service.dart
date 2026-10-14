import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Shared avatar pick / upload / delete logic used by both the Profile
/// screen and the Personal Details screen.
class AvatarResult {
  final bool ok;
  final String? url;
  final String? error;

  const AvatarResult({required this.ok, this.url, this.error});
}

class AvatarService {
  const AvatarService._();

  /// Shows the camera/gallery picker sheet. Returns null if dismissed.
  static Future<ImageSource?> pickSource(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Change Profile Photo',
                style: Theme.of(ctx)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take Photo'),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// On web, XFile.path is a blob URI (no extension) — derive the extension
  /// safely from the real filename, whitelisted, defaulting to jpg.
  static String safeImageExt(String name, String path) {
    String? from(String src) {
      final dot = src.lastIndexOf('.');
      if (dot < 0 || dot >= src.length - 1) return null;
      final ext = src.substring(dot + 1).toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');
      const allowed = {'jpg', 'jpeg', 'png', 'webp'};
      return allowed.contains(ext) ? ext : null;
    }

    return from(name) ?? from(path) ?? 'jpg';
  }

  /// Picks, compresses and uploads to the 'avatars' bucket.
  /// Returns the public URL on success.
  static Future<AvatarResult> pickAndUpload(
    ImageSource source, {
    required String? userId,
  }) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (picked == null) {
        return const AvatarResult(ok: false);
      }

      final bytes = await picked.readAsBytes();
      final ext = safeImageExt(picked.name, picked.path);
      final fileName =
          '${userId ?? "guest"}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      // Upload under a per-user folder so deleteAll's list(path: userId) finds it
      final uploadPath = userId != null ? '$userId/$fileName' : fileName;

      final client = Supabase.instance.client;
      await client.storage.from('avatars').uploadBinary(
        uploadPath,
        bytes,
        fileOptions: const FileOptions(upsert: true),
      );
      final publicUrl =
          client.storage.from('avatars').getPublicUrl(uploadPath);

      return AvatarResult(ok: true, url: publicUrl);
    } on StorageException catch (e) {
      return AvatarResult(ok: false, error: 'Upload failed: ${e.message}');
    } catch (e) {
      final msg = e.toString().contains('Supabase')
          ? 'Photo upload unavailable in demo mode'
          : 'Upload failed: $e';
      return AvatarResult(ok: false, error: msg);
    }
  }

  /// Removes all photos for [userId] from the bucket.
  static Future<AvatarResult> deleteAll(String? userId) async {
    if (userId == null) {
      return const AvatarResult(ok: false, error: 'Not signed in');
    }
    try {
      final client = Supabase.instance.client;
      final files = await client.storage.from('avatars').list(path: userId);
      if (files.isNotEmpty) {
        final paths = files.map((f) => '$userId/${f.name}').toList();
        await client.storage.from('avatars').remove(paths);
      }
      return const AvatarResult(ok: true);
    } on StorageException catch (e) {
      return AvatarResult(ok: false, error: 'Delete failed: ${e.message}');
    } catch (e) {
      return AvatarResult(ok: false, error: 'Delete failed: $e');
    }
  }
}
