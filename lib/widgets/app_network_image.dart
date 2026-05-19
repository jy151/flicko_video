import 'package:cached_network_image/cached_network_image.dart';
import 'package:flicko_video/i18n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final Color placeholderColor;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.errorWidget,
    this.placeholderColor = const Color(0xFF2A2A4A),
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        final progress = (downloadProgress.progress ?? 0) * 100;
        return Container(
          width: width,
          height: height,
          color: placeholderColor,
          alignment: Alignment.center,
          child: SizedBox(
            width: 36,
            height: 36,
            child: CupertinoActivityIndicator()
          ),
        ); 
      },
      errorWidget: (context, url, error) {
        if (errorWidget != null) {
          return errorWidget!;
        }

        return Container(
          width: width,
          height: height,
          color: placeholderColor,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.broken_image_outlined,
                color: Colors.white54,
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.loadFailed,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }
}
