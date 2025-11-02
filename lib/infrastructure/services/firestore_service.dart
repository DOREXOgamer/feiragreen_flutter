import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feiragreen_flutter/infrastructure/logging/logger_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoggerService _logger = LoggerService();

  FirebaseFirestore get firestore => _firestore;

  // Coleções
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String cartItemsCollection = 'cart_items';

  // USERS

  // Criar usuário
  Future<void> createUser(String uid, Map<String, dynamic> userData) async {
    try {
      _logger.info('Criando usuário no Firestore: $uid');
      await _firestore.collection(usersCollection).doc(uid).set({
        ...userData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _logger.info('Usuário criado com sucesso: $uid');
    } catch (e) {
      _logger.error('Erro ao criar usuário: $uid', e);
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  // Obter usuário por ID
  Future<DocumentSnapshot> getUser(String uid) async {
    try {
      _logger.debug('Buscando usuário: $uid');
      return await _firestore.collection(usersCollection).doc(uid).get();
    } catch (e) {
      _logger.error('Erro ao buscar usuário: $uid', e);
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

  // Atualizar usuário
  Future<void> updateUser(String uid, Map<String, dynamic> userData) async {
    try {
      _logger.info('Atualizando usuário: $uid');
      await _firestore.collection(usersCollection).doc(uid).update({
        ...userData,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _logger.info('Usuário atualizado com sucesso: $uid');
    } catch (e) {
      _logger.error('Erro ao atualizar usuário: $uid', e);
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  // Deletar usuário
  Future<void> deleteUser(String uid) async {
    try {
      _logger.info('Deletando usuário: $uid');
      await _firestore.collection(usersCollection).doc(uid).delete();
      _logger.info('Usuário deletado com sucesso: $uid');
    } catch (e) {
      _logger.error('Erro ao deletar usuário: $uid', e);
      throw Exception('Erro ao deletar usuário: $e');
    }
  }

  // PRODUCTS

  // Criar produto
  Future<String> createProduct(Map<String, dynamic> productData) async {
    try {
      _logger.info('Criando produto: ${productData['nome']}');
      final docRef = await _firestore.collection(productsCollection).add({
        ...productData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _logger.info('Produto criado com sucesso: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.error('Erro ao criar produto', e);
      throw Exception('Erro ao criar produto: $e');
    }
  }

  // Obter todos os produtos
  Future<QuerySnapshot> getAllProducts() async {
    try {
      _logger.debug('Buscando todos os produtos');
      return await _firestore
          .collection(productsCollection)
          .orderBy('createdAt', descending: true)
          .get();
    } catch (e) {
      _logger.error('Erro ao buscar produtos', e);
      throw Exception('Erro ao buscar produtos: $e');
    }
  }

  // Obter produtos por usuário
  Future<QuerySnapshot> getProductsByUser(String userId) async {
    try {
      _logger.debug('Buscando produtos do usuário: $userId');
      return await _firestore
          .collection(productsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
    } catch (e) {
      _logger.error('Erro ao buscar produtos do usuário: $userId', e);
      throw Exception('Erro ao buscar produtos do usuário: $e');
    }
  }

  // Buscar produtos por nome
  Future<QuerySnapshot> searchProducts(String query) async {
    try {
      _logger.debug('Buscando produtos com query: $query');
      return await _firestore
          .collection(productsCollection)
          .where('nome', isGreaterThanOrEqualTo: query)
          .where('nome', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
    } catch (e) {
      _logger.error('Erro ao buscar produtos', e);
      throw Exception('Erro ao buscar produtos: $e');
    }
  }

  // Obter categorias distintas
  Future<List<String>> getDistinctCategories() async {
    try {
      _logger.debug('Buscando categorias distintas');
      final snapshot = await _firestore.collection(productsCollection).get();
      final categories = <String>{};

      for (var doc in snapshot.docs) {
        final categoria = doc.data()['categoria'] as String?;
        if (categoria != null && categoria.isNotEmpty) {
          categories.add(categoria);
        }
      }

      final sortedCategories = categories.toList()..sort();
      _logger.debug('Encontradas ${sortedCategories.length} categorias');
      return sortedCategories;
    } catch (e) {
      _logger.error('Erro ao buscar categorias', e);
      throw Exception('Erro ao buscar categorias: $e');
    }
  }

  // Atualizar produto
  Future<void> updateProduct(
      String productId, Map<String, dynamic> productData) async {
    try {
      _logger.info('Atualizando produto: $productId');
      await _firestore.collection(productsCollection).doc(productId).update({
        ...productData,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _logger.info('Produto atualizado com sucesso: $productId');
    } catch (e) {
      _logger.error('Erro ao atualizar produto: $productId', e);
      throw Exception('Erro ao atualizar produto: $e');
    }
  }

  // Deletar produto
  Future<void> deleteProduct(String productId) async {
    try {
      _logger.info('Deletando produto: $productId');
      await _firestore.collection(productsCollection).doc(productId).delete();
      _logger.info('Produto deletado com sucesso: $productId');
    } catch (e) {
      _logger.error('Erro ao deletar produto: $productId', e);
      throw Exception('Erro ao deletar produto: $e');
    }
  }

  // CART ITEMS

  // Adicionar item ao carrinho
  Future<String> addToCart(Map<String, dynamic> cartItemData) async {
    try {
      _logger
          .info('Adicionando item ao carrinho: ${cartItemData['productId']}');
      final docRef = await _firestore.collection(cartItemsCollection).add({
        ...cartItemData,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _logger.info('Item adicionado ao carrinho: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.error('Erro ao adicionar item ao carrinho', e);
      throw Exception('Erro ao adicionar item ao carrinho: $e');
    }
  }

  // Obter itens do carrinho por usuário
  Future<QuerySnapshot> getCartItemsByUser(String userId) async {
    try {
      _logger.debug('Buscando itens do carrinho do usuário: $userId');
      return await _firestore
          .collection(cartItemsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
    } catch (e) {
      _logger.error('Erro ao buscar itens do carrinho: $userId', e);
      throw Exception('Erro ao buscar itens do carrinho: $e');
    }
  }

  // Atualizar quantidade do item no carrinho
  Future<void> updateCartItemQuantity(String cartItemId, int quantity) async {
    try {
      _logger
          .info('Atualizando quantidade do item: $cartItemId para $quantity');
      await _firestore.collection(cartItemsCollection).doc(cartItemId).update({
        'quantity': quantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _logger.info('Quantidade atualizada com sucesso');
    } catch (e) {
      _logger.error('Erro ao atualizar quantidade do item: $cartItemId', e);
      throw Exception('Erro ao atualizar quantidade: $e');
    }
  }

  // Remover item do carrinho
  Future<void> removeFromCart(String cartItemId) async {
    try {
      _logger.info('Removendo item do carrinho: $cartItemId');
      await _firestore.collection(cartItemsCollection).doc(cartItemId).delete();
      _logger.info('Item removido do carrinho com sucesso');
    } catch (e) {
      _logger.error('Erro ao remover item do carrinho: $cartItemId', e);
      throw Exception('Erro ao remover item do carrinho: $e');
    }
  }

  // Limpar carrinho do usuário
  Future<void> clearUserCart(String userId) async {
    try {
      _logger.info('Limpando carrinho do usuário: $userId');
      final batch = _firestore.batch();
      final cartItems = await getCartItemsByUser(userId);

      for (var doc in cartItems.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      _logger.info('Carrinho limpo com sucesso para usuário: $userId');
    } catch (e) {
      _logger.error('Erro ao limpar carrinho do usuário: $userId', e);
      throw Exception('Erro ao limpar carrinho: $e');
    }
  }

  // MÉTODOS GERAIS

  // Verificar se documento existe
  Future<bool> documentExists(String collection, String docId) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();
      return doc.exists;
    } catch (e) {
      _logger.error(
          'Erro ao verificar existência do documento: $collection/$docId', e);
      return false;
    }
  }

  // Obter stream de coleção (para real-time updates)
  Stream<QuerySnapshot> getCollectionStream(String collection,
      {String? orderBy, bool descending = true}) {
    Query query = _firestore.collection(collection);
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    return query.snapshots();
  }

  // Obter stream de documento (para real-time updates)
  Stream<DocumentSnapshot> getDocumentStream(String collection, String docId) {
    return _firestore.collection(collection).doc(docId).snapshots();
  }
}
