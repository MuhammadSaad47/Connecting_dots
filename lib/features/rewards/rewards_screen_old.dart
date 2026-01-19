import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_colors.dart';
import '../../data/mock_data.dart';
import '../../widgets/app_card.dart';
import '../../widgets/primary_button.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  double attendanceProgress = 1.0;
  bool confetti = false;

  @override
  Widget build(BuildContext context) {
    final canClaim = attendanceProgress >= 1.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance',
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
                          'Keep it up!',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Reach 100% to claim your reward.',
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
              'Available Rewards',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: MockData.rewards.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final r = MockData.rewards[index];
                  return AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.navy.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.navy.withValues(alpha: 0.35),
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.award,
                            color: AppColors.navy,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${r.tier} • ${r.benefit}',
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
