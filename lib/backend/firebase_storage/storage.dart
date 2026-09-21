import 'dart:typed_data';

/// ⚠️  DISABLED — Firebase Storage is no longer used.
///
/// This stub keeps every legacy `uploadData(...)` call compiling while we
/// migrate the app to ImgBB. Any file still calling this will get `null`
/// back and print a warning so you can find it.
///
/// Real uploads go through `_uploadToImgBB` in
/// `lib/add_product/add_product_widget.dart`.
Future<String?> uploadData(String path, Uint8List data) async {
  // ignore: avoid_print
  print(
    '⚠️  uploadData() called for "$path" — Firebase Storage is disabled. '
    'Migrate this page to ImgBB.',
  );
  return null;
}
