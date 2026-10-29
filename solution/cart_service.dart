import '../models/cart_line.dart';
import '../models/product.dart';
import '../models/promo.dart';

/// In-memory shopping cart used by the ShopCart sample UI.
class CartService {
  CartService({this.shippingFee = 7.99, this.freeShippingThreshold = 50.0});

  final double shippingFee;
  final double freeShippingThreshold;

  final List<CartLine> _lines = [];
  PromoCode? _promo;

  List<CartLine> get lines => List.unmodifiable(_lines);
  PromoCode? get appliedPromo => _promo;

  double get subtotal =>
      _lines.fold(0.0, (sum, line) => sum + line.lineTotal);

  double get discount {
    final promo = _promo;
    if (promo == null) return 0;
    if (subtotal < promo.minSubtotal) return 0;
    switch (promo.type) {
      case PromoType.percent:
        return subtotal * (promo.value / 100.0);
      case PromoType.flat:
        return promo.value.clamp(0, subtotal).toDouble();
    }
  }

  double get shipping {
    final afterDiscount = subtotal - discount;
    if (afterDiscount >= freeShippingThreshold) return 0;
    return shippingFee;
  }

  double get total => subtotal - discount + shipping;

  void addItem(Product product, {int quantity = 1}) {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity', 'must be > 0');
    }

    final index = _lines.indexWhere((l) => l.productId == product.id);
    if (index >= 0) {
      final existing = _lines[index];
      _lines[index] = existing.copyWith(quantity: existing.quantity + quantity);
      return;
    }

    _lines.add(
      CartLine(
        productId: product.id,
        name: product.name,
        unitPrice: product.unitPrice,
        quantity: quantity,
      ),
    );
  }

  void setQuantity(String productId, int quantity) {
    if (quantity < 0) {
      throw ArgumentError.value(quantity, 'quantity', 'must be >= 0');
    }
    final index = _lines.indexWhere((l) => l.productId == productId);
    if (index < 0) {
      throw StateError('Product $productId is not in the cart');
    }
    if (quantity == 0) {
      _lines.removeAt(index);
      return;
    }
    _lines[index] = _lines[index].copyWith(quantity: quantity);
  }

  void removeItem(String productId) {
    _lines.removeWhere((l) => l.productId == productId);
  }

  /// Applies a promo by code string. Returns false if the code is unknown
  /// or does not meet the minimum subtotal requirement.
  bool applyPromoCode(String rawCode) {
    final promo = PromoCatalog.lookup(rawCode);
    if (promo == null) return false;
    if (subtotal < promo.minSubtotal) return false;
    _promo = promo;
    return true;
  }

  void clearPromo() => _promo = null;

  void clear() {
    _lines.clear();
    _promo = null;
  }
}
