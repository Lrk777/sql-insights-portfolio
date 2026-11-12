-- 01_dq_checks.sql — data-quality checks before any KPI
-- Messy-data story: partial demos, orphan FKs, coupon fan-out, null product hierarchy

CREATE OR REPLACE TABLE dq_results (
  check_id VARCHAR,
  check_name VARCHAR,
  metric_value DOUBLE,
  notes VARCHAR
);

DELETE FROM dq_results;

INSERT INTO dq_results
SELECT 'DQ01', 'txn_row_count', COUNT(*)::DOUBLE, 'expect ~1.47M in this pin'
FROM raw_transactions;

INSERT INTO dq_results
SELECT 'DQ02', 'distinct_households_in_txn', COUNT(DISTINCT household_id)::DOUBLE, NULL
FROM raw_transactions;

INSERT INTO dq_results
SELECT 'DQ03', 'demographics_row_count', COUNT(*)::DOUBLE, 'partial panel — not all shoppers'
FROM raw_demographics;

INSERT INTO dq_results
SELECT 'DQ04', 'demo_coverage_of_txn_hh_pct',
  100.0 * COUNT(DISTINCT CASE WHEN d.household_id IS NOT NULL THEN t.household_id END)
    / NULLIF(COUNT(DISTINCT t.household_id), 0),
  'share of purchasing HH that have demographics'
FROM raw_transactions t
LEFT JOIN raw_demographics d ON CAST(t.household_id AS VARCHAR) = CAST(d.household_id AS VARCHAR);

INSERT INTO dq_results
SELECT 'DQ05', 'orphan_product_ids_in_txn', COUNT(*)::DOUBLE,
  'txn product_id with no products row'
FROM raw_transactions t
WHERE NOT EXISTS (
  SELECT 1 FROM raw_products p WHERE CAST(p.product_id AS VARCHAR) = CAST(t.product_id AS VARCHAR)
);

INSERT INTO dq_results
SELECT 'DQ06', 'products_missing_department', COUNT(*)::DOUBLE, NULL
FROM raw_products
WHERE department IS NULL OR TRIM(CAST(department AS VARCHAR)) = '';

INSERT INTO dq_results
SELECT 'DQ07', 'products_missing_category', COUNT(*)::DOUBLE, NULL
FROM raw_products
WHERE product_category IS NULL OR TRIM(CAST(product_category AS VARCHAR)) = '';

INSERT INTO dq_results
SELECT 'DQ08', 'orphan_redemptions_no_coupon_row', COUNT(*)::DOUBLE,
  'redemption coupon_upc+campaign with no coupons match'
FROM raw_coupon_redemptions r
WHERE NOT EXISTS (
  SELECT 1 FROM raw_coupons c
  WHERE CAST(c.coupon_upc AS VARCHAR) = CAST(r.coupon_upc AS VARCHAR)
    AND CAST(c.campaign_id AS VARCHAR) = CAST(r.campaign_id AS VARCHAR)
);

INSERT INTO dq_results
SELECT 'DQ09', 'orphan_redemptions_hh_not_targeted', COUNT(*)::DOUBLE,
  'redeeming HH not in campaigns for that campaign_id'
FROM raw_coupon_redemptions r
WHERE NOT EXISTS (
  SELECT 1 FROM raw_campaigns c
  WHERE CAST(c.household_id AS VARCHAR) = CAST(r.household_id AS VARCHAR)
    AND CAST(c.campaign_id AS VARCHAR) = CAST(r.campaign_id AS VARCHAR)
);

INSERT INTO dq_results
SELECT 'DQ10', 'avg_products_per_coupon_upc_campaign', AVG(n)::DOUBLE,
  'fan-out risk if joining coupons carelessly to baskets'
FROM (
  SELECT coupon_upc, campaign_id, COUNT(*)::DOUBLE AS n
  FROM raw_coupons
  GROUP BY 1, 2
);

INSERT INTO dq_results
SELECT 'DQ11', 'txn_negative_or_zero_sales_lines', COUNT(*)::DOUBLE, NULL
FROM raw_transactions
WHERE sales_value IS NULL OR sales_value <= 0;

INSERT INTO dq_results
SELECT 'DQ12', 'duplicate_demo_household_ids', COUNT(*)::DOUBLE, NULL
FROM (
  SELECT household_id FROM raw_demographics GROUP BY 1 HAVING COUNT(*) > 1
);

SELECT * FROM dq_results ORDER BY check_id;
