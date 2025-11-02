import 'package:feiragreen_flutter/domain/entities/cart_item.dart';

abstract class CartItemRepository {
  Future<void> addCartItem(CartItem cartItem);
  Future<List<CartItem>> getCartItemsByUser(String userId);
  Future<void> updateCartItemQuantity(String id, int quantity);
  Future<void> deleteCartItem(String id);
  Future<void> clearUserCart(String userId);
}
