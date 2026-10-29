import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopcart/cart/cart_service.dart';
import 'package:shopcart/main.dart';
import 'package:shopcart/models/product.dart';

void main() {
  testWidgets('adding the same catalog item twice shows quantity 2',
      (tester) async {
    final cart = CartService();
    await tester.pumpWidget(MaterialApp(home: CartPage(cart: cart)));

    await tester.tap(find.byKey(const Key('add-sku-mug')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('add-sku-mug')));
    await tester.pump();

    expect(find.text('Qty 2'), findsOneWidget);
    final subtotal = tester.widget<Text>(find.byKey(const Key('money-Subtotal')));
    expect(subtotal.data, '\$24.00');
  });

  testWidgets('decrementing to zero removes the cart line', (tester) async {
    final cart = CartService();
    cart.addItem(Catalog.byId('sku-mug'));
    await tester.pumpWidget(MaterialApp(home: CartPage(cart: cart)));

    await tester.tap(find.byKey(const Key('dec-sku-mug')));
    await tester.pump();

    expect(find.byKey(const Key('line-sku-mug')), findsNothing);
    expect(find.text('Cart is empty'), findsOneWidget);
  });
}
