import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:feiragreen_flutter/presentation/utils/permission_handler.dart';
import 'package:feiragreen_flutter/presentation/utils/image_utils.dart';
import 'package:feiragreen_flutter/infrastructure/services/firebase_service.dart';
import 'package:feiragreen_flutter/domain/entities/product.dart';
import 'package:feiragreen_flutter/application/services/logger_service.dart';

class ProductManagementScreen extends StatefulWidget {
  final String userId;

  const ProductManagementScreen({super.key, required this.userId});

  @override
  State<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  List<Product> _products = [];
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final firebaseService = FirebaseService();
    final productsData = await firebaseService.getProductsByUser(widget.userId);
    setState(() {
      _products = productsData;
    });
  }

  Future<void> _pickImage() async {
    // Solicitar permissões necessárias para o image picker
    final hasPermission = await PermissionUtils.requestImagePickerPermissions();

    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Permissões necessárias para acessar imagens'),
          action: SnackBarAction(
            label: 'Configurações',
            onPressed: () => PermissionUtils.openAppSettings(),
          ),
        ),
      );
      return;
    }

    final image = await ImageUtils.pickImageOnly();
    if (image == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleção cancelada ou arquivo não é imagem')),
      );
      LoggerService.instance.warn('Seleção de imagem inválida ou cancelada', tag: 'ProductManagement');
      return;
    }

    setState(() {
      _selectedImage = image;
    });
    LoggerService.instance.info('Imagem selecionada',
        tag: 'ProductManagement', data: {'path': image.path});
  }

  Future<String?> _saveImageToAppDir(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final productImagesDir = Directory('${appDir.path}/product_images');
    if (!await productImagesDir.exists()) {
      await productImagesDir.create(recursive: true);
    }
    final fileName = path.basename(image.path);
    final savedImage = await image.copy('${productImagesDir.path}/$fileName');
    return savedImage.path;
  }

  Future<void> _showProductDialog({Product? product}) async {
    final nomeController = TextEditingController(text: product?.nome ?? '');
    final precoController =
        TextEditingController(text: product?.preco.toString() ?? '');
    final descricaoController =
        TextEditingController(text: product?.descricao ?? '');
    String selectedCategoria = product?.categoria ?? 'Outros';
    _selectedImage = product?.imageUrl != null && product!.imageUrl!.isNotEmpty
        ? File(product.imageUrl!)
        : null;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Adicionar Produto' : 'Editar Produto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: precoController,
                  decoration: const InputDecoration(labelText: 'Preço'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  controller: descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                const SizedBox(height: 10),
                _selectedImage != null
                    ? Image.file(_selectedImage!,
                        width: 100, height: 100, fit: BoxFit.cover)
                    : const Icon(Icons.image_not_supported, size: 100),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Selecionar Imagem'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategoria,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: const [
                    DropdownMenuItem(value: 'Fruta', child: Text('Frutas')),
                    DropdownMenuItem(value: 'Verdura', child: Text('Verduras')),
                    DropdownMenuItem(
                        value: 'Hortaliça', child: Text('Hortaliças')),
                    DropdownMenuItem(value: 'Legume', child: Text('Legumes')),
                    DropdownMenuItem(value: 'Outros', child: Text('Outros')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategoria = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nome = nomeController.text.trim();
                final preco =
                    double.tryParse(precoController.text.trim()) ?? 0.0;
                final descricao = descricaoController.text.trim();

                if (nome.isEmpty || preco <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Nome e preço são obrigatórios e preço deve ser maior que zero')),
                  );
                  return;
                }

                String? imagePath = product?.imageUrl;
                if (_selectedImage != null) {
                  imagePath = await _saveImageToAppDir(_selectedImage!);
                }

                final newProduct = Product(
                  id: product?.id,
                  userId: widget.userId,
                  nome: nome,
                  preco: preco,
                  descricao: descricao,
                  imageUrl: imagePath,
                  categoria: selectedCategoria,
                );

                final firebaseService = FirebaseService();
                await firebaseService.setProduct(newProduct);

                await _loadProducts();
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(String id) async {
    final firebaseService = FirebaseService();
    await firebaseService.deleteProduct(id);
    await _loadProducts();
  }

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product.nome),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildProductImage(product.imageUrl!, height: 150),
                  ),
                const SizedBox(height: 16),
                Text(
                  'Preço: R\$ ${product.preco.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                if (product.descricao != null && product.descricao!.isNotEmpty)
                  Text(
                    'Descrição: ${product.descricao}',
                    style: const TextStyle(fontSize: 14),
                  ),
                const SizedBox(height: 8),
                Text(
                  'Categoria: ${product.categoria}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'ID do Produto: ${product.id}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
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
            child: const Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          );
        },
      );
    } else if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height ?? 150,
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
      // Local file
      return Image.file(
        File(imageUrl),
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height ?? 150,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Produtos'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onLongPress: () => _showProductDetails(product),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: product.imageUrl != null &&
                              product.imageUrl!.isNotEmpty
                          ? _buildProductImage(product.imageUrl!,
                              height: double.infinity)
                          : Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                    ),
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'R\$ ${product.preco.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blue, size: 20),
                            onPressed: () =>
                                _showProductDialog(product: product),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red, size: 20),
                            onPressed: () => _deleteProduct(product.id!),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        onPressed: () => _showProductDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
