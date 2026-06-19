# Customer Churn Prediction Engine

An end-to-end predictive analytics repository utilizing SQL for data extraction and feature engineering, and Python for machine learning modeling and pipeline evaluation. This architecture translates historical telemetry into risk indicators to mitigate customer attrition.

## System Architecture & Pipeline

The pipeline processes data through a structured multi-layer architecture:
1. Data Ingestion: Loading raw operational telemetry.
2. Storage & Engineering: Storing data in a PostgreSQL database and running targeted SQL views to engineer non-linear behavioral features.
3. Modeling Pipeline: Scaling inputs, partitioning data, and evaluating predictive algorithms in Python.
4. Deployment: Serializing models to serve data to an upcoming application layer.

## Core Optimization Metrics

Initial baselines used a linear Logistic Regression model, which achieved high overall accuracy but lacked the sensitivity required to detect actual churn instances. The architecture was upgraded to an ensemble Random Forest Classifier utilizing class-weight balancing to mitigate the 74/26 retention-to-churn data imbalance.

### Performance Breakdown

| Metric | Baseline (Logistic Regression) | Optimized Engine (Random Forest) | Impact |
| :--- | :--- | :--- | :--- |
| **Overall Accuracy** | 80.98% | 76.58% | Balanced for majority class noise |
| **Churn Recall** | 53.48% | 78.07% | +24.59% capture rate increase |
| **F1-Score** | 59.88% | 63.89% | Stronger harmonic mean profile |

*Note on Accuracy vs. Recall:* While the baseline model reported higher overall accuracy, it failed to identify nearly half of the true churners. The balanced Random Forest model trades a marginal amount of overall accuracy to successfully intercept 78.07% of at-risk accounts, creating significantly higher financial yield for retention marketing campaigns.

## Strategic Business Insights (Model Interpretability)

By extracting the feature importance from the optimized Random Forest engine, millions of data matrix calculations convert into three actionable corporate strategies:

1. **The Critical Onboarding Window:** Customer tenure is the strongest predictor of stability. Volatility is heavily concentrated in the first 0–6 months. *Action: Implement a proactive customer success check-in at Day 30 and Day 90 for all new subscribers.*
2. **The Month-to-Month Contract Trap:** Accounts on short-term rolling contracts are highly volatile, especially when paired with high monthly bills. *Action: Incentivize a transition to 1-year or 2-year terms by offering a financial discount that offsets their perceived price risk.*
3. **High-Tier Friction:** High financial indicators (`total_charges`) heavily influence model branching. Customers paying premium tiers are actively shopping for competitors if their service experience hiccups.

## Project Structure

```text
├── data/                       # Local raw data assets
├── eda_queries.sql             # SQL files for exploratory data analysis
├── feature_engineering.sql     # SQL scripts defining database views and flags
├── ingest_data.py              # Data ingestion pipeline script
├── churn_analysis.ipynb        # Model development, evaluation, and visualization notebook
├── .gitignore                  # System files and binary artifact exclusion configurations
└── requirements.txt            # Python dependency manifest