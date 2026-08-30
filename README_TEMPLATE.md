# 🏦 Bank Customer Churn: Behavioral & Demographic Drivers of Attrition
***Decoding Bank Churn: What Really Makes Customers Walk Away?***

> When a customer closes their bank account, who do you picture? 🤔💭

A low-income saver struggling with minimum balance requirements? A borrower with a poor credit score who got rejected for a loan? Or someone with a maxed-out credit card?

Most people assume customer attrition is driven by financial hardship. But when you look closely at raw banking records, the usual assumptions begin to fall apart. High earners walk away just as easily as entry-level workers, and pristine credit scores offer zero guarantee of loyalty.

So if creditworthiness, account balances, and annual salaries don't predict who stays and who leaves... what actually does?

This project conducts an end-to-end SQL investigation across 10,000 retail banking accounts to look past standard financial metrics, separate statistical noise from genuine behavioral signals, and uncover the real root causes of customer flight.

---

## 1. Project Overview

A retail bank was experiencing elevated customer attrition but lacked clarity on the true behavioral and demographic root causes behind account closures. This project analyzes 10,000 European customer records using PostgreSQL to evaluate data completeness, test common financial assumptions, and identify the key drivers of customer flight. By examining demographic segments, product engagement levels, and multi-variable risk profiles, the analysis isolates high-risk customer segments to support proactive, data-driven retention strategies.

---

## 🎯 Objectives

- **Primary Objective:** [Identify the key demographic and behavioral drivers of customer churn to guide targeted retention strategies.]
- **Specific Objective 1:** [Evaluate individual customer variables (geography, age, activity, product depth, FICO tiers, and salary) to separate true churn drivers from non-predictive factors.]
- **Specific Objective 2:** [Build a composite high-risk profile to pinpoint the most vulnerable customer segment and measure its share of total churn volume.]

> 💡 *Every analysis decision in this project traces back to one of these objectives.*

---

## 🛠️ Project Scope & Tools

### Project Scope

| Dimension | Details |
|-----------|---------|
| **In Scope** | Analysis of **10,000 retail banking customer records** across **France, Germany, and Spain**. Evaluation includes demographic attributes (**Age, Gender, Country**), financial metrics (**FICO Credit Score, Account Balance, Estimated Salary**), engagement indicators (**Active Membership, Product Count, Credit Card Status**), and customer churn outcomes (`Exited`). |
| **Out of Scope** | Predictive machine learning models (such as Random Forest and Logistic Regression), customer sentiment or satisfaction surveys, customer support ticket logs, and detailed transaction-level data, as these were not available in the source dataset. |
| **Time Period** | Cross-sectional snapshot from a historical Kaggle benchmark dataset. Analysis conducted in **2026**. |
| **Granularity** | Customer-level data, with **one row representing one unique customer** (`customer_id`). |
---

### Tools & Technologies

| Category | Tool(s) Used |
|-----------|-------------|
| **Data Storage** | PostgreSQL, CSV (Raw Kaggle Dataset) |
| **Data Processing** | PostgreSQL (DDL, table creation, data integrity validation, data type conversion) |
| **Analysis** | SQL (Aggregations, CASE Statements, Subqueries, Window Functions, Customer Segmentation) |
| **Database Client** | pgAdmin 4 |
| **Version Control** | Git, GitHub |
| **Documentation** | Markdown (`README.md`) |
---

### Technology Stack

- **PostgreSQL** → Database management and analytical querying.
- **pgAdmin 4** → Database administration and query execution.
- **SQL** → Data cleaning, transformation, segmentation, and business analysis.
- **Git & GitHub** → Version control and project portfolio hosting.
- **Markdown** → Project documentation and reporting.

---

## ⚙️Data Source & Schema

### Data Source

- **Origin:** Kaggle - Bank Customer Churn Dataset
- **Dataset Structure:** Contains **10,000 unique customer records** from **France, Germany, and Spain**, with 13 core customer and banking attributes.
- **Format:** Flat CSV file imported into PostgreSQL for analysis.

---
## Data Dictionary & Schema Definition

| Column Name | Data Type | Constraints | Description |
|------------|-----------|------------|-------------|
| `customer_id` | INTEGER | Unique Identifier | Unique numerical identifier assigned to each customer. |
| `surname` | VARCHAR(255) | NOT NULL | Customer's surname used for identification purposes. |
| `credit_score` | INTEGER | 350-850 | FICO-based score representing the customer's creditworthiness. |
| `geography` | VARCHAR(255) | Categorical | Customer's country of residence (`France`, `Germany`, or `Spain`). |
| `gender` | VARCHAR(50) | Categorical | Customer gender (`Male` or `Female`). |
| `age` | INTEGER | Continuous | Customer age in years. Analysis includes age-group segmentation. |
| `tenure` | INTEGER | 0-10 Years | Number of years the customer has maintained a relationship with the bank. |
| `balance` | NUMERIC | Monetary Value | Current account balance held by the customer. |
| `num_of_products` | INTEGER | 1-4 | Total number of banking products or services owned by the customer. |
| `has_cr_card` | INTEGER | Binary (0/1) | Indicates credit card ownership (`1 = Yes`, `0 = No`). |
| `is_active_member` | INTEGER | Binary (0/1) | Indicates account activity status (`1 = Active`, `0 = Inactive`). |
| `estimated_salary` | NUMERIC | Monetary Value | Estimated annual salary of the customer. |
| `exited` | INTEGER | Binary (0/1) | Customer churn indicator (`1 = Exited`, `0 = Retained`). |
---

## 📊Pre-Analysis 

Before conducting the analysis, the dataset was imported into PostgreSQL and subjected to a series of quality assurance checks to ensure data accuracy, completeness, and structural integrity.

### Database Setup

The first step was creating a relational table that mirrors the structure of the source dataset.

```sql

CREATE TABLE bank_churn (
customer_id INTEGER,
surname VARCHAR(255),
credit_score INTEGER,
geography VARCHAR(255),
gender VARCHAR(50),
age INTEGER,
tenure INTEGER,
balance NUMERIC,
num_of_products INTEGER,
has_cr_card INTEGER,
is_active_member INTEGER,
estimated_salary NUMERIC,
exited INTEGER
);
```
I began by creating a PostgreSQL table to store the customer churn dataset and assigning appropriate data types to each attribute.

- `INTEGER` was used for numeric identifiers, counts, and binary indicators.
- `VARCHAR` was used for categorical and text-based attributes.
- `NUMERIC` was assigned to financial variables such as `balance` and `estimated_salary` to preserve decimal precision.

This schema provided a structured foundation for data validation and analytical querying.
---

### Initial Data Inspection

After importing the CSV file, I performed a quick inspection of the dataset to verify that the import process was successful.
```sql
SELECT *
FROM bank_churn
LIMIT 10;
```
Reviewing a sample of records helped confirm that:
- Columns were mapped correctly.
- Data types appeared consistent with expectations.
- Categorical values were imported properly.
- No column shifting or formatting issues occurred during import.
- 
This initial inspection served as an important quality check before deeper analysis.

---

### Data Integrity & Missing Value Audit

To assess data completeness, I checked every column for missing values.

```sql
SELECT
COUNT(*) - COUNT(customer_id) AS missing_customer_id,
COUNT(*) - COUNT(surname) AS missing_surname,
COUNT(*) - COUNT(credit_score) AS missing_credit_score,
COUNT(*) - COUNT(geography) AS missing_geography,
COUNT(*) - COUNT(gender) AS missing_gender,
COUNT(*) - COUNT(age) AS missing_age,
COUNT(*) - COUNT(tenure) AS missing_tenure,
COUNT(*) - COUNT(balance) AS missing_balance,
COUNT(*) - COUNT(num_of_products) AS missing_num_of_products,
COUNT(*) - COUNT(has_cr_card) AS missing_has_cr_card,
COUNT(*) - COUNT(is_active_member) AS missing_is_active_member,
COUNT(*) - COUNT(estimated_salary) AS missing_estimated_salary,
COUNT(*) - COUNT(exited) AS missing_exited
FROM bank_churn;
```
Data quality is critical for producing reliable analytical insights. To verify completeness, I compared the total row count against the non-null count for each column.

**Result:** No missing values were detected across any field in the dataset.

This confirmed that:
- The dataset was fully populated.
- No imputation techniques were required.
- All customer records were eligible for analysis.





## 10. Recommendations

<!--
  Action-oriented. Addressed to a real audience.
  Tied explicitly to the insight that supports each one.

  WHAT GOOD LOOKS LIKE:
  Priority: High
  Recommendation: "Conduct a fulfilment audit for home goods deliveries
                   in Region A - specifically investigating whether returns
                   correlate with a particular warehouse, carrier, or SKU batch."
  Based On: Insight 1 - return rate anomaly in Region A
  Owner: Operations / Supply Chain team

  WHAT TO AVOID:
  ❌ "Improve the return rate."
     (Not actionable. Doesn't say who, how, or where to start.)
  ❌ "Further analysis is needed."
     (This is a placeholder, not a recommendation.)
-->

| Priority | Recommendation | Based On | Suggested Owner |
|----------|---------------|----------|-----------------|
| High | [Specific, actionable step] | [Insight it comes from] | [Who should act] |
| Medium | [Specific, actionable step] | [Insight it comes from] | [Who should act] |
| Low | [Exploratory or longer-term suggestion] | [Insight it comes from] | [Who should act] |

---

## 11. Assumptions & Limitations

<!--
  WHAT GOOD LOOKS LIKE:
  Assumption: "Transaction records were assumed to be complete for all five regions.
               No validation was performed against source system record counts."
  Limitation: "The analysis cannot distinguish between returns initiated by
               the customer vs. returns initiated by the business (e.g., recalls).
               If business-initiated returns are concentrated in Region A, the
               return rate finding may reflect a policy decision, not a quality issue."

  WHAT TO AVOID:
  ❌ Leaving this section blank or writing "None known."
     Every project has limitations. Documenting them is a sign of
     analytical maturity - not a confession of failure.
-->

### Assumptions
- [What did you treat as true without being able to verify?]
- [What simplifications did you make for scope or feasibility?]
- [What domain rules or definitions did you accept as given?]

### Limitations
- [What gaps exist in the data?]
- [What analysis was out of scope but could affect interpretation?]
- [What would a more rigorous version of this project include?]
- [Are there known biases in the data source or collection method?]

> *The goal here is pre-emptive Q&A. What would a thoughtful skeptic push back on? Document the answer here, before they ask.*

---

## 12. Future Enhancements

<!--
  WHAT GOOD LOOKS LIKE:
  ✅ "Automate the monthly data pull from the POS export folder using
      a scheduled Python script, replacing the current manual process."
  ✅ "Expand the return rate analysis to include carrier-level data,
      which was unavailable in this dataset but exists in the logistics system."

  WHAT TO AVOID:
  ❌ "Add a machine learning model."
     (Vague, and disconnected from the actual findings of this project.)
  ❌ Listing aspirational features that don't follow logically from the work.
-->

- [ ] [Enhancement 1 - specific and traceable to a real gap in this project]
- [ ] [Enhancement 2]
- [ ] [Enhancement 3]
- [ ] [Enhancement 4]

---

## 13. Deliverables

| Deliverable | Description | Location |
|-------------|-------------|----------|
| [Name] | [What it contains] | [`/path/to/file`] |
| [Name] | [What it contains] | [`/path/to/file`] |
| [Name] | [What it contains] | [`/path/to/file`] |

---

## 14. Author

**[Your Name]**
[Your role or title - current or target]

- 🔗 [LinkedIn URL]
- 💼 [Portfolio or GitHub profile URL]
- 📧 [Email - optional]

---

*Last updated: [Month YYYY]*
*If this template helped you, consider starring the repository.*
