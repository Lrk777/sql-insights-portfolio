-- 03_mart_basket.sql — trusted line + basket marts

CREATE OR REPLACE TABLE mart_line_item AS
SELECT
  t.*,
  p.department,
  p.brand,
  p.product_category,
  p.product_type,
  p.has_department,
  p.has_category,
  CASE WHEN d.household_id IS NOT NULL THEN 1 ELSE 0 END AS has_demographics,
  d.age,
  d.income,
  d.kids_count,
  d.household_comp,
  CASE
    WHEN p.product_id IS NULL THEN 'orphan_product'
    WHEN d.household_id IS NULL THEN 'product_ok_demo_missing'
    ELSE 'product_and_demo'
  END AS dq_join_status
FROM stg_transactions t
LEFT JOIN stg_products p USING (product_id)
LEFT JOIN stg_demographics d USING (household_id);

CREATE OR REPLACE TABLE mart_basket AS
SELECT
  household_id,
  store_id,
  basket_id,
  MIN(txn_date) AS basket_date,
  MIN(week) AS week,
  COUNT(*) AS n_lines,
  SUM(sales_value) AS basket_sales,
  SUM(CASE WHEN is_promo_line = 1 THEN sales_value ELSE 0 END) AS promo_sales,
  SUM(is_promo_line) AS n_promo_lines,
  MAX(has_demographics) AS has_demographics
FROM mart_line_item
GROUP BY 1, 2, 3;

-- Quick peek
SELECT dq_join_status, COUNT(*) AS n_lines, ROUND(SUM(sales_value), 2) AS sales
FROM mart_line_item
GROUP BY 1
ORDER BY n_lines DESC;
