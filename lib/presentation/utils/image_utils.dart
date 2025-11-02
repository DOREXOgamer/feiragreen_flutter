import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static const _allowedExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.webp'];

  static bool isImagePath(String path) {
    final lower = path.toLowerCase();
    return _allowedExtensions.any((ext) => lower.endsWith(ext));
  }

  /// Picks an image from gallery, ensuring it's an image file.
  /// Returns a File on mobile/desktop, or null if the selection was canceled
  /// or not an image.
  static Future<File?> pickImageOnly() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return null;
    if (!isImagePath(xfile.path)) return null;
    return File(xfile.path);
  }
}

