import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../services/firestore_service.dart';
import '../logging/logger_service.dart';

class CartRepositoryImpl implements CartRepository {
  final FirestoreService _firestoreService;
  final LoggerService _logger = LoggerService();

  CartRepositoryImpl({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  @override
  Future<String?> insertCartItem(CartItem cartItem) async {
    try {
      _logger.info('Inserindo item no carrinho: ${cartItem.productId}');
      final cartItemData = cartItem.toMap();
      cartItemData.remove('id'); // Firestore gera o ID automaticamente
      final cartItemId = await _firestoreService.addToCart(cartItemData);
      _logger.info('Item do carrinho inserido com sucesso: $cartItemId');
      return cartItemId;
    } catch (e) {
      _logger.error(
          'Erro ao inserir item no carrinho: ${cartItem.productId}', e);
      return null;
    }
  }

  @override
  Future<List<CartItem>> getCartItemsByUser(String userId) async {
    try {
      _logger.debug('Buscando itens do carrinho do usuário: $userId');
      final snapshot = await _firestoreService.getCartItemsByUser(userId);
      final cartItems = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CartItem.fromMap(data);
      }).toList();
      _logger.debug(
          'Encontrados ${cartItems.length} itens no carrinho do usuário: $userId');
      return cartItems;
    } catch (e) {
      _logger.error('Erro ao buscar itens do carrinho do usuário: $userId', e);
      return [];
    }
  }

  @override
  Future<bool> updateCartItemQuantity(String id, int quantity) async {
    try {
      _logger.info(
          'Atualizando quantidade do item do carrinho: $id para $quantity');
      await _firestoreService.updateCartItemQuantity(id, quantity);
      _logger
          .info('Quantidade do item do carrinho atualizada com sucesso: $id');
      return true;
    } catch (e) {
      _logger.error('Erro ao atualizar quantidade do item do carrinho: $id', e);
      return false;
    }
  }

  @override
  Future<bool> deleteCartItem(String id) async {
    try {
      _logger.info('Deletando item do carrinho: $id');
      await _firestoreService.removeFromCart(id);
      _logger.info('Item do carrinho deletado com sucesso: $id');
      return true;
    } catch (e) {
      _logger.error('Erro ao deletar item do carrinho: $id', e);
      return false;
    }
  }

  @override
  Future<bool> clearUserCart(String userId) async {
    try {
      _logger.info('Limpando carrinho do usuário: $userId');
      await _firestoreService.clearUserCart(userId);
      _logger.info('Carrinho do usuário limpo com sucesso: $userId');
      return true;
    } catch (e) {
      _logger.error('Erro ao limpar carrinho do usuário: $userId', e);
      return false;
    }
  }
}
