import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../logging/logger_service.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LoggerService _logger = LoggerService();

  DatabaseHelper._privateConstructor();

  // CRUD para usuários
  Future<String?> insertUser(Map<String, dynamic> user) async {
    try {
      _logger.info('Inserting user: ${user['email']}');
      final docRef = await _firestore.collection('users').add(user);
      _logger.info('User inserted successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.error('Error inserting user: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      _logger.debug('Getting user by email: $email');
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final user = querySnapshot.docs.first.data();
        user['id'] = querySnapshot.docs.first.id;
        _logger.debug('User found: ${user['email']}');
        return user;
      } else {
        _logger.debug('User not found: $email');
        return null;
      }
    } catch (e) {
      _logger.error('Error getting user by email: $e');
      return null;
    }
  }

  Future<bool> updateUser(Map<String, dynamic> user) async {
    try {
      final userId = user['id'];
      user.remove('id'); // Remove id from data to update
      _logger.info('Updating user: $userId');
      await _firestore.collection('users').doc(userId).update(user);
      _logger.info('User updated successfully: $userId');
      return true;
    } catch (e) {
      _logger.error('Error updating user: $e');
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      _logger.info('Deleting user: $userId');
      await _firestore.collection('users').doc(userId).delete();
      _logger.info('User deleted successfully: $userId');
      return true;
    } catch (e) {
      _logger.error('Error deleting user: $e');
      return false;
    }
  }

  // CRUD para produtos
  Future<String?> insertProduct(Map<String, dynamic> product) async {
    try {
      _logger.info('Inserting product: ${product['nome']}');
      final docRef = await _firestore.collection('products').add(product);
      _logger.info('Product inserted successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.error('Error inserting product: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getProductsByUser(String userId) async {
    try {
      _logger.debug('Getting products by user: $userId');
      final querySnapshot = await _firestore
          .collection('products')
          .where('userId', isEqualTo: userId)
          .get();

      final products = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      _logger.debug('Found ${products.length} products for user: $userId');
      return products;
    } catch (e) {
      _logger.error('Error getting products by user: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      _logger.debug('Getting all products');
      final querySnapshot = await _firestore.collection('products').get();

      final products = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      _logger.debug('Found ${products.length} total products');
      return products;
    } catch (e) {
      _logger.error('Error getting all products: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    try {
      _logger.debug('Searching products with query: $query');
      final querySnapshot = await _firestore
          .collection('products')
          .where('nome', isGreaterThanOrEqualTo: query)
          .where('nome', isLessThan: query + '\uf8ff')
          .get();

      final products = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      _logger.debug('Found ${products.length} products matching query: $query');
      return products;
    } catch (e) {
      _logger.error('Error searching products: $e');
      return [];
    }
  }

  Future<List<String>> getDistinctCategories() async {
    try {
      _logger.debug('Getting distinct categories');
      final querySnapshot = await _firestore.collection('products').get();

      final categories = querySnapshot.docs
          .map((doc) => doc.data()['categoria'] as String? ?? 'Outros')
          .toSet()
          .toList()
        ..sort();

      _logger.debug('Found ${categories.length} distinct categories');
      return categories;
    } catch (e) {
      _logger.error('Error getting distinct categories: $e');
      return ['Outros'];
    }
  }

  Future<bool> updateProduct(Map<String, dynamic> product) async {
    try {
      final productId = product['id'];
      product.remove('id'); // Remove id from data to update
      _logger.info('Updating product: $productId');
      await _firestore.collection('products').doc(productId).update(product);
      _logger.info('Product updated successfully: $productId');
      return true;
    } catch (e) {
      _logger.error('Error updating product: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      _logger.info('Deleting product: $productId');
      await _firestore.collection('products').doc(productId).delete();
      _logger.info('Product deleted successfully: $productId');
      return true;
    } catch (e) {
      _logger.error('Error deleting product: $e');
      return false;
    }
  }

  // CRUD para cart_items
  Future<String?> insertCartItem(Map<String, dynamic> cartItem) async {
    try {
      _logger.info('Inserting cart item for user: ${cartItem['userId']}');
      final docRef = await _firestore.collection('cart_items').add(cartItem);
      _logger.info('Cart item inserted successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.error('Error inserting cart item: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCartItemsByUser(String userId) async {
    try {
      _logger.debug('Getting cart items for user: $userId');
      final querySnapshot = await _firestore
          .collection('cart_items')
          .where('userId', isEqualTo: userId)
          .get();

      final cartItems = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      _logger.debug('Found ${cartItems.length} cart items for user: $userId');
      return cartItems;
    } catch (e) {
      _logger.error('Error getting cart items by user: $e');
      return [];
    }
  }

  Future<bool> updateCartItemQuantity(String cartItemId, int quantity) async {
    try {
      _logger.info('Updating cart item quantity: $cartItemId to $quantity');
      await _firestore.collection('cart_items').doc(cartItemId).update({
        'quantity': quantity,
      });
      _logger.info('Cart item quantity updated successfully: $cartItemId');
      return true;
    } catch (e) {
      _logger.error('Error updating cart item quantity: $e');
      return false;
    }
  }

  Future<bool> deleteCartItem(String cartItemId) async {
    try {
      _logger.info('Deleting cart item: $cartItemId');
      await _firestore.collection('cart_items').doc(cartItemId).delete();
      _logger.info('Cart item deleted successfully: $cartItemId');
      return true;
    } catch (e) {
      _logger.error('Error deleting cart item: $e');
      return false;
    }
  }

  Future<bool> clearUserCart(String userId) async {
    try {
      _logger.info('Clearing cart for user: $userId');
      final querySnapshot = await _firestore
          .collection('cart_items')
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      _logger.info('Cart cleared successfully for user: $userId');
      return true;
    } catch (e) {
      _logger.error('Error clearing user cart: $e');
      return false;
    }
  }

  // Authentication methods
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      _logger.info('Signing in user: $email');
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.info('User signed in successfully: $email');
      return result;
    } catch (e) {
      _logger.error('Error signing in user: $e');
      return null;
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      _logger.info('Creating user: $email');
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.info('User created successfully: $email');
      return result;
    } catch (e) {
      _logger.error('Error creating user: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      _logger.info('Signing out user');
      await _auth.signOut();
      _logger.info('User signed out successfully');
    } catch (e) {
      _logger.error('Error signing out user: $e');
    }
  }

  User? get currentUser => _auth.currentUser;
}
