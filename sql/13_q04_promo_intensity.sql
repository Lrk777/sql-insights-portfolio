-- Q04 Promo intensity by department (discounted lines vs all)

CREATE OR REPLACE TABLE q04_promo_intensity AS
SELECT
  COALESCE(department, '(missing department)') AS department,
  COUNT(*) AS n_lines,
  SUM(is_promo_line) AS n_promo_lines,
  ROUND(100.0 * SUM(is_promo_line) / NULLIF(COUNT(*), 0), 2) AS pct_lines_on_promo,
  ROUND(SUM(sales_value), 2) AS sales_value,
  ROUND(SUM(CASE WHEN is_promo_line = 1 THEN sales_value ELSE 0 END), 2) AS promo_sales_value,
  ROUND(
    100.0 * SUM(CASE WHEN is_promo_line = 1 THEN sales_value ELSE 0 END)
      / NULLIF(SUM(sales_value), 0),
    2
  ) AS pct_sales_on_promo,
  CASE
    WHEN 100.0 * SUM(CASE WHEN is_promo_line = 1 THEN sales_value ELSE 0 END)
           / NULLIF(SUM(sales_value), 0) >= 50 THEN 'high_promo_reliance'
    WHEN 100.0 * SUM(CASE WHEN is_promo_line = 1 THEN sales_value ELSE 0 END)
           / NULLIF(SUM(sales_value), 0) >= 25 THEN 'mid_promo_reliance'
    ELSE 'low_promo_reliance'
  END AS promo_band
FROM mart_line_item
GROUP BY 1
HAVING SUM(sales_value) > 1000
ORDER BY pct_sales_on_promo DESC;

SELECT * FROM q04_promo_intensity LIMIT 25;
