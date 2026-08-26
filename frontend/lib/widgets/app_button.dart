import 'package:flutter/material.dart';

enum ButtonVariant {
  primary,
  secondary,
  outlined,
  danger,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor;
    Color foregroundColor;
    Color borderColor = Colors.transparent;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = theme.colorScheme.primary;
        foregroundColor = theme.colorScheme.onPrimary;
        break;
      case ButtonVariant.secondary:
        backgroundColor = theme.colorScheme.secondary;
        foregroundColor = theme.colorScheme.onSecondary;
        break;
      case ButtonVariant.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary;
        break;
      case ButtonVariant.danger:
        backgroundColor = theme.colorScheme.error;
        foregroundColor = theme.colorScheme.onError;
        break;
    }

    double horizontalPadding;
    double verticalPadding;
    double fontSize;

    switch (size) {
      case ButtonSize.small:
        horizontalPadding = 12;
        verticalPadding = 6;
        fontSize = 12;
        break;
      case ButtonSize.medium:
        horizontalPadding = 16;
        verticalPadding = 10;
        fontSize = 14;
        break;
      case ButtonSize.large:
        horizontalPadding = 24;
        verticalPadding = 14;
        fontSize = 16;
        break;
    }

    // 🔥 CORREGIDO: Usamos un contenedor con width fijo o flexible según isFullWidth
    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: borderColor != Colors.transparent
            ? BorderSide(color: borderColor)
            : null,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        // 🔥 IMPORTANTE: No usar minimumSize con infinity cuando está en Row
        minimumSize: isFullWidth ? const Size(double.infinity, 0) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: variant == ButtonVariant.outlined ? 0 : 2,
      ),
      child: isLoading
          ? SizedBox(
              height: fontSize + 4,
              width: fontSize + 4,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foregroundColor,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: fontSize + 4),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );

    // 🔥 Si es fullWidth, usar SizedBox con width infinito pero con constraints adecuados
    if (isFullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}