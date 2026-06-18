--- Feature Engineering for Customer Churn Prediction Project

-- 1. FINANCIAL RATIOS & BEHAVIOR

-- Q: How much does a customer spend per month relative to their total lifespan?
-- (Create a feature: Total Charges divided by Tenure to get 'avg_monthly_spend'. 
-- Note: Handle potential division-by-zero errors if tenure is 0!)
CREATE OR REPLACE VIEW v_avg_monthly_spend AS 
SELECT
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges,

    -- Safely handle empty text strings in total_charges and cast to numeric 
    CASE
        WHEN total_charges = ' ' OR total_charges IS NULL THEN 0.00
        ELSE CAST(total_charges as NUMERIC(10, 2))
    END AS total_charges,

    -- Calculate historical average spend while protecting against division by zero
    CASE 
        WHEN tenure = 0 THEN 0.00
        ELSE ROUND(CAST(total_charges AS NUMERIC(10,2)) / tenure, 2)
    END as historical_avg_monthly_spend,
    churn

FROM telco_churn;

-- View the new table to verify the new feature
SELECT * FROM v_avg_monthly_spend LIMIT 10;


-- Q: Is a customer's monthly bill higher than the average bill of the entire dataset?
-- (Create a binary flag [1 or 0] called 'above_average_bill' by comparing MonthlyCharges 
-- to a subquery of the dataset's overall average monthly charge)

-- Drop the old version completely to reset the column structure
DROP VIEW IF EXISTS v_clean_churn_data;

-- Build the view fresh with your new flag
CREATE OR REPLACE VIEW v_clean_churn_data AS 
SELECT
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges,
    total_charges,
    historical_avg_monthly_spend,

    -- above average spend flag (from previous view)
    CASE 
        WHEN monthly_charges > historical_avg_monthly_spend THEN 1
        ELSE 0
    END as above_average_flag,

    churn

FROM v_avg_monthly_spend;

SELECT * FROM v_clean_churn_data;

-- Check the distribution of the new flag across churned vs non-churned customers
SELECT COUNT(above_average_flag) as count, above_average_flag, churn
FROM v_clean_churn_data
GROUP BY churn, above_average_flag;


-- Q: How long has the customer been with the company relative to a standard two-year benchmark?
-- (Create a metric called 'tenure_years' by converting the tenure months into years [tenure / 12.0])
DROP VIEW IF EXISTS v_clean_churn_data;

CREATE VIEW v_clean_churn_data AS 
SELECT
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges,
    total_charges,
    historical_avg_monthly_spend,

    -- Above average spend flag
    CASE
        WHEN monthly_charges > historical_avg_monthly_spend THEN 1
        ELSE 0
    END AS above_average_flag,

    -- New Feature: Convert months to years
    ROUND(tenure / 12.0, 2) AS tenure_years,

    churn
FROM v_avg_monthly_spend;

select * from v_clean_churn_data;

-- Q: Is the customer an "at-risk newbie"?
-- (Create a flag [1 or 0] called 'is_new_m2m_customer' for users who have a 
-- Month-to-Month contract AND a tenure of less than 6 months)

-- Drop the view to avoid the strict Postgres column-order/name clash errors
DROP VIEW IF EXISTS v_clean_churn_data;

-- Re-create the view including all previous features plus the new newbie flag
CREATE VIEW v_clean_churn_data AS 
SELECT
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges,
    total_charges,
    historical_avg_monthly_spend,

    -- Feature 1: Above average spend flag
    CASE
        WHEN monthly_charges > historical_avg_monthly_spend THEN 1
        ELSE 0
    END AS above_average_flag,

    -- Feature 2: Convert months to years
    ROUND(tenure / 12.0, 2) AS tenure_years,

    -- Feature 3: At-Risk Newbie Flag (Using AND to link contract type and tenure threshold)
    CASE
        WHEN contract = 'Month-to-month' AND tenure < 6 THEN 1
        ELSE 0
    END AS is_new_m2m_customer,

    churn
FROM v_avg_monthly_spend;

-- Verify the new column data works
SELECT customer_id, contract, tenure, is_new_m2m_customer, churn 
FROM v_clean_churn_data 
LIMIT 15;


-- 2. THE FINAL MASTER VIEW (THE MACHINE LEARNING INPUT FOR PYTHON ML PIPELINE)

-- Q: How do we combine all these new features with our original data into one clean table?
-- (Write a final SELECT statement that pulls the core original columns [customer_id, churn, etc.] 
-- AND includes all 4 of your newly engineered features above. 
-- Hint: You can wrap this in a VIEW called 'v_ml_churn_input' so Python can easily pull it later)

-- Drop any legacy, iterative views to reset the database namespace cleanly
DROP VIEW IF EXISTS v_clean_churn_data;
DROP VIEW IF EXISTS v_avg_monthly_spend;
DROP VIEW IF EXISTS v_ml_churn_input;

-- Build the definitive Master View using sequential CTE blocks
CREATE OR REPLACE VIEW v_ml_churn_input AS 
WITH base_cleaned_pipeline AS (
    -- CTE STEP 1: INITIAL CLEANING & DATA TYPE CORRECTION
    -- We parse and isolate the text 'total_charges' here so math features work smoothly.
    SELECT
        customer_id,
        gender,
        senior_citizen,
        partner,
        dependents,
        tenure,
        phone_service,
        multiple_lines,
        internet_service,
        online_security,
        online_backup,
        device_protection,
        tech_support,
        streaming_tv,
        streaming_movies,
        contract,
        paperless_billing,
        payment_method,
        monthly_charges,
        churn,
        -- Safely map empty text strings for new customers to numeric decimals
        CASE
            WHEN total_charges = ' ' OR total_charges IS NULL THEN 0.00
            ELSE CAST(total_charges as NUMERIC(10, 2))
        END AS clean_total_charges
    FROM telco_churn
),
computed_lifespan_metrics AS (
    -- CTE STEP 2: HISTORICAL AVERAGE spend DERIVATION
    -- Pulls from our clean pipeline layer and protects against division-by-zero errors.
    SELECT
        *,
        -- Feature 1: Historical Lifespan Monthly Spend
        CASE 
            WHEN tenure = 0 THEN 0.00
            ELSE ROUND(clean_total_charges / tenure, 2)
        END as historical_avg_monthly_spend
    FROM base_cleaned_pipeline
)
-- CTE STEP 3: MASTER DATA ASSEMBLY & MACHINE LEARNING INPUTS
SELECT
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges,
    clean_total_charges AS total_charges,
    historical_avg_monthly_spend,

    -- Feature A: Above Average Spend Flag (Comparing active monthly bill to historical lifespan average)
    CASE 
        WHEN monthly_charges > historical_avg_monthly_spend THEN 1
        ELSE 0
    END as above_average_flag,

    -- Feature B: Tenure Converted to Years (Decimal scale benchmarked to 12 months)
    ROUND(tenure / 12.0, 2) AS tenure_years,

    -- Feature C: At-Risk Newbie Flag (Month-to-month contract AND less than 6 months tenure)
    CASE 
        WHEN contract = 'Month-to-month' AND tenure < 6 THEN 1
        ELSE 0
    END as is_new_m2m_customer,
    
    churn
FROM computed_lifespan_metrics;


--- 3. DATA VALIDATION & QUALITY ASSURANCE RUN

-- Run validation check to view all original data merged with your 3 new features
SELECT 
    customer_id, 
    contract,
    tenure,
    tenure_years,
    monthly_charges, 
    historical_avg_monthly_spend, 
    above_average_flag, 
    is_new_m2m_customer, 
    churn 
FROM v_ml_churn_input 
LIMIT 20;