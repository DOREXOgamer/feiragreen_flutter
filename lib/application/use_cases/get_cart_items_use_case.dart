import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository cartRepository;

  GetCartItemsUseCase(this.cartRepository);

  Future<List<CartItem>> execute(String userId) async {
    return await cartRepository.getCartItemsByUser(userId);
  }
}
