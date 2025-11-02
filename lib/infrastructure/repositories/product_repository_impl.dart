import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../services/firestore_service.dart';
import '../logging/logger_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirestoreService _firestoreService;
  final LoggerService _logger = LoggerService();

  ProductRepositoryImpl({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  @override
  Future<String?> insertProduct(Product product) async {
    try {
      _logger.info('Inserindo produto: ${product.nome}');
      final productData = product.toMap();
      productData.remove('id'); // Firestore gera o ID automaticamente
      final productId = await _firestoreService.createProduct(productData);
      _logger.info('Produto inserido com sucesso: $productId');
      return productId;
    } catch (e) {
      _logger.error('Erro ao inserir produto: ${product.nome}', e);
      return null;
    }
  }

  @override
  Future<List<Product>> getProductsByUser(String userId) async {
    try {
      _logger.debug('Buscando produtos do usuário: $userId');
      final snapshot = await _firestoreService.getProductsByUser(userId);
      final products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromMap(data);
      }).toList();
      _logger.debug(
          'Encontrados ${products.length} produtos para o usuário: $userId');
      return products;
    } catch (e) {
      _logger.error('Erro ao buscar produtos do usuário: $userId', e);
      return [];
    }
  }

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      _logger.debug('Buscando todos os produtos');
      final snapshot = await _firestoreService.getAllProducts();
      final products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromMap(data);
      }).toList();
      _logger.debug('Encontrados ${products.length} produtos no total');
      return products;
    } catch (e) {
      _logger.error('Erro ao buscar todos os produtos', e);
      return [];
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      _logger.debug('Buscando produtos com query: $query');
      final snapshot = await _firestoreService.searchProducts(query);
      final products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromMap(data);
      }).toList();
      _logger.debug(
          'Encontrados ${products.length} produtos para a query: $query');
      return products;
    } catch (e) {
      _logger.error('Erro ao buscar produtos com query: $query', e);
      return [];
    }
  }

  @override
  Future<List<String>> getDistinctCategories() async {
    try {
      _logger.debug('Buscando categorias distintas');
      final categories = await _firestoreService.getDistinctCategories();
      _logger.debug('Encontradas ${categories.length} categorias');
      return categories;
    } catch (e) {
      _logger.error('Erro ao buscar categorias distintas', e);
      return [];
    }
  }

  @override
  Future<bool> updateProduct(Product product) async {
    try {
      _logger.info('Atualizando produto: ${product.id}');
      final productData = product.toMap();
      productData.remove('id'); // ID é usado como chave do documento
      await _firestoreService.updateProduct(product.id!, productData);
      _logger.info('Produto atualizado com sucesso: ${product.id}');
      return true;
    } catch (e) {
      _logger.error('Erro ao atualizar produto: ${product.id}', e);
      return false;
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    try {
      _logger.info('Deletando produto: $id');
      await _firestoreService.deleteProduct(id);
      _logger.info('Produto deletado com sucesso: $id');
      return true;
    } catch (e) {
      _logger.error('Erro ao deletar produto: $id', e);
      return false;
    }
  }
}
