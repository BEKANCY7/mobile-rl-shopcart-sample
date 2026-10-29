# Task: Fix ShopCart checkout rules

## Platform
- Cross-platform mobile — Flutter / Dart

## Difficulty
Medium

## Summary
`ShopCart` is a small Flutter shopping-cart sample. Four business rules in
`lib/cart/cart_service.dart` are implemented incorrectly. Restore the intended
behavior so every automated test passes.

## Intended business rules
1. **Merge quantities on add** — Calling `addItem` for a SKU that is already in
   the cart must **add** the new quantity to the existing line, not replace it.
2. **Zero quantity removes the line** — `setQuantity(id, 0)` must remove that
   line from the cart (no zero-quantity ghost lines).
3. **Promo minimum subtotal** — Known promo codes (`SAVE10`, `FLAT5`) must be
   rejected (`applyPromoCode` returns `false`, promo left unset) when the cart
   subtotal is below the promo’s `minSubtotal`. While a promo is active, the
   `discount` getter must also yield `0` if the current subtotal falls below
   that minimum.
4. **Free shipping after discount** — Shipping is `$7.99` by default and becomes
   `$0` only when `(subtotal - discount) >= freeShippingThreshold` (default
   `$50`). Do **not** use the raw pre-discount subtotal for this check.

## Promo catalog (already defined)
| Code   | Type    | Value | Min subtotal |
|--------|---------|-------|--------------|
| SAVE10 | percent | 10%   | 30           |
| FLAT5  | flat    | $5    | 20           |

## Constraints
- Change only what is required to satisfy the rules above.
- Keep the public API of `CartService` stable (`addItem`, `setQuantity`,
  `applyPromoCode`, `subtotal`, `discount`, `shipping`, `total`, etc.).
- Do not modify the test files under `test/`.

## Verification
From the `app/` directory:

```bash
flutter test
```

Or from the repository root:

```bash
./verify.sh
```

All tests must pass with exit code 0.
