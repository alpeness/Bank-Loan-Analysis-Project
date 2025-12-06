## 1) Portfolio Overview

General health check of the loan portfolio including total volume and averages.

```sql
SELECT
    COUNT(DISTINCT c.customer_id) AS `Total Number of Customers`,
    COUNT(DISTINCT l.loan_id) AS `Total Credits`,
    ROUND(SUM(l.current_loan_amount) / 1000000000, 3) AS `Total Loan Amount (Billion)`,
    ROUND(AVG(l.current_loan_amount), 2)AS `Average Loan Amount`,
    ROUND(AVG(cp.credit_score), 2) AS `Average Credit Score`
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
JOIN credit_profiles cp ON l.customer_id = cp.customer_id;
```

#### Answer:
<img width="702" height="88" alt="Screenshot 2025-12-05 at 20 39 49" src="https://github.com/user-attachments/assets/cd8231a1-def1-487a-b10f-de8578a9180d" />

<br> <br>

- The analysis reveals a substantial portfolio valued at **$2.74** billion spanning **10,000** unique clients.
- High average loan volume **(approximately $308,000)** indicates a focus on large-scale credit products (e.g., mortgages).
- With an average credit score of **716.6**, the portfolio appears generally healthy.

