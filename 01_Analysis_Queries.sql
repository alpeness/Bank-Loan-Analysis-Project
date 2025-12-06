-- 1) Portfolio Overview

SELECT
    COUNT(DISTINCT c.customer_id) AS `Total Number of Customers`,
    COUNT(DISTINCT l.loan_id) AS `Total Credits`,
    ROUND(SUM(l.current_loan_amount) / 1000000000, 3) AS `Total Loan Amount (Billion)`,
    ROUND(AVG(l.current_loan_amount), 2)AS `Average Loan Amount`,
    ROUND(AVG(cp.credit_score), 2) AS `Average Credit Score`
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
JOIN credit_profiles cp ON l.customer_id = cp.customer_id;


-- 2) Credit Score Distribution

SELECT
    CASE
        WHEN cp.credit_score >= 800 THEN 'Excellent'
        WHEN cp.credit_score >= 740 THEN 'Very Good'
        WHEN cp.credit_score >= 670 THEN 'Good'
        WHEN cp.credit_score >= 580 THEN 'Fair'
        ELSE 'Poor'
        END AS credit_score_distribution,
        COUNT(DISTINCT cp.customer_id) AS `Number Of Customer`,
        ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(),2) AS `Percentage`
FROM credit_profiles cp
WHERE cp.credit_score IS NOT NULL
GROUP BY credit_score_distribution
ORDER BY
    CASE credit_score_distribution
        WHEN 'Excellent' THEN 1
        WHEN 'Very Good' THEN 2
        WHEN 'Good' THEN 3
        WHEN 'Fair' THEN 4
        WHEN 'Poor' THEN 5
    END;


-- 3) Risk Segmentation

SELECT
    CASE
        WHEN cp.credit_score >= 750 AND ((cp.monthly_debt / (c.annual_income / 12)) * 100 < 30) AND cp.bankruptcies = 0 THEN 'Low Risk'
        WHEN cp.credit_score >= 700 AND ((cp.monthly_debt / (c.annual_income / 12)) * 100 < 40) THEN 'Medium Risk'
        WHEN cp.credit_score < 650 OR cp.number_of_credit_problems > 0 THEN 'Very High Risk'
        ELSE 'High Risk'
    END AS risk_category,
    COUNT(DISTINCT c.customer_id) AS `Number of Customers`,
    ROUND(AVG(cp.credit_score), 2) AS `Average Credit Score`,
    ROUND(AVG(MAX_LOAN.max_amount), 2) AS `Average Loan Amount`,
    ROUND(AVG(cp.monthly_debt), 2) AS `Average Monthly Debt`,
    ROUND(AVG((cp.monthly_debt / (c.annual_income / 12)) * 100), 2) AS `Average DTI Ratio %`
FROM credit_profiles cp
JOIN customers c ON cp.customer_id = c.customer_id
JOIN (
    SELECT customer_id, MAX(current_loan_amount) as max_amount
    FROM loans
    GROUP BY customer_id
) MAX_LOAN ON c.customer_id = MAX_LOAN.customer_id
GROUP BY risk_category
ORDER BY
    CASE risk_category
        WHEN 'Low Risk' THEN 1
        WHEN 'Medium Risk' THEN 2
        WHEN 'High Risk' THEN 3
        WHEN 'Very High Risk' THEN 4
    END;


-- 4) TOP 10 Best Customers

SELECT
    c.customer_id AS `Customer ID`,
    cp.credit_score AS `Credit Score`,
    ROUND((c.annual_income / 1000000), 3) AS `Annual Income (Million)`,
    l.current_loan_amount AS `Total Loan Amount`

FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
JOIN credit_profiles cp ON c.customer_id = cp.customer_id
WHERE cp.credit_score IS NOT NULL AND
      cp.number_of_credit_problems = 0
ORDER BY cp.credit_score DESC, c.annual_income DESC
LIMIT 10;


-- 5) TOP 10 Riskiest Customer

SELECT
    c.customer_id AS `Customer ID`,
    cp.credit_score AS `Credit Score`,
    cp.number_of_credit_problems AS `Number of Credit Problems`,
    ROUND(c.annual_income / 1000000, 3) AS `Annual Income (Million)`,
    l.current_loan_amount AS `Total Loan Amount`,
    cp.monthly_debt AS `Monthly Debt`

FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
JOIN credit_profiles cp ON c.customer_id = cp.customer_id
WHERE cp.credit_score AND cp.number_of_credit_problems IS NOT NULL
ORDER BY cp.credit_score, cp.number_of_credit_problems DESC
LIMIT 10;


-- 6) DTI (Debt-to-Income) Ratio Analysis

SELECT
    CASE
        WHEN (cp.monthly_debt / (c.annual_income / 12)) * 100 < 30 THEN 'Low (<30%)'
        WHEN (cp.monthly_debt / (c.annual_income / 12)) * 100 < 43 THEN 'Medium (30-43%)'
        WHEN (cp.monthly_debt / (c.annual_income / 12)) * 100 < 50 THEN 'High (43-50%)'
        ELSE 'Very High (>50%)'
    END AS dti_category,
    COUNT(DISTINCT c.customer_id) AS `Number of Customers`,
    ROUND(AVG(cp.credit_score), 2) AS `Average Credit Score`,
    ROUND(AVG((cp.monthly_debt / (c.annual_income / 12)) * 100), 2) AS `Average DTI Ratio %`,
    ROUND(AVG(l.current_loan_amount), 2) AS `Average Loan Amount`
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
JOIN credit_profiles cp ON c.customer_id = cp.customer_id
GROUP BY dti_category
ORDER BY
    CASE dti_category
        WHEN 'Low (<30%)' THEN 1
        WHEN 'Medium (30-43%)' THEN 2
        WHEN 'High (43-50%)' THEN 3
        WHEN 'Very High (>50%)' THEN 4
    END;


-- 7) Loan Term Analysis

SELECT
    l.term AS `Term`,
    COUNT(DISTINCT l.loan_id) AS `Number Of Loans`,
    ROUND(SUM(l.current_loan_amount) / 1000000000, 2) AS `Total Loan Volume in Billion`,
    ROUND(AVG(l.current_loan_amount), 0) AS `Average Loan Amount`,
    ROUND(AVG(cp.credit_score), 1) AS `Average Credit Score`

FROM loans l
JOIN credit_profiles cp ON l.customer_id = cp.customer_id
GROUP BY l.term
ORDER BY COUNT(*) DESC;


-- 8) Loan Amount Distribution

SELECT
    CASE
        WHEN current_loan_amount < 50000 THEN 'Low (0-50K)'
        WHEN current_loan_amount < 100000 THEN 'Medium (50-100K)'
        WHEN current_loan_amount < 200000 THEN 'High (100-200K)'
        ELSE 'Very High (200K+)'
    END AS loan_category,
    COUNT(*) AS `Number of Loan`,
    SUM(current_loan_amount) AS `Total Amount`,
    ROUND(AVG(current_loan_amount), 2) AS `Average Amount`,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS 'Percentage'
FROM loans l
GROUP BY loan_category
ORDER BY CASE loan_category
        WHEN 'Low (0-50K)' THEN 1
        WHEN 'Medium (50-100K)' THEN 2
        WHEN 'High (100-200K)' THEN 3
        WHEN 'Very High (200K+)' THEN 4
    END;


-- 9) Loan Purpose Analysis

SELECT
    l.purpose as Purpose,
    COUNT(DISTINCT l.loan_id) `Number of Loans For Each Purpose`,
    SUM(l.current_loan_amount) AS `Total Loan Amount`,
    ROUND(AVG(cp.credit_score), 2) `Average Credit Score`,
    ROUND(AVG(cp.monthly_debt), 2) `Average Monthly Debt`,
    COUNT(CASE WHEN cp.number_of_credit_problems > 0 THEN 1 END) `Customers With Credit Problems`,
    ROUND(100.0 * COUNT(CASE WHEN cp.number_of_credit_problems > 0 THEN 1 END) / COUNT(*), 2) AS `Percentage Have Problems`
FROM loans l
JOIN customers c ON c.customer_id = l.customer_id
JOIN credit_profiles cp ON l.customer_id = cp.customer_id
GROUP BY purpose
ORDER BY `Percentage Have Problems` DESC;


-- 10) Home Ownership Analysis

SELECT
    c.home_ownership AS `Home Ownership`,
    COUNT(*) AS `Number Of Customer`,
    ROUND(AVG(c.annual_income) / 1000000, 3) AS `Average Income in Million (Annual)`,
    ROUND(AVG(l.current_loan_amount), 2) AS `Average Loan Amount`,
    ROUND(AVG(cp.credit_score), 2) AS `Average Credit Score`

FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
JOIN credit_profiles cp ON c.customer_id = cp.customer_id
GROUP BY home_ownership
ORDER BY COUNT(*) DESC;

