-- Q05 Campaign reach → redeem funnel by campaign type
-- Interview angle: was the promo "real"? Start with coverage & redemption, not lift.

CREATE OR REPLACE TABLE q05_campaign_funnel AS
WITH targeted AS (
  SELECT
    d.campaign_type,
    c.campaign_id,
    c.household_id
  FROM stg_campaigns c
  JOIN stg_campaign_descriptions d USING (campaign_id)
),
redeemers AS (
  SELECT DISTINCT campaign_id, household_id
  FROM stg_coupon_redemptions
)
SELECT
  campaign_type,
  COUNT(DISTINCT t.campaign_id) AS n_campaigns,
  COUNT(DISTINCT t.household_id) AS n_targeted_hh,
  COUNT(DISTINCT CASE WHEN r.household_id IS NOT NULL THEN t.household_id END) AS n_redeeming_hh,
  ROUND(
    100.0 * COUNT(DISTINCT CASE WHEN r.household_id IS NOT NULL THEN t.household_id END)
      / NULLIF(COUNT(DISTINCT t.household_id), 0),
    2
  ) AS redemption_rate_pct
FROM targeted t
LEFT JOIN redeemers r
  ON t.campaign_id = r.campaign_id AND t.household_id = r.household_id
GROUP BY 1
ORDER BY redemption_rate_pct DESC;

SELECT * FROM q05_campaign_funnel;
