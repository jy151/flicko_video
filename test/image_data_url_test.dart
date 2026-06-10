import 'dart:convert';
import 'dart:typed_data';

import 'package:flicko_video/utils/image_data_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('imageDataUrl prefixes detected PNG mime type', () {
    final bytes = Uint8List.fromList([
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
    ]);

    expect(
      imageDataUrl(bytes: bytes),
      'data:image/png;base64,${base64Encode(bytes)}',
    );
  });

  test('imageDataUrl normalizes picker jpg mime type', () {
    final bytes = Uint8List.fromList([0x01, 0x02, 0x03]);

    expect(
      imageDataUrl(bytes: bytes, mimeType: 'image/jpg'),
      'data:image/jpeg;base64,${base64Encode(bytes)}',
    );
  });
}
