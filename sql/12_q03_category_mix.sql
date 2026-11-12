-- Q03 Category mix: sales + household penetration by department

CREATE OR REPLACE TABLE q03_category_mix AS
WITH base AS (
  SELECT
    COALESCE(department, '(missing department)') AS department,
    household_id,
    sales_value
  FROM mart_line_item
),
agg AS (
  SELECT
    department,
    ROUND(SUM(sales_value), 2) AS sales_value,
    COUNT(DISTINCT household_id) AS n_households,
    COUNT(*) AS n_lines
  FROM base
  GROUP BY 1
),
tot AS (
  SELECT COUNT(DISTINCT household_id) AS all_hh FROM mart_line_item
)
SELECT
  a.*,
  ROUND(100.0 * a.n_households / t.all_hh, 2) AS hh_penetration_pct,
  ROUND(100.0 * a.sales_value / SUM(a.sales_value) OVER (), 2) AS sales_share_pct,
  RANK() OVER (ORDER BY a.sales_value DESC) AS sales_rank
FROM agg a CROSS JOIN tot t
ORDER BY a.sales_value DESC;

SELECT * FROM q03_category_mix LIMIT 20;
