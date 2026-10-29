import 'package:flutter/material.dart';

import 'cart/cart_service.dart';
import 'models/product.dart';
import 'models/promo.dart';

void main() {
  runApp(const ShopCartApp());
}

class ShopCartApp extends StatelessWidget {
  const ShopCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopCart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
      ),
      home: const CartPage(),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key, this.cart});

  final CartService? cart;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final CartService _cart;
  final _promoController = TextEditingController();
  String? _promoMessage;

  @override
  void initState() {
    super.initState();
    _cart = widget.cart ?? CartService();
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _add(Product product) {
    _cart.addItem(product);
    _refresh();
  }

  void _applyPromo() {
    final ok = _cart.applyPromoCode(_promoController.text);
    setState(() {
      _promoMessage = ok
          ? 'Applied ${_cart.appliedPromo!.code}'
          : 'Promo not valid for this cart';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ShopCart Sample')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Text('Catalog', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...Catalog.products.map(
            (p) => ListTile(
              key: Key('catalog-${p.id}'),
              title: Text(p.name),
              subtitle: Text('\$${p.unitPrice.toStringAsFixed(2)}'),
              trailing: IconButton(
                key: Key('add-${p.id}'),
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () => _add(p),
              ),
            ),
          ),
          const Divider(height: 32),
          Text('Cart', style: Theme.of(context).textTheme.titleLarge),
          if (_cart.lines.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Cart is empty'),
            ),
          ..._cart.lines.map(
            (line) => ListTile(
              key: Key('line-${line.productId}'),
              title: Text(line.name),
              subtitle: Text('Qty ${line.quantity}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: Key('dec-${line.productId}'),
                    onPressed: () {
                      _cart.setQuantity(line.productId, line.quantity - 1);
                      _refresh();
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  IconButton(
                    key: Key('inc-${line.productId}'),
                    onPressed: () {
                      _cart.setQuantity(line.productId, line.quantity + 1);
                      _refresh();
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 32),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('promo-input'),
                  controller: _promoController,
                  decoration: const InputDecoration(
                    labelText: 'Promo code',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                key: const Key('promo-apply'),
                onPressed: _applyPromo,
                child: const Text('Apply'),
              ),
            ],
          ),
          if (_promoMessage != null) ...[
            const SizedBox(height: 8),
            Text(_promoMessage!, key: const Key('promo-message')),
          ],
          const SizedBox(height: 16),
          _MoneyRow(label: 'Subtotal', value: _cart.subtotal),
          _MoneyRow(label: 'Discount', value: _cart.discount),
          _MoneyRow(label: 'Shipping', value: _cart.shipping),
          _MoneyRow(label: 'Total', value: _cart.total, emphasize: true),
          if (_cart.appliedPromo != null)
            Text(
              'Promo: ${_cart.appliedPromo!.code}'
              '${_cart.appliedPromo!.type == PromoType.percent ? ' (${_cart.appliedPromo!.value.toInt()}%)' : ''}',
              key: const Key('active-promo'),
            ),
        ],
        ),
      ),
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final double value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            '\$${value.toStringAsFixed(2)}',
            key: Key('money-$label'),
            style: style,
          ),
        ],
      ),
    );
  }
}
