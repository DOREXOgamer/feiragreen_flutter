import 'dart:math';
import 'package:flutter/material.dart';
import 'package:feiragreen_flutter/infrastructure/services/firebase_service.dart';
import 'package:feiragreen_flutter/domain/entities/product.dart';
import 'package:feiragreen_flutter/application/services/logger_service.dart';

class CheckoutScreen extends StatefulWidget {
  final String userId;

  const CheckoutScreen({super.key, required this.userId});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _cepController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();

  bool _isLoading = false;
  double _total = 0.0;
  String _paymentMethod = 'Pix';

  List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _enderecoController.dispose();
    _cepController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      final firebaseService = FirebaseService();

      final cartItemsData = await firebaseService.getCartItemsByUser(widget.userId);
      final allProducts = await firebaseService.getAllProducts();

      List<Map<String, dynamic>> combinedCartItems = [];
      double total = 0.0;

      for (var cartItem in cartItemsData) {
        final product = allProducts.firstWhere(
          (p) => p.id == cartItem.productId,
          orElse: () => Product(
            id: cartItem.productId,
            userId: '0',
            nome: 'Produto não encontrado',
            preco: 0.0,
            descricao: '',
            imageUrl: null,
            categoria: 'Outros',
          ),
        );

        final itemTotal = product.preco * cartItem.quantity;
        total += itemTotal;

        combinedCartItems.add({
          'id': cartItem.id,
          'productId': product.id,
          'nome': product.nome,
          'preco': product.preco,
          'quantidade': cartItem.quantity,
          'total': itemTotal,
          'imageUrl': product.imageUrl,
        });
      }

      setState(() {
        _cartItems = combinedCartItems;
        _total = total;
        _isLoading = false;
      });

      LoggerService.instance.info('Checkout data loaded',
          tag: 'CheckoutScreen', data: {'items': _cartItems.length, 'total': _total});
    } catch (e) {
      setState(() => _isLoading = false);
      LoggerService.instance.error('Erro ao carregar dados de checkout',
          tag: 'CheckoutScreen', error: e);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao carregar dados: $e')));
    }
  }

  Future<void> _simulatePurchase() async {
    if (!_formKey.currentState!.validate()) return;
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Carrinho vazio. Adicione itens antes.')),
      );
      return;
    }

    try {
      LoggerService.instance.info('Simular compra', tag: 'CheckoutScreen', data: {
        'userId': widget.userId,
        'paymentMethod': _paymentMethod,
        'total': _total,
      });

      final firebaseService = FirebaseService();
      await firebaseService.clearUserCart(widget.userId);

      final orderId = 'FG-${Random().nextInt(900000) + 100000}';

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Pedido confirmado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Número do pedido: $orderId'),
              const SizedBox(height: 8),
              Text('Total: R\$ ${_total.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Forma de pagamento: $_paymentMethod'),
              const SizedBox(height: 12),
              const Text('Obrigado pela compra!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      LoggerService.instance.error('Erro ao simular compra',
          tag: 'CheckoutScreen', error: e);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao finalizar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Simulado'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumo do Carrinho',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._cartItems.map((item) => Card(
                        child: ListTile(
                          leading: item['imageUrl'] != null
                              ? Image.network(item['imageUrl'], width: 48, height: 48, fit: BoxFit.cover)
                              : const Icon(Icons.shopping_bag),
                          title: Text(item['nome'] ?? 'Produto'),
                          subtitle: Text('Qtd: ${item['quantidade']} • R\$ ${item['preco'].toStringAsFixed(2)}'),
                          trailing: Text('R\$ ${(item['total'] as double).toStringAsFixed(2)}'),
                        ),
                      )),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('R\$ ${_total.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Divider(),
                  const SizedBox(height: 8),

                  const Text(
                    'Dados do Comprador',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nomeController,
                          decoration: const InputDecoration(labelText: 'Nome completo'),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _enderecoController,
                          decoration: const InputDecoration(labelText: 'Endereço'),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o endereço' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _cepController,
                          decoration: const InputDecoration(labelText: 'CEP'),
                          keyboardType: TextInputType.number,
                          validator: (v) => (v == null || v.trim().length < 8) ? 'CEP inválido' : null,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _cidadeController,
                                decoration: const InputDecoration(labelText: 'Cidade'),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe a cidade' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 80,
                              child: TextFormField(
                                controller: _estadoController,
                                decoration: const InputDecoration(labelText: 'UF'),
                                textCapitalization: TextCapitalization.characters,
                                validator: (v) => (v == null || v.trim().length != 2) ? 'UF' : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Forma de Pagamento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _paymentMethod,
                    items: const [
                      DropdownMenuItem(value: 'Pix', child: Text('Pix')),
                      DropdownMenuItem(value: 'Cartão', child: Text('Cartão (simulado)')),
                      DropdownMenuItem(value: 'Boleto', child: Text('Boleto')),
                    ],
                    onChanged: (v) => setState(() => _paymentMethod = v ?? 'Pix'),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _simulatePurchase,
                      icon: const Icon(Icons.check_circle),
                      label: const Text(
                        'Simular Compra',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

