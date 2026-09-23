import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Cloudinary unsigned upload helper.
/// No API secret required — the unsigned preset handles auth.
class CloudinaryService {
  // ─── Cloudinary credentials (public — safe to hardcode) ───
  static const String cloudName   = 'da1tlnlw';
  static const String uploadPreset = 'zannext_unsigned';

  static Uri get _uploadUri =>
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  /// Upload bytes to Cloudinary. Returns the secure URL or null on failure.
  static Future<String?> upload(
    Uint8List bytes, {
    String? filename,
    String folder = 'zannext',
    int retries = 2,
  }) async {
    if (bytes.isEmpty) {
      debugPrint('❌ Cloudinary: empty bytes');
      return null;
    }

    for (var attempt = 0; attempt <= retries; attempt++) {
      try {
        final request = http.MultipartRequest('POST', _uploadUri)
          ..fields['upload_preset'] = uploadPreset
          ..fields['folder'] = folder
          ..files.add(http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: filename ?? 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ));

        final streamed = await request
            .send()
            .timeout(const Duration(seconds: 30));
        final response = await http.Response.fromStream(streamed);

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final url = json['secure_url'] as String?;
          if (url != null && url.isNotEmpty) {
            debugPrint('✅ Cloudinary upload success: $url');
            return url;
          }
        }

        debugPrint('Cloudinary failed (try ${attempt + 1}): ${response.statusCode} ${response.body}');
      } catch (e) {
        debugPrint('Cloudinary error (try ${attempt + 1}): $e');
      }

      if (attempt < retries) {
        await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
      }
    }
    return null;
  }
}
