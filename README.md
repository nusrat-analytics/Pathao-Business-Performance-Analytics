# Pathao-Business-Performance-Analytics
<img width="1358" height="759" alt="Executives Insights   Recommendations" src="https://github.com/user-attachments/assets/ab02263e-2022-4a94-a576-dcbf69165cdf" />
#  Pathao Ride-Sharing Business Intelligence Dashboard

### End-to-End Business Intelligence Solution

PostgreSQL | SQL |Power BI | DAX | Business Intelligence | Data Engineering

##### Transforming ride-sharing operational data into actionable business intelligence through modern data engineering, dimensional modeling, and executive analytics.

### Business Problem

Ride-sharing platforms generate thousands of operational records every day. Without an integrated analytics platform, stakeholders struggle to identify revenue trends, understand customer behavior, optimize driver utilization, reduce cancellations, and make informed strategic decisions.This project addresses these challenges by transforming raw ride-sharing data into executive-ready dashboards that enable data-driven operational and strategic decision-making.

### Business Objectives

* Monitor Revenue Performance

* Analyze Demand Patterns

* Reduce Cancellation Risk

* Improve Driver Productivity

* Measure Customer Retention

* Support Executive Decisions

### End-to-End Analytics Workflow

```mermaid
flowchart LR
    A[CSV Data Sources] --> B[PostgreSQL]
    B --> C[Raw Layer]
    C --> D[Staging Layer]
    D --> E[Intermediate Layer]
    E --> F[Analytics Layer]
    F --> G[Power BI Data Model]
    G --> H[Interactive Dashboards]
    H --> I[Business Insights & Recommendations]
```

### PostgreSQL Data Engineering

| Layer        | Description                                    |
| ------------ | ---------------------------------------------- |
| Raw          | Source ride-sharing datasets                   |
| Staging      | Cleaning, profiling, validation                |
| Intermediate | Business transformations & feature engineering |
| Analytics    | Reporting-ready dimensional tables             |


#### SQL Tasks Performed

* Data Profiling

* Data Cleaning

* Duplicate Detection

* Data Validation

* Missing Value Handling

* Feature Engineering

* Business Rule Validation

* SQL Views

* Multi-layer Architecture

### Power BI Data Model
<img width="1410" height="720" alt="Data Modelling" src="https://github.com/user-attachments/assets/b48537d8-7fef-463d-9241-a4ef3aabbdbe" />


##### The analytical model follows a star schema consisting of one centralized fact table connected to customer, driver, date, and time dimensions, enabling scalable analytical queries and efficient report performance.

###  Dashboard Walkthrough

##### The dashboard is organized into seven analytical modules, each designed to answer specific business questions and support data-driven decision-making across executive, operational, customer, and revenue perspectives.

#### 01. Executive Overview

<img width="1046" height="738" alt="Overview" src="https://github.com/user-attachments/assets/5391c6f0-ff6d-4453-8910-ec2560edf834" />

#### Business Questions
*How is overall business performance changing?
*What are the current operational KPIs?
*Which customer segments contribute the most revenue?
#### Key Insights
*Revenue decreased compared with the previous period.
*Premium customers generated most of the revenue.
*Peak-hour demand drives operational pressure.
#### Business Value
Provides executives with an overall health check of business performance.

#### Demand & Supply

<img width="1047" height="593" alt="Demand   Supply" src="https://github.com/user-attachments/assets/b8a675ba-10ef-4712-9673-bd97d963a345" />


