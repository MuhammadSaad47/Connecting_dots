import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/orders_provider.dart';
import '../food/cart_provider.dart';
import '../../widgets/app_card.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdProvider(orderId));
    final tf = DateFormat('EEE, d MMM • h:mm a');
    final money = NumberFormat.currency(
      locale: 'en_PK',
      symbol: 'Rs ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
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
      body: order == null
          ? Center(
              child: Text(
                'Order not found.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textMuted),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.navyLight,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.navy.withValues(alpha: 0.25),
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.badgeCheck,
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
                                'Order #${order.id.substring(order.id.length - 6)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tf.format(order.placedAt),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.navy.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.navy.withValues(alpha: 0.30),
                            ),
                          ),
                          child: Text(
                            order.deliveryOption == DeliveryOption.drone
                                ? 'Drone'
                                : 'Rider',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Items',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      itemCount: order.lines.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final l = order.lines[index];
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
                                    l.imageAsset,
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
                                    errorBuilder: (context, error, st) {
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
                                      l.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${money.format(l.unitPricePkr)} × ${l.quantity}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                money.format(l.lineTotal),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.navy,
                                    ),
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
                          value: money.format(order.subtotalPkr),
                        ),
                        const SizedBox(height: 8),
                        _TotalRow(
                          label: 'Delivery Fee',
                          value: money.format(order.deliveryFeePkr),
                        ),
                        const Divider(height: 18),
                        _TotalRow(
                          label: 'Total',
                          value: money.format(order.totalPkr),
                          strong: true,
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

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = strong
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.navy,
            )
        : Theme.of(context).textTheme.bodyMedium;

    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text(value, style: style),
      ],
    );
  }
}
