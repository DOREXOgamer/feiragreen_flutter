import 'package:feiragreen_flutter/domain/entities/product.dart';

abstract class ProductRepository {
  Future<void> setProduct(Product product);
  Future<List<Product>> getProductsByUser(String userId);
  Future<List<Product>> getAllProducts();
  Future<List<Product>> searchProducts(String query);
  Future<List<String>> getDistinctCategories();
  Future<void> deleteProduct(String id);
}
