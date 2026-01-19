import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  const CartItem({required this.menuItemId, required this.quantity});

  final String menuItemId;
  final int quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      menuItemId: menuItemId,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartNotifier extends StateNotifier<Map<String, CartItem>> {
  CartNotifier() : super(const {});

  void add(String menuItemId) {
    final existing = state[menuItemId];
    if (existing == null) {
      state = {
        ...state,
        menuItemId: CartItem(menuItemId: menuItemId, quantity: 1),
      };
      return;
    }

    state = {
      ...state,
      menuItemId: existing.copyWith(quantity: existing.quantity + 1),
    };
  }

  void removeOne(String menuItemId) {
    final existing = state[menuItemId];
    if (existing == null) return;

    final nextQty = existing.quantity - 1;
    if (nextQty <= 0) {
      final next = {...state}..remove(menuItemId);
      state = next;
      return;
    }

    state = {
      ...state,
      menuItemId: existing.copyWith(quantity: nextQty),
    };
  }

  void clear() {
    state = const {};
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, CartItem>>(
  (ref) => CartNotifier(),
);

enum DeliveryOption { drone, rider }

final deliveryOptionProvider = StateProvider<DeliveryOption>(
  (ref) => DeliveryOption.rider,
);
