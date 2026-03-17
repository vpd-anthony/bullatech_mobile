import 'dart:io';

import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePreviewRow extends StatelessWidget {
  final List<XFile> images;

  const ImagePreviewRow({
    super.key,
    required this.images,
  });

  @override
  Widget build(final BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Text(
          'Image Preview:',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // ✅ Two images per row
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1, // square
          ),
          itemBuilder: (final context, final index) {
            return GestureDetector(
              onTap: () => _openImagePreview(context, images[index]),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(images[index].path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: InkWell(
                      onTap: () => _openImagePreview(context, images[index]),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
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
