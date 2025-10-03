import 'package:carbon_it_images_search/presentation/widgets/image_item_params.dart';
import 'package:flutter/material.dart';

class ImageItem extends StatelessWidget {
  final ImageItemParams params;
  final Function() onImageActionPerformed;

  const ImageItem({super.key, required this.params, required this.onImageActionPerformed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () => onImageActionPerformed(),
      child: AspectRatio(
        aspectRatio: params.aspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                params.imageSource,
                fit: params.boxFit,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: Colors.black12),
                      const Center(
                        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                    ],
                  );
                },
                errorBuilder:
                    (BuildContext context, Object error, StackTrace? stackTrace) => Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 24),
                    ),
                gaplessPlayback: true,
                semanticLabel: params.alt,
              ),
              Positioned(
                top: 16,
                right: 16,
                child: InkWell(
                  onTap: () => onImageActionPerformed(),
                  child:
                      (params.isFavorite)
                          ? Icon(Icons.bookmark, color: Colors.red)
                          : Icon(Icons.bookmark_add_outlined, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
