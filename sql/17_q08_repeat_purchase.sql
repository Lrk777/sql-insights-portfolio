-- Q08 Repeat purchase windows for GROCERY department (days between trips)

CREATE OR REPLACE TABLE q08_repeat_purchase AS
WITH grocery_baskets AS (
  SELECT
    household_id,
    basket_id,
    MIN(txn_date) AS basket_date
  FROM mart_line_item
  WHERE department = 'GROCERY'
  GROUP BY 1, 2
),
ordered AS (
  SELECT
    household_id,
    basket_id,
    basket_date,
    LAG(basket_date) OVER (PARTITION BY household_id ORDER BY basket_date, basket_id) AS prev_basket_date,
    DATE_DIFF('day',
      LAG(basket_date) OVER (PARTITION BY household_id ORDER BY basket_date, basket_id),
      basket_date
    ) AS days_since_prev,
    ROW_NUMBER() OVER (PARTITION BY household_id ORDER BY basket_date, basket_id) AS trip_n
  FROM grocery_baskets
),
first_month AS (
  SELECT
    household_id,
    DATE_TRUNC('month', MIN(basket_date)) AS first_grocery_month
  FROM grocery_baskets
  GROUP BY 1
)
SELECT
  f.first_grocery_month AS cohort_month,
  COUNT(DISTINCT o.household_id) AS n_households,
  ROUND(AVG(o.days_since_prev), 2) AS avg_days_between_grocery_trips,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY o.days_since_prev), 2) AS median_days_between_trips,
  COUNT(*) AS n_repeat_trips
FROM ordered o
JOIN first_month f USING (household_id)
WHERE o.days_since_prev IS NOT NULL
GROUP BY 1
ORDER BY 1;

SELECT * FROM q08_repeat_purchase;
