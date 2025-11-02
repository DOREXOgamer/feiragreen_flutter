import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository productRepository;

  GetAllProductsUseCase(this.productRepository);

  Future<List<Product>> execute() async {
    return await productRepository.getAllProducts();
  }
}
