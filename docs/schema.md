# Schema — CPG promo insights lab

## Join keys

| Key | Type note |
|-----|-----------|
| `household_id` | Text/int ID — keep as VARCHAR in staging to avoid silent casts |
| `product_id` | Product SKU key |
| `basket_id` | Trip / checkout ID |
| `campaign_id` | Marketing campaign |
| `coupon_upc` | Coupon identifier (many products per UPC × campaign) |

## ER sketch (logical)

```text
demographics (partial) ──< households >── transactions >── products
                              │
                              ├── campaigns >── campaign_descriptions
                              │
                              └── coupon_redemptions >── coupons >── products
```

## Grains

| Object | Grain |
|--------|-------|
| `raw_transactions` / `stg_transactions` | 1 row = 1 basket line |
| `raw_products` / `stg_products` | 1 row = 1 product |
| `raw_demographics` / `stg_demographics` | 1 row = 1 household (subset only) |
| `mart_line_item` | Trusted line + product (+ demo flags) |
| `mart_basket` | 1 row = 1 basket |

## Metric definitions (used in SQL comments)

- **Promo line:** `retail_disc > 0 OR coupon_disc > 0` (retailer and/or coupon discount on the line).
- **Demo-known sales:** lines whose `household_id` appears in demographics.
- **Campaign funnel:** targeted households (`campaigns`) → redeemers (`coupon_redemptions`) by `campaign_type`.
- Never claim causal “lift” without an explicit holdout design — this lab reports **associations and coverage**, not ROI causation.
