// Updated WorkspaceCard with memberCount
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/feature/workspace/presentation/shared/role_badge.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkspaceCard extends HookWidget {
  final String name;
  final WorkspaceRole role;
  final String description;
  final VoidCallback onClick;
  final int memberCount;

  const WorkspaceCard({
    super.key,
    required this.name,
    required this.role,
    required this.description,
    required this.onClick,
    this.memberCount = 4, // Default value for backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isCardHovered = useState(false);
    final isIconHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isCardHovered.value = true,
      onExit: (_) => isCardHovered.value = false,
      child: GestureDetector(
        onTap: onClick,
        child: ShadCard(
          backgroundColor: theme.colorScheme.background,
          radius: BorderRadius.circular(12),
          border: ShadBorder.all(color: theme.colorScheme.border),
          padding: const EdgeInsets.all(24),
          shadows: isCardHovered.value
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoleBadge(role: role),
                      const SizedBox(width: 6),
                      MouseRegion(
                        onEnter: (_) => isIconHovered.value = true,
                        onExit: (_) => isIconHovered.value = false,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isIconHovered.value
                                ? theme.colorScheme.border.withValues(alpha: .3)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: GestureDetector(
                            onTap: () {}, // Prevents card click
                            child: const Icon(LucideIcons.ellipsis, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(description, style: theme.textTheme.muted),
              const SizedBox(height: 16),
              Text(
                "$memberCount members",
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}