import 'package:flutter/material.dart';

enum ButtonType { primary, plain, neutral }

class HoloButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;

  /// Optional UI states
  final bool loading;
  final bool error;

  const HoloButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = ButtonType.primary,
    this.loading = false,
    this.error = false,
  });

  bool get isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final disabled = isDisabled || loading;
    final theme = Theme.of(context);

    final bg = _backgroundColor(theme, disabled, error);
    final fg = _foregroundColor(theme, disabled, error);
    final border = _borderColor(theme, disabled, error);

    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        disabledBackgroundColor: _backgroundColor(theme, true, false),
        disabledForegroundColor: _foregroundColor(theme, true, false),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: border == null
              ? BorderSide.none
              : BorderSide(color: border, width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        elevation: type == ButtonType.primary ? 2 : 0,
        animationDuration: const Duration(milliseconds: 150),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading) ...[
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: fg,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(label, style: theme.textTheme.labelLarge?.copyWith(color: fg)),
        ],
      ),
    );
  }

  // ----------------------------
  //   STYLE MAPS
  // ----------------------------

  Color _backgroundColor(ThemeData theme, bool disabled, bool errorState) {
    if (disabled) return theme.colorScheme.surfaceContainerHighest;
    if (errorState) return theme.colorScheme.error.withValues(alpha: 0.1);

    return switch (type) {
      ButtonType.primary => theme.colorScheme.primary,
      ButtonType.plain => Colors.transparent,
      ButtonType.neutral => Colors.white,
    };
  }

  Color _foregroundColor(ThemeData theme, bool disabled, bool errorState) {
    if (disabled) return theme.colorScheme.onSurface.withValues(alpha: 0.4);
    if (errorState) return theme.colorScheme.error;

    return switch (type) {
      ButtonType.primary => theme.colorScheme.onPrimary,
      ButtonType.plain => theme.colorScheme.primary,
      ButtonType.neutral => Colors.black,
    };
  }

  Color? _borderColor(ThemeData theme, bool disabled, bool errorState) {
    if (type == ButtonType.neutral && !disabled && !errorState) {
      return theme.colorScheme.primary;
    }

    if (errorState && !disabled) {
      return theme.colorScheme.error;
    }

    return null;
  }
}
