import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkspaceCardSkeleton extends StatelessWidget {
  const WorkspaceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    
    return ShadCard(
      backgroundColor: theme.colorScheme.background,
      radius: BorderRadius.circular(12),
      border: ShadBorder.all(color: theme.colorScheme.border),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title skeleton
              _buildSkeleton(width: 140, height: 20),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Role Badge skeleton
                  _buildSkeleton(width: 70, height: 24, borderRadius: 12),
                  const SizedBox(width: 6),
                  // Ellipsis icon skeleton
                  _buildSkeleton(width: 28, height: 28, borderRadius: 6),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description lines skeleton
          _buildSkeleton(width: double.infinity, height: 14),
          const SizedBox(height: 8),
          _buildSkeleton(width: 180, height: 14),
          const SizedBox(height: 16),
          // Member count skeleton
          _buildSkeleton(width: 80, height: 12),
        ],
      ),
    );
  }

  Widget _buildSkeleton({
    required double width,
    required double height,
    double borderRadius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Slate 100
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
