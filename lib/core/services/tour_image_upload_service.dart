import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadedTourImage {
  final String downloadUrl;
  final String fileName;
  final String storagePath;

  const UploadedTourImage({
    required this.downloadUrl,
    required this.fileName,
    required this.storagePath,
  });
}

class TourImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UploadedTourImage?> pickAndUpload({
    required String companyId,
    required String uploaderRole,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      throw StateError('Seçilen dosya okunamadı. Lütfen farklı bir görsel deneyin.');
    }

    final safeCompanyId = _sanitizeSegment(companyId);
    final safeFileName = _sanitizeSegment(file.name);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final storagePath = 'tour_images/$safeCompanyId/$timestamp-$safeFileName';

    final metadata = SettableMetadata(
      contentType: _guessContentType(_extractExtension(file.name)),
      customMetadata: {
        'companyId': companyId,
        'uploaderRole': uploaderRole,
        'originalFileName': file.name,
      },
    );

    final ref = _storage.ref().child(storagePath);
    await ref.putData(bytes, metadata);
    final downloadUrl = await ref.getDownloadURL();

    return UploadedTourImage(
      downloadUrl: downloadUrl,
      fileName: file.name,
      storagePath: storagePath,
    );
  }

  Future<void> deleteByUrl(String downloadUrl) async {
    if (downloadUrl.trim().isEmpty) return;
    try {
      await _storage.refFromURL(downloadUrl).delete();
    } catch (_) {
      // Existing tours may point to an external URL or already deleted file.
    }
  }

  String _sanitizeSegment(String input) {
    final sanitized = input.trim().replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    return sanitized.isEmpty ? 'file' : sanitized;
  }

  String? _extractExtension(String fileName) {
    final trimmed = fileName.trim();
    final dotIndex = trimmed.lastIndexOf('.');
    if (dotIndex <= 0 || dotIndex == trimmed.length - 1) {
      return null;
    }
    return trimmed.substring(dotIndex + 1);
  }

  String _guessContentType(String? extension) {
    switch ((extension ?? '').toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      default:
        return 'image/jpeg';
    }
  }
}
