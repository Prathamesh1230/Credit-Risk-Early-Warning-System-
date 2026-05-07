create database credit_risk;
use credit_risk;

select count(*) 
from credit_risk_ews_final;

-- 1. Total Records & Default Rate
SELECT 
COUNT(*) AS total_customers,
SUM(`Default`) AS total_defaults,
ROUND(AVG(`Default`)*100,2) AS default_rate_percentage
FROM credit_risk_ews_final;

-- 2. Risk Category Distribution
SELECT Risk_Category,
COUNT(*) AS customer_count
FROM credit_risk_ews_final
GROUP BY Risk_Category
ORDER BY customer_count DESC;

-- 3. Early Warning Customers Count
SELECT Early_Warning,
COUNT(*) AS total_customers
FROM credit_risk_ews_final
GROUP BY Early_Warning;

-- 4. Default Rate by Risk Category
SELECT Risk_Category, COUNT(*) AS total_customers,
SUM(`Default`) AS total_defaults,
ROUND(AVG(`Default`)*100,2) AS default_rate_percentage
FROM credit_risk_ews_final
GROUP BY Risk_Category
ORDER BY default_rate_percentage DESC;

-- 5. Average Risk Score by Loan Purpose
SELECT LoanPurpose,
ROUND(AVG(Risk_Score),2) AS avg_risk_score,
COUNT(*) AS total_customers
FROM credit_risk_ews_final
GROUP BY LoanPurpose
ORDER BY avg_risk_score DESC;

-- 6. Risk Distribution by Employment Type
SELECT EmploymentType, Risk_Category,
COUNT(*) AS total_customers
FROM credit_risk_ews_final
GROUP BY EmploymentType, Risk_Category
ORDER BY EmploymentType;

-- 7. Average Financial Indicators by Risk Category
SELECT Risk_Category,
ROUND(AVG(DTIRatio),3) AS avg_dti,
ROUND(AVG(Loan_to_Income),3) AS avg_loan_income_ratio,
ROUND(AVG(InterestRate),3) AS avg_interest_rate
FROM credit_risk_ews_final
GROUP BY Risk_Category;

-- 8. Top 10 High Risk Customers
SELECT LoanID, Income, LoanAmount, CreditScore, Risk_Score, Risk_Category
FROM credit_risk_ews_final
ORDER BY Risk_Score DESC
LIMIT 10;

-- 9. Ranking Customers by Risk Score
SELECT LoanID, Risk_Score,
RANK() OVER (ORDER BY Risk_Score DESC) AS risk_rank
FROM credit_risk_ews_final;

-- 10. High Risk Portfolio Summary
WITH high_risk_data AS (
SELECT *
FROM credit_risk_ews_final
WHERE Risk_Category = 'High Risk'
)
SELECT 
COUNT(*) AS high_risk_customers,
ROUND(AVG(Risk_Score),2) AS avg_high_risk_score,
ROUND(AVG(DTIRatio),3) AS avg_dti
FROM high_risk_data;

-- 11. Default Rate by Income Group
SELECT 
CASE 
WHEN Income < 40000 THEN 'Low Income'
WHEN Income BETWEEN 40000 AND 80000 THEN 'Middle Income'
ELSE 'High Income'
END AS income_group,
COUNT(*) AS total_customers,
ROUND(AVG(`Default`)*100,2) AS default_rate
FROM credit_risk_ews_final
GROUP BY income_group
ORDER BY default_rate DESC;