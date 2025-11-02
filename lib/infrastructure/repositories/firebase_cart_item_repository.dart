import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_item_repository.dart';

/**
 * Implementação do repositório de itens de carrinho usando Firebase.
 * 
 * Esta classe implementa a interface ICartItemRepository definida na camada de domínio,
 * fornecendo a implementação concreta usando o Firebase Firestore.
 */
class FirebaseCartItemRepository implements ICartItemRepository {
  final FirebaseFirestore _firestore;

  /**
   * Construtor que recebe a instância do Firestore.
   * 
   * Permite a injeção de dependências para facilitar testes.
   */
  FirebaseCartItemRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /**
   * Referência à coleção de itens de carrinho no Firestore.
   */
  CollectionReference get _cartItems => _firestore.collection('cart_items');

  @override
  Future<String> addCartItem(CartItem cartItem) async {
    try {
      final docRef = await _cartItems.add(cartItem.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao adicionar item ao carrinho: $e');
    }
  }

  @override
  Future<void> updateCartItem(CartItem cartItem) async {
    try {
      if (cartItem.id == null) {
        throw Exception('Item de carrinho sem ID não pode ser atualizado');
      }
      await _cartItems.doc(cartItem.id).update(cartItem.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar item do carrinho: $e');
    }
  }

  @override
  Future<void> deleteCartItem(String cartItemId) async {
    try {
      await _cartItems.doc(cartItemId).delete();
    } catch (e) {
      throw Exception('Erro ao excluir item do carrinho: $e');
    }
  }

  @override
  Future<List<CartItem>> getCartItemsByUserId(String userId) async {
    try {
      final querySnapshot = await _cartItems.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CartItem.fromMap({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar itens do carrinho: $e');
    }
  }

  @override
  Future<CartItem?> getCartItemById(String cartItemId) async {
    try {
      final docSnapshot = await _cartItems.doc(cartItemId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return CartItem.fromMap({...data, 'id': cartItemId});
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar item do carrinho: $e');
    }
  }

  @override
  Future<void> clearCart(String userId) async {
    try {
      final batch = _firestore.batch();
      final querySnapshot = await _cartItems.where('userId', isEqualTo: userId).get();
      
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao limpar carrinho: $e');
    }
  }
}