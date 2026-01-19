import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_colors.dart';
import '../../data/mock_data.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_asset_image.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/precache_assets_once.dart';
import 'cart_provider.dart';

class FoodScreen extends ConsumerWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final format = NumberFormat.currency(locale: 'en_PK', symbol: 'Rs ', decimalDigits: 0);

    final foodAssets = MockData.foodMenu.map((e) => e.imageUrl).toList(growable: false);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final gridAspectRatio = screenWidth < 380 ? 0.62 : 0.80;
    final descMaxLines = screenWidth < 380 ? 1 : 2;
    final cardPadding = screenWidth < 380 ? const EdgeInsets.all(10) : const EdgeInsets.all(12);
    final afterImageSpacing = screenWidth < 380 ? 8.0 : 10.0;
    final afterTitleSpacing = screenWidth < 380 ? 2.0 : 4.0;

    final totalItems = cart.values.fold<int>(0, (sum, i) => sum + i.quantity);

    return PrecacheAssetsOnce(
      assetPaths: foodAssets,
      cacheWidth: 600,
      cacheHeight: 420,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food Menu'),
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
          actions: [
            IconButton(
              tooltip: 'Checkout',
              onPressed: totalItems == 0 ? null : () => context.push('/delivery'),
              icon: Badge(
                isLabelVisible: totalItems > 0,
                label: Text('$totalItems'),
                child: const Icon(LucideIcons.shoppingBag),
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cafeteria Picks',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tap any item to see details and add to order.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: GridView.builder(
                  cacheExtent: 1200,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: gridAspectRatio,
                  ),
                  itemCount: MockData.foodMenu.length,
                  itemBuilder: (context, index) {
                    final item = MockData.foodMenu[index];
                    return AppCard(
                      onTap: () => _openDetailsSheet(
                        context: context,
                        ref: ref,
                        item: item,
                        format: format,
                      ),
                      backgroundColor: AppColors.navyLight.withValues(alpha: 0.35),
                      padding: cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: AppAssetImage(
                                assetPath: item.imageUrl,
                                cacheWidth: 600,
                                cacheHeight: 420,
                              ),
                            ),
                          ),
                          SizedBox(height: afterImageSpacing),
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          SizedBox(height: afterTitleSpacing),
                          Flexible(
                            child: Text(
                              item.description,
                              maxLines: descMaxLines,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textMuted),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  format.format(item.pricePkr),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppColors.navy,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.navy.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.navy.withValues(alpha: 0.18),
                                  ),
                                ),
                                child: const Icon(
                                  LucideIcons.plus,
                                  size: 16,
                                  color: AppColors.navy,
                                ),
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
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: PrimaryButton(
              label: totalItems == 0
                  ? 'Add items to checkout'
                  : 'Checkout ($totalItems) →',
              icon: LucideIcons.truck,
              onPressed: totalItems == 0 ? null : () => context.push('/delivery'),
            ),
          ),
        ),
      ),
    );
  }

  void _openDetailsSheet({
    required BuildContext context,
    required WidgetRef ref,
    required FoodMenuItem item,
    required NumberFormat format,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _FoodDetailsSheet(
          item: item,
          format: format,
          onAdd: () {
            ref.read(cartProvider.notifier).add(item.id);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _FoodDetailsSheet extends StatelessWidget {
  const _FoodDetailsSheet({
    required this.item,
    required this.format,
    required this.onAdd,
  });

  final FoodMenuItem item;
  final NumberFormat format;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.asset(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  frameBuilder: (context, child, frame, wasSync) {
                    if (wasSync || frame != null) return child;
                    return Container(
                      color: AppColors.navyLight,
                      child: const Center(
                        child: Icon(
                          LucideIcons.image,
                          color: AppColors.navy,
                          size: 34,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.navyLight,
                      child: const Icon(
                        LucideIcons.imageOff,
                        color: AppColors.navy,
                        size: 42,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  format.format(item.pricePkr),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card2,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'Spicy Level: ${item.isVeg ? 'Veg' : 'Non-Veg'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card2,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'Category: ${item.category}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Add to Order',
              icon: LucideIcons.plus,
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
