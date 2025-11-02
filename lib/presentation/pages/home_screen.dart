import 'package:flutter/material.dart';
import 'package:feiragreen_flutter/infrastructure/services/firebase_service.dart';
import 'package:feiragreen_flutter/domain/entities/product.dart';
import 'package:feiragreen_flutter/domain/entities/user.dart';
import 'package:feiragreen_flutter/domain/entities/cart_item.dart';
import 'package:feiragreen_flutter/presentation/pages/profile_screen.dart';
import 'package:feiragreen_flutter/presentation/pages/carrinho_screen.dart';
import 'package:feiragreen_flutter/presentation/pages/busca_screen.dart';
import 'package:feiragreen_flutter/presentation/pages/address_screen.dart';
import 'package:feiragreen_flutter/presentation/components/components.dart';
import 'package:feiragreen_flutter/application/services/logger_service.dart';

// Enhanced Product Card with animations and modern design
class EnhancedProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onLongPress;

  const EnhancedProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onLongPress,
  });

  @override
  State<EnhancedProductCard> createState() => _EnhancedProductCardState();
}

class _EnhancedProductCardState extends State<EnhancedProductCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Card(
                elevation: 8,
                shadowColor: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.grey[50]!,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child:
                              _buildProductImage(widget.product.imageUrl ?? ''),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'R\$ ${widget.product.preco.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFF2E7D32),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF2E7D32),
                                      Color(0xFF4CAF50)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF2E7D32)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: widget.onAddToCart,
                                  tooltip: 'Adicionar ao carrinho',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          );
        },
      );
    } else {
      return Image.network(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          );
        },
      );
    }
  }
}

// O ProductCard agora é um widget separado para melhor organização e reutilização.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onLongPress;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // Função local para construir a imagem do produto.
    Widget _buildProductImage(String imageUrl) {
      if (imageUrl.startsWith('assets/')) {
        return Image.asset(
          imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.image_not_supported,
                size: 40,
                color: Colors.grey,
              ),
            );
          },
        );
      } else {
        return Image.network(
          imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.image_not_supported,
                size: 40,
                color: Colors.grey,
              ),
            );
          },
        );
      }
    }

    return GestureDetector(
      onLongPress: onLongPress,
      child: Card(
        elevation: 4, // Adiciona sombra para um efeito de elevação
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Bordas arredondadas
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: _buildProductImage(product.imageUrl ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'R\$ ${product.preco.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      color: const Color(0xFF2E7D32),
                      onPressed: onAddToCart,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Product> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _cartItemCount = 0;
  User? _userData;
  bool _isLoadingUser = true;
  int _currentBannerIndex = 0;
  late PageController _bannerController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  String _selectedCategory = 'Todos';

  final List<Map<String, dynamic>> _bannerData = [
    {
      'image': 'assets/imagens/baners/imagem1.png',
      'title': 'FINAL DE SEMANA',
      'subtitle': 'FRUTAS E VERDURAS\nOFERTAS COM 50% OFF',
      'color': const Color(0xFF2E7D32),
    },
    {
      'image': 'assets/imagens/baners/imagem2.png',
      'title': 'PRODUTOS ORGÂNICOS',
      'subtitle': 'CULTIVADOS COM\nAMOR E CUIDADO',
      'color': const Color(0xFF4CAF50),
    },
    {
      'image': 'assets/imagens/baners/imagem3.png',
      'title': 'FRESCOS TODO DIA',
      'subtitle': 'ENTREGAMOS NA SUA\nCASA COM QUALIDADE',
      'color': const Color(0xFF66BB6A),
    },
  ];

  List<Map<String, String>> _categories = [
    {'name': 'Todos', 'icon': '🌟'},
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(initialPage: 0);
    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _fadeAnimationController, curve: Curves.easeInOut),
    );

    _startBannerAutoScroll();

    _loadCategories();
    _loadProducts();
    _loadCartItemCount();
    _loadUserData();
  }

  Future<void> _loadCategories() async {
    final firebaseService = FirebaseService();
    final categories = await firebaseService.getDistinctCategories();
    setState(() {
      _categories = [
        {'name': 'Todos', 'icon': '🌟'},
        ...categories
            .map((cat) => {'name': cat, 'icon': _getCategoryIcon(cat)}),
      ];
    });
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'frutas':
        return '🍎';
      case 'verduras':
        return '🥬';
      case 'hortaliças':
        return '🥕';
      case 'legumes':
        return '🥔';
      case 'orgânicos':
        return '🌱';
      case 'ofertas':
        return '🔥';
      default:
        return '🌟';
    }
  }

  void _startBannerAutoScroll() {
    Future.delayed(const Duration(seconds: 5), () async {
      if (!mounted) return;
      int nextPage = _currentBannerIndex + 1;
      if (nextPage >= _bannerData.length) {
        nextPage = 0;
      }
      await _fadeAnimationController.forward();
      setState(() {
        _currentBannerIndex = nextPage;
      });
      _bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      await _fadeAnimationController.reverse();
      _startBannerAutoScroll();
    });
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final firebaseService = FirebaseService();
      final productsData = await firebaseService.getAllProducts();

      setState(() {
        _products = productsData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar produtos: $e';
      });
    }
  }

  Future<void> _loadCartItemCount() async {
    final count = await _getCartItemCount();
    setState(() {
      _cartItemCount = count;
    });
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoadingUser = true;
      });

      // Buscar dados do usuário pelo email
      final firebaseService = FirebaseService();
      final userData =
          await firebaseService.getUserByEmail(widget.user['email']);

      setState(() {
        _userData = userData;
        _isLoadingUser = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingUser = false;
      });
      LoggerService.instance.error('Erro ao carregar dados do usuário',
          tag: 'HomeScreen', error: e);
    }
  }

  Future<void> _goToProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(user: widget.user)),
    );
    await _loadProducts();
    await _loadCartItemCount();
  }

  Future<void> _goToAddress() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddressScreen()),
    );
  }

  Future<void> _refreshProducts() async {
    await _loadProducts();
    await _loadCartItemCount();
  }

  Future<void> _goToCar() async {
    LoggerService.instance.info('Abrir carrinho',
        tag: 'HomeScreen', data: {'userId': widget.user['id']});
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CarrinhoScreen(userId: widget.user['id'] as String),
      ),
    );
    await _loadProducts();
    await _loadCartItemCount();
  }

  Future<void> _goToBusca() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BuscaScreen(user: widget.user)),
    );
    await _loadProducts();
    await _loadCartItemCount();
  }

  Future<void> _addToCart(Product product) async {
    try {
      LoggerService.instance.info('Adicionar ao carrinho',
          tag: 'HomeScreen',
          data: {'userId': widget.user['id'], 'productId': product.id});
      final firebaseService = FirebaseService();
      final cartItems = await firebaseService.getCartItemsByUser(
        widget.user['id'] as String,
      );
      final existingItem = cartItems.firstWhere(
        (item) => item.productId == product.id,
        orElse: () => CartItem(
          userId: '',
          productId: '',
          quantity: 0,
          createdAt: DateTime.now(),
        ),
      );

      if (existingItem.productId.isNotEmpty && existingItem.id != null) {
        LoggerService.instance.info('Atualizar quantidade no carrinho',
            tag: 'HomeScreen',
            data: {'cartItemId': existingItem.id, 'newQuantity': existingItem.quantity + 1});
        await firebaseService.updateCartItemQuantity(
          existingItem.id!,
          existingItem.quantity + 1,
        );
      } else {
        final cartItem = CartItem(
          userId: widget.user['id'] as String,
          productId: product.id!,
          quantity: 1,
          createdAt: DateTime.now(),
        );
        await firebaseService.addCartItem(cartItem);
        LoggerService.instance.info('Item criado no carrinho',
            tag: 'HomeScreen', data: {'productId': product.id});
      }

      await _loadCartItemCount();
      setState(() {}); // Force UI update after cart count changes

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.nome} adicionado ao carrinho!')),
      );
      LoggerService.instance.info('Produto adicionado ao carrinho',
          tag: 'HomeScreen', data: {'productId': product.id});
    } catch (e) {
      LoggerService.instance.error('Erro ao adicionar ao carrinho',
          tag: 'HomeScreen', error: e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar ao carrinho: $e')),
      );
    }
  }

  Future<int> _getCartItemCount() async {
    try {
      final firebaseService = FirebaseService();
      final cartItems = await firebaseService.getCartItemsByUser(
        widget.user['id'] as String,
      );
      int total = 0;
      for (var item in cartItems) {
        total += item.quantity;
      }
      return total;
    } catch (e) {
      LoggerService.instance.warn('Falha ao obter contagem do carrinho',
          tag: 'HomeScreen', data: {'userId': widget.user['id']});
      return 0;
    }
  }

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header com título
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E7D32),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // Conteúdo
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.imageUrl != null &&
                            product.imageUrl!.isNotEmpty)
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _buildProductImage(product.imageUrl ?? '',
                                  height: 180),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'R\$ ${product.preco.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (product.descricao != null &&
                            product.descricao!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Descrição:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.descricao!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        const SizedBox(height: 12),
                        Text(
                          'ID do Produto: ${product.id}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Botões de ação
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF2E7D32)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Fechar',
                            style: TextStyle(color: Color(0xFF2E7D32)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _addToCart(product);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Adicionar ao Carrinho',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductImage(String imageUrl, {double? height}) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height ?? 150,
            color: Colors.grey[200],
            child: const Icon(Icons.image_not_supported,
                size: 40, color: Colors.grey),
          );
        },
      );
    } else {
      // Assume it's a network URL
      return Image.network(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height ?? 150,
            color: Colors.grey[200],
            child: const Icon(Icons.image_not_supported,
                size: 40, color: Colors.grey),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        onSearchPressed: _goToBusca,
        onCartPressed: _goToCar,
        cartItemCount: _cartItemCount,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/imagens/LogoFeiraGreen.png',
                    height: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Olá, ${widget.user['name'] ?? 'Usuário'}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                _goToProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Endereço'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                _goToAddress();
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: RefreshIndicator(
          onRefresh: _refreshProducts,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner destaque with PageView and fade animation
                Container(
                  margin: const EdgeInsets.all(16),
                  height: 140,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _bannerController,
                        itemCount: _bannerData.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentBannerIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final banner = _bannerData[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              banner['image'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        },
                      ),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _bannerData[_currentBannerIndex]['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  shadows: [
                                    Shadow(blurRadius: 3, color: Colors.black)
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _bannerData[_currentBannerIndex]['subtitle'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  shadows: [
                                    Shadow(blurRadius: 3, color: Colors.black)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Categories horizontal list
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category['name'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category['name']!;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2E7D32)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                category['icon']!,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                category['name']!,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Lista de produtos em grid filtered by category
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage.isNotEmpty
                          ? Center(
                              child: Text(
                                _errorMessage,
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                            )
                          : _filteredProducts().isEmpty
                              ? Center(
                                  child: Text(
                                    'Nenhum produto encontrado.',
                                    style: TextStyle(
                                      color: theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        2, // 2 itens por linha para melhor visualização
                                    mainAxisSpacing:
                                        12, // Reduz espaço vertical
                                    crossAxisSpacing:
                                        12, // Reduz espaço horizontal
                                    childAspectRatio:
                                        0.65, // Ajusta proporção para evitar overflow
                                  ),
                                  itemCount: _filteredProducts().length,
                                  itemBuilder: (context, index) {
                                    final product = _filteredProducts()[index];
                                    return ProductCard(
                                      product: product,
                                      onAddToCart: () => _addToCart(product),
                                      onLongPress: () =>
                                          _showProductDetails(product),
                                    );
                                  },
                                ),
                ),
                const SizedBox(height: 24),

                // Footer simples e com a identidade visual
                Container(
                  width: double.infinity,
                  color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/imagens/LogoFeiraGreen.png',
                        height: 40,
                        color: const Color(0xFF2E7D32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '© 2025 FeiraGreen. Todos os direitos reservados.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white70 : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.facebook,
                            color: isDarkMode ? Colors.white70 : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.camera_alt,
                            color: isDarkMode ? Colors.white70 : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.phone,
                            color: isDarkMode ? Colors.white70 : Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Product> _filteredProducts() {
    if (_selectedCategory == 'Todos') {
      return _products;
    }
    return _products.where((product) {
      return product.categoria.toLowerCase() == _selectedCategory.toLowerCase();
    }).toList();
  }
}
