import 'package:flutter/material.dart';
import 'package:feiragreen_flutter/domain/entities/product.dart';

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

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        height: 120, // Altura fixa para evitar problemas de layout
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 120,
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
        height: 120, // Altura fixa para evitar problemas de layout
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 120,
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
    final theme = Theme.of(context);

    return Card(
      color: theme.cardTheme.color,
      elevation: 2,
      margin: const EdgeInsets.all(8), // Adiciona margem para evitar overflow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        // Usar InkWell em vez de GestureDetector para melhor feedback visual
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          // Adiciona constraints para evitar overflow
          constraints: const BoxConstraints(minWidth: 150, maxWidth: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize:
                MainAxisSize.min, // Evita que a coluna expanda infinitamente
            children: [
              // Imagem do produto
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? _buildProductImage(product.imageUrl!)
                    : Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
              ),
              // Informações do produto
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.nome,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      maxLines: 2, // Permite mais linhas para evitar overflow
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'R\$${product.preco.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      // Adiciona SizedBox para controlar o tamanho do botão
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text(
                          'Adicionar',
                          style: TextStyle(fontSize: 12, color: Colors.white),
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
    );
  }
}
