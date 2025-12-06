## 3) Loan Purpose Analysis

Understanding why customers are borrowing money and their repayment behavior based on the purpose.

```sql
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
```

#### Answer:
<img width="706" height="420" alt="Screenshot 2025-12-05 at 20 43 52" src="https://github.com/user-attachments/assets/8dfe0596-0dcd-43f9-ab65-1f2cd62fbe37" />

<br> <br>

- **Main Reason for Loans:** Most customers (79%) use loans to pay off other debts (Debt Consolidation). This is the biggest category with $2.25 Billion in value.
- **Highest Risk:** Customers borrowing to "Buy a House" are the riskiest. About 25.7% of them (1 in 4) have a history of credit problems.
- **Safest Loans:** Loans for cars and small businesses have the fewest problems. Small business owners rarely have past issues (only 3.23%), making them very safe borrowers.
