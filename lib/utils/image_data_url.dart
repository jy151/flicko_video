import 'dart:convert';
import 'dart:typed_data';

String imageDataUrl({
  required Uint8List bytes,
  String? path,
  String? mimeType,
}) {
  final resolvedMimeType =
      _normalizeImageMimeType(mimeType) ??
      _detectMimeTypeFromBytes(bytes) ??
      _detectMimeTypeFromPath(path) ??
      'image/jpeg';
  return 'data:$resolvedMimeType;base64,${base64Encode(bytes)}';
}

String? _normalizeImageMimeType(String? mimeType) {
  final value = mimeType?.trim().toLowerCase();
  if (value == null || value.isEmpty || !value.startsWith('image/')) {
    return null;
  }
  return value == 'image/jpg' ? 'image/jpeg' : value;
}

String? _detectMimeTypeFromBytes(Uint8List bytes) {
  if (bytes.length >= 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47 &&
      bytes[4] == 0x0D &&
      bytes[5] == 0x0A &&
      bytes[6] == 0x1A &&
      bytes[7] == 0x0A) {
    return 'image/png';
  }

  if (bytes.length >= 3 &&
      bytes[0] == 0xFF &&
      bytes[1] == 0xD8 &&
      bytes[2] == 0xFF) {
    return 'image/jpeg';
  }

  if (bytes.length >= 12 &&
      bytes[0] == 0x52 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46 &&
      bytes[3] == 0x46 &&
      bytes[8] == 0x57 &&
      bytes[9] == 0x45 &&
      bytes[10] == 0x42 &&
      bytes[11] == 0x50) {
    return 'image/webp';
  }

  if (bytes.length >= 6) {
    final header = String.fromCharCodes(bytes.take(6)).toLowerCase();
    if (header == 'gif87a' || header == 'gif89a') {
      return 'image/gif';
    }
  }

  return null;
}

String? _detectMimeTypeFromPath(String? path) {
  final lowerPath = path?.toLowerCase();
  if (lowerPath == null || lowerPath.isEmpty) {
    return null;
  }

  if (lowerPath.endsWith('.png')) {
    return 'image/png';
  }
  if (lowerPath.endsWith('.jpg') || lowerPath.endsWith('.jpeg')) {
    return 'image/jpeg';
  }
  if (lowerPath.endsWith('.webp')) {
    return 'image/webp';
  }
  if (lowerPath.endsWith('.gif')) {
    return 'image/gif';
  }
  if (lowerPath.endsWith('.heic')) {
    return 'image/heic';
  }
  if (lowerPath.endsWith('.heif')) {
    return 'image/heif';
  }

  return null;
}
