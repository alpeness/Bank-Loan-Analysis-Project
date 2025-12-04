# Bank Loan Analysis Project
Analyzing bank loan data with SQL to evaluate portfolio health, credit risk, and customer segmentation.

### 1) Entity Relationship Diagram
<img width="595" height="524" alt="Screenshot 2025-12-04 at 23 35 24" src="https://github.com/user-attachments/assets/07de10a5-c122-4afd-8189-219e6d34e4cb" />

### 2) Business Tasks

#### a) Portfolio overview

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

##### Answer:
<img width="1345" height="56" alt="Screenshot 2025-12-04 at 23 51 10" src="https://github.com/user-attachments/assets/be5aad9a-a5bc-457f-9af3-62f2fe62283a" />


- The analysis reveals a substantial portfolio valued at $2.74 billion spanning 10,000 unique clients.
- High average loan volume (approximately $308,000) indicates a focus on large-scale credit products (e.g., mortgages).
- With an average credit score of 716.6, the portfolio appears generally healthy.


#### b) Loan amount distribution
#### c) Loan purpose analysis
#### d) Risk segmentation
#### e) Loan term analysis
#### f) Home ownership analysis
#### g) Top 10 best customers
#### h) Top 10 riskiest customers
