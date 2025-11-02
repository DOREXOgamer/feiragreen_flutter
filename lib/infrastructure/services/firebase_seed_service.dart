import 'package:feiragreen_flutter/domain/entities/user.dart';
import 'package:feiragreen_flutter/domain/entities/product.dart';
import 'package:feiragreen_flutter/infrastructure/services/firebase_service.dart';

class FirebaseSeedService {
  final FirebaseService _firebaseService = FirebaseService();

  // Dados dos usuários
  final List<User> users = [
    User(
      id: 'admin_user',
      nome: 'Admin',
      email: 'admin@feiragreens.com',
      senha: 'admin123',
      role: 'admin',
    ),
  ];

  // Dados dos produtos
  final List<Product> products = [
    Product(
      id: 'abacaxi_1',
      userId: 'admin_user',
      nome: 'Abacaxi',
      preco: 12.99,
      categoria: 'Frutas',
      descricao: 'Abacaxi fresco',
      imageUrl:
          'assets/imagens/product_images/1748306873_julien-pianetti-Cr9hZrpC1Oc-unsplash.jpg',
    ),
    Product(
      id: 'laranja_1',
      userId: 'admin_user',
      nome: 'Laranja',
      preco: 0.50,
      categoria: 'Frutas',
      descricao: 'Laranja doce',
      imageUrl:
          'assets/imagens/product_images/1748306892_xiaolong-wong-nibgG33H0F8-unsplash.jpg',
    ),
    Product(
      id: 'figo_1',
      userId: 'admin_user',
      nome: 'Figo',
      preco: 5.00,
      categoria: 'Frutas',
      descricao: 'Figo maduro',
      imageUrl:
          'assets/imagens/product_images/1748310608_tijana-drndarski-HVmNcqo_P2A-unsplash.jpg',
    ),
    Product(
      id: 'banana_1',
      userId: 'admin_user',
      nome: 'Banana',
      preco: 4.00,
      categoria: 'Frutas',
      descricao: 'Banana nanica',
      imageUrl: 'assets/imagens/product_images/1748308115_banana-nanica.png',
    ),
    Product(
      id: 'morango_1',
      userId: 'admin_user',
      nome: 'Morango',
      preco: 15.00,
      categoria: 'Frutas',
      descricao: 'Morango fresco',
      imageUrl:
          'assets/imagens/product_images/1748308184_morango-saiba-qual-e-a-sua-importancia-para-a-sua-saude-image (1).jpg',
    ),
    Product(
      id: 'alface_1',
      userId: 'admin_user',
      nome: 'Alface',
      preco: 1.99,
      categoria: 'Verduras',
      descricao: 'Alface crespa',
      imageUrl:
          'assets/imagens/product_images/1748307066_gabriel-mihalcea-5MU_4hPl67Y-unsplash.jpg',
    ),
    Product(
      id: 'tomate_1',
      userId: 'admin_user',
      nome: 'Tomate',
      preco: 6.00,
      categoria: 'Hortaliças',
      descricao: 'Tomate vermelho',
      imageUrl:
          'assets/imagens/product_images/1748307125_leilani-angel-d2aZ2MJBSeU-unsplash.jpg',
    ),
    Product(
      id: 'pimentao_1',
      userId: 'admin_user',
      nome: 'Pimentão',
      preco: 6.99,
      categoria: 'Hortaliças',
      descricao: 'Pimentão vermelho',
      imageUrl:
          'assets/imagens/product_images/1748307491_loa-kon-txwBEnKG9oM-unsplash.jpg',
    ),
    Product(
      id: 'mel_1',
      userId: 'admin_user',
      nome: 'Mel de abelha',
      preco: 36.00,
      categoria: 'Outros',
      descricao: 'Mel puro',
      imageUrl:
          'assets/imagens/product_images/1748307573_kateryna-hliznitsova-xkS7uc6TN3c-unsplash.jpg',
    ),
    Product(
      id: 'pimentao_2',
      userId: 'admin_user',
      nome: 'Pimentão',
      preco: 4.00,
      categoria: 'Hortaliças',
      descricao: 'Pimentão vermelho',
      imageUrl:
          'assets/imagens/product_images/1748311041_1748307175_ekaterina-grosheva-m7bSlagiFLw-unsplash.jpg',
    ),
    Product(
      id: 'chicoria_1',
      userId: 'admin_user',
      nome: 'Chicória',
      preco: 5.99,
      categoria: 'Verduras',
      descricao: 'Chicória fresca',
      imageUrl: 'assets/imagens/product_images/1748309930_CHICORIA.webp',
    ),
  ];

  // Método para popular o Firestore
  Future<void> seedFirestore() async {
    try {
      // Verificar se já existem usuários
      final existingUsers =
          await _firebaseService.getUserByEmail('admin@feiragreens.com');
      if (existingUsers == null) {
        // Inserir usuários apenas se não existirem
        for (var user in users) {
          await _firebaseService.setUser(user);
        }
        print('📊 ${users.length} usuários inseridos no Firestore');
      } else {
        print('📊 Usuários já existem no Firestore, pulando inserção');
      }

      // Verificar se já existem produtos
      final existingProducts = await _firebaseService.getAllProducts();
      if (existingProducts.isEmpty) {
        // Inserir produtos apenas se não existirem
        for (var product in products) {
          await _firebaseService.setProduct(product);
        }
        print('📦 ${products.length} produtos inseridos no Firestore');
      } else {
        print('📦 Produtos já existem no Firestore, pulando inserção');
      }

      print('✅ Firestore populado com sucesso!');
    } catch (e) {
      print('❌ Erro ao popular Firestore: $e');
    }
  }
}
