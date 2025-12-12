import 'dart:io';

import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  MediaService._internal();
  static final MediaService instance = MediaService._internal();

  final ImagePicker _picker = ImagePicker();

  Future<File?> takePhotoAndSaveToGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (image == null) return null;

    await GallerySaver.saveImage(image.path);
    return File(image.path);
  }

  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return null;
    return File(image.path);
  }
}