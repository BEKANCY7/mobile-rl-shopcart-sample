enum PromoType { percent, flat }

class PromoCode {
  const PromoCode({
    required this.code,
    required this.type,
    required this.value,
    this.minSubtotal = 0,
  });

  final String code;
  final PromoType type;

  /// Percent: 0–100. Flat: currency amount.
  final double value;

  /// Promo is valid only when cart subtotal is >= this amount.
  final double minSubtotal;
}

class PromoCatalog {
  static const codes = <String, PromoCode>{
    'SAVE10': PromoCode(
      code: 'SAVE10',
      type: PromoType.percent,
      value: 10,
      minSubtotal: 30,
    ),
    'FLAT5': PromoCode(
      code: 'FLAT5',
      type: PromoType.flat,
      value: 5,
      minSubtotal: 20,
    ),
  };

  static PromoCode? lookup(String raw) {
    final key = raw.trim().toUpperCase();
    return codes[key];
  }
}
