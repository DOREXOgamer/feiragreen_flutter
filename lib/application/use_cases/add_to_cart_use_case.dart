import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository cartRepository;

  AddToCartUseCase(this.cartRepository);

  Future<void> execute(String userId, String productId, int quantity) async {
    final cartItem = CartItem(
      userId: userId,
      productId: productId,
      quantity: quantity,
      createdAt: DateTime.now(),
    );
    await cartRepository.insertCartItem(cartItem);
  }
}
