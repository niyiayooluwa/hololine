// ==================== CUSTOM WIDGETS ====================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hololine_flutter/ui/core/ui/theme/theme.dart';

/// Elevated card with consistent styling
class HLCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final bool elevated;

  const HLCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: elevated ? theme.elevation2 : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: card,
      );
    }

    return card;
  }
}

/// Status badge for transactions, workspaces, etc.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool small;

  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.small = false,
  });

  factory StatusBadge.success(String label, {bool small = false}) {
    return StatusBadge(
      label: label,
      backgroundColor: const Color(0xFFD1FAE5),
      textColor: const Color(0xFF065F46),
      small: small,
    );
  }

  factory StatusBadge.error(String label, {bool small = false}) {
    return StatusBadge(
      label: label,
      backgroundColor: const Color(0xFFFEE2E2),
      textColor: const Color(0xFF991B1B),
      small: small,
    );
  }

  factory StatusBadge.warning(String label, {bool small = false}) {
    return StatusBadge(
      label: label,
      backgroundColor: const Color(0xFFFEF3C7),
      textColor: const Color(0xFF92400E),
      small: small,
    );
  }

  factory StatusBadge.info(String label, {bool small = false}) {
    return StatusBadge(
      label: label,
      backgroundColor: const Color(0xFFDCEAFE),
      textColor: const Color(0xFF1E40AF),
      small: small,
    );
  }

  factory StatusBadge.premium(String label, {bool small = false}) {
    return StatusBadge(
      label: label,
      backgroundColor: const Color(0xFFF5F3FF),
      textColor: const Color(0xFF5B21B6),
      small: small,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 12,
        vertical: small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(small ? 6 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: small ? 12 : 14,
              color: textColor ?? theme.colorScheme.onSurface,
            ),
            SizedBox(width: small ? 4 : 6),
          ],
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: small ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: textColor ?? theme.colorScheme.onSurface,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state widget with consistent styling
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading indicator with consistent styling
class HLLoadingIndicator extends StatelessWidget {
  final String? message;
  final bool small;

  const HLLoadingIndicator({
    super.key,
    this.message,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: small ? 24 : 40,
            height: small ? 24 : 40,
            child: const CircularProgressIndicator(strokeWidth: 3),
          ),
          if (message != null) ...[
            SizedBox(height: small ? 12 : 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
