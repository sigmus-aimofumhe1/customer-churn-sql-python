# Executive Customer Churn Analytics Platform

An enterprise-grade data science and analytics platform that transforms raw operational telecommunications data into predictive business intelligence. This project implements an end-to-end analytics pipeline spanning relational database design, SQL feature engineering, machine learning model development, and a cloud-hosted interactive dashboard for real-time customer churn prediction.

The platform enables organizations to proactively identify at-risk customers, estimate financial exposure from potential churn, and provide account managers with an interactive environment to evaluate customer retention strategies.

**Live Dashboard:** [https://customer-churn-analytic-dashboard.streamlit.app/](https://customer-churn-analytic-dashboard.streamlit.app/)

---

## Executive Overview

Customer churn is one of the most important business metrics for subscription-based companies. Every customer lost impacts:
* Customer Lifetime Value (LTV)
* Customer Acquisition Cost (CAC)
* Monthly Recurring Revenue (MRR)
* Revenue forecasting
* Sales efficiency

Rather than simply reporting historical churn, this project focuses on **predictive analytics**, allowing organizations to identify customers before they leave.

The platform combines historical customer behavior, engineered SQL features, and machine learning predictions into an executive dashboard for business decision making.

---

## Business KPIs

The dashboard provides executive-level metrics including:

| KPI | Description |
| :--- | :--- |
| **Overall Churn Rate** | Historical percentage of customers that churned (26.5%) |
| **Average Customer Tenure** | Average customer lifetime in months |
| **At-Risk Revenue Pipeline** | Estimated outstanding revenue associated with high-risk customers |
| **Monthly Charges Distribution** | Spending patterns across customer groups |
| **Contract Distribution** | Customer segmentation by contract type |

These KPIs allow decision makers to monitor portfolio health while drilling down into individual customer predictions.

---

## System Architecture

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