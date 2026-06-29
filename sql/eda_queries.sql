-- Exploratory Data Analysis (EDA) via SQL Customer Churn Prediction Project

-- 1. BASELINE DATA AUDIT
-- What does the overall table structure look like, and what are the data types?
SELECT * 
FROM information_schema.columns
WHERE TABLE_NAME = 'telco_churn'
LIMIT 10;

-- How many total customers are in the dataset?
SELECT COUNT(*) AS total_customers
FROM telco_churn;

-- 2. TARGET VARIABLE DISTRIBUTION (GROUND TRUTH)
-- How many customers stayed vs. left, and what is the overall churn percentage?
SELECT 
    churn,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telco_churn),
        2
    ) AS percentage
FROM telco_churn
GROUP BY churn;

-- 3. CATEGORICAL RISK DRIVERS
-- Which contract types have the highest volume and percentage of churn?
-- (Compare Month-to-Month vs. One-Year vs. Two-Year contracts)
SELECT 
    contract,
    COUNT(*) AS customer_count,
    ROUND(count(*) * 100.0 / (SELECT COUNT(*) FROM telco_churn WHERE churn = 'Yes'), 2) AS churn_percentage 
FROM telco_churn
WHERE churn = 'Yes'
GROUP BY contract
ORDER BY churn_percentage DESC;

-- Does the payment method affect whether a customer leaves?
SELECT payment_method, count(churn) AS churn_count
FROM telco_churn
WHERE churn = 'Yes'
GROUP BY payment_method;

-- Broader look at automatic vs. manual payments
SELECT 
    CASE
        WHEN payment_method LIKE '%automatic%' THEN 'Automatic'
        ELSE 'Manual'
    END AS payment_type,
    COUNT(*) AS churn_count
FROM telco_churn
WHERE churn = 'Yes'
GROUP BY payment_type;

-- Q: Is there a specific internet service type associated with higher churn?
-- (Compare DSL, Fiber Optic, or No Internet)
SELECT internet_service, count(churn) AS churn_count
FROM telco_churn
WHERE churn = 'Yes'
GROUP BY internet_service
ORDER BY churn_count DESC;


-- 4. NUMERICAL AGGREGATIONS & OUTLIERS
-- What is the average, minimum, and maximum tenure of our customers?
-- (Helps identify the typical lifespan of a customer)
SELECT AVG(tenure) AS avg_tenure, 
       MIN(tenure) AS min_tenure, 
       MAX(tenure) AS max_tenure
FROM telco_churn;

-- What is the average monthly charge for customers who churned vs. those who stayed?

-- The query was giving an error because total_charges is stored as a string
-- and there are some non-numeric values (like empty strings) in that column. 
-- We need to clean the data before we can calculate the average.

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'telco_churn'
  AND column_name = 'total_charges';

SELECT customer_id, total_charges
FROM telco_churn
WHERE TRIM(total_charges) = '';

SELECT DISTINCT total_charges
FROM telco_churn
WHERE TRIM(total_charges) <> ''
  AND TRIM(total_charges) !~ '^[0-9]+(\.[0-9]+)?$';

SELECT 
    churn,
    AVG(
        CAST(NULLIF(TRIM(total_charges), '') AS FLOAT)
    ) AS avg_total_charges
FROM telco_churn
GROUP BY churn;


-- Are there any data anomalies? 
-- (e.g., Customers with 0 tenure months but positive total charges, or vice versa)
WITH cleaned_data AS (
    SELECT *,
           -- Convert empty strings to NULL, then cast to float
           CAST(NULLIF(TRIM(total_charges), '') AS FLOAT) AS total_charges_float
    FROM telco_churn
)
SELECT *
FROM cleaned_data
WHERE (tenure = 0 AND total_charges_float > 0)
   OR (tenure > 0 AND (total_charges_float IS NULL OR total_charges_float = 0));


-- 5. SEGMENTATION AND DRILL-DOWN

-- For customers on a Month-to-Month contract, what is their average tenure before they churn?
-- (Pins down the exact "risk window" where customer success teams should intervene)
SELECT 
    AVG(tenure) AS avg_months_before_churn
FROM telco_churn
WHERE contract = 'Month-to-month' 
  AND churn = 'Yes';
