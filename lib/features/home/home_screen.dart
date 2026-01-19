import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/app_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final aspect = w < 380 ? 0.7 : w < 600 ? 0.8 : 0.9;
    final subtitleLines = w < 380 ? 1 : 2;
    final padding = w < 380 ? 8.0 : 10.0;
    final crossAxisCount = w < 400 ? 2 : 2;

    final tiles = <_HomeTileData>[
      _HomeTileData(
        title: 'Food & Delivery',
        subtitle: 'Cafeteria menu + checkout',
        icon: LucideIcons.utensils,
        route: '/food',
        accent: AppColors.navy,
        backgroundAsset: 'assets/images/food_delivery.jpg',
      ),
      _HomeTileData(
        title: 'Jobs',
        subtitle: 'Campus gigs & freelance',
        icon: LucideIcons.briefcase,
        route: '/jobs',
        accent: AppColors.navySoft,
        backgroundAsset: 'assets/images/jobs.jpg',
      ),
      _HomeTileData(
        title: 'Upcoming Events',
        subtitle: 'Deadlines, campus meetups',
        icon: LucideIcons.calendarDays,
        route: '/events',
        accent: AppColors.accent,
        backgroundAsset: 'assets/images/upcoming_events.jpeg',
      ),
      _HomeTileData(
        title: 'Podcasts',
        subtitle: 'Scheduled episodes & talks',
        icon: LucideIcons.mic,
        route: '/podcasts',
        accent: AppColors.navyLight,
        backgroundAsset: 'assets/images/podcast.jpg',
      ),
      _HomeTileData(
        title: 'Rewards',
        subtitle: 'Attendance & perks',
        icon: LucideIcons.award,
        route: '/rewards',
        accent: AppColors.navyLight,
        backgroundAsset: 'assets/images/rewards.jpg',
      ),
      _HomeTileData(
        title: 'Blogs',
        subtitle: 'Student life & tips',
        icon: LucideIcons.fileText,
        route: '/blogs',
        accent: AppColors.navySoft,
        backgroundAsset: 'assets/images/blogs.jpg',
      ),
    ];

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(LucideIcons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: const AppLogo(size: 34, showWordmark: true),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.user),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: w < 380 ? 16 : null,
                  ),
            ),
            SizedBox(height: w < 380 ? 1 : 4),
            Text(
              'What would you like to do today?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                    fontSize: w < 380 ? 11 : null,
                  ),
            ),
            SizedBox(height: w < 380 ? 8 : 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: w < 380 ? 4 : 8,
                  mainAxisSpacing: w < 380 ? 4 : 8,
                  childAspectRatio: aspect,
                ),
                itemCount: tiles.length,
                itemBuilder: (context, index) {
                  final t = tiles[index];
                  return AppCard(
                    onTap: () => context.push(t.route),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background image
                        if (t.backgroundAsset != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              t.backgroundAsset!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: t.accent.withValues(alpha: 0.15),
                              ),
                            ),
                          ),
                        // Gradient overlay for readability
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.1),
                                Colors.black.withValues(alpha: 0.4),
                              ],
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: EdgeInsets.all(w < 380 ? 6 : padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(w < 380 ? 4 : 10),
                                ),
                                padding: EdgeInsets.all(w < 380 ? 2 : 6),
                                child: Icon(
                                  t.icon,
                                  color: t.accent,
                                  size: w < 380 ? 12 : 20,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              Text(
                                t.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: w < 380 ? 10 : null,
                                    ),
                              ),
                              SizedBox(height: w < 380 ? 0 : 2),
                              Text(
                                t.subtitle,
                                maxLines: subtitleLines,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: w < 380 ? 8 : null,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate(delay: (index * 100).ms)
                      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOut);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTileData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color accent;
  final String? backgroundAsset;

  const _HomeTileData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.accent,
    this.backgroundAsset,
  });
}
