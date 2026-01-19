import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/clock_provider.dart';
import '../../data/mock_data.dart';
import '../../widgets/app_asset_image.dart';
import '../../widgets/app_card.dart';
import '../../widgets/precache_assets_once.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowAsync = ref.watch(clockProvider);

    return nowAsync.when(
      data: (now) {
        final items = MockData.upcomingEvents
            .map((e) => e.rollForward(now))
            .toList()
          ..sort((a, b) => a.startAt.compareTo(b.startAt));

        final assets = items.map((e) => e.thumbnailAsset).toList(growable: false);

        return PrecacheAssetsOnce(
          assetPaths: assets,
          cacheWidth: 240,
          cacheHeight: 240,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Upcoming Events'),
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
            body: ListView.separated(
              cacheExtent: 1200,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final e = items[index];
                return AppCard(
                  backgroundColor: AppColors.navyLight.withValues(alpha: 0.45),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: AppAssetImage(
                            assetPath: e.thumbnailAsset,
                            cacheWidth: 200,
                            cacheHeight: 200,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              e.subtitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _Pill(
                                  icon: LucideIcons.clock,
                                  text: _formatTimeRange(e.startAt, e.endAt),
                                ),
                                _Pill(
                                  icon: LucideIcons.mapPin,
                                  text: e.location,
                                ),
                                _Pill(
                                  icon: LucideIcons.timer,
                                  text: _startsInText(now, e.startAt),
                                  highlight: true,
                                ),
                              ],
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
        );
      },
      error: (e, st) => Center(
        child: Text(
          'Failed to load events',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textMuted),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    final df = DateFormat('EEE, d MMM');
    final tf = DateFormat('h:mm a');
    return '${df.format(start)} • ${tf.format(start)} - ${tf.format(end)}';
  }

  String _startsInText(DateTime now, DateTime start) {
    final diff = start.difference(now);
    if (diff.isNegative) return 'Live / Passed';

    final mins = diff.inMinutes;
    if (mins < 60) return 'Starts in ${mins}m';

    final hours = diff.inHours;
    if (hours < 24) return 'Starts in ${hours}h';

    final days = diff.inDays;
    return 'Starts in ${days}d';
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.text,
    this.highlight = false,
  });

  final IconData icon;
  final String text;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final bg = highlight
        ? AppColors.navy.withValues(alpha: 0.10)
        : AppColors.card2;
    final border = highlight
        ? AppColors.navy.withValues(alpha: 0.35)
        : AppColors.border;
    final fg = highlight ? AppColors.navy : AppColors.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: fg, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
