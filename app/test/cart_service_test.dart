import 'package:flutter_test/flutter_test.dart';
import 'package:shopcart/cart/cart_service.dart';
import 'package:shopcart/models/product.dart';

void main() {
  late CartService cart;
  final mug = Catalog.byId('sku-mug'); // 12
  final tee = Catalog.byId('sku-tee'); // 28
  final bag = Catalog.byId('sku-bag'); // 36

  setUp(() {
    cart = CartService(shippingFee: 7.99, freeShippingThreshold: 50);
  });

  group('addItem', () {
    test('increments quantity when the same SKU is added again', () {
      cart.addItem(mug, quantity: 1);
      cart.addItem(mug, quantity: 2);

      expect(cart.lines, hasLength(1));
      expect(cart.lines.single.quantity, 3);
      expect(cart.subtotal, 36.0);
    });

    test('keeps distinct SKUs on separate lines', () {
      cart.addItem(mug);
      cart.addItem(tee);

      expect(cart.lines, hasLength(2));
      expect(cart.subtotal, 40.0);
    });
  });

  group('setQuantity', () {
    test('removes the line when quantity is set to 0', () {
      cart.addItem(mug, quantity: 2);
      cart.setQuantity(mug.id, 0);

      expect(cart.lines, isEmpty);
      expect(cart.subtotal, 0);
    });

    test('updates quantity for an existing line', () {
      cart.addItem(tee, quantity: 1);
      cart.setQuantity(tee.id, 4);

      expect(cart.lines.single.quantity, 4);
      expect(cart.subtotal, 112.0);
    });
  });

  group('promo codes', () {
    test('rejects SAVE10 when subtotal is below minSubtotal (30)', () {
      cart.addItem(mug); // 12
      final ok = cart.applyPromoCode('SAVE10');

      expect(ok, isFalse);
      expect(cart.appliedPromo, isNull);
      expect(cart.discount, 0);
    });

    test('applies SAVE10 when subtotal meets minSubtotal', () {
      cart.addItem(tee); // 28
      cart.addItem(mug); // 12 -> subtotal 40
      final ok = cart.applyPromoCode('save10');

      expect(ok, isTrue);
      expect(cart.discount, closeTo(4.0, 0.001)); // 10% of 40
      expect(cart.total, closeTo(40.0 - 4.0 + 7.99, 0.001));
    });

    test('rejects FLAT5 below minSubtotal (20)', () {
      cart.addItem(mug); // 12
      expect(cart.applyPromoCode('FLAT5'), isFalse);
      expect(cart.discount, 0);
    });

    test('applies FLAT5 when eligible', () {
      cart.addItem(tee); // 28
      expect(cart.applyPromoCode('FLAT5'), isTrue);
      expect(cart.discount, 5.0);
    });
  });

  group('shipping', () {
    test('charges shipping when post-discount total is below threshold', () {
      // subtotal 48, SAVE10 => discount 4.8, post-discount 43.2 < 50
      cart.addItem(bag); // 36
      cart.addItem(mug); // 12 -> 48
      expect(cart.applyPromoCode('SAVE10'), isTrue);

      expect(cart.subtotal, 48.0);
      expect(cart.discount, closeTo(4.8, 0.001));
      expect(cart.shipping, 7.99);
      expect(cart.total, closeTo(48.0 - 4.8 + 7.99, 0.001));
    });

    test('waives shipping when post-discount amount reaches threshold', () {
      cart.addItem(bag); // 36
      cart.addItem(tee); // 28 -> 64
      expect(cart.shipping, 0);
      expect(cart.total, 64.0);
    });

    test('free shipping uses amount after discount, not raw subtotal', () {
      // Raw subtotal 54 >= 50, but SAVE10 leaves 48.6 < 50 → must charge shipping.
      cart.addItem(Catalog.byId('sku-hat')); // 18
      cart.addItem(bag); // 36 -> 54
      expect(cart.subtotal, 54.0);
      expect(cart.applyPromoCode('SAVE10'), isTrue);
      expect(cart.discount, closeTo(5.4, 0.001));
      expect(cart.shipping, 7.99);
    });
  });
}
