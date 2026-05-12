import 'package:flutter/material.dart';
import '../../theme/theme_extensions.dart';
import '../loading_view/loading_text.dart';

class CommonButton extends StatelessWidget {
  const CommonButton._({
    super.key,
    required this.title,
    required this.variant,
    this.onTap,
    this.height = 48,
    this.width,
    this.padding,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.foregroundColor,
    this.loaderColor,
    this.leading,
    this.trailing,
    this.borderRadius = 12,
    this.elevation = 2,
    this.isLoading = false,
    this.isExpanded = true,
    this.disabled = false,
  });

  // =========================
  // Filled
  // =========================

  factory CommonButton.filled({
    Key? key,
    required String title,
    VoidCallback? onTap,
    Color? backgroundColor,
    Color? borderColor,
    Color? foregroundColor,
    double? width,
    double height = 48,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    bool isLoading = false,
    bool isExpanded = true,
    bool disabled = false,
    Color? loaderColor,
    Widget? leading,
    Widget? trailing,
    double borderRadius = 8,
  }) {
    return CommonButton._(
      key: key,
      title: title,
      variant: _ButtonVariant.filled,
      onTap: onTap,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      foregroundColor: foregroundColor,
      width: width,
      height: height,
      padding: padding,
      textStyle: textStyle,
      isLoading: isLoading,
      isExpanded: isExpanded,
      disabled: disabled,
      loaderColor: loaderColor,
      leading: leading,
      trailing: trailing,
      borderRadius: borderRadius,
    );
  }

  // =========================
  // Elevated
  // =========================

  factory CommonButton.elevated({
    Key? key,
    required String title,
    VoidCallback? onTap,
    Color? backgroundColor,
    Color? borderColor,
    Color? foregroundColor,
    double? width,
    double height = 48,
    double elevation = 2,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    bool isLoading = false,
    bool isExpanded = true,
    bool disabled = false,
    Color? loaderColor,
    Widget? leading,
    Widget? trailing,
    double borderRadius = 8,
  }) {
    return CommonButton._(
      key: key,
      title: title,
      variant: _ButtonVariant.elevated,
      onTap: onTap,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      foregroundColor: foregroundColor,
      width: width,
      height: height,
      elevation: elevation,
      padding: padding,
      textStyle: textStyle,
      isLoading: isLoading,
      isExpanded: isExpanded,
      disabled: disabled,
      loaderColor: loaderColor,
      leading: leading,
      trailing: trailing,
      borderRadius: borderRadius,
    );
  }

  // =========================
  // Outlined
  // =========================

  factory CommonButton.outlined({
    Key? key,
    required String title,
    VoidCallback? onTap,
    Color? borderColor,
    Color? foregroundColor,
    double? width,
    double height = 48,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    bool isLoading = false,
    bool isExpanded = true,
    bool disabled = false,
    Color? loaderColor,
    Widget? leading,
    Widget? trailing,
    double borderRadius = 8,
  }) {
    return CommonButton._(
      key: key,
      title: title,
      variant: _ButtonVariant.outlined,
      onTap: onTap,
      borderColor: borderColor,
      foregroundColor: foregroundColor,
      width: width,
      height: height,
      padding: padding,
      textStyle: textStyle,
      isLoading: isLoading,
      isExpanded: isExpanded,
      disabled: disabled,
      loaderColor: loaderColor,
      leading: leading,
      trailing: trailing,
      borderRadius: borderRadius,
    );
  }

  // =========================
  // Text
  // =========================

  factory CommonButton.text({
    Key? key,
    required String title,
    VoidCallback? onTap,
    Color? foregroundColor,
    double? width,
    double height = 48,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    bool isLoading = false,
    bool isExpanded = false,
    bool disabled = false,
    Color? loaderColor,
    Widget? leading,
    Widget? trailing,
    double borderRadius = 8,
  }) {
    return CommonButton._(
      key: key,
      title: title,
      variant: _ButtonVariant.text,
      onTap: onTap,
      foregroundColor: foregroundColor,
      width: width,
      height: height,
      padding: padding,
      textStyle: textStyle,
      isLoading: isLoading,
      isExpanded: isExpanded,
      disabled: disabled,
      loaderColor: loaderColor,
      leading: leading,
      trailing: trailing,
      borderRadius: borderRadius,
    );
  }

  // =========================
  // Ghost
  // =========================

  factory CommonButton.ghost({
    Key? key,
    required String title,
    VoidCallback? onTap,
    Color? foregroundColor,
    double? width,
    double height = 48,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    bool isLoading = false,
    bool isExpanded = false,
    bool disabled = false,
    Color? loaderColor,
    Widget? leading,
    Widget? trailing,
    double borderRadius = 8,
  }) {
    return CommonButton._(
      key: key,
      title: title,
      variant: _ButtonVariant.ghost,
      onTap: onTap,
      foregroundColor: foregroundColor,
      width: width,
      height: height,
      padding: padding,
      textStyle: textStyle,
      isLoading: isLoading,
      isExpanded: isExpanded,
      disabled: disabled,
      loaderColor: loaderColor,
      leading: leading,
      trailing: trailing,
      borderRadius: borderRadius,
    );
  }

  // =========================
  // Fields
  // =========================

  final String title;
  final _ButtonVariant variant;
  final VoidCallback? onTap;

  final double height;
  final double? width;

  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? foregroundColor;
  final Color? loaderColor;

  final Widget? leading;
  final Widget? trailing;

  final double borderRadius;
  final double elevation;

  final bool isLoading;
  final bool isExpanded;
  final bool disabled;

  bool get _isDisabled => disabled || isLoading;

  bool get _isOutlined => variant == _ButtonVariant.outlined;

  bool get _isText =>
      variant == _ButtonVariant.text ||
          variant == _ButtonVariant.ghost;

  bool get _isElevated =>
      variant == _ButtonVariant.elevated;

  @override
  Widget build(BuildContext context) {
    final btnTheme = _resolveTheme(context);

    return SizedBox(
      width: isExpanded ? (width ?? double.infinity) : width,
      height: height,
      child: _buildButton(btnTheme),
    );
  }

  Widget _buildButton(_ButtonTheme theme) {
    final style = ButtonStyle(
      elevation: WidgetStatePropertyAll(
        _isElevated && !_isDisabled
            ? elevation
            : 0,
      ),
      backgroundColor: WidgetStatePropertyAll(
        theme.background,
      ),
      foregroundColor: WidgetStatePropertyAll(
        theme.foreground,
      ),
      padding: WidgetStatePropertyAll(
        padding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
      ),
      side: theme.border == null
          ? null
          : WidgetStatePropertyAll(
        BorderSide(color: theme.border!),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );

    final child = LoadingText(
      isLoading: isLoading,
      color: loaderColor,
      child: _ButtonContent(
        title: title,
        foregroundColor: theme.foreground,
        textStyle: textStyle,
        leading: leading,
        trailing: trailing,
      ),
    );

    final handler = _isDisabled ? null : onTap;

    if (_isOutlined) {
      return OutlinedButton(
        onPressed: handler,
        style: style,
        child: child,
      );
    }

    if (_isText) {
      return TextButton(
        onPressed: handler,
        style: style,
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: handler,
      style: style,
      child: child,
    );
  }

  _ButtonTheme _resolveTheme(BuildContext context) {
    if (_isDisabled) {
      return _ButtonTheme.disabled();
    }

    if (_isOutlined) {
      final color = borderColor ?? context.primaryColor;

      return _ButtonTheme(
        background: Colors.transparent,
        foreground: foregroundColor ?? color,
        border: color,
      );
    }

    if (_isText) {
      final base = context.primaryColor;
      return _ButtonTheme(
        background: Colors.transparent,
        foreground: foregroundColor ?? (_isGhost ? base.withAlpha(230) : base),
      );
    }

    return _ButtonTheme(
      background: backgroundColor ?? context.primaryColor,
      foreground: foregroundColor ?? context.onPrimary,
      border: borderColor,
    );
  }

  bool get _isGhost =>
      variant == _ButtonVariant.ghost;
}

enum _ButtonVariant {
  filled,
  elevated,
  outlined,
  text,
  ghost,
}

class _ButtonTheme {
  const _ButtonTheme({
    required this.background,
    required this.foreground,
    this.border,
  });

  factory _ButtonTheme.disabled() {
    return _ButtonTheme(
      background: Colors.grey.shade300,
      foreground: Colors.grey.shade600,
      border: Colors.grey.shade300,
    );
  }

  final Color background;
  final Color foreground;
  final Color? border;
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.title,
    required this.foregroundColor,
    this.textStyle,
    this.leading,
    this.trailing,
  });

  final String title;
  final Color foregroundColor;
  final TextStyle? textStyle;

  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: leading,
          ),

        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style:
            textStyle ??
                TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
          ),
        ),

        if (trailing != null)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: trailing,
          ),
      ],
    );
  }
}
