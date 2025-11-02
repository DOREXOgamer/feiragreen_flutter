class CartItem {
  final String? id;
  final String userId;
  final String productId;
  final int quantity;
  final String createdAt;

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
      'createdAt': createdAt,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      userId: map['userId'],
      productId: map['productId'],
      quantity: map['quantity'],
      createdAt: map['createdAt'],
    );
  }
}
