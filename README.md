# CPG Category & Promo Insights: SQL Lab

SQL analysis of a 1.47M-line grocery panel (2,469 households, one year of 2017 shopping) to answer the questions a category or promotions analyst gets every week. The data-quality checks decide which answers can be trusted.

## The question

Which campaign types are worth repeating, how dependent are the big departments on discounts, and which customer metrics are biased by gaps in the data?

## Key findings

1. **Type A campaigns convert best.** 24.9% of targeted households redeemed, against 11.7% for Type B and 7.6% for Type C. Per 100 coupon UPCs, Type A produced 213 redemptions; Type C produced 54.
2. **Discounts drive a large share of sales.** 55% of Grocery sales dollars, 56% of Meat and 64% of packaged meat sit on a discounted line. For Fuel it is 94%, which says more about how "discount" is defined (any retail or coupon discount) than about real promo activity.
3. **Demographic cuts overweight heavy shoppers.** Only 32.4% of households have a demographics record, yet they account for 57.1% of sales. Any "average customer by income" metric describes the bigger spenders.
4. **Two joins would silently corrupt reporting if done naively.** Each coupon UPC × campaign fans out to about 97 products. Separately, 4,836 transaction lines ($173) point to products that don't exist.
5. **Miscellaneous is a data gap, not a category.** It ranks 8th by sales, but 29% of its lines have no category.

**Targeted households that redeemed, by campaign type**

| | % redeemed | |
|---|---:|---|
| Type A (1,490 HH) | 24.9% | `█████████████████` |
| Type B (995 HH) | 11.7% | `████████` |
| Type C (397 HH) | 7.6% | `█████` |

**Share of sales dollars on a discounted line, top 8 departments**

| | % of sales $ | |
|---|---:|---|
| Grocery | 55.4% | `███████████` |
| Drug Gm | 28.4% | `██████` |
| Fuel | 94.0% | `███████████████████` |
| Produce | 23.4% | `█████` |
| Meat | 56.4% | `███████████` |
| Meat-Pckgd | 63.6% | `█████████████` |
| Deli | 42.1% | `████████` |
| Miscellaneous | 69.0% | `██████████████` |

**Households with demographics: share of households vs share of sales**

| | % | |
|---|---:|---|
| Share of households | 32.4% | `██████` |
| Share of sales dollars | 57.1% | `███████████` |

## Recommendation

| Decision | Why | Trade-off |
|---|---|---|
| Put the next campaign test into the Type A format, with a holdout group | It redeems at 2–3x the rate of B and C | There's no trade-spend cost in the data, so higher redemption isn't yet proof of higher return; the holdout measures true lift |
| Cut or redesign Type C | 30 of 397 targeted households redeemed | A small sample of 6 campaigns; confirm on the next cycle before cutting |
| Report demographic KPIs with a coverage caveat, or reweight to the full panel | Covered households skew to heavy spenders (57% of sales from 32% of households) | Reweighting adds a step every analyst has to understand |
| Track Grocery and Meat "sales on discount" monthly | Over half their dollars already carry a discount, so margin is sensitive to promo depth | Needs a tighter promo definition than "any discount" to be meaningful |
| Aggregate coupons before joining to baskets; fix orphan product IDs at source | Prevents a ~97x row fan-out and unmatched sales | One more staging step |

## Data

| | |
|---|---|
| Source | Dunnhumby / 84.51° *The Complete Journey*, via the [completejourney](https://github.com/bradleyboehmke/completejourney) package |
| Size | 1,469,307 transaction lines, 2,469 households, campaigns, coupons, partial demographics (2017) |
| Licence | Non-commercial / educational. Raw CSVs are not redistributed; see `DATA_LICENSE.md` |

## Method

`raw → DQ checks → staging views → line and basket marts → 10 insight queries` in DuckDB. Techniques used: CTEs, `RANK` / `NTILE` / `LAG` windows, anti-joins, `CASE` bands, and null-safe denominators. The run order is in `sql/90_run_all.sql`, and the details are in [`findings/insights.md`](findings/insights.md).

## How to run

```bash
python3 -m pip install duckdb pyreadr pandas
python3 scripts/download_data.py          # writes gitignored data/raw/*.csv
python3 scripts/run_pipeline.py --export-samples
```

## Limitations and next steps

- This is a US grocery panel, not Canadian POS or syndicated data.
- Redemption and discount share are associations, not causal lift.
- Demographics are partial, as described above.
- Next: add trade-spend assumptions to estimate campaign ROI, and build a Tableau Public category scorecard on the marts.

## Author

Lavanya Kumar · Bachelor of Data Science (Honours), York University, graduating April 2027 · [GitHub](https://github.com/Lrk777) · [LinkedIn](https://www.linkedin.com/in/lavanya-kumar-610a07214)
