import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<String?> insertCartItem(CartItem cartItem);
  Future<List<CartItem>> getCartItemsByUser(String userId);
  Future<bool> updateCartItemQuantity(String id, int quantity);
  Future<bool> deleteCartItem(String id);
  Future<bool> clearUserCart(String userId);
}
