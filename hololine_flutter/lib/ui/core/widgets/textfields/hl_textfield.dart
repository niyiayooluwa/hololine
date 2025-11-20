import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class HoloTextField extends StatelessWidget {
  final String? label;
  final String? description;
  final String? error;

  final Widget? leading;
  final Widget? trailing;

  final TextEditingController? controller;
  final String? hint;
  final bool obscure;
  final String obscuringCharacter;
  final TextInputType keyboardType;

  final VoidCallback? onTrailingTap;

  const HoloTextField({
    super.key,
    this.label,
    this.description,
    this.error,
    this.leading,
    this.trailing,
    this.controller,
    this.hint,
    this.obscure = false,
    this.obscuringCharacter = '●',
    this.keyboardType = TextInputType.text,
    this.onTrailingTap,
  });

  bool get hasError => error != null && error!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// COLORS
    final borderColor =
        hasError ? theme.colorScheme.error : theme.colorScheme.outlineVariant;

    final bgColor = theme.colorScheme.surface;

    final textColor =
        hasError ? theme.colorScheme.error : theme.colorScheme.onSurface;

    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 250,
          maxWidth: 350,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LABEL
            if (label != null) ...[
              Text(
                label!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: hasError ? theme.colorScheme.error : textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
            ],

            /// DESCRIPTION
            if (description != null) ...[
              Text(
                description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
            ],

            /// TEXTFIELD CONTAINER
            TextField(
              controller: controller,
              obscureText: obscure,
              obscuringCharacter: obscuringCharacter,
              keyboardType: keyboardType,
              style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                prefixIcon: leading != null ? leading : null,
                suffixIcon: trailing != null
                    ? GestureDetector(
                        onTap: onTrailingTap,
                        child: trailing,
                      )
                    : null,
                isCollapsed: true,
                border: InputBorder.none,
              ),
            ),

            /// ERROR MESSAGE
            if (hasError) ...[
              const SizedBox(height: 6),
              Text(
                error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ));
  }
}

@Preview()
Widget preview() {
  return SizedBox(
    height: 500,
    width: 500,
    child: Container(
        decoration: BoxDecoration(color: Colors.blue),
        child: Center(
          child: HoloTextField(
            label: 'Login',
            hint: 'This is the hint text',
            leading: Icon(Icons.email_outlined, size: 16),
            trailing: Icon(Icons.lock_outline, size: 16),
          ),
        )),
  );
}
