import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/constants/app_colors.dart';
import 'app_logo.dart';
import 'modern_snackbar.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  const AppLogo(size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connecting Dots',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Campus Super App',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _Item(
                    icon: LucideIcons.home,
                    label: 'Home',
                    onTap: () => context.go('/'),
                  ),
                  _Item(
                    icon: LucideIcons.utensils,
                    label: 'Food & Delivery',
                    onTap: () => context.go('/food'),
                  ),
                  _Item(
                    icon: LucideIcons.calendarDays,
                    label: 'Upcoming Events',
                    onTap: () => context.go('/events'),
                  ),
                  _Item(
                    icon: LucideIcons.mic,
                    label: 'Podcasts',
                    onTap: () => context.go('/podcasts'),
                  ),
                  _Item(
                    icon: LucideIcons.receipt,
                    label: 'Orders',
                    onTap: () => context.go('/orders'),
                  ),
                  _Item(
                    icon: LucideIcons.award,
                    label: 'Rewards',
                    onTap: () => context.go('/rewards'),
                  ),
                  _Item(
                    icon: LucideIcons.briefcase,
                    label: 'Jobs',
                    onTap: () => context.go('/jobs'),
                  ),
                  _Item(
                    icon: LucideIcons.fileText,
                    label: 'Blogs',
                    onTap: () => context.go('/blogs'),
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  _Item(
                    icon: LucideIcons.logOut,
                    label: 'Logout',
                    danger: true,
                    onTap: () {
                      context.go('/splash');
                      ModernSnackBar.info(context, 'Logged out successfully');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final fg = danger ? AppColors.danger : AppColors.textPrimary;

    return ListTile(
      leading: Icon(icon, color: fg),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }
}
