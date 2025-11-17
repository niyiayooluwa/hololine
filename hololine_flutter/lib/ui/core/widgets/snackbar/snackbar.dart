import 'package:flutter/material.dart';
import 'package:hololine_flutter/ui/core/ui/theme/theme.dart';

enum ErrorType { success, info, warning, error }

class HoloSnackbar extends StatelessWidget {
  final ErrorType type;
  final String message;

  const HoloSnackbar({super.key, required this.type, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = switch (type) {
      ErrorType.success => theme.colorScheme.successLight,
      ErrorType.info => theme.colorScheme.infoLight,
      ErrorType.warning => theme.colorScheme.warningLight,
      ErrorType.error => theme.colorScheme.errorLight,
    };

    final foregroundColor = switch (type) {
      ErrorType.success => theme.colorScheme.success,
      ErrorType.info => theme.colorScheme.info,
      ErrorType.warning => theme.colorScheme.warning,
      ErrorType.error => theme.colorScheme.error,
    };

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 48, minWidth: 300),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: foregroundColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Icon(
                Icons.info_outline_rounded,
                color: foregroundColor,
                size: 16,
              ),
              SizedBox(width: 12),
              Text(
                message,
                style:
                    theme.textTheme.bodySmall?.copyWith(color: foregroundColor),
              )
            ]),
            Icon(
              Icons.cancel_outlined,
              color: foregroundColor,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
