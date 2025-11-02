import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feiragreen_flutter/infrastructure/services/firebase_service.dart';
import 'package:feiragreen_flutter/repositories/product_repository.dart';
import 'package:feiragreen_flutter/repositories/cart_item_repository.dart';
import 'package:feiragreen_flutter/repositories/user_repository.dart';
import 'package:feiragreen_flutter/domain/entities/product.dart';

// Serviço principal que implementa os repositórios
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

// Providers de repositório, expondo os contratos
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ref.watch(firebaseServiceProvider);
});

final cartItemRepositoryProvider = Provider<CartItemRepository>((ref) {
  return ref.watch(firebaseServiceProvider);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return ref.watch(firebaseServiceProvider);
});

// Busca de produtos por termo (debounced pelo widget)
final searchProductsProvider =
    FutureProvider.autoDispose.family<List<Product>, String>((ref, query) async {
  final repo = ref.watch(productRepositoryProvider);
  if (query.isEmpty) {
    return <Product>[];
  }
  return await repo.searchProducts(query);
});

