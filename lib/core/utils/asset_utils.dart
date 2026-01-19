import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Returns a widget that reliably loads an asset on web and mobile.
/// On web, we use Image.asset with cacheWidth/Height.
/// On mobile, we use ResizeImage for efficient decoding.
Widget safeAssetImage({
  required String assetPath,
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  int? cacheWidth,
  int? cacheHeight,
  Widget? placeholder,
  Widget? errorWidget,
}) {
  final Widget defaultPlaceholder = placeholder ??
      Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.image, color: Colors.grey, size: 34),
        ),
      );

  final Widget defaultError = errorWidget ??
      Container(
        color: Colors.grey.shade300,
        child: const Center(
          child: Icon(Icons.broken_image, color: Colors.grey, size: 34),
        ),
      );

  final imageWidget = kIsWeb
      ? Image.asset(
          assetPath,
          fit: fit,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          errorBuilder: (context, error, stackTrace) => defaultError,
          frameBuilder: (context, child, frame, wasSync) {
            if (wasSync || frame != null) return child;
            return defaultPlaceholder;
          },
        )
      : Image(
          image: (cacheWidth != null || cacheHeight != null)
              ? ResizeImage(AssetImage(assetPath), width: cacheWidth, height: cacheHeight)
              : AssetImage(assetPath),
          fit: fit,
          errorBuilder: (context, error, stackTrace) => defaultError,
          frameBuilder: (context, child, frame, wasSync) {
            if (wasSync || frame != null) return child;
            return defaultPlaceholder;
          },
        );

  // Wrap with SizedBox if width or height is specified
  if (width != null || height != null) {
    return SizedBox(
      width: width,
      height: height,
      child: imageWidget,
    );
  }

  return imageWidget;
}
