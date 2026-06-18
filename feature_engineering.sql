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


-- 2. LOYALTY & ENGAGEMENT METRICS

-- Q: How long has the customer been with the company relative to a standard two-year benchmark?
-- (Create a metric called 'tenure_years' by converting the tenure months into years [tenure / 12.0])
select * from telco_churn;



-- Q: Is the customer an "at-risk newbie"?
-- (Create a flag [1 or 0] called 'is_new_m2m_customer' for users who have a 
-- Month-to-Month contract AND a tenure of less than 6 months)



-- 3. THE FINAL MASTER VIEW (THE MACHINE LEARNING INPUT)

-- Q: How do we combine all these new features with our original data into one clean table?
-- (Write a final SELECT statement that pulls the core original columns [customer_id, churn, etc.] 
-- AND includes all 4 of your newly engineered features above. 
-- Hint: You can wrap this in a VIEW called 'v_ml_churn_input' so Python can easily pull it later)