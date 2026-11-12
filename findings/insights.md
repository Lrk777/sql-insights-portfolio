# Insights — Complete Journey CPG SQL lab

All numbers below come from DuckDB runs of `sql/01_dq_checks.sql` and `sql/10_q*.sql` on the 2026-11-03 pin (`data/manifest.md`). Re-run `python3 scripts/run_pipeline.py --export-samples` to refresh.

## Data quality first

| Check | Result |
|-------|--------|
| Transaction lines | 1,469,307 |
| Distinct purchasing households | 2,469 |
| Households with demographics | 801 (32.4% of purchasing HH) |
| Orphan product lines | 4,836 lines · ~$172.57 sales |
| Products missing category | 540 |
| Avg products per coupon UPC×campaign | ~97.1 (fan-out trap) |
| Zero/negative sales lines | 11,226 |
| Redemptions missing coupon or target match | 0 in this extract |

## Business-style findings

1. **Adequacy ≠ row coverage.** Demo-known HH are 32.4% of shoppers but **57.1% of sales** ($2.62M of $4.60M). Any income/kids story must say that out loud.
2. **Promo intensity is category-specific.** FUEL shows **94%** of sales $ on promo-flagged lines; packaged seafood / meat also land in a “high_promo_reliance” band. GROCERY dominates dollars but is not the most promo-skewed department.
3. **Campaign type changes redemption behaviour.** Among targeted households, Type A redeems at **24.9%**, Type B **11.7%**, Type C **7.6%**. That is a coverage finding — not yet incremental lift.
4. **Repeat grocery trips are frequent for early cohorts.** Jan-2017 first-grocery HH show median **3 days** between grocery baskets (avg ~5.9) — useful ops context for promo timing discussions.
5. **Watchlist:** MISCELLANEOUS is a top-sales department with **~29%** of lines missing `product_category` — fix hierarchy before category reviews.

## What we deliberately do *not* claim

- “Campaign X lifted sales by Y%” without a holdout / pre-post design and cost file  
- That demo-based segments represent all shoppers  
- Endorsement by Dunnhumby, 84.51°, or any retailer  

## Interview soundbite

“Before arguing promo lift, I measured whether the panel could support the question: demographics only cover a third of households but over half of sales, coupon tables fan out ~97 products per offer, and some high-sales departments are missing category labels. Then I compared campaign redemption rates by type and promo reliance by department with CTEs and windows in DuckDB.”
