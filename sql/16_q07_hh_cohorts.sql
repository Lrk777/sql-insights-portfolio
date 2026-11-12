-- Q07 Household cohorts (demo-known only): spend + promo reliance by income / kids

CREATE OR REPLACE TABLE q07_hh_cohorts AS
WITH hh AS (
  SELECT
    household_id,
    COALESCE(income, '(income unknown)') AS income,
    COALESCE(kids_count, '(kids unknown)') AS kids_count,
    SUM(sales_value) AS hh_sales,
    SUM(CASE WHEN is_promo_line = 1 THEN sales_value ELSE 0 END) AS hh_promo_sales,
    COUNT(DISTINCT basket_id) AS n_baskets
  FROM mart_line_item
  WHERE has_demographics = 1
  GROUP BY 1, 2, 3
)
SELECT
  income,
  kids_count,
  COUNT(*) AS n_households,
  ROUND(AVG(hh_sales), 2) AS avg_hh_sales,
  ROUND(AVG(n_baskets), 2) AS avg_baskets,
  ROUND(AVG(100.0 * hh_promo_sales / NULLIF(hh_sales, 0)), 2) AS avg_pct_sales_on_promo
FROM hh
GROUP BY 1, 2
HAVING COUNT(*) >= 10
ORDER BY avg_hh_sales DESC;

SELECT * FROM q07_hh_cohorts LIMIT 30;
