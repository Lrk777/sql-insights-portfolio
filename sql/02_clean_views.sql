-- 02_clean_views.sql — typed staging views + availability flags

CREATE OR REPLACE VIEW stg_transactions AS
SELECT
  CAST(household_id AS VARCHAR) AS household_id,
  CAST(store_id AS VARCHAR) AS store_id,
  CAST(basket_id AS VARCHAR) AS basket_id,
  CAST(product_id AS VARCHAR) AS product_id,
  CAST(quantity AS DOUBLE) AS quantity,
  CAST(sales_value AS DOUBLE) AS sales_value,
  CAST(retail_disc AS DOUBLE) AS retail_disc,
  CAST(coupon_disc AS DOUBLE) AS coupon_disc,
  CAST(coupon_match_disc AS DOUBLE) AS coupon_match_disc,
  CAST(week AS INTEGER) AS week,
  CAST(transaction_timestamp AS TIMESTAMP) AS transaction_timestamp,
  CAST(transaction_timestamp AS DATE) AS txn_date,
  CASE
    WHEN COALESCE(retail_disc, 0) > 0 OR COALESCE(coupon_disc, 0) > 0 THEN 1
    ELSE 0
  END AS is_promo_line
FROM raw_transactions;

CREATE OR REPLACE VIEW stg_products AS
SELECT
  CAST(product_id AS VARCHAR) AS product_id,
  CAST(manufacturer_id AS VARCHAR) AS manufacturer_id,
  NULLIF(TRIM(CAST(department AS VARCHAR)), '') AS department,
  NULLIF(TRIM(CAST(brand AS VARCHAR)), '') AS brand,
  NULLIF(TRIM(CAST(product_category AS VARCHAR)), '') AS product_category,
  NULLIF(TRIM(CAST(product_type AS VARCHAR)), '') AS product_type,
  NULLIF(TRIM(CAST(package_size AS VARCHAR)), '') AS package_size,
  CASE WHEN department IS NULL OR TRIM(CAST(department AS VARCHAR)) = '' THEN 0 ELSE 1 END AS has_department,
  CASE WHEN product_category IS NULL OR TRIM(CAST(product_category AS VARCHAR)) = '' THEN 0 ELSE 1 END AS has_category
FROM raw_products;

CREATE OR REPLACE VIEW stg_demographics AS
SELECT
  CAST(household_id AS VARCHAR) AS household_id,
  NULLIF(TRIM(CAST(age AS VARCHAR)), '') AS age,
  NULLIF(TRIM(CAST(income AS VARCHAR)), '') AS income,
  NULLIF(TRIM(CAST(home_ownership AS VARCHAR)), '') AS home_ownership,
  NULLIF(TRIM(CAST(marital_status AS VARCHAR)), '') AS marital_status,
  NULLIF(TRIM(CAST(household_size AS VARCHAR)), '') AS household_size,
  NULLIF(TRIM(CAST(household_comp AS VARCHAR)), '') AS household_comp,
  NULLIF(TRIM(CAST(kids_count AS VARCHAR)), '') AS kids_count
FROM raw_demographics;

CREATE OR REPLACE VIEW stg_campaigns AS
SELECT
  CAST(campaign_id AS VARCHAR) AS campaign_id,
  CAST(household_id AS VARCHAR) AS household_id
FROM raw_campaigns;

CREATE OR REPLACE VIEW stg_campaign_descriptions AS
SELECT
  CAST(campaign_id AS VARCHAR) AS campaign_id,
  NULLIF(TRIM(CAST(campaign_type AS VARCHAR)), '') AS campaign_type,
  CAST(start_date AS DATE) AS start_date,
  CAST(end_date AS DATE) AS end_date
FROM raw_campaign_descriptions;

CREATE OR REPLACE VIEW stg_coupons AS
SELECT
  CAST(coupon_upc AS VARCHAR) AS coupon_upc,
  CAST(product_id AS VARCHAR) AS product_id,
  CAST(campaign_id AS VARCHAR) AS campaign_id
FROM raw_coupons;

CREATE OR REPLACE VIEW stg_coupon_redemptions AS
SELECT
  CAST(household_id AS VARCHAR) AS household_id,
  CAST(coupon_upc AS VARCHAR) AS coupon_upc,
  CAST(campaign_id AS VARCHAR) AS campaign_id,
  CAST(redemption_date AS DATE) AS redemption_date
FROM raw_coupon_redemptions;
