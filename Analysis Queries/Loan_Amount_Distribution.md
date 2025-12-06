## 2) Loan Amount Distribution

Categorizing loans into Low, Medium, High, and Very High segments to analyze the concentration of capital.

```sql
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
```
#### Answer: 
<img width="626" height="178" alt="Screenshot 2025-12-05 at 20 28 23" src="https://github.com/user-attachments/assets/99a48eb5-e299-487d-9745-55cf64c6c121" />

<br> <br>

- **Most Loans are Large:** The data shows that the majority of loans are for large amounts. The "Very High (>200K)" category is the biggest group, making up **71.98%** of all loans.
- **Main Money Source:** Since most loans are in the >200K category, they make up the biggest part of the total money, summing up to about **$2.39 Billion**.
- **Few Small Loans:** Loans under 100K are rare in this dataset, representing less than **9%** of the total. This indicates that the bank mostly gives out large loans instead of small ones.
