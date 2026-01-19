import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_data.dart';
import '../../features/food/cart_provider.dart';

class OrderLine {
  const OrderLine({
    required this.menuItemId,
    required this.name,
    required this.unitPricePkr,
    required this.quantity,
    required this.imageAsset,
  });

  final String menuItemId;
  final String name;
  final int unitPricePkr;
  final int quantity;
  final String imageAsset;

  int get lineTotal => unitPricePkr * quantity;
}

class OrderRecord {
  const OrderRecord({
    required this.id,
    required this.placedAt,
    required this.deliveryOption,
    required this.deliveryFeePkr,
    required this.lines,
  });

  final String id;
  final DateTime placedAt;
  final DeliveryOption deliveryOption;
  final int deliveryFeePkr;
  final List<OrderLine> lines;

  int get subtotalPkr => lines.fold<int>(0, (sum, l) => sum + l.lineTotal);
  int get totalPkr => subtotalPkr + deliveryFeePkr;
}

class OrdersNotifier extends StateNotifier<List<OrderRecord>> {
  OrdersNotifier() : super(const []);

  String createOrder({
    required Map<String, CartItem> cart,
    required DeliveryOption option,
  }) {
    final byId = {for (final i in MockData.foodMenu) i.id: i};

    final lines = <OrderLine>[];
    for (final ci in cart.values) {
      final menu = byId[ci.menuItemId];
      if (menu == null) continue;
      lines.add(
        OrderLine(
          menuItemId: menu.id,
          name: menu.name,
          unitPricePkr: menu.pricePkr,
          quantity: ci.quantity,
          imageAsset: menu.imageUrl,
        ),
      );
    }

    final deliveryFeePkr = option == DeliveryOption.drone ? 100 : 30;
    final id = DateTime.now().microsecondsSinceEpoch.toString();

    final record = OrderRecord(
      id: id,
      placedAt: DateTime.now(),
      deliveryOption: option,
      deliveryFeePkr: deliveryFeePkr,
      lines: lines,
    );

    state = [record, ...state];
    return id;
  }

  void clearAll() {
    state = const [];
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<OrderRecord>>(
  (ref) => OrdersNotifier(),
);

final orderByIdProvider = Provider.family<OrderRecord?, String>((ref, id) {
  final orders = ref.watch(ordersProvider);
  for (final o in orders) {
    if (o.id == id) return o;
  }
  return null;
});
