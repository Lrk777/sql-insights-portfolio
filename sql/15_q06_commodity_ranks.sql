-- Q06 Within-department commodity ranks (NTILE) by sales

CREATE OR REPLACE TABLE q06_commodity_ranks AS
WITH cat AS (
  SELECT
    COALESCE(department, '(missing department)') AS department,
    COALESCE(product_category, '(missing category)') AS product_category,
    SUM(sales_value) AS sales_value,
    COUNT(DISTINCT household_id) AS n_households,
    COUNT(*) AS n_lines
  FROM mart_line_item
  GROUP BY 1, 2
),
ranked AS (
  SELECT
    *,
    RANK() OVER (PARTITION BY department ORDER BY sales_value DESC) AS sales_rank_in_dept,
    NTILE(10) OVER (PARTITION BY department ORDER BY sales_value DESC) AS sales_decile_in_dept,
    ROUND(
      100.0 * sales_value / NULLIF(SUM(sales_value) OVER (PARTITION BY department), 0),
      2
    ) AS pct_of_dept_sales
  FROM cat
  WHERE sales_value > 0
)
SELECT *
FROM ranked
WHERE sales_decile_in_dept = 1 OR sales_decile_in_dept = 10
ORDER BY department, sales_decile_in_dept, sales_value DESC;

SELECT department, product_category, sales_value, sales_decile_in_dept, pct_of_dept_sales
FROM q06_commodity_ranks
WHERE department IN ('GROCERY', 'DRUG GM', 'PRODUCE')
LIMIT 40;
