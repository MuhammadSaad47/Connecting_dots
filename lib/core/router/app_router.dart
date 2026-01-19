import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/food/food_screen.dart';
import '../../features/food/delivery_screen.dart';
import '../../features/rewards/rewards_screen.dart';
import '../../features/jobs/jobs_screen.dart';
import '../../features/blogs/blogs_screen.dart';
import '../../features/events/events_screen.dart';
import '../../features/podcasts/podcasts_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/orders/order_detail_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildAppRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/food',
        builder: (context, state) => const FoodScreen(),
      ),
      GoRoute(
        path: '/delivery',
        builder: (context, state) => const DeliveryScreen(),
      ),
      GoRoute(
        path: '/rewards',
        builder: (context, state) => const RewardsScreen(),
      ),
      GoRoute(
        path: '/jobs',
        builder: (context, state) => const JobsScreen(),
      ),
      GoRoute(
        path: '/blogs',
        builder: (context, state) => const BlogsScreen(),
      ),
      GoRoute(
        path: '/events',
        builder: (context, state) => const EventsScreen(),
      ),
      GoRoute(
        path: '/podcasts',
        builder: (context, state) => const PodcastsScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/orders/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null || id.isEmpty) return const OrdersScreen();
          return OrderDetailScreen(orderId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              'Oops! Page not found.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try going back.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    ),
  );
}
