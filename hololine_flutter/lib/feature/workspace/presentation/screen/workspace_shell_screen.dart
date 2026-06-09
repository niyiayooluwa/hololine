import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkspaceShellScreen extends HookWidget {
  final Widget child;

  const WorkspaceShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location.endsWith('/ledger')) currentIndex = 1;
    if (location.endsWith('/catalog')) currentIndex = 2;
    if (location.endsWith('/inventory')) currentIndex = 3;
    if (location.endsWith('/analytics')) currentIndex = 4;
    if (location.endsWith('/ai')) currentIndex = 5;
    if (location.endsWith('/members')) currentIndex = 6;
    if (location.endsWith('/settings')) currentIndex = 7;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // From HTML body background
      body: Row(
        children: [
          // Nav Rail
          _Sidebar(
            currentIndex: currentIndex,
            onNavigate: (index) {
              final id = GoRouterState.of(context).pathParameters['id'];
              if (id == null) return;
              
              if (index == 0) context.go('/workspace/$id/dashboard');
              if (index == 1) context.go('/workspace/$id/ledger');
              if (index == 2) context.go('/workspace/$id/catalog');
              if (index == 3) context.go('/workspace/$id/inventory');
              if (index == 4) context.go('/workspace/$id/analytics');
              if (index == 5) context.go('/workspace/$id/ai');
              if (index == 6) context.go('/workspace/$id/members');
              if (index == 7) context.go('/workspace/$id/settings');
            },
          ),
          // Main Content
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const _Sidebar({
    required this.currentIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      width: 260.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: theme.colorScheme.border),
        ),
      ),
      child: Column(
        children: [
          // Top Header (Workspace Selector)
          const _WorkspaceSelector(),
          
          // Scrollable Navigation Menu
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CORE SECTION
                  const _SectionTitle(title: 'Core'),
                  _NavItem(
                    icon: LucideIcons.layoutDashboard,
                    label: 'Dashboard',
                    isActive: currentIndex == 0,
                    onTap: () => onNavigate(0),
                  ),
                  _NavItem(
                    icon: LucideIcons.bookOpen,
                    label: 'Ledger',
                    isActive: currentIndex == 1,
                    onTap: () => onNavigate(1),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // OPERATIONS SECTION
                  const _SectionTitle(title: 'Operations'),
                  _NavItem(
                    icon: LucideIcons.package,
                    label: 'Catalog',
                    isActive: currentIndex == 2,
                    onTap: () => onNavigate(2),
                  ),
                  _NavItem(
                    icon: LucideIcons.boxes,
                    label: 'Inventory',
                    isActive: currentIndex == 3,
                    onTap: () => onNavigate(3),
                  ),

                  const SizedBox(height: 24),

                  // INSIGHTS SECTION
                  const _SectionTitle(title: 'Insights'),
                  _NavItem(
                    icon: Icons.bar_chart_rounded,
                    label: 'Analytics',
                    isActive: currentIndex == 4,
                    onTap: () => onNavigate(4),
                  ),
                  _NavItem(
                    icon: LucideIcons.sparkles,
                    label: 'AI Reporting',
                    isActive: currentIndex == 5,
                    onTap: () => onNavigate(5),
                  ),

                  const SizedBox(height: 24),

                  // WORKSPACE SECTION
                  const _SectionTitle(title: 'Workspace'),
                  _NavItem(
                    icon: LucideIcons.users,
                    label: 'Members',
                    isActive: currentIndex == 6,
                    onTap: () => onNavigate(6),
                    badgeCount: 4,
                  ),
                  _NavItem(
                    icon: LucideIcons.settings,
                    label: 'Settings',
                    isActive: currentIndex == 7,
                    onTap: () => onNavigate(7),
                  ),
                  _NavItem(
                    icon: LucideIcons.logOut,
                    label: 'Logout',
                    isActive: false,
                    onTap: () {
                      // TODO: Implement logout logic via SessionManager
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom PLG Hook / Promo Card
          const _PromoCard(),
        ],
      ),
    );
  }
}

class _WorkspaceSelector extends StatelessWidget {
  const _WorkspaceSelector();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.border)),
      ),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // TODO: Open workspace switcher
            },
            borderRadius: BorderRadius.circular(8),
            hoverColor: theme.colorScheme.muted.withValues(alpha: 0.5),
            splashColor: theme.colorScheme.muted,
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.foreground,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        )
                      ]
                    ),
                    child: Icon(LucideIcons.layers, size: 16, color: theme.colorScheme.background),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Acme Corp',
                          style: theme.textTheme.small.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Pro Plan',
                          style: theme.textTheme.small.copyWith(
                            fontSize: 11,
                            color: theme.colorScheme.mutedForeground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    LucideIcons.chevronsUpDown, 
                    size: 16, 
                    color: theme.colorScheme.mutedForeground,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: ShadTheme.of(context).textTheme.small.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: ShadTheme.of(context).colorScheme.mutedForeground,
        ),
      ),
    );
  }
}

class _NavItem extends HookWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int? badgeCount;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isHovered = useState(false);

    Color getIconColor() {
      if (isActive) return theme.colorScheme.foreground;
      if (isHovered.value) return theme.colorScheme.foreground;
      return theme.colorScheme.mutedForeground;
    }

    Color getTextColor() {
      if (isActive) return theme.colorScheme.foreground;
      if (isHovered.value) return theme.colorScheme.foreground;
      return theme.colorScheme.mutedForeground;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isActive ? theme.colorScheme.muted : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          onHover: (val) => isHovered.value = val,
          borderRadius: BorderRadius.circular(8),
          hoverColor: theme.colorScheme.muted.withValues(alpha: 0.5),
          splashColor: theme.colorScheme.muted,
          highlightColor: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(icon, size: 18, color: getIconColor()),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: theme.textTheme.small.copyWith(
                          color: getTextColor(),
                          fontSize: 14,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (badgeCount != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.muted, // slate-100
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            )
                          ]
                        ),
                        child: Text(
                          badgeCount.toString(),
                          style: theme.textTheme.small.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF475569), // slate-600
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (isActive)
                Positioned(
                  left: -12, // Pulls it flush with the padding boundary (from HTML spec)
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 3,
                      height: 18,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.foreground,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoCard extends HookWidget {
  const _PromoCard();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isHovered = useState(false);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colorScheme.border)),
      ),
      child: MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) => isHovered.value = false,
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.muted.withValues(alpha: 0.5), // slate-50
            borderRadius: BorderRadius.circular(12), // rounded-xl
            border: Border.all(
              color: isHovered.value ? const Color(0xFFCBD5E1) : theme.colorScheme.border, // hover:border-slate-300
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Decorative background flare
              Positioned(
                right: -16,
                top: -16,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isHovered.value ? 1.0 : 0.5,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFEBDFFF), // hololine-light glow
                          blurRadius: 32,
                          spreadRadius: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seat Limit',
                        style: theme.textTheme.small.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.foreground,
                        ),
                      ),
                      Text(
                        '3/3',
                        style: theme.textTheme.small.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF8B5CF6), // hololine-dark
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Mock Progress Bar
                  Row(
                    children: [
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: theme.colorScheme.foreground, borderRadius: BorderRadius.circular(4)))),
                      const SizedBox(width: 4),
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: theme.colorScheme.foreground, borderRadius: BorderRadius.circular(4)))),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: const [
                              BoxShadow(color: Color(0x998B5CF6), blurRadius: 8, spreadRadius: 0)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: theme.colorScheme.border, borderRadius: BorderRadius.circular(4)))),
                      const SizedBox(width: 4),
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: theme.colorScheme.border, borderRadius: BorderRadius.circular(4)))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Unlock unlimited seats and advanced AI reporting.',
                    style: theme.textTheme.small.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.mutedForeground,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: theme.colorScheme.border),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
                      ]
                    ),
                    child: Text(
                      'Upgrade to Pro',
                      style: theme.textTheme.small.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155), // slate-700
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
