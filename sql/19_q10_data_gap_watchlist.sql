-- Q10 Data-gap watchlist — high volume with weak hierarchy / demo linkage
-- Framed as adequacy gaps, not "bad categories"

CREATE OR REPLACE TABLE q10_data_gap_watchlist AS
WITH dept AS (
  SELECT
    COALESCE(department, '(missing department)') AS department,
    COUNT(*) AS n_lines,
    ROUND(SUM(sales_value), 2) AS sales_value,
    ROUND(100.0 * AVG(CASE WHEN has_category = 0 OR has_category IS NULL THEN 1 ELSE 0 END), 2) AS pct_lines_missing_category,
    ROUND(100.0 * AVG(1 - has_demographics), 2) AS pct_lines_demo_unknown,
    ROUND(100.0 * AVG(is_promo_line), 2) AS pct_lines_promo
  FROM mart_line_item
  GROUP BY 1
),
ranked AS (
  SELECT
    *,
    RANK() OVER (ORDER BY sales_value DESC) AS sales_rank,
    CASE
      WHEN pct_lines_missing_category >= 5 OR department = '(missing department)' THEN 'hierarchy_gap'
      WHEN pct_lines_demo_unknown >= 70 THEN 'demo_coverage_gap'
      ELSE 'ok_for_descriptive'
    END AS gap_flag
  FROM dept
)
SELECT *
FROM ranked
WHERE sales_rank <= 15 AND gap_flag <> 'ok_for_descriptive'
ORDER BY sales_value DESC;

SELECT * FROM q10_data_gap_watchlist;
