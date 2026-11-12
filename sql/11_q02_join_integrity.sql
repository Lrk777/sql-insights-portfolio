-- Q02 Join integrity: orphan products + orphan / mistargeted redemptions

CREATE OR REPLACE TABLE q02_join_integrity AS
SELECT 'orphan_product_lines' AS issue,
       COUNT(*)::BIGINT AS n,
       ROUND(SUM(sales_value), 2) AS sales_value
FROM mart_line_item
WHERE dq_join_status = 'orphan_product'
UNION ALL
SELECT 'redemptions_total', COUNT(*)::BIGINT, NULL
FROM stg_coupon_redemptions
UNION ALL
SELECT 'redemptions_no_coupon_match', COUNT(*)::BIGINT, NULL
FROM stg_coupon_redemptions r
WHERE NOT EXISTS (
  SELECT 1 FROM stg_coupons c
  WHERE c.coupon_upc = r.coupon_upc AND c.campaign_id = r.campaign_id
)
UNION ALL
SELECT 'redemptions_hh_not_in_campaign_target', COUNT(*)::BIGINT, NULL
FROM stg_coupon_redemptions r
WHERE NOT EXISTS (
  SELECT 1 FROM stg_campaigns c
  WHERE c.household_id = r.household_id AND c.campaign_id = r.campaign_id
);

SELECT * FROM q02_join_integrity;
