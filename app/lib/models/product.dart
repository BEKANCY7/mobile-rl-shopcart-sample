class Product {
  const Product({
    required this.id,
    required this.name,
    required this.unitPrice,
  });

  final String id;
  final String name;
  final double unitPrice;
}

class Catalog {
  static const products = <Product>[
    Product(id: 'sku-mug', name: 'Ceramic Mug', unitPrice: 12.0),
    Product(id: 'sku-tee', name: 'Cotton Tee', unitPrice: 28.0),
    Product(id: 'sku-bag', name: 'Tote Bag', unitPrice: 36.0),
    Product(id: 'sku-hat', name: 'Cap', unitPrice: 18.0),
  ];

  static Product byId(String id) =>
      products.firstWhere((p) => p.id == id);
}
