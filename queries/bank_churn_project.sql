DROP TABLE IF EXISTS bank_churn;

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
-- Check dataset
SELECT *
FROM bank_churn
LIMIT 10;

SELECT COUNT(*)
FROM bank_churn

-- check for missing data
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

-- Phase 2

-- counter number of customers 
SELECT COUNT(*)
FROM bank_churn
;
-- What percentage of customers left the bank?
SELECT 
     ROUND(COUNT(exited)*100.0/
	       (SELECT COUNT(*)
            FROM bank_churn), 2) AS percent_exited 
FROM 
   bank_churn
WHERE 
    exited = 1;

SELECT 
ROUND(SUM(exited)*100.0/COUNT(*), 2) AS churn_percent
FROM bank_churn;

-- PHASE 3: WHERE is churn happening?
-- Does churn differ by geography?
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

--Question 3. Does churn differ across customer demographics?
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
    age_group;

 -- question 4 : Gender
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

-- question 5: Are inactive customers more likely to leave?
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

-- Question 6: Does the number of bank products affect churn?
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

-- Question 7
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

-- Question 8
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

-- Question 9 : Does credit score relate to churn?
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
    credit_score_tier;


-- Question 10: Does estimated salary distinguish customers who leave?
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

-- Question 11 : 
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
