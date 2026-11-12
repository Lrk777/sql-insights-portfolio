-- 90_run_all.sql — human-readable run order
-- Prefer: python3 scripts/run_pipeline.py
--
-- .read sql/00_load.sql
-- .read sql/01_dq_checks.sql
-- .read sql/02_clean_views.sql
-- .read sql/03_mart_basket.sql
-- .read sql/10_q01_demo_coverage.sql
-- .read sql/11_q02_join_integrity.sql
-- .read sql/12_q03_category_mix.sql
-- .read sql/13_q04_promo_intensity.sql
-- .read sql/14_q05_campaign_funnel.sql
-- .read sql/15_q06_commodity_ranks.sql
-- .read sql/16_q07_hh_cohorts.sql
-- .read sql/17_q08_repeat_purchase.sql
-- .read sql/18_q09_coupon_efficiency.sql
-- .read sql/19_q10_data_gap_watchlist.sql

SELECT 'Use scripts/run_pipeline.py' AS note;
