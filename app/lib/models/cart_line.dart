class CartLine {
  const CartLine({
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });

  final String productId;
  final String name;
  final double unitPrice;
  final int quantity;

  double get lineTotal => unitPrice * quantity;

  CartLine copyWith({int? quantity}) {
    return CartLine(
      productId: productId,
      name: name,
      unitPrice: unitPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}
