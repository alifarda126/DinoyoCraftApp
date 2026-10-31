import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'dc_shimmer.dart';

/// Komponen gambar serbaguna yang otomatis membedakan URL jaringan (Remote),
/// Aset lokal (Assets), dan File lokal disk.
/// Mendukung disk caching otomatis dan skeleton shimmer placeholder.
class DcCachedImage extends StatelessWidget {
  const DcCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  bool get _isNetwork =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  bool get _isAsset => imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_isNetwork) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            DcShimmer.box(
              width: width ?? double.infinity,
              height: height ?? double.infinity,
              borderRadius: 0,
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: AppColors.surfaceSubtle,
              child: Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ),
            ),
      );
    } else if (_isAsset) {
      imageWidget = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: AppColors.surfaceSubtle,
              child: Center(
                child: Icon(
                  Icons.image_not_supported_rounded,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ),
            ),
      );
    } else {
      imageWidget = Image.file(
        File(imageUrl),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: AppColors.surfaceSubtle,
              child: Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ),
            ),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

