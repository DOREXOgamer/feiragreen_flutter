class CartItem {
  final String? id;
  final String userId;
  final String productId;
  final int quantity;
  final DateTime createdAt;

  CartItem({
    this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      userId: map['userId'],
      productId: map['productId'],
      quantity: map['quantity'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  CartItem copyWith({
    String? id,
    String? userId,
    String? productId,
    int? quantity,
    DateTime? createdAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
