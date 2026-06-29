# Executive Customer Churn Analytics Platform

An end-to-end **Customer Churn Analytics Platform** that combines **PostgreSQL**, **SQL**, **Python**, **Scikit-Learn**, and **Streamlit** to transform raw telecommunications customer data into actionable business intelligence. The platform demonstrates a production-style analytics workflow, from relational database design and SQL feature engineering to machine learning model development and deployment through an interactive executive dashboard.

**🌐 Live Dashboard:** https://customer-churn-analytic-dashboard.streamlit.app/

---

## Executive Overview

Customer churn is one of the most critical metrics for subscription-based businesses. Losing customers reduces recurring revenue, lowers customer lifetime value (LTV), increases customer acquisition costs (CAC), and impacts financial forecasting.

Rather than simply reporting historical churn, this project focuses on **predictive analytics**, enabling organizations to identify customers who are likely to leave before cancellation occurs. By combining SQL-engineered business features with machine learning, the platform provides real-time churn predictions that support proactive retention strategies.

---

## Key Features

- End-to-end analytics pipeline from raw data to deployment
- PostgreSQL relational database and SQL feature engineering
- Machine learning models for churn prediction
- Interactive Streamlit dashboard with Plotly visualizations
- Real-time customer prediction playground
- Executive KPI dashboard
- Cloud deployment via Streamlit Community Cloud

---

## Technology Stack

| Category | Technologies |
|----------|--------------|
| **Database** | PostgreSQL, SQL |
| **Data Science** | Python, Pandas, NumPy |
| **Machine Learning** | Scikit-Learn, Logistic Regression, Random Forest |
| **Visualization** | Streamlit, Plotly |
| **Deployment** | Streamlit Community Cloud |

---

## System Architecture

```text
Raw Customer Data
        │
        ▼
 PostgreSQL Database
        │
        ▼
 SQL Feature Engineering
        │
        ▼
 Python Data Pipeline
        │
        ▼
 Machine Learning Training
        │
        ▼
 Serialized Models (.pkl)
        │
        ▼
 Streamlit Dashboard
        │
        ▼
 Real-Time Churn Prediction
```

Heavy data processing, SQL transformations, and model training are performed offline. The deployed application loads only serialized models and a snapshot dataset, enabling fast and efficient real-time inference.

---

## Data Pipeline

The project follows a structured analytics workflow:

1. **Data Ingestion** – Raw telecommunications customer data is imported into PostgreSQL, where missing values, data types, and data quality are validated.

2. **SQL Feature Engineering** – Business features such as customer tenure, contract classifications, revenue metrics, and service adoption indicators are engineered directly in SQL to create an analytical feature layer.

3. **Machine Learning** – The engineered dataset is exported into Python for preprocessing, train-test splitting, model training, evaluation, and model serialization.

4. **Deployment** – Only lightweight assets (trained models and analytical snapshots) are deployed, eliminating the need for runtime ETL or model retraining.

---

## Dashboard Features

The Streamlit dashboard provides an interactive environment for business users and decision-makers.

### Executive KPIs

- Overall historical churn rate
- Average customer tenure
- Customer population
- Revenue at risk
- Monthly charges distribution
- Contract distribution

### Customer Prediction Playground

Users can simulate customer scenarios by adjusting variables such as:

- Customer tenure
- Monthly charges
- Contract type
- Internet service
- Payment method
- Additional subscribed services

The application automatically aligns user inputs with the trained model's expected feature order before generating predictions, ensuring reliable inference.

### Interactive Visualizations

The dashboard includes:

- Churn probability gauge
- Customer risk comparison chart
- Executive KPI cards
- Distribution charts built with Plotly

---

## Machine Learning

The project implements a supervised binary classification pipeline to predict whether a customer is likely to churn.

Models evaluated include:

- Logistic Regression
- Random Forest

Model selection is based on overall business usefulness rather than accuracy alone.

### Evaluation Metrics

To better evaluate performance on an imbalanced classification problem, multiple metrics are considered:

- **Accuracy** – Overall prediction correctness.
- **Precision** – Minimizes false positives, reducing unnecessary retention costs.
- **Recall** – Maximizes identification of customers likely to churn, helping protect recurring revenue.

---

## Repository Structure

```text
customer-churn-sql-python/
│
├── data/
│   ├── WA_Fn-UseC_-Telco-Customer-Churn.csv
│   └── churn_snapshot.csv
│
├── models/
│   ├── churn_lr_model.pkl
│   ├── churn_model.pkl
│   └── churn_optimized_rf_model.pkl
│
├── app.py
├── launch.command
├── requirements.txt
├── .gitignore
└── README.md
```

---

## Local Installation

Clone the repository:

```bash
git clone https://github.com/sigmus-aimofumhe1/customer-churn-sql-python.git
cd customer-churn-sql-python
```

Create a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Run the application:

```bash
streamlit run app.py
```

On macOS, you can also launch the application by double-clicking:

```text
launch.command
```

---

## Future Improvements

Potential enhancements include:

- XGBoost and LightGBM benchmarking
- SHAP model explainability
- Customer Lifetime Value (CLV) prediction
- Automated ETL with Apache Airflow
- Docker containerization
- CI/CD using GitHub Actions
- PostgreSQL cloud backend
- Real-time database synchronization
- Model monitoring and drift detection
- REST API deployment with FastAPI

---

## Authors

**Sigmus Aimofumhe**

- GitHub: https://github.com/sigmus-aimofumhe1
- LinkedIn: https://linkedin.com/in/eshiobomhe-aimofumhe/

**Winner Igbogbo**

- GitHub: https://github.com/winner107
- LinkedIn: https://www.linkedin.com/in/winner-igbogbo

---

## License

This project is intended for educational and portfolio purposes.
