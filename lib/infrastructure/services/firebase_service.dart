import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:feiragreen_flutter/application/services/logger_service.dart';
import 'package:feiragreen_flutter/repositories/user_repository.dart';
import 'package:feiragreen_flutter/repositories/product_repository.dart';
import 'package:feiragreen_flutter/repositories/cart_item_repository.dart';
import 'package:feiragreen_flutter/domain/entities/user.dart';
import 'package:feiragreen_flutter/domain/entities/product.dart';
import 'package:feiragreen_flutter/domain/entities/cart_item.dart';

class FirebaseService
    implements UserRepository, ProductRepository, CartItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

  // Users collection reference
  CollectionReference get _users => _firestore.collection('users');

  // Products collection reference
  CollectionReference get _products => _firestore.collection('products');

  // Cart items collection reference
  CollectionReference get _cartItems => _firestore.collection('cart_items');

  // Orders collection reference
  CollectionReference get _orders => _firestore.collection('orders');

  // UserRepository implementation
  @override
  Future<void> setUser(User user) async {
    final docRef = _users.doc(user.id?.toString() ?? _auth.currentUser?.uid);
    LoggerService.instance
        .info('Set user', tag: 'FirebaseService', data: {'userId': docRef.id});
    await docRef.set(user.toMap(), SetOptions(merge: true));
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    LoggerService.instance.info('Get user by email',
        tag: 'FirebaseService', data: {'email': email});
    final querySnapshot = await _users.where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isNotEmpty) {
      LoggerService.instance.info('User found by email',
          tag: 'FirebaseService', data: {'email': email});
      return User.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<User?> getUserById(String id) async {
    try {
      LoggerService.instance
          .info('Get user by id', tag: 'FirebaseService', data: {'userId': id});
      final docSnapshot = await _users.doc(id).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data is Map<String, dynamic>) {
          return User.fromMap(data);
        } else {
          throw Exception(
              'Dados do usuário não estão no formato esperado: ${data.runtimeType}');
        }
      }
      return null;
    } catch (e) {
      LoggerService.instance.error('Erro ao buscar usuário por ID',
          tag: 'FirebaseService', error: e);
      throw Exception('Erro ao buscar usuário por ID: $e');
    }
  }

  // ProductRepository implementation
  @override
  Future<void> setProduct(Product product) async {
    if (product.id != null && product.id!.isNotEmpty) {
      LoggerService.instance.info('Update product',
          tag: 'FirebaseService', data: {'productId': product.id});
      await _products
          .doc(product.id!)
          .set(product.toMap(), SetOptions(merge: true));
    } else {
      final newDoc = await _products.add(product.toMap());
      LoggerService.instance.info('Create product',
          tag: 'FirebaseService', data: {'productId': newDoc.id});
    }
  }

  @override
  Future<List<Product>> getProductsByUser(String userId) async {
    LoggerService.instance.info('Get products by user',
        tag: 'FirebaseService', data: {'userId': userId});
    final querySnapshot =
        await _products.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Product.fromMap({...data, 'id': doc.id});
    }).toList();
  }

  @override
  Future<List<Product>> getAllProducts() async {
    LoggerService.instance.info('Get all products', tag: 'FirebaseService');
    final querySnapshot = await _products.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Product.fromMap({...data, 'id': doc.id});
    }).toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    LoggerService.instance.info('Search products',
        tag: 'FirebaseService', data: {'query': query});

    if (query.trim().isEmpty) {
      return [];
    }

    // Converter query para lowercase para busca case-insensitive
    final lowerQuery = query.toLowerCase().trim();

    // Buscar todos os produtos e filtrar localmente para maior flexibilidade
    final querySnapshot = await _products.get();
    final allProducts = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Product.fromMap({...data, 'id': doc.id});
    }).toList();

    // Filtrar produtos que contenham o termo de busca em nome, categoria ou descrição
    final filteredProducts = allProducts.where((product) {
      final nome = product.nome.toLowerCase();
      final categoria = product.categoria.toLowerCase();
      final descricao = (product.descricao ?? '').toLowerCase();

      // Busca por palavras parciais em qualquer um dos campos
      return nome.contains(lowerQuery) ||
          categoria.contains(lowerQuery) ||
          descricao.contains(lowerQuery);
    }).toList();

    // Ordenar resultados por relevância (nome primeiro, depois categoria, depois descrição)
    filteredProducts.sort((a, b) {
      final aName = a.nome.toLowerCase();
      final bName = b.nome.toLowerCase();
      final aCategory = a.categoria.toLowerCase();
      final bCategory = b.categoria.toLowerCase();

      // Priorizar matches no nome
      final aNameMatch = aName.contains(lowerQuery);
      final bNameMatch = bName.contains(lowerQuery);

      if (aNameMatch && !bNameMatch) return -1;
      if (!aNameMatch && bNameMatch) return 1;

      // Se ambos têm match no nome, priorizar matches que começam com a query
      if (aNameMatch && bNameMatch) {
        final aStartsWith = aName.startsWith(lowerQuery);
        final bStartsWith = bName.startsWith(lowerQuery);

        if (aStartsWith && !bStartsWith) return -1;
        if (!aStartsWith && bStartsWith) return 1;
      }

      // Priorizar matches na categoria
      final aCategoryMatch = aCategory.contains(lowerQuery);
      final bCategoryMatch = bCategory.contains(lowerQuery);

      if (aCategoryMatch && !bCategoryMatch) return -1;
      if (!aCategoryMatch && bCategoryMatch) return 1;

      // Ordenação alfabética como fallback
      return aName.compareTo(bName);
    });

    return filteredProducts;
  }

  @override
  Future<List<String>> getDistinctCategories() async {
    final querySnapshot = await _products.get();
    final categories = querySnapshot.docs
        .map((doc) =>
            (doc.data() as Map<String, dynamic>)['categoria'] as String)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  @override
  Future<void> deleteProduct(String id) async {
    LoggerService.instance.info('Delete product',
        tag: 'FirebaseService', data: {'productId': id});
    await _products.doc(id).delete();
  }

  // CartItemRepository implementation
  @override
  Future<void> addCartItem(CartItem cartItem) async {
    if (cartItem.id != null && cartItem.id!.isNotEmpty) {
      LoggerService.instance.info('Update cart item',
          tag: 'FirebaseService', data: {'cartItemId': cartItem.id});
      await _cartItems
          .doc(cartItem.id!)
          .set(cartItem.toMap(), SetOptions(merge: true));
    } else {
      final newDoc = await _cartItems.add(cartItem.toMap());
      LoggerService.instance.info('Create cart item',
          tag: 'FirebaseService', data: {'cartItemId': newDoc.id});
    }
  }

  @override
  Future<List<CartItem>> getCartItemsByUser(String userId) async {
    LoggerService.instance.info('Get cart items by user',
        tag: 'FirebaseService', data: {'userId': userId});
    final querySnapshot =
        await _cartItems.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return CartItem.fromMap({...data, 'id': doc.id});
    }).toList();
  }

  @override
  Future<void> updateCartItemQuantity(String id, int quantity) async {
    LoggerService.instance.info('Update cart item quantity',
        tag: 'FirebaseService', data: {'cartItemId': id, 'quantity': quantity});
    await _cartItems.doc(id).update({'quantity': quantity});
  }

  @override
  Future<void> deleteCartItem(String id) async {
    LoggerService.instance.info('Delete cart item',
        tag: 'FirebaseService', data: {'cartItemId': id});
    await _cartItems.doc(id).delete();
  }

  @override
  Future<void> clearUserCart(String userId) async {
    LoggerService.instance.info('Clear user cart',
        tag: 'FirebaseService', data: {'userId': userId});
    final querySnapshot =
        await _cartItems.where('userId', isEqualTo: userId).get();
    LoggerService.instance.info('Cart items to clear',
        tag: 'FirebaseService', data: {'count': querySnapshot.docs.length});
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Create order document with purchase info
  Future<String> createOrder({
    required String userId,
    required String orderId,
    required List<Map<String, dynamic>> items,
    required double total,
    required String paymentMethod,
    Map<String, dynamic>? buyerInfo,
  }) async {
    final payload = {
      'userId': userId,
      'orderId': orderId,
      'items': items,
      'total': total,
      'paymentMethod': paymentMethod,
      'buyerInfo': buyerInfo ?? {},
      'createdAt': FieldValue.serverTimestamp(),
    };

    LoggerService.instance.info('Create order',
        tag: 'FirebaseService', data: {'userId': userId, 'orderId': orderId});
    final docRef = await _orders.add(payload);
    return docRef.id;
  }
}
