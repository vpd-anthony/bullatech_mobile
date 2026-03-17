import 'dart:io';

import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePreviewGrid extends StatelessWidget {
  final List<XFile> images;
  final void Function(int index) onRemove;
  final VoidCallback onAddImage; // callback to open image picker

  const ImagePreviewGrid({
    super.key,
    required this.images,
    required this.onRemove,
    required this.onAddImage,
  });

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: images.length + 1, // +1 for "Add" button
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (final context, final index) {
          // Add image button
          if (index == images.length) {
            return GestureDetector(
              onTap: onAddImage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                ),
              ),
            );
          }

          // Existing image preview
          return GestureDetector(
            onTap: () => _openImagePreview(context, images[index]),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(images[index].path),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: InkWell(
                    onTap: () => onRemove(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openImagePreview(final BuildContext context, final XFile image) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (final _, final __, final ___) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: Image.file(File(image.path)),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        color: AppColors.primaryDark,
                        iconSize: 24,
                        splashRadius: 22,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
