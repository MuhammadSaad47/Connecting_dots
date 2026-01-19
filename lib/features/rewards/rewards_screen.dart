import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/asset_utils.dart';
import '../../data/mock_data.dart';
import '../../widgets/app_card.dart';
import '../../widgets/primary_button.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  double attendanceProgress = 0.73; // Mock: 73% this month
  bool confetti = false;

  @override
  Widget build(BuildContext context) {
    final canClaim = attendanceProgress >= 1.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () {
            if (Navigator.canPop(context)) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Attendance',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 86,
                    height: 86,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: attendanceProgress,
                          strokeWidth: 10,
                          backgroundColor: AppColors.border,
                          valueColor:
                              const AlwaysStoppedAnimation(AppColors.navy),
                        ),
                        Text(
                          '${(attendanceProgress * 100).round()}%',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          canClaim ? 'You can claim!' : 'Keep it up!',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          canClaim
                              ? 'Claim your monthly reward.'
                              : 'Reach 100% to claim your reward.',
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
            const SizedBox(height: 14),
            Stack(
              children: [
                PrimaryButton(
                  label: canClaim ? 'Claim Reward' : 'Claim Reward (Locked)',
                  icon: LucideIcons.gift,
                  onPressed: canClaim
                      ? () {
                          final messenger = ScaffoldMessenger.of(context);
                          setState(() {
                            confetti = true;
                          });

                          Future<void>.delayed(900.ms, () {
                            if (!mounted) return;
                            setState(() {
                              confetti = false;
                            });
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Reward claimed!'),
                              ),
                            );
                          });
                        }
                      : null,
                ),
                if (confetti)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: _ConfettiBurst(key: UniqueKey()),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Top Performers This Month',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: MockData.leaderboard.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final entry = MockData.leaderboard[index];
                  final rank = index + 1;
                  final isTop3 = rank <= 3;
                  return AppCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Rank badge
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isTop3
                                ? (rank == 1
                                    ? Colors.amber
                                    : rank == 2
                                        ? Colors.grey.shade400
                                        : Colors.brown.shade300)
                                : AppColors.navy.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '$rank',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: isTop3 ? Colors.white : AppColors.navy,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Avatar
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.navyLight.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '👤',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Name + achievement
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                entry.achievement,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        // Points
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${entry.points}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                        color: AppColors.navy,
                                        fontWeight: FontWeight.w900,
                                      ),
                            ),
                            Text(
                              'points',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiBurst extends StatelessWidget {
  const _ConfettiBurst({super.key});

  @override
  Widget build(BuildContext context) {
    final rand = math.Random();

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final pieces = List.generate(14, (i) {
          final dx = rand.nextDouble() * w;
          final size = 8 + rand.nextDouble() * 8;
          final color = i.isEven ? AppColors.navy : AppColors.success;

          return Positioned(
            left: dx,
            top: h * 0.25 + rand.nextDouble() * 10,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            )
                .animate()
                .slideY(begin: 0, end: 1.1, duration: 850.ms)
                .fadeOut(duration: 850.ms),
          );
        });

        return Stack(children: pieces);
      },
    );
  }
}
