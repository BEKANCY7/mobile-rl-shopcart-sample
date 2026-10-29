# Reference solution

## Root causes
All defects live in `app/lib/cart/cart_service.dart`:

1. **`addItem`** assigned `quantity` instead of `existing.quantity + quantity`.
2. **`setQuantity`** wrote quantity `0` into the list instead of removing the line.
3. **`applyPromoCode` / `discount`** never consulted `PromoCode.minSubtotal`.
4. **`shipping`** compared raw `subtotal` to the free-shipping threshold instead of
   `subtotal - discount`.

## Apply
```bash
cp solution/cart_service.dart app/lib/cart/cart_service.dart
# or
patch -p0 < solution/fix.patch
```

## Verify
```bash
./verify.sh
```
