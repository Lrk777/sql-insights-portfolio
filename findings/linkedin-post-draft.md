# LinkedIn post draft (paste-ready)

**Suggested post**

I wanted a SQL portfolio piece that shows commercial / RGM thinking — not another forecast notebook, and not overlapping my health-system capstone.

So I built a **SQL-only CPG category & promo lab** on Dunnhumby’s Complete Journey panel (DuckDB):

- DQ layer first: orphan products, coupon fan-out (~97 products per offer), and the fact that **demographics cover ~32% of households but ~57% of sales**
- Promo intensity by department (e.g. fuel sales heavily promo-flagged — metric definition matters before “lift”)
- Campaign funnel by type: Type A targeted HH redeem at ~25% vs ~12% / ~8% for B / C

Repo (SQL files + findings): *link after publish → `sql-insights-portfolio`*

Stack: DuckDB · CTEs · window functions · joins · CASE · data-quality checks  
Open to new-grad **BI / insights / RGM / category** roles for April 2027+.

#SQL #DuckDB #DataAnalytics #CPG #RGM #BusinessIntelligence #NewGrad2027

---

**60-second interview talk-track**

“My capstone already covers health analytics with Grace Hospital. For portfolio versatility I built a DuckDB SQL lab on Complete Journey grocery data. I started with data quality — partial demographics, coupon fan-out, missing category labels — then used CTEs and windows for category mix, promo reliance, and campaign redemption funnels. I’m careful not to call redemption ‘lift’ without a holdout and cost data.”
