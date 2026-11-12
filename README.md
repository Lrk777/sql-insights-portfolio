# CPG Category & Promo Insights — SQL Lab

SQL-first portfolio project for **BI / insights / RGM / commercial analytics** roles.

## Problem

How do category sales, promotions, and coupon campaigns behave in a multi-table grocery panel — and where is the data too incomplete to claim “lift” honestly?

## Why this project

Built for GTA new-grad **CPG / RGM / category insights** talk-tracks (promo intensity, basket behaviour, coupon DQ traps). Health-system analytics stay with my York Data Science Capstone (Grace Hospital / Ontario home care). This repo shows **SQL versatility on commercial data**.

## Stack

- **DuckDB** + SQL (CTEs, windows, joins, `CASE`, anti-joins, DQ tables)
- Markdown findings + sample query outputs
- Thin Python runner only to execute `.sql` files

## Data

- **Source:** Dunnhumby / 84.51° **Complete Journey** panel (via [completejourney](https://github.com/bradleyboehmke/completejourney) extract)
- **Pin:** ~2,469 households · **1,469,307** transaction lines · campaigns / coupons / partial demographics
- **License:** non-commercial / educational — attribute Dunnhumby / 84.51°; **raw CSVs not redistributed** (see `DATA_LICENSE.md`, `data/manifest.md`)

## Method

`raw → DQ checks → staging views → line/basket marts → 10 insight queries`

Promo lines are defined as `retail_disc > 0 OR coupon_disc > 0`. Campaign “success” starts with **targeting → redemption coverage**, not causal ROI (no trade-spend cost file).

## Reproduce

```bash
python3 -m pip install duckdb pyreadr pandas
python3 scripts/download_data.py          # writes gitignored data/raw/*.csv
python3 scripts/run_pipeline.py --export-samples
```

SQL order is listed in `sql/90_run_all.sql`.

## Key findings (from this pin’s query runs)

1. **Demographics cover only 32.4% of purchasing households — but 57.1% of sales $.** Cohort KPIs on demos alone will systematically overweight heavier shoppers (`10_q01`).
2. **4,836 transaction lines (≈$173 sales) have orphan `product_id`s**; coupon redemptions cleanly match coupon + campaign target tables in this extract (`11_q02`).
3. **GROCERY is ~50.4% of sales** with 99.6% household penetration; FUEL is only ~7.2% of sales but **94% of FUEL sales $ sit on promo-flagged lines** — a classic “was the promo real, or is the metric definition the story?” interview beat (`12_q03`, `13_q04`).
4. **Campaign redemption rates differ sharply by type:** Type A **24.9%** of targeted HH redeem vs Type B **11.7%** vs Type C **7.6%** (`14_q05`).
5. **Coupon fan-out averages ~97 products per coupon UPC×campaign** — joining coupons to baskets without aggregation will explode rows (`01_dq_checks` DQ10).
6. **MISCELLANEOUS** ranks in the top sales departments yet has **~29% of lines missing category** — a data-adequacy watch item, not a “bad category” claim (`19_q10`).

More detail: [`findings/insights.md`](findings/insights.md) · sample CSVs under `outputs/sample/`.

## SQL techniques demonstrated

CTEs · `RANK` / `NTILE` / window `LAG` · multi-table joins · `CASE` bands · `GROUP BY` / `HAVING` · anti-join / `NOT EXISTS` · null-safe denominators · campaign date attributes · DQ result table

## Limitations

- US grocery panel — not Canadian POS / Nielsen syndicated data
- Associations ≠ causal promo lift
- Partial demographics; demo-only cohorts are biased toward covered HH
- Optional `promotions` (display/mailer) table is large and not required for Q01–Q10

## Author

**Lavanya Kumar** · Bachelor of Data Science (Honours), Computation · York University · Graduating April 2027  
GitHub: [Lrk777](https://github.com/Lrk777) · LinkedIn: [lavanya-kumar-610a07214](https://www.linkedin.com/in/lavanya-kumar-610a07214)
