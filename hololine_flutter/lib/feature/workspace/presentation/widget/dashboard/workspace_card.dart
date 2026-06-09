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
                    style: theme.textTheme.h4
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoleBadge(role: role),
                      const SizedBox(width: 6),
                      Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: PopupMenuButton<String>(
                          color: theme.colorScheme.background,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: theme.colorScheme.border),
                          ),
                          offset: const Offset(0, 8),
                          position: PopupMenuPosition.under,
                          onSelected: (value) {
                            if (value == 'settings') {
                              ShadToaster.of(context).show(const ShadToast(description: Text('Routing to Settings...')));
                            } else if (value == 'members') {
                              ShadToaster.of(context).show(const ShadToast(description: Text('Routing to Members...')));
                            } else if (value == 'leave') {
                              ShadToaster.of(context).show(const ShadToast(description: Text('Leaving Workspace...')));
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'settings',
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Icon(LucideIcons.settings, size: 16, color: theme.colorScheme.mutedForeground),
                                  const SizedBox(width: 8),
                                  Text('Settings', style: theme.textTheme.small.copyWith(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'members',
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Icon(LucideIcons.users, size: 16, color: theme.colorScheme.mutedForeground),
                                  const SizedBox(width: 8),
                                  Text('Members', style: theme.textTheme.small.copyWith(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(height: 1),
                            PopupMenuItem(
                              value: 'leave',
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Icon(LucideIcons.logOut, size: 16, color: theme.colorScheme.destructive),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Leave Workspace', 
                                    style: theme.textTheme.small.copyWith(
                                      color: theme.colorScheme.destructive, 
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          child: MouseRegion(
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
                              child: const Icon(LucideIcons.ellipsis, size: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Text(
                  description, 
                  style: theme.textTheme.muted,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AvatarStack(memberCount: memberCount),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: isCardHovered.value ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF8FAFC), // slate-50
                        border: Border.all(color: const Color(0xFFE2E8F0)), // slate-200
                      ),
                      child: const Icon(
                        LucideIcons.arrowRight,
                        size: 16,
                        color: Color(0xFF475569), // slate-600
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarStack extends StatelessWidget {
  final int memberCount;

  const AvatarStack({super.key, required this.memberCount});

  @override
  Widget build(BuildContext context) {
    if (memberCount <= 0) return const SizedBox.shrink();

    final int displayCount = memberCount > 3 ? 2 : memberCount;
    final bool showOverflow = memberCount > 3;

    return SizedBox(
      height: 32,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: i * 24.0, // 32 size, -8 overlap -> 24 step
              child: _buildAvatar(i),
            ),
          if (showOverflow)
            Positioned(
              left: displayCount * 24.0,
              child: _buildOverflowCircle(memberCount - 2, context),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(int index) {
    final seeds = ['Felix', 'Sarah', 'John'];
    final seed = seeds[index % seeds.length];
    final avatarUrl = 'https://api.dicebear.com/10.x/glyphs/png?seed=$seed';
    
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF1F5F9), // slate-100
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(
          image: NetworkImage(avatarUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildOverflowCircle(int overflowCount, BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE2E8F0), // slate-200
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '+$overflowCount',
        style: ShadTheme.of(context).textTheme.small.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF64748B), // slate-500
        ),
      ),
    );
  }
}