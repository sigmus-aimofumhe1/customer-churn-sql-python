--- Feature Engineering for Customer Churn Prediction Project

-- 1. FINANCIAL RATIOS & BEHAVIOR

-- Q: How much does a customer spend per month relative to their total lifespan?
-- (Create a feature: Total Charges divided by Tenure to get 'avg_monthly_spend'. 
-- Note: Handle potential division-by-zero errors if tenure is 0!)



-- Q: Is a customer's monthly bill higher than the average bill of the entire dataset?
-- (Create a binary flag [1 or 0] called 'above_average_bill' by comparing MonthlyCharges 
-- to a subquery of the dataset's overall average monthly charge)



-- 2. LOYALTY & ENGAGEMENT METRICS

-- Q: How long has the customer been with the company relative to a standard two-year benchmark?
-- (Create a metric called 'tenure_years' by converting the tenure months into years [tenure / 12.0])



-- Q: Is the customer an "at-risk newbie"?
-- (Create a flag [1 or 0] called 'is_new_m2m_customer' for users who have a 
-- Month-to-Month contract AND a tenure of less than 6 months)



-- 3. THE FINAL MASTER VIEW (THE MACHINE LEARNING INPUT)

-- Q: How do we combine all these new features with our original data into one clean table?
-- (Write a final SELECT statement that pulls the core original columns [customer_id, churn, etc.] 
-- AND includes all 4 of your newly engineered features above. 
-- Hint: You can wrap this in a VIEW called 'v_ml_churn_input' so Python can easily pull it later)