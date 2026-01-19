import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/orders_provider.dart';
import '../../data/mock_data.dart';
import '../../widgets/app_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/modern_snackbar.dart';
import 'cart_provider.dart';

class DeliveryScreen extends ConsumerWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final option = ref.watch(deliveryOptionProvider);

    final format = NumberFormat.currency(
      locale: 'en_PK',
      symbol: 'Rs ',
      decimalDigits: 0,
    );

    final byId = {for (final i in MockData.foodMenu) i.id: i};

    final subtotal = cart.values.fold<int>(0, (sum, ci) {
      final menu = byId[ci.menuItemId];
      if (menu == null) return sum;
      return sum + (menu.pricePkr * ci.quantity);
    });

    final deliveryFee = option == DeliveryOption.drone ? 100 : 30;
    final total = subtotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout & Delivery'),
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
        child: cart.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.shoppingBag,
                      size: 42,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your order is empty.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Go back and add something spicy.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      label: 'Back to Menu',
                      icon: LucideIcons.utensils,
                      isExpanded: false,
                      onPressed: () => context.go('/food'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Options',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _DeliveryOptionCard(
                          isSelected: option == DeliveryOption.drone,
                          icon: Icons.air,
                          title: 'Drone Delivery',
                          priceText: '+ Rs 100',
                          timeText: '5 Minutes',
                          tag: 'Fastest',
                          onTap: () => ref
                              .read(deliveryOptionProvider.notifier)
                              .state = DeliveryOption.drone,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DeliveryOptionCard(
                          isSelected: option == DeliveryOption.rider,
                          icon: LucideIcons.bike,
                          title: 'Student Rider',
                          priceText: '+ Rs 30',
                          timeText: '25 Minutes',
                          tag: 'Saver',
                          onTap: () => ref
                              .read(deliveryOptionProvider.notifier)
                              .state = DeliveryOption.rider,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Order Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      itemCount: cart.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final ci = cart.values.elementAt(index);
                        final menu = byId[ci.menuItemId];
                        if (menu == null) return const SizedBox.shrink();

                        final lineTotal = menu.pricePkr * ci.quantity;

                        return AppCard(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: 54,
                                  height: 54,
                                  child: Image.asset(
                                    menu.imageUrl,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    frameBuilder:
                                        (context, child, frame, wasSync) {
                                      if (wasSync || frame != null) return child;
                                      return Container(
                                        color: AppColors.navyLight,
                                        child: const Center(
                                          child: Icon(
                                            LucideIcons.image,
                                            color: AppColors.navy,
                                            size: 22,
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
                                          size: 22,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menu.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${format.format(menu.pricePkr)} × ${ci.quantity}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    format.format(lineTotal),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: AppColors.navy,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () => ref
                                            .read(cartProvider.notifier)
                                            .removeOne(menu.id),
                                        icon: const Icon(LucideIcons.minus),
                                      ),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () => ref
                                            .read(cartProvider.notifier)
                                            .add(menu.id),
                                        icon: const Icon(LucideIcons.plus),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _TotalRow(
                          label: 'Subtotal',
                          value: format.format(subtotal),
                        ),
                        const SizedBox(height: 8),
                        _TotalRow(
                          label: 'Delivery Fee',
                          value: format.format(deliveryFee),
                        ),
                        const Divider(height: 18),
                        _TotalRow(
                          label: 'Total',
                          value: format.format(total),
                          isStrong: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: PrimaryButton(
                  label: 'Place Order',
                  icon: LucideIcons.badgeCheck,
                  onPressed: () {
                    final orderId = ref.read(ordersProvider.notifier).createOrder(
                          cart: cart,
                          option: option,
                        );
                    ref.read(cartProvider.notifier).clear();
                    ModernSnackBar.success(
                      context,
                      'Order placed successfully!',
                    );
                    context.go('/orders/$orderId');
                  },
                ),
              ),
            ),
    );
  }
}

class _DeliveryOptionCard extends StatelessWidget {
  const _DeliveryOptionCard({
    required this.isSelected,
    required this.icon,
    required this.title,
    required this.priceText,
    required this.timeText,
    required this.tag,
    required this.onTap,
  });

  final bool isSelected;
  final IconData icon;
  final String title;
  final String priceText;
  final String timeText;
  final String tag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = isSelected ? AppColors.navy : AppColors.border;
    final tint = isSelected
        ? AppColors.navy.withValues(alpha: 0.10)
        : AppColors.card2.withValues(alpha: 0.60);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: 1),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.textPrimary, size: 18),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.navy.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    tag,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              priceText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              timeText,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  final String label;
  final String value;
  final bool isStrong;

  @override
  Widget build(BuildContext context) {
    final style = isStrong
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            )
        : Theme.of(context).textTheme.bodyMedium;

    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text(
          value,
          style: style?.copyWith(
            color: isStrong ? AppColors.navy : null,
          ),
        ),
      ],
    );
  }
}
