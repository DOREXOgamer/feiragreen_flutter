import '../../application/use_cases/add_to_cart_use_case.dart';
import '../../application/use_cases/get_all_products_use_case.dart';
import '../../application/use_cases/get_cart_items_use_case.dart';
import '../../application/use_cases/login_use_case.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../repositories/cart_repository_impl.dart';
import '../repositories/product_repository_impl.dart';
import '../repositories/user_repository_impl.dart';
import '../services/auth_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import '../logging/logger_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() => _instance;

  ServiceLocator._internal();

  // Services
  AuthService get authService => AuthService();
  FirebaseAuthService get firebaseAuthService => FirebaseAuthService();
  FirestoreService get firestoreService => FirestoreService();
  LoggerService get loggerService => LoggerService();

  // Repositories
  UserRepository get userRepository => UserRepositoryImpl(
        firebaseAuthService: firebaseAuthService,
        firestoreService: firestoreService,
      );
  ProductRepository get productRepository => ProductRepositoryImpl(
        firestoreService: firestoreService,
      );
  CartRepository get cartRepository => CartRepositoryImpl(
        firestoreService: firestoreService,
      );

  // Use Cases
  GetAllProductsUseCase get getAllProductsUseCase =>
      GetAllProductsUseCase(productRepository);
  AddToCartUseCase get addToCartUseCase => AddToCartUseCase(cartRepository);
  GetCartItemsUseCase get getCartItemsUseCase =>
      GetCartItemsUseCase(cartRepository);
  LoginUseCase get loginUseCase => LoginUseCase(userRepository);
}

// Global instance
final serviceLocator = ServiceLocator();

// Setup function
Future<void> setupServiceLocator() async {
  // Services are initialized lazily when accessed
}
