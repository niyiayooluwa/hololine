import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/core/application/providers.dart';
//import 'package:hololine_flutter/feature/workspace/presentation/widget/global_nav_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AccountSettingsScreen extends HookConsumerWidget {
  final String activeTab;

  const AccountSettingsScreen({
    super.key,
    required this.activeTab,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    
    // Fetch the real user from the session
    final session = ref.watch(sessionProvider);
    final user = session.signedInUser;

    // Form controllers initialized with real user data
    final nameController = useTextEditingController(text: user?.userName ?? '');
    final emailController = useTextEditingController(text: user?.email ?? '');

    // Tab state linked to navigation bar callback
    final currentTab = activeTab == 'billing' ? 'billing' : 'profile';

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      //appBar: const GlobalNavBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1024),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back to Dashboard link
                GestureDetector(
                  onTap: () => context.go('/workspaces'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.arrowLeft,
                        size: 14,
                        color: theme.colorScheme.mutedForeground,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Back to Dashboard',
                        style: theme.textTheme.small.copyWith(
                          color: theme.colorScheme.mutedForeground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Screen Title
                Text(
                  'Account Settings',
                  style: theme.textTheme.h2.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                // Responsive Layout: Sidebar + Form Content
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 640;
                    
                    final sidebar = Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SidebarButton(
                          icon: LucideIcons.user,
                          label: 'Profile Settings',
                          isActive: currentTab == 'profile',
                          onTap: () => context.go('/settings?tab=profile'),
                        ),
                        const SizedBox(height: 4),
                        _SidebarButton(
                          icon: LucideIcons.creditCard,
                          label: 'Billing & Subscriptions',
                          isActive: currentTab == 'billing',
                          onTap: () => context.go('/settings?tab=billing'),
                        ),
                      ],
                    );

                    final content = currentTab == 'profile'
                        ? _buildProfileTab(context, theme, nameController, emailController, user)
                        : _buildBillingTab(context, theme);

                    if (isDesktop) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 240, child: sidebar),
                          const SizedBox(width: 48),
                          Expanded(child: content),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          sidebar,
                          const SizedBox(height: 32),
                          content,
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- PROFILE TAB ---
  Widget _buildProfileTab(
    BuildContext context,
    ShadThemeData theme,
    TextEditingController nameController,
    TextEditingController emailController,
    dynamic user,
  ) {
    // Force DiceBear avatar (Serverpod auto-generates default imageUrls that we want to override)
    final avatarUrl = 'https://api.dicebear.com/10.x/glyphs/png?seed=${Uri.encodeComponent(user?.userName ?? 'User')}';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: theme.textTheme.large.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),

          // Avatar Row
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.muted,
                  border: Border.all(color: theme.colorScheme.border, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(avatarUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ShadButton.outline(
                        onPressed: () {
                          ShadToaster.of(context).show(
                            const ShadToast(description: Text('Avatar uploads are disabled in development.')),
                          );
                        },
                        child: const Text('Change Avatar'),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          ShadToaster.of(context).show(
                            const ShadToast(description: Text('Avatar removed.')),
                          );
                        },
                        child: Text(
                          'Remove',
                          style: theme.textTheme.small.copyWith(
                            color: theme.colorScheme.destructive,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'JPG, GIF or PNG. 1MB max.',
                    style: theme.textTheme.muted.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Fields
          ShadInputFormField(
            id: 'full_name',
            controller: nameController,
            label: const Text('Full Name'),
          ),
          const SizedBox(height: 20),
          ShadInputFormField(
            id: 'email_address',
            controller: emailController,
            label: const Text('Email Address'),
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 32),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Save Button
          Align(
            alignment: Alignment.centerRight,
            child: ShadButton(
              onPressed: () {
                ShadToaster.of(context).show(
                  const ShadToast(
                    title: Text('Success'),
                    description: Text('Profile updated successfully'),
                  ),
                );
              },
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  // --- BILLING TAB ---
  Widget _buildBillingTab(BuildContext context, ShadThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tab Headers
        Text(
          'Workspace Subscriptions',
          style: theme.textTheme.large.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage billing and plans for the workspaces you own.',
          style: theme.textTheme.muted.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 24),

        // Workspace Subscription Detail Card (Acme Corp)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Badge row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Acme Corp Ledger',
                                style: theme.textTheme.h4.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.muted,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Starter (Free)',
                                style: theme.textTheme.small.copyWith(
                                  color: theme.colorScheme.mutedForeground,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your primary headquarters ledger.',
                          style: theme.textTheme.muted.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Price Tag
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$0',
                        style: theme.textTheme.h1.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/mo',
                        style: theme.textTheme.muted.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Seat Limit Section (Free plan has 3 seats cap)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seat Usage',
                        style: theme.textTheme.small.copyWith(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '3 / 3 free seats reached',
                        style: theme.textTheme.small.copyWith(
                          color: theme.colorScheme.destructive,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Red Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: Container(
                      height: 8,
                      width: double.infinity,
                      color: theme.colorScheme.muted,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 1.0, // 3/3 = 100%
                        child: Container(color: theme.colorScheme.destructive),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You cannot invite more members to this workspace on the Free plan.',
                    style: theme.textTheme.muted.copyWith(fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 20),

              // Upgrade Button and Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pro Plan: \$15 / seat / month.',
                    style: theme.textTheme.small.copyWith(color: theme.colorScheme.mutedForeground),
                  ),
                  ShadButton(
                    onPressed: () {
                      ShadToaster.of(context).show(
                        const ShadToast(
                          description: Text('Routing to Stripe Checkout for Acme Corp...'),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.zap, size: 14),
                        SizedBox(width: 8),
                        Text('Upgrade Acme Corp'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Add Workspace CTA (Workspace limit of 1 on Free plan)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.muted.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.border, style: BorderStyle.solid),
          ),
          child: LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth > 500;
              final textContent = Expanded(
                flex: isWide ? 3 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need another independent workspace?',
                      style: theme.textTheme.large.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'The free tier is limited to 1 parent workspace. Upgrade to Pro to unlock unlimited parent workspaces.',
                      style: theme.textTheme.muted.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              );

              final actionBtn = ShadButton.outline(
                backgroundColor: theme.colorScheme.background,
                onPressed: () {
                  ShadToaster.of(context).show(
                    const ShadToast(description: Text('Upgrade required to create a new workspace.')),
                  );
                },
                child: const Text('Unlock Workspaces'),
              );

              if (isWide) {
                return Row(
                  children: [
                    textContent,
                    const SizedBox(width: 24),
                    actionBtn,
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    textContent,
                    const SizedBox(height: 16),
                    actionBtn,
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _SidebarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.muted : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? theme.colorScheme.foreground : theme.colorScheme.mutedForeground,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: theme.textTheme.small.copyWith(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? theme.colorScheme.foreground : theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
