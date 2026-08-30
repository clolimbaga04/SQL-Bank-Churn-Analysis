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

- **Primary Objective:** Identify the key demographic and behavioral drivers of customer churn to guide targeted retention strategies.
- **Specific Objective 1:** Evaluate individual customer variables (geography, age, activity, product depth, FICO tiers, and salary) to separate true churn drivers from non-predictive factors.
- **Specific Objective 2:** Build a composite high-risk profile to pinpoint the most vulnerable customer segment and measure its share of total churn volume.

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

## Analysis 

### 📊 Question 1: Baseline Metric
**What is the overall baseline customer churn rate across the entire bank?**
```sql
SELECT 
     ROUND(COUNT(exited)*100.0/
	       (SELECT COUNT(*)
            FROM bank_churn), 2) AS percent_exited 
FROM 
   bank_churn
WHERE 
    exited = 1;
```
Overall Churn Rate: 20.37%

### 🌍 Question 2: Demographic - Geography
**Does customer geographic location (France, Germany, Spain) influence account closure rates?**
```sql
SELECT 
    geography,
    COUNT(customer_id) AS total_customers,
    SUM(exited) AS churned_customers,
    ROUND(AVG(exited) * 100, 2) AS churn_rate_percentage
FROM 
    bank_churn
GROUP BY 
    geography
ORDER BY 
    churn_rate_percentage DESC;
```
| Geography | Total Customers | Churned Customers | Churn Rate Percentage |
|------------|----------------|------------------|----------------------|
| Germany | 2,509 | 814 | 32.44% |
| Spain | 2,477 | 413 | 16.67% |
| France | 5,014 | 810 | 16.15% |

Customer churn is not spread evenly across regions. While France and Spain stay relatively stable with churn rates around 16%, Germany stands out as a major pain point at 32.44%—practically double the other two markets. In fact, even though German clients make up only a quarter of all customers, they account for almost 40% of everyone who walked away.

Still, a customer's location only tells us *where* people are leaving, not *why*. Living in Germany doesn't automatically make someone cancel their account. To see what is really pushing people out the door, we need to dig into who these customers actually are—starting with their age.

### 👥 Question 3: Demographic - Gender
**Do male and female customers exhibit different retention and attrition behaviors?**
```sql
SELECT
    gender,
	COUNT(customer_id),
	SUM(exited) AS churned_customers,
	ROUND(AVG(exited) * 100, 2) AS churn_rate_percentage
FROM
    bank_churn
GROUP BY
    gender
ORDER BY
    churn_rate_percentage;
```
| Gender | Total Customers | Churned Customers | Churn Rate Percentage |
|---------|---------------:|------------------:|----------------------:|
| Male | 5,457 | 898 | 16.46% |
| Female | 4,543 | 1,139 | 25.07% |

Gender reveals another noticeable gap in retention. While male customers stay at a healthier rate with only 16.46% leaving, female customers see a 25.07% churn rate which is roughly 8.6 percentage points higher. In fact, even though there are fewer female clients in the dataset, they make up the majority of total lost accounts (almost 56%).

Just like location, gender alone doesn't explain why people close their accounts. However, knowing that older clients and female clients are leaving at higher rates gives us clear clues on where the bank is slipping. 

### 🎂 Question 4: Demographic - Age
**At what life stage or age bracket are customers most prone to leaving the bank?**
```sql
SELECT
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        WHEN age BETWEEN 51 AND 60 THEN '51-60'
        ELSE '61+' 
    END AS age_group,
	COUNT(customer_id),
	SUM(exited) AS churned_customers,
	ROUND(AVG(exited) * 100, 2) AS churn_rate_percentage
FROM
    bank_churn
GROUP BY
    age_group
ORDER BY
    age_group
```
| Age Group | Total Customers | Churned Customers | Churn Rate Percentage |
|-----------|---------------:|------------------:|----------------------:
| 18-30 | 1,968 | 148 | 7.52% |
| 31-40 | 4,451 | 538 | 12.09% |
| 41-50 | 2,320 | 788 | 33.97% |
| 51-60 | 797 | 448 | 56.21% |
| 61+ | 464 | 115 | 24.78% |

Customer attrition is highly concentrated within specific demographic brackets, revealing a stark non-linear relationship between age and churn. While the bank successfully retains younger demographics (maintaining a low 7.5% to 12% churn rate for customers under 40), risk accelerates dramatically in middle age.

The data highlights a severe retention failure among customers in their 50s, where the churn rate peaks at an alarming 56.21%—meaning more than half of the customers in this bracket are leaving. Furthermore, the 41-50 demographic represents the highest absolute volume of lost accounts (788 customers).

Because these age brackets typically represent a consumer's peak earning and wealth-consolidation years, this targeted attrition suggests the bank's current product offerings may lack competitive wealth management, retirement planning, or investment vehicles. The bank is successfully onboarding young professionals but failing to scale with their financial needs as they mature. To see if these patterns are tied to how people actually interact with the bank, we need to shift our focus from who is leaving to how they behave. Let us now look whether being an active member keeps customers around.

### 🔄 Question 5: Behavioral - Member Activity
**How strongly does active membership and engagement protect against account closure compared to inactivity?**
```sql
SELECT
    CASE WHEN is_active_member = 0 THEN 'inactive'
		 ELSE 'active' END AS member_status,
	COUNT(customer_id),
	SUM(exited) AS churned_customers,
	ROUND(AVG(exited) * 100, 2) AS churn_rate_percentage
FROM
    bank_churn
GROUP BY
    member_status
ORDER BY
    churn_rate_percentage;
```
| Membership Status | Total Customers | Churned Customers | Churn Rate Percentage |
|------------------|---------------:|------------------:|----------------------:|
| Active | 5,151 | 735 | 14.27% |
| Inactive | 4,849 | 1,302 | 26.85% |

Customer activity is a major dividing line in account retention. Active members stay fairly loyal with a churn rate of only 14.27%, while inactive members leave at nearly double that rate (26.85%). In fact, inactive customers account for almost 64% of all lost accounts across the bank.

Unlike age or geography—which a bank cannot change—engagement is something the business can directly influence through targeted marketing, app improvements, and customer outreach. However, member status only tells us if someone is using the bank, not how deeply integrated they are. To see if holding more accounts builds stronger customer loyalty, we next look at how the number of bank products affects churn.

### 🏦 Question 6: Engagement - Product Depth
**How does the number of products held impact segment churn rates, and what proportion of total bank-wide churn volume does each product tier represent?**
```sql
SELECT 
    num_of_products,
    COUNT(customer_id) AS total_customers,
    SUM(exited) AS churned_customers,
    ROUND(AVG(exited) * 100, 2) AS segment_churn_rate,
    ROUND(SUM(exited) * 100.0 / (SELECT SUM(exited) FROM bank_churn), 2) AS pct_of_total_bank_churn
FROM 
    bank_churn
GROUP BY 
    num_of_products
ORDER BY 
    pct_of_total_bank_churn DESC;
```
| Number of Products | Total Customers | Churned Customers | Segment Churn Rate | % of Total Bank Churn |
|-------------------|---------------:|------------------:|-------------------:|----------------------:|
| 1 | 5,084 | 1,409 | 27.71% | 69.17% |
| 2 | 4,590 | 348 | 7.58% | 17.08% |
| 3 | 266 | 220 | 82.71% | 10.80% |
| 4 | 60 | 60 | 100.00% | 2.95% |

Product adoption reveals a clear retention sweet spot. Customers with two products are the most loyal, with a low churn rate of just 7.58%. In contrast, single-product holders leave at more than triple that rate (27.71%) and account for nearly 70% of all lost accounts, showing that shallow account relationships make it easy for customers to switch banks.

At the other extreme, customers holding three or four products experience critical churn spikes at 82.71% and 100%. While this group represents a smaller segment, the sharp drop-off suggests that over-bundling may cause issues—such as overlapping maintenance fees, poor cross-product support, or complicated management.

Since account relationships strongly shape customer behavior, the next step is to examine financial profiles, starting with how account balance tiers relate to customer churn.

### 💳 Question 7: Engagement - Credit Card Ownership
**Does holding a bank-issued credit card act as an effective retention anchor?**
```sql
SELECT 
    CASE 
        WHEN has_cr_card = 1 THEN 'Has Credit Card'
        ELSE 'No Credit Card' 
    END AS credit_card_status,
    COUNT(customer_id) AS total_customers,
    SUM(exited) AS churned_customers,
    ROUND(AVG(exited) * 100, 2) AS churn_rate_percentage
FROM 
    bank_churn
GROUP BY 
    credit_card_status
ORDER BY 
    churn_rate_percentage DESC;
```
 | Credit Card Status | Total Customers | Churned Customers | Churn Rate Percentage |
|-------------------|---------------:|------------------:|----------------------:|
| No Credit Card | 2,945 | 613 | 20.81% |
| Has Credit Card | 7,055 | 1,424 | 20.18% |

Credit card ownership shows almost no impact on customer retention. Clients without a card leave at 20.81%, while those with a card leave at 20.18%—a virtually flat difference of just 0.63 percentage points.

This is an important finding because it proves that simply putting a credit card in a customer's hands does not build loyalty or prevent them from walking away. Because card ownership alone offers no predictive value for churn, we need to look deeper into financial metrics

### 📊 Question 8: Financial - Credit Score
**Does customer creditworthiness (evaluated across standard credit score tiers) predict flight risk?**
```sql
SELECT 
    CASE 
        WHEN credit_score BETWEEN 300 AND 579 THEN '1. Poor (300-579)'
        WHEN credit_score BETWEEN 580 AND 669 THEN '2. Fair (580-669)'
        WHEN credit_score BETWEEN 670 AND 739 THEN '3. Good (670-739)'
        WHEN credit_score BETWEEN 740 AND 799 THEN '4. Very Good (740-799)'
        ELSE '5. Exceptional (800-850)' 
    END AS credit_score_tier,
    COUNT(customer_id) AS total_customers,
    SUM(exited) AS churned_customers,
    ROUND(AVG(exited) * 100, 2) AS churn_rate_percentage
FROM 
    bank_churn
GROUP BY 
    credit_score_tier
ORDER BY 
    credit_score_tier
```
| Credit Score Tier | Total Customers | Churned Customers | Churn Rate Percentage |
|------------------|---------------:|------------------:|----------------------:|
| Poor (300-579) | 2,362 | 520 | 22.02% |
| Fair (580-669) | 3,331 | 685 | 20.56% |
| Good (670-739) | 2,428 | 452 | 18.62% |
| Very Good (740-799) | 1,224 | 252 | 20.59% |
| Exceptional (800-850) | 655 | 128 | 19.54% |

Using the standard FICO score scale reveals that credit health has almost no bearing on whether a customer stays or leaves. Across every category—from Poor to Exceptional—churn rates stay remarkably flat between 18.62% and 22.02%, representing a narrow spread of just 3.4 percentage points.

Customers with top-tier credit (800+) exit at a 19.54% rate, which is barely different from the 20.56% churn rate of Fair-tier holders. This confirms that creditworthiness alone provides little predictive value for identifying flight risk.

### 💰 Question 9: Financial - Account Balance
**Do higher account balances deter or encourage customer churn across balance tiers?**
```sql
SELECT 
    CASE 
        WHEN balance = 0 THEN '1. Zero Balance ($0)'
        WHEN balance > 0 AND balance <= 50000 THEN '2. Low Balance ($1 - $50k)'
        WHEN balance > 50000 AND balance <= 100000 THEN '3. Medium Balance ($50k - $100k)'
        WHEN balance > 100000 AND balance <= 150000 THEN '4. High Balance ($100k - $150k)'
        ELSE '5. Very High Balance ($150k+)' 
    END AS balance_tier,
    COUNT(customer_id) AS total_customers,
    SUM(exited) AS churned_customers,
    ROUND(AVG(exited) * 100, 2) AS churn_rate_percentage
FROM 
    bank_churn
GROUP BY 
    balance_tier
ORDER BY 
    balance_tier;
```
| Balance Tier | Total Customers | Churned Customers | Churn Rate Percentage |
|-------------|---------------:|------------------:|----------------------:|
| Zero Balance ($0) | 3,617 | 500 | 13.82% |
| Low Balance ($1 - $50k) | 75 | 26 | 34.67% |
| Medium Balance ($50k - $100k) | 1,509 | 300 | 19.88% |
| High Balance ($100k - $150k) | 3,830 | 987 | 25.77% |
| Very High Balance ($150k+) | 969 | 224 | 23.12% |

Account balances reveal a surprising dynamic: having more money in the bank does not guarantee customer loyalty. Customers with zero balances show the lowest churn rate at 13.82%, while those in higher balance tiers ($100k and above) leave at rates between 23% and 26%. In fact, customers with over $100k make up nearly 60% of all churned accounts.

This pattern suggests that higher-wealth clients are more sensitive to competitive interest rates, investment returns, or premium perks offered by rival institutions. Losing these accounts poses a direct risk to the bank's total deposit base.

### 💵 Question 10: Financial - Estimated Salary
**Does income level distinguish customers who stay from those who leave?**
```sql
SELECT 
    CASE 
        WHEN exited = 0 THEN 'Stayed'
        ELSE 'Exited' 
    END AS customer_status,
    COUNT(customer_id) AS total_customers,
    ROUND(AVG(estimated_salary), 2) AS average_salary
FROM 
    bank_churn
GROUP BY 
    customer_status;
```
| Customer Status | Total Customers | Average Salary |
|----------------|---------------:|---------------:|
| Stayed | 7,963 | $99,738.39 |
| Exited | 2,037 | $101,465.68 |

Estimated salary shows almost no meaningful difference between customers who stay with the bank and those who leave. Customers who remained earned an average of $99,738.39, compared with $101,465.68 among customers who churned—a difference of only $1,727.29, or about 1.73%.

This suggests that income level alone is not a strong predictor of customer churn. Customers across different income levels are leaving at relatively similar rates, meaning retention efforts should not focus on salary alone.

With individual demographic, behavioral, and financial factors now assessed, the next step is to combine the strongest risk indicators—geography, older age groups, high account balances, and inactive status—to identify a clear high-risk customer profile.

## Question 15 (Composite High-Risk Profile): What is the churn rate when stacking all proven high-risk variables into a single composite profile compared to the rest of the customer base?

Throughout the analysis, we examined each variable individually to distinguish meaningful churn drivers from factors that showed little impact. Financial indicators such as credit score and estimated salary showed almost no relationship with account closures. In contrast, several demographic, behavioral, and product-related factors consistently pointed to customers with higher churn risk.

The next step is to bring these findings together. By combining the strongest risk indicators identified in the earlier analysis, we can identify a specific customer segment that deserves immediate attention:
- Geography: Germany
- Gender: Female
- Age: 40 years and older
- Engagement: Inactive customers
- Product Depth: Customers holding only one product
```sql
SELECT 
    CASE 
        WHEN geography = 'Germany' 
             AND gender = 'Female' 
             AND is_active_member = 0 
             AND num_of_products = 1 
             AND age >= 40 THEN 'Target High-Risk Profile'
        ELSE 'All Other Customers' 
    END AS customer_profile,
    COUNT(customer_id) AS total_customers,
    SUM(exited) AS total_churned,
    ROUND(AVG(exited) * 100, 2) AS churn_rate_percentage
FROM 
    bank_churn
GROUP BY 
    customer_profile
ORDER BY 
    churn_rate_percentage DESC;
```
| Customer Profile | Total Customers | Total Churned | Churn Rate Percentage |
|------------------|---------------:|--------------:|----------------------:|
| Target High-Risk Profile | 200 | 144 | 72.00% |
| All Other Customers | 9,800 | 1,893 | 19.32% |

The combination of these factors reveals a significant retention risk. Among female customers in Germany aged 40 and above who are inactive and hold only one product, 72% have churned.

This is substantially higher than the 19.32% churn rate among all other customers. In other words, customers matching this profile are nearly four times more likely to churn than the rest of the customer base.

This finding turns the analysis from simply describing who is leaving into identifying where the bank should act. Instead of applying broad and costly retention strategies to thousands of customers, the bank can focus its efforts on this concentrated group of 200 high-risk customers.

---

## Recommendations

- Prioritize retention efforts for **high-risk customers** (inactive, Germany-based, female, age 40+, and single-product holders).
- Re-engage **inactive customers** through targeted outreach and personalized offers.
- Encourage **single-product customers** to adopt a second relevant product.
- Strengthen relationships with **older and high-balance customers** through personalized financial services.
- Implement a **churn monitoring dashboard** to identify and address at-risk customers early.
---

### Assumptions & Limitations
### Assumptions
- **Data Integrity:** Each row represents a unique customer and the dataset is free of duplicates.
- **Engagement Validity:** The `is_active_member` flag accurately reflects customer engagement.
 
### Limitations
- **Snapshot Data:** No historical transactions or behavioral trends are available.
- **Limited Detail:** Customer service interactions and specific product types are not included.
- **No External Factors:** Competitor actions and economic conditions are not captured.

> Note: The findings highlight **associations rather than causation** and should be interpreted accordingly.

---
## Author

**Carl Lhester O Limbaga**
