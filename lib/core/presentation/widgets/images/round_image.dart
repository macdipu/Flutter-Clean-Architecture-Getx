import 'package:any_image_view/any_image_view.dart';
import 'package:flutter/material.dart';
import '../../theme/theme_extensions.dart';

/// for any image type. All image rendering is delegated to AnyImageView.
class CRoundImage extends StatelessWidget {
  const CRoundImage({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.border,
    this.backgroundColor,
    this.radius,
    this.fit,
    this.onTap,
    this.alignment,
    this.boxShadow,
    this.shape = BoxShape.rectangle,
    this.placeholderWidget,
    this.errorWidget,
    this.enableZoom = false,
    this.elevated = false,
  });

  // Dimension properties
  final double? height;
  final double? width;

  // Spacing properties
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  // Styling properties
  final BoxBorder? border;
  final Color? backgroundColor;
  final double? radius;
  final Alignment? alignment;
  final List<BoxShadow>? boxShadow;
  final BoxShape shape;

  // Image source - can be String (asset/network/file), File, XFile, Uint8List
  final dynamic imagePath;

  // Image display properties
  final BoxFit? fit;

  // Error & placeholder handling
  final Widget? placeholderWidget;
  final Widget? errorWidget;

  // Interaction properties
  final Function()? onTap;
  final bool enableZoom;

  /// When true and [backgroundColor]/[boxShadow] aren't explicitly set,
  /// gives the image an opaque theme-aware surface backing with a soft
  /// elevation shadow (e.g. a product card thumbnail).
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? (elevated ? context.surface : null),
        borderRadius: _getBorderRadius(),
      ),
      child: _buildImageContent(context),
    );
  }

  /// Centralized method to build the image content
  /// This is the single point where you can modify image rendering behavior
  Widget _buildImageContent(BuildContext context) {
    return AnyImageView(
      key: ValueKey(imagePath),
      imagePath: imagePath,
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      fit: fit,
      alignment: alignment,
      borderRadius: _getBorderRadius(),
      placeholderWidget: placeholderWidget,
      errorWidget: errorWidget,
      enableZoom: enableZoom,
      shape: shape,
      border: border,
      boxShadow: boxShadow ??
          (elevated
              ? [
                  BoxShadow(
                    color: context.shadow.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null),
    );
  }

  /// Helper method to calculate border radius based on shape
  BorderRadius _getBorderRadius() {
    if (shape == BoxShape.circle) {
      return BorderRadius.circular(9999);
    }
    return BorderRadius.circular(radius ?? 0);
  }
}


/// Factory class for creating common image configurations
/// This makes it easy to maintain consistent image styles across your app
class CImageFactory {
  /// Creates a circular profile image
  static Widget profile({
    required dynamic imagePath,
    double size = 50,
    VoidCallback? onTap,
    String? errorPlaceHolder,
  }) {
    return CRoundImage(
      imagePath: imagePath,
      height: size,
      width: size,
      shape: BoxShape.circle,
      fit: BoxFit.cover,
      onTap: onTap,
      placeholderWidget: AnyImageView(imagePath: 'assets/images/default_avatar.png',) ,
    );
  }

  /// Creates a rounded card image
  static Widget card({
    required dynamic imagePath,
    double? height,
    double? width,
    double radius = 12,
    VoidCallback? onTap,
  }) {
    return CRoundImage(
      imagePath: imagePath,
      height: height,
      width: width,
      radius: radius,
      fit: BoxFit.cover,
      onTap: onTap,
    );
  }

  /// Creates a thumbnail image
  static Widget thumbnail({
    required dynamic imagePath,
    double size = 80,
    double radius = 8,
    VoidCallback? onTap,
  }) {
    return CRoundImage(
      imagePath: imagePath,
      height: size,
      width: size,
      radius: radius,
      fit: BoxFit.cover,
      onTap: onTap,
    );
  }

  /// Creates a banner image
  static Widget banner({
    required dynamic imagePath,
    double? height,
    double? width,
    VoidCallback? onTap,
  }) {
    return CRoundImage(
      imagePath: imagePath,
      height: height,
      width: width,
      fit: BoxFit.cover,
      onTap: onTap,
    );
  }

  /// Creates a product image with shadow
  static Widget product({
    required dynamic imagePath,
    double size = 120,
    double radius = 16,
    VoidCallback? onTap,
  }) {
    return CRoundImage(
      imagePath: imagePath,
      height: size,
      width: size,
      radius: radius,
      fit: BoxFit.contain,
      elevated: true,
      onTap: onTap,
    );
  }
}

/// Usage Examples:
///
/// // Basic usage
/// CRoundImage(
///   imagePath: 'https://example.com/image.jpg',
///   height: 100,
///   width: 100,
///   radius: 12,
/// )
///
/// // Using factory methods
/// CImageFactory.profile(
///   imagePath: userAvatar,
///   size: 50,
///   onTap: () => showProfile(),
/// )
///
/// // Circular image with border
/// CRoundImage(
///   imagePath: userPhoto,
///   height: 80,
///   width: 80,
///   shape: BoxShape.circle,
///   border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
/// )
///
/// // Simple image without styling
/// CImage(
///   imagePath: 'assets/images/banner.png',
///   height: 200,
///   fit: BoxFit.cover,
/// )