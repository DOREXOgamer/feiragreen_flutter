import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

/**
 * Implementação do repositório de produtos usando Firebase.
 * 
 * Esta classe implementa a interface IProductRepository definida na camada de domínio,
 * fornecendo a implementação concreta usando o Firebase Firestore.
 */
class FirebaseProductRepository implements IProductRepository {
  final FirebaseFirestore _firestore;

  /**
   * Construtor que recebe a instância do Firestore.
   * 
   * Permite a injeção de dependências para facilitar testes.
   */
  FirebaseProductRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /**
   * Referência à coleção de produtos no Firestore.
   */
  CollectionReference get _products => _firestore.collection('products');

  @override
  Future<String> addProduct(Product product) async {
    try {
      final docRef = await _products.add(product.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao adicionar produto: $e');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    try {
      if (product.id == null) {
        throw Exception('Produto sem ID não pode ser atualizado');
      }
      await _products.doc(product.id).update(product.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar produto: $e');
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await _products.doc(productId).delete();
    } catch (e) {
      throw Exception('Erro ao excluir produto: $e');
    }
  }

  @override
  Future<Product?> getProductById(String productId) async {
    try {
      final docSnapshot = await _products.doc(productId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return Product.fromMap({...data, 'id': productId});
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar produto: $e');
    }
  }

  @override
  Future<List<Product>> getProductsByUserId(String userId) async {
    try {
      final querySnapshot = await _products.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product.fromMap({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar produtos do usuário: $e');
    }
  }

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      final querySnapshot = await _products.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product.fromMap({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar todos os produtos: $e');
    }
  }
}