class Product {
  final String? id;
  final String userId;
  final String nome;
  final double preco;
  final String? descricao;
  final String? imageUrl;
  final String categoria;

  Product({
    this.id,
    required this.userId,
    required this.nome,
    required this.preco,
    this.descricao,
    this.imageUrl,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'nome': nome,
      'preco': preco,
      'descricao': descricao,
      'imageUrl': imageUrl,
      'categoria': categoria,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      userId: map['userId'],
      nome: map['nome'],
      preco: map['preco'],
      descricao: map['descricao'],
      imageUrl: map['imageUrl'],
      categoria: map['categoria'] ?? 'Outros',
    );
  }
}
