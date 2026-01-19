import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/clock_provider.dart';
import '../../data/mock_data.dart';
import '../../widgets/app_asset_image.dart';
import '../../widgets/app_card.dart';
import '../../widgets/precache_assets_once.dart';

class PodcastsScreen extends ConsumerWidget {
  const PodcastsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowAsync = ref.watch(clockProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcasts'),
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
      body: nowAsync.when(
        data: (now) {
          final items = MockData.podcasts
              .map((p) => p.rollForward(now))
              .toList()
            ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

          final assets = <String>{
            for (final p in items) p.topicThumbnailAsset,
            for (final p in items) p.hostImageAsset,
          }.toList(growable: false);

          return PrecacheAssetsOnce(
            assetPaths: assets,
            cacheWidth: 256,
            cacheHeight: 256,
            child: ListView.separated(
              cacheExtent: 1200,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final p = items[index];
                return AppCard(
                  backgroundColor: AppColors.navyLight.withValues(alpha: 0.45),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: 84,
                          height: 84,
                          child: AppAssetImage(
                            assetPath: p.topicThumbnailAsset,
                            cacheWidth: 256,
                            cacheHeight: 256,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.topicTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                ClipOval(
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: AppAssetImage(
                                      assetPath: p.hostImageAsset,
                                      cacheWidth: 96,
                                      cacheHeight: 96,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${p.hostName} • ${p.guestName}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppColors.textMuted),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _Pill(
                                  icon: LucideIcons.calendarClock,
                                  text: _formatSchedule(p.scheduledAt),
                                  highlight: true,
                                ),
                                _Pill(
                                  icon: LucideIcons.timer,
                                  text: '${p.durationMinutes} min',
                                ),
                                _Pill(
                                  icon: LucideIcons.tag,
                                  text: p.category,
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
          );
        },
        error: (e, st) => Center(
          child: Text(
            'Failed to load podcasts',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textMuted),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  String _formatSchedule(DateTime date) {
    final df = DateFormat('EEE, d MMM');
    final tf = DateFormat('h:mm a');
    return '${df.format(date)} • ${tf.format(date)}';
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
