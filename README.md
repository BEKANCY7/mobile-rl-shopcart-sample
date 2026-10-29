# Mobile RL Sample — Flutter ShopCart

Representative **Reinforcement Learning / agentic coding** task for mobile
engineering evaluation (Flutter / Dart).

This package is original work prepared as a public sample for Adzzat-style
mobile RL task sourcing. It includes:

| Artifact | Path |
|----------|------|
| Agent-facing instructions | [`TASK.md`](TASK.md) |
| Task metadata | [`metadata.json`](metadata.json) |
| Starter app (intentionally buggy) | [`app/`](app/) |
| Automated verifier | [`verify.sh`](verify.sh) |
| Docker environment | [`Dockerfile`](Dockerfile) |
| Reference solution + patch | [`solution/`](solution/) |

## Quick start (local)

```bash
# Requires Flutter SDK >= 3.5
./verify.sh
```

Expected on the **starter** (buggy) codebase: tests **fail**.

Apply the reference fix, then re-run:

```bash
cp solution/cart_service.dart app/lib/cart/cart_service.dart
./verify.sh
```

Expected after the fix: `VERIFY_OK` and exit code `0`.

## Docker

```bash
docker build -t shopcart-rl-sample .
# Starter (should fail):
docker run --rm shopcart-rl-sample
```

## Task shape

- **Type:** bug identification & repair  
- **Platform:** Cross-platform (Flutter)  
- **Language:** Dart  
- **Difficulty:** Medium  
- **Signal:** `flutter test` (unit + widget)

The agent must repair cart merge, zero-quantity removal, promo minimums, and
post-discount free-shipping logic without editing tests.

## License
Sample code is provided for evaluation / demonstration. Do not reuse as
production shopping-cart logic without review.
