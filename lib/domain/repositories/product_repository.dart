import '../entities/product.dart';

// Contrato legado utilizado por implementações Firebase específicas
abstract class IProductRepository {
  Future<String> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String productId);
  Future<Product?> getProductById(String productId);
  Future<List<Product>> getProductsByUserId(String userId);
  Future<List<Product>> getAllProducts();
}

abstract class ProductRepository {
  Future<String?> insertProduct(Product product);
  Future<List<Product>> getProductsByUser(String userId);
  Future<List<Product>> getAllProducts();
  Future<List<Product>> searchProducts(String query);
  Future<List<String>> getDistinctCategories();
  Future<bool> updateProduct(Product product);
  Future<bool> deleteProduct(String id);
}
