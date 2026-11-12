-- Q01 Coverage & adequacy: demo presence vs sales share
-- Finding: filled after run in findings/insights.md

CREATE OR REPLACE TABLE q01_demo_coverage AS
WITH hh AS (
  SELECT
    household_id,
    MAX(has_demographics) AS has_demographics,
    SUM(sales_value) AS hh_sales
  FROM mart_line_item
  GROUP BY 1
)
SELECT
  CASE WHEN has_demographics = 1 THEN 'demo_known' ELSE 'demo_unknown' END AS demo_band,
  COUNT(*) AS n_households,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_households,
  ROUND(SUM(hh_sales), 2) AS sales_value,
  ROUND(100.0 * SUM(hh_sales) / SUM(SUM(hh_sales)) OVER (), 2) AS pct_sales
FROM hh
GROUP BY 1
ORDER BY demo_band;

SELECT * FROM q01_demo_coverage;
-- Finding: (run pipeline — see findings/insights.md)
