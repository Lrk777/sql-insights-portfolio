-- Q09 Coupon efficiency sketch (NOT full ROI — no trade-spend cost file)
-- Distributed offer rows vs redemption events; honest limitation in notes.

CREATE OR REPLACE TABLE q09_coupon_efficiency AS
WITH distributed AS (
  SELECT
    c.campaign_id,
    d.campaign_type,
    COUNT(*) AS coupon_product_rows,
    COUNT(DISTINCT c.coupon_upc) AS n_coupon_upcs,
    COUNT(DISTINCT c.product_id) AS n_products_on_coupon
  FROM stg_coupons c
  JOIN stg_campaign_descriptions d USING (campaign_id)
  GROUP BY 1, 2
),
redeemed AS (
  SELECT
    campaign_id,
    COUNT(*) AS n_redemption_events,
    COUNT(DISTINCT household_id) AS n_redeeming_hh,
    COUNT(DISTINCT coupon_upc) AS n_redeemed_upcs
  FROM stg_coupon_redemptions
  GROUP BY 1
)
SELECT
  dist.campaign_type,
  COUNT(*) AS n_campaigns,
  SUM(dist.coupon_product_rows) AS coupon_product_rows,
  SUM(dist.n_coupon_upcs) AS n_coupon_upcs,
  SUM(COALESCE(r.n_redemption_events, 0)) AS n_redemption_events,
  SUM(COALESCE(r.n_redeeming_hh, 0)) AS n_redeeming_hh,
  ROUND(
    100.0 * SUM(COALESCE(r.n_redemption_events, 0)) / NULLIF(SUM(dist.n_coupon_upcs), 0),
    4
  ) AS redemption_events_per_100_upcs
FROM distributed dist
LEFT JOIN redeemed r USING (campaign_id)
GROUP BY 1
ORDER BY n_redemption_events DESC;

SELECT * FROM q09_coupon_efficiency;
