import 'package:feiragreen_flutter/database/database_helper.dart';

class SeedData {
  static final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Dados dos usuários
  static final List<Map<String, dynamic>> users = [
    {
      'id': 1,
      'nome': 'Admin',
      'email': 'admin@feiragreens.com',
      'senha': 'admin123',
      'imagemPerfil': null,
    },
  ];

  // Dados dos produtos do MySQL (convertidos para a estrutura do Flutter)
  static final List<Map<String, dynamic>> products = [
    {
      'userId': 1,
      'nome': 'Abacaxi',
      'preco': 12.99,
      'categoria': 'Frutas',
      'descricao': 'Abacaxi fresco',
      'imageUrl':
          'assets/imagens/product_images/1748306873_julien-pianetti-Cr9hZrpC1Oc-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Laranja',
      'preco': 0.50,
      'categoria': 'Frutas',
      'descricao': 'Laranja doce',
      'imageUrl':
          'assets/imagens/product_images/1748306892_xiaolong-wong-nibgG33H0F8-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Figo',
      'preco': 5.00,
      'categoria': 'Frutas',
      'descricao': 'Figo maduro',
      'imageUrl':
          'assets/imagens/product_images/1748310608_tijana-drndarski-HVmNcqo_P2A-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Banana',
      'preco': 4.00,
      'categoria': 'Frutas',
      'descricao': 'Banana nanica',
      'imageUrl': 'assets/imagens/product_images/1748308115_banana-nanica.png',
    },
    {
      'userId': 1,
      'nome': 'Morango',
      'preco': 15.00,
      'categoria': 'Frutas',
      'descricao': 'Morango fresco',
      'imageUrl':
          'assets/imagens/product_images/1748308184_morango-saiba-qual-e-a-sua-importancia-para-a-sua-saude-image (1).jpg',
    },
    {
      'userId': 1,
      'nome': 'Alface',
      'preco': 1.99,
      'categoria': 'Verduras',
      'descricao': 'Alface crespa',
      'imageUrl':
          'assets/imagens/product_images/1748307066_gabriel-mihalcea-5MU_4hPl67Y-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Tomate',
      'preco': 6.00,
      'categoria': 'Hortaliças',
      'descricao': 'Tomate vermelho',
      'imageUrl':
          'assets/imagens/product_images/1748307125_leilani-angel-d2aZ2MJBSeU-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Pimentão',
      'preco': 6.99,
      'categoria': 'Verduras',
      'descricao': 'Pimentão colorido',
      'imageUrl': 'assets/imagens/product_images/1748311088_Acelga (1).webp',
    },
    {
      'userId': 1,
      'nome': 'Batata',
      'preco': 6.00,
      'categoria': 'Legumes',
      'descricao': 'Batata especial',
      'imageUrl':
          'assets/imagens/product_images/1748307949_Batata-Especial-1kg.png',
    },
    {
      'userId': 1,
      'nome': 'Pimentão verde',
      'preco': 5.00,
      'categoria': 'Legumes',
      'descricao': 'Pimentão verde fresco',
      'imageUrl':
          'assets/imagens/product_images/1748307724_tiry-nelson-gono-3N_znw90QlU-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Abóbora',
      'preco': 3.50,
      'categoria': 'Legumes',
      'descricao': 'Abóbora madura',
      'imageUrl':
          'assets/imagens/product_images/1748307268_personalgraphic-com-CC6X_13kuFQ-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Beterraba',
      'preco': 2.99,
      'categoria': 'Legumes',
      'descricao': 'Beterraba orgânica',
      'imageUrl':
          'assets/imagens/product_images/1748307986_beterraba---caixa-de-20kg-pmg262fswo.webp',
    },
    {
      'userId': 1,
      'nome': 'Rabanete',
      'preco': 7.99,
      'categoria': 'Legumes',
      'descricao': 'Rabanete fresco',
      'imageUrl':
          'assets/imagens/product_images/1748307390_jo-lanta-_v8-VaFTWro-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Pão caseiro',
      'preco': 15.00,
      'categoria': 'Outros',
      'descricao': 'Pão artesanal',
      'imageUrl':
          'assets/imagens/product_images/1748306704_joanna-stolowicz-y7x_TQO5XP0-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Bolacha caseira',
      'preco': 23.00,
      'categoria': 'Outros',
      'descricao': 'Bolacha artesanal',
      'imageUrl':
          'assets/imagens/product_images/1748306746_glen-carrie-Xcn2Yztj0W8-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Queijo artesanal',
      'preco': 69.00,
      'categoria': 'Outros',
      'descricao': 'Queijo artesanal',
      'imageUrl':
          'assets/imagens/product_images/1748307448_alexander-maasch-KaK2jp8ie8s-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Geleia artesanal',
      'preco': 21.00,
      'categoria': 'Outros',
      'descricao': 'Geleia caseira',
      'imageUrl':
          'assets/imagens/product_images/1748307491_loa-kon-txwBEnKG9oM-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Mel de abelha',
      'preco': 36.00,
      'categoria': 'Outros',
      'descricao': 'Mel puro',
      'imageUrl':
          'assets/imagens/product_images/1748307573_kateryna-hliznitsova-xkS7uc6TN3c-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Pimentão',
      'preco': 4.00,
      'categoria': 'Hortaliças',
      'descricao': 'Pimentão vermelho',
      'imageUrl':
          'assets/imagens/product_images/1748311041_1748307175_ekaterina-grosheva-m7bSlagiFLw-unsplash.jpg',
    },
    {
      'userId': 1,
      'nome': 'Chicória',
      'preco': 5.99,
      'categoria': 'Verduras',
      'descricao': 'Chicória fresca',
      'imageUrl': 'assets/imagens/product_images/1748309930_CHICORIA.webp',
    },
  ];

  // Método para popular o banco de dados
  static Future<void> seedDatabase() async {
    try {
      // Garante que o banco está inicializado
      final db = await _dbHelper.database;

      // Verificar se já existem usuários
      final existingUsers = await db.query('users');
      if (existingUsers.isEmpty) {
        // Inserir usuários apenas se não existirem
        for (var user in users) {
          await _dbHelper.insertUser(user);
        }
        print('📊 ${users.length} usuários inseridos');
      } else {
        print('📊 Usuários já existem, pulando inserção');
      }

      // Verificar se já existem produtos
      final existingProducts = await db.query('products');
      if (existingProducts.isEmpty) {
        // Inserir produtos apenas se não existirem
        for (var product in products) {
          await _dbHelper.insertProduct(product);
        }
        print('📦 ${products.length} produtos inseridos');
      } else {
        print('📦 Produtos já existem, pulando inserção');
      }

      print('✅ Banco de dados populado com sucesso!');
    } catch (e) {
      print('❌ Erro ao popular banco de dados: $e');
    }
  }

  // Método para limpar e recriar o banco de dados
  static Future<void> resetDatabase() async {
    try {
      final db = await _dbHelper.database;

      // Limpar tabelas
      await db.delete('users');
      await db.delete('products');
      await db.delete('cart_items');

      print('🗑️ Banco de dados limpo com sucesso!');
    } catch (e) {
      print('❌ Erro ao limpar banco de dados: $e');
    }
  }
}
