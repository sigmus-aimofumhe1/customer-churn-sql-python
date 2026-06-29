````markdown
# Executive Customer Churn Analytics Platform

An enterprise-grade data science and analytics platform that transforms raw operational telecommunications data into predictive business intelligence. This project implements an end-to-end analytics pipeline spanning relational database design, SQL feature engineering, machine learning model development, and a cloud-hosted interactive dashboard for real-time customer churn prediction.

The platform enables organizations to proactively identify at-risk customers, estimate financial exposure from potential churn, and provide account managers with an interactive environment to evaluate customer retention strategies.

** Live Dashboard:** https://customer-churn-analytic-dashboard.streamlit.app/

---

# Executive Overview

Customer churn is one of the most important business metrics for subscription-based companies. Every customer lost impacts:

- Customer Lifetime Value (LTV)
- Customer Acquisition Cost (CAC)
- Monthly Recurring Revenue (MRR)
- Revenue forecasting
- Sales efficiency

Rather than simply reporting historical churn, this project focuses on **predictive analytics**, allowing organizations to identify customers before they leave.

The platform combines historical customer behavior, engineered SQL features, and machine learning predictions into an executive dashboard for business decision making.

---

# Business KPIs

The dashboard provides executive-level metrics including:

| KPI | Description |
|------|-------------|
| **Overall Churn Rate** | Historical percentage of customers that churned (26.5%) |
| **Average Customer Tenure** | Average customer lifetime in months |
| **At-Risk Revenue Pipeline** | Estimated outstanding revenue associated with high-risk customers |
| **Monthly Charges Distribution** | Spending patterns across customer groups |
| **Contract Distribution** | Customer segmentation by contract type |

These KPIs allow decision makers to monitor portfolio health while drilling down into individual customer predictions.

---

# System Architecture

The application follows a modular production-style architecture.

Heavy computation—including database processing, SQL transformations, feature engineering, and machine learning training—is performed offline.

The deployed Streamlit application serves only lightweight inference and visualization.

```text
+----------------------------------------------------------------------------------+
|                         OFFLINE DATA & MODELING LAYER                            |
|                                                                                  |
| Raw Telco Dataset                                                                |
|        │                                                                         |
|        ▼                                                                         |
| PostgreSQL Database                                                              |
|        │                                                                         |
|        ▼                                                                         |
| SQL Feature Engineering Views                                                    |
|        │                                                                         |
|        ▼                                                                         |
| Python Data Pipeline                                                             |
|        │                                                                         |
|        ▼                                                                         |
| Machine Learning Training                                                        |
|        │                                                                         |
|        ▼                                                                         |
| Serialized Models (.pkl) + Snapshot Dataset                                      |
+----------------------------------------------------------------------------------+
                                      │
                                      ▼
+----------------------------------------------------------------------------------+
|                         ONLINE INFERENCE LAYER                                   |
|                                                                                  |
| Snapshot CSV                                                                     |
|        │                                                                         |
|        ▼                                                                         |
| Streamlit Application                                                            |
|        │                                                                         |
|        ▼                                                                         |
| Plotly Dashboards                                                                |
|        │                                                                         |
|        ▼                                                                         |
| Real-Time Customer Churn Predictions                                             |
+----------------------------------------------------------------------------------+
```

---

# Technology Stack

### Database

- PostgreSQL
- SQL
- Relational schema design
- Views
- Feature engineering

### Data Science

- Python
- Pandas
- NumPy
- Scikit-Learn

### Machine Learning

- Logistic Regression
- Random Forest
- Feature preprocessing
- Model serialization with Pickle

### Visualization

- Streamlit
- Plotly Graph Objects

### Deployment

- Streamlit Community Cloud

---

# Data Pipeline

The project follows a structured analytics workflow.

## 1. Data Ingestion

The raw telecommunications dataset is imported into PostgreSQL.

During ingestion:

- Missing values are handled
- Data types are standardized
- Constraints are validated
- Tables are normalized where appropriate

---

## 2. SQL Feature Engineering

Instead of performing all preprocessing in Python, important business features are engineered inside SQL.

Examples include:

- Customer tenure calculations
- Monthly revenue aggregations
- Contract classifications
- Service adoption indicators
- Customer segmentation variables

The resulting analytical view serves as the machine learning feature table.

---

## 3. Machine Learning

The engineered dataset is exported into Python for model training.

Models evaluated include:

- Logistic Regression
- Optimized Random Forest

Training includes:

- Train/test split
- Feature preprocessing
- Model evaluation
- Performance comparison
- Serialization using Pickle

---

## 4. Deployment

Only lightweight assets are deployed:

- Trained model
- Snapshot dataset
- Streamlit dashboard

No heavy ETL or model retraining occurs during runtime.

This significantly improves deployment speed and cloud resource usage.

---

# Interactive Prediction Playground

The application includes a real-time prediction interface where users can simulate customer scenarios.

The interface automatically aligns user inputs with the trained model's expected feature ordering using:

```python
model.feature_names_in_
```

This prevents feature mismatch during inference.

Users can modify:

- Customer tenure
- Monthly charges
- Contract type
- Internet service
- Payment method
- Additional customer attributes

The application constructs a feature vector matching the model's training schema before generating predictions.

---

# Dashboard Features

## Executive KPIs

- Overall churn rate
- Average customer tenure
- Revenue at risk
- Customer counts

---

## Churn Probability Prediction

The dashboard estimates:

- Churn probability
- Predicted customer outcome
- Confidence score

---

## Risk Comparison Chart

A horizontal Plotly bar chart compares:

- Current customer risk
- Historical company churn average

Horizontal orientation was intentionally selected to improve readability across devices.

---

## Risk Gauge

A Plotly radial gauge visualizes churn probability.

Conditional coloring provides immediate interpretation:

- 🟢 Green → Low Risk
- 🔴 Red → High Risk

The gauge updates instantly whenever user inputs change.

---

# Machine Learning Evaluation

Accuracy alone is insufficient for churn prediction because customer churn datasets are often imbalanced.

Instead, model performance was evaluated using business-oriented metrics.

## Precision

High precision minimizes false positives.

Business benefit:

- Reduces unnecessary retention discounts
- Avoids spending marketing budget on customers who were unlikely to churn

---

## Recall

High recall maximizes identification of actual churning customers.

Business benefit:

- Captures more customers before cancellation
- Protects recurring revenue
- Improves retention campaign effectiveness

---

## Model Selection

Multiple algorithms were evaluated.

The production model was selected based on overall predictive performance and business usefulness rather than accuracy alone.

---

# Repository Structure

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

# Local Installation

## Clone the Repository

```bash
git clone https://github.com/sigmus-aimofumhe1/customer-churn-sql-python.git

cd customer-churn-sql-python
```

---

## Create a Virtual Environment

```bash
python3 -m venv .venv

source .venv/bin/activate
```

---

## Install Dependencies

```bash
pip install -r requirements.txt
```

---

## Run the Application

```bash
streamlit run app.py
```

Or on macOS:

Double-click

```text
launch.command
```

to start the application automatically.

---

# Project Highlights

- Relational database design

- SQL feature engineering

- Machine learning pipeline

- Logistic Regression implementation

- Random Forest implementation

- Feature preprocessing

- Interactive Streamlit dashboard

- Plotly visualizations

- Cloud deployment

- Real-time customer inference

---

# Future Improvements

Potential enhancements include:

- XGBoost and LightGBM benchmarking
- SHAP model explainability
- Customer lifetime value prediction
- Automated ETL pipeline with Airflow
- Docker containerization
- CI/CD with GitHub Actions
- PostgreSQL hosted backend
- Real-time database synchronization
- Model monitoring and drift detection
- REST API deployment with FastAPI

---

# Authors

**Sigmus Aimofumhe**
GitHub: *https://github.com/sigmus-aimofumhe1*
LinkedIn: *https://linkedin.com/in/eshiobomhe-aimofumhe/*

**Winner Igbogbo**

GitHub: *https://github.com/winner107*

LinkedIn: *https://www.linkedin.com/in/winner-igbogbo*

---

# License

This project is intended for educational and portfolio purposes.
````
