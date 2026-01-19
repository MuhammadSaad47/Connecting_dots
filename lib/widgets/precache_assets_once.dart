import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PrecacheAssetsOnce extends StatefulWidget {
  const PrecacheAssetsOnce({
    super.key,
    required this.assetPaths,
    required this.child,
    this.cacheWidth,
    this.cacheHeight,
  });

  final List<String> assetPaths;
  final Widget child;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  State<PrecacheAssetsOnce> createState() => _PrecacheAssetsOnceState();
}

class _PrecacheAssetsOnceState extends State<PrecacheAssetsOnce> {
  bool _done = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_done) return;
    _done = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final p in widget.assetPaths) {
        final ImageProvider<Object> provider;
        if (kIsWeb) {
          provider = AssetImage(p);
        } else {
          provider = (widget.cacheWidth != null || widget.cacheHeight != null)
              ? ResizeImage(
                  AssetImage(p),
                  width: widget.cacheWidth,
                  height: widget.cacheHeight,
                )
              : AssetImage(p);
        }
        precacheImage(provider, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
