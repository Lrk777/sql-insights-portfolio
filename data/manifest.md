# Data manifest — Complete Journey (CPG promo lab)

**Pinned source (this build):** [bradleyboehmke/completejourney](https://github.com/bradleyboehmke/completejourney) `data/` (processed Complete Journey / 84.51° panel)  
**Upstream:** [Dunnhumby Source Files — Complete Journey](https://www.dunnhumby.com/source-files/)  
**Pin date:** 2026-11-03  
**Grain:** ~2,469 households · ~1.47M transaction lines · ~1 year (2017 panel in this extract)

## Files expected under `data/raw/` (gitignored)

| File | Rows (this pin) | Role |
|------|-----------------|------|
| `transactions.csv` | 1,469,307 | Basket lines: HH, store, basket, product, qty, sales, discounts, week, timestamp |
| `products.csv` | 92,331 | Product hierarchy: department, category, type, brand, pack size |
| `demographics.csv` | 801 | Partial HH attributes (age, income, kids, …) |
| `campaigns.csv` | 6,589 | Household × campaign targeting |
| `campaign_descriptions.csv` | 27 | Campaign type + start/end dates |
| `coupons.csv` | 116,204 | Coupon UPC × product × campaign |
| `coupon_redemptions.csv` | 2,102 | Redemption events |
| `promotions.csv` | 20,940,529 | Optional: display/mailer support by product × store × week |

Binary sources before CSV export (also gitignored): `*.rda`, `transactions.rds`, `promotions.rds`.

## Reproduce download

See `scripts/download_notes.md` or run:

```bash
python3 scripts/download_data.py
```

## License reminder

Non-commercial / educational. **Do not commit raw files.** Attribute Dunnhumby / 84.51°. Details: `DATA_LICENSE.md`.
