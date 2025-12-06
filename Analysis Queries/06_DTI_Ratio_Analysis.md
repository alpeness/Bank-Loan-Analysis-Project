## 10) DTI (Debt-to-Income) Ratio Analysis

```sql
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
```

#### Answer:
<img width="683" height="202" alt="Screenshot 2025-12-06 at 16 43 50" src="https://github.com/user-attachments/assets/439019aa-a51c-419e-9d2a-ad592d46b7a4" />

<br><br>

- **Strong Financial Health:** The majority of customers (7,462) maintain a "Low" DTI (<30%) and hold the highest average credit scores (717). This confirms that low leverage correlates with high creditworthiness.

- **Impact of Debt:** There is a clear negative trend: as the debt ratio increases to "Medium," credit scores drop. Higher debt burdens directly reduce customer quality.

- **Over-Leveraged Risk:** The "Very High" DTI segment (>50%) is significant in size (1,981 customers) and borrows as much as the low-risk group (~300k). This suggests these customers are over-leveraged and pose a higher default risk.

- **Data Anomalies:** The NULL values in the "Very High" category point to data quality issues, likely due to unreported or zero income. This specific segment requires manual auditing.
