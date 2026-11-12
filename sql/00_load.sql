-- 00_load.sql — create raw tables from CSVs under data/raw/
-- Requires: scripts/run_pipeline.py sets file_search_path to project root

CREATE OR REPLACE TABLE raw_transactions AS
SELECT * FROM read_csv_auto('data/raw/transactions.csv', header = true, sample_size = -1);

CREATE OR REPLACE TABLE raw_products AS
SELECT * FROM read_csv_auto('data/raw/products.csv', header = true, sample_size = -1);

CREATE OR REPLACE TABLE raw_demographics AS
SELECT * FROM read_csv_auto('data/raw/demographics.csv', header = true, sample_size = -1);

CREATE OR REPLACE TABLE raw_campaigns AS
SELECT * FROM read_csv_auto('data/raw/campaigns.csv', header = true, sample_size = -1);

CREATE OR REPLACE TABLE raw_campaign_descriptions AS
SELECT * FROM read_csv_auto('data/raw/campaign_descriptions.csv', header = true, sample_size = -1);

CREATE OR REPLACE TABLE raw_coupons AS
SELECT * FROM read_csv_auto('data/raw/coupons.csv', header = true, sample_size = -1);

CREATE OR REPLACE TABLE raw_coupon_redemptions AS
SELECT * FROM read_csv_auto('data/raw/coupon_redemptions.csv', header = true, sample_size = -1);

-- Sanity counts (also written into dq later)
SELECT 'raw_transactions' AS tbl, COUNT(*) AS n FROM raw_transactions
UNION ALL SELECT 'raw_products', COUNT(*) FROM raw_products
UNION ALL SELECT 'raw_demographics', COUNT(*) FROM raw_demographics
UNION ALL SELECT 'raw_campaigns', COUNT(*) FROM raw_campaigns
UNION ALL SELECT 'raw_campaign_descriptions', COUNT(*) FROM raw_campaign_descriptions
UNION ALL SELECT 'raw_coupons', COUNT(*) FROM raw_coupons
UNION ALL SELECT 'raw_coupon_redemptions', COUNT(*) FROM raw_coupon_redemptions;
