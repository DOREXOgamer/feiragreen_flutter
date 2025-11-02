import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadiusGeometry? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  }) : assert(imageUrl != null || assetPath != null,
            'É necessário fornecer imageUrl ou assetPath');

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      imageWidget = Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child:
                const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
          );
        },
      );
    } else {
      imageWidget = Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child:
                const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
          );
        },
      );
    }

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius as BorderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
