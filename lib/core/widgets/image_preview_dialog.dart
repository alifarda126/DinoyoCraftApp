import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_text.dart';

/// Dialog penampil foto / gambar full-screen dengan dukungan zoom & pan interaktif (InteractiveViewer).
///
/// Fitur:
/// - Foto memenuhi lebar layar penuh dari ujung kiri ke kanan (edge-to-edge).
/// - Zoom bebas ke seluruh layar tanpa batasan boundary area (boundaryMargin infinity).
/// - Dukungan double-tap untuk zoom cepat & reset.
/// - Pinch-to-zoom hingga 6x & pan bebas ke segala arah.
class ImagePreviewDialog extends StatefulWidget {
  const ImagePreviewDialog({
    super.key,
    this.title,
    this.subtitle,
    this.bytes,
    this.filePath,
    this.assetPath,
    this.isAvatar = false,
  });

  final String? title;
  final String? subtitle;
  final Uint8List? bytes;
  final String? filePath;
  final String? assetPath;
  final bool isAvatar;

  static Future<void> show(
    BuildContext context, {
    String? title,
    String? subtitle,
    Uint8List? bytes,
    String? filePath,
    String? assetPath,
    bool isAvatar = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.96),
      builder: (_) => ImagePreviewDialog(
        title: title,
        subtitle: subtitle,
        bytes: bytes,
        filePath: filePath,
        assetPath: assetPath,
        isAvatar: isAvatar,
      ),
    );
  }

  @override
  State<ImagePreviewDialog> createState() => _ImagePreviewDialogState();
}

class _ImagePreviewDialogState extends State<ImagePreviewDialog> {
  final TransformationController _transformationController =
      TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (!_transformationController.value.isIdentity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails?.localPosition;
      if (position != null) {
        final matrix = Matrix4.identity()
          ..setEntry(0, 0, 2.5)
          ..setEntry(1, 1, 2.5)
          ..setEntry(0, 3, -position.dx * 1.5)
          ..setEntry(1, 3, -position.dy * 1.5);
        _transformationController.value = matrix;
      } else {
        final matrix = Matrix4.identity()
          ..setEntry(0, 0, 2.5)
          ..setEntry(1, 1, 2.5);
        _transformationController.value = matrix;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        widget.bytes != null ||
        (widget.filePath != null && widget.filePath!.isNotEmpty) ||
        (widget.assetPath != null && widget.assetPath!.isNotEmpty);

    final screenWidth = MediaQuery.sizeOf(context).width;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background hitam pekat penuh agar fokus total pada foto
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.96),
              ),
            ),

            // Area Zoom & Pan interaktif di seluruh layar tanpa batasan boundary
            Positioned.fill(
              child: hasImage
                  ? GestureDetector(
                      onDoubleTapDown: (details) => _doubleTapDetails = details,
                      onDoubleTap: _handleDoubleTap,
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        boundaryMargin: const EdgeInsets.all(double.infinity),
                        clipBehavior: Clip.none,
                        minScale: 0.8,
                        maxScale: 6.0,
                        panEnabled: true,
                        scaleEnabled: true,
                        child: Center(
                          child: _buildImage(context, screenWidth),
                        ),
                      ),
                    )
                  : Center(child: _buildAvatarPlaceholder()),
            ),

            // Header atas dengan gradasi halus agar judul & tombol close selalu jelas
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      if (widget.title != null)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.title!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              if (widget.subtitle != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  widget.subtitle!,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                      else
                        const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.22),
                          shape: const CircleBorder(),
                        ),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Petunjuk di bawah bila preview avatar profil
            if (widget.isAvatar)
              Positioned(
                bottom: MediaQuery.paddingOf(context).bottom + 24,
                left: 24,
                right: 24,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Text(
                      'Ubah foto profil melalui menu Kelola Data Diri'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, double screenWidth) {
    if (widget.isAvatar) {
      final double avatarSize = (screenWidth * 0.72).clamp(200.0, 320.0);
      return ClipOval(
        child: Container(
          width: avatarSize,
          height: avatarSize,
          color: Colors.white10,
          child: _rawImage(
            width: avatarSize,
            height: avatarSize,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Foto produk & foto ulasan: Memenuhi lebar layar secara penuh ke kanan & kiri (edge-to-edge)
    return SizedBox(
      width: screenWidth,
      child: _rawImage(
        width: screenWidth,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _rawImage({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
  }) {
    if (widget.bytes != null) {
      return Image.memory(
        widget.bytes!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _errorWidget(),
      );
    }
    if (widget.filePath != null) {
      return Image.file(
        File(widget.filePath!),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _errorWidget(),
      );
    }
    if (widget.assetPath != null) {
      return Image.asset(
        widget.assetPath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _errorWidget(),
      );
    }
    return _errorWidget();
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        size: 96,
        color: Colors.white70,
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.broken_image_rounded,
            size: 48,
            color: Colors.white60,
          ),
          const SizedBox(height: 12),
          Text(
            'Gagal memuat gambar'.tr,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
