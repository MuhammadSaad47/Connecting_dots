import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/constants/app_colors.dart';

class AppAssetImage extends StatelessWidget {
  const AppAssetImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.cacheHeight,
  });

  final String assetPath;
  final BoxFit fit;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    Widget placeholder({bool error = false}) {
      return Container(
        color: AppColors.navyLight,
        child: Center(
          child: Icon(
            error ? LucideIcons.imageOff : LucideIcons.image,
            color: AppColors.navy,
            size: 34,
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        placeholder(),
        if (kIsWeb)
          Image.asset(
            assetPath,
            fit: fit,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) => placeholder(error: true),
            frameBuilder: (context, child, frame, wasSync) {
              if (wasSync || frame != null) return child;
              return const SizedBox.shrink();
            },
          )
        else
          Image(
            image: (cacheWidth != null || cacheHeight != null)
                ? ResizeImage(
                    AssetImage(assetPath),
                    width: cacheWidth,
                    height: cacheHeight,
                  )
                : AssetImage(assetPath),
            fit: fit,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) => placeholder(error: true),
            frameBuilder: (context, child, frame, wasSync) {
              if (wasSync || frame != null) return child;
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}
