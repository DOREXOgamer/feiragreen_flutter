import 'package:flutter/material.dart';

class ItemScreen extends StatelessWidget {
  final String nome;
  final String descricao;
  final double preco;
  final String imagemUrl;

  const ItemScreen({
    super.key,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagemUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nome),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imagemUrl),
            const SizedBox(height: 16),
            Text(
              nome,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ ${preco.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              descricao,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para adicionar ao carrinho
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
              ),
              child: const Text('Adicionar ao Carrinho'),
            ),
          ],
        ),
      ),
    );
  }
}
