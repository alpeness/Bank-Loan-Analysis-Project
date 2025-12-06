## 3) Risk Segmentation

Categorizing customers into risk levels (Low, Medium, High, Very High) to understand potential default risks.

```sql
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
```

#### Answer:
<img width="706" height="218" alt="Screenshot 2025-12-06 at 15 54 41" src="https://github.com/user-attachments/assets/6f1b2954-e028-4553-a5f2-ba3d2f04fde7" />

<br><br>

- **The Majority are Safe:** Most customers (about 61%) fall into the "Medium Risk" category. They have solid credit scores (around 728) and manageable debt levels.

- **Risky Borrowing Trend:** Surprisingly, the "Very High Risk" customers are borrowing the most money (avg. $342k), even though they have the lowest credit scores. This is a major red flag for the bank.

- **Ideal Customers are Rare:** Only a tiny group (1.7%) qualifies as "Low Risk." These people have very little debt compared to their income (12% DTI), making them the perfect borrowers.

