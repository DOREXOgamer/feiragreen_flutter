import '../entities/product.dart';

abstract class ProductRepository {
  Future<String?> insertProduct(Product product);
  Future<List<Product>> getProductsByUser(String userId);
  Future<List<Product>> getAllProducts();
  Future<List<Product>> searchProducts(String query);
  Future<List<String>> getDistinctCategories();
  Future<bool> updateProduct(Product product);
  Future<bool> deleteProduct(String id);
}
