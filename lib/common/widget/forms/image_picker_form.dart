import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef OnImagesPicked = void Function(List<XFile> images);

class ImagePickerForm {
  final ImagePicker _picker = ImagePicker();

  /// Opens the bottom sheet to choose camera or gallery
  void showImageSourcePicker({
    required final BuildContext context,
    required final OnImagesPicked onImagesPicked,
  }) {
    showModalBottomSheet(
      backgroundColor: AppColors.transparent,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (final _) {
        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    final images = await _pickImages(ImageSource.gallery);
                    if (images.isNotEmpty) onImagesPicked(images);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.pop(context);
                    final images = await _pickImages(ImageSource.camera);
                    if (images.isNotEmpty) onImagesPicked(images);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Internal method to pick images
  Future<List<XFile>> _pickImages(final ImageSource source) async {
    if (source == ImageSource.camera) {
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) return [image];
      return [];
    } else {
      final images = await _picker.pickMultiImage();
      return images;
    }
  }
}
