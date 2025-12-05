# Bank Loan Analysis Project
Analyzing bank loan data with SQL to evaluate portfolio health, credit risk, and customer segmentation.

## 1) Entity Relationship Diagram
<img width="595" height="524" alt="Screenshot 2025-12-04 at 23 35 24" src="https://github.com/user-attachments/assets/07de10a5-c122-4afd-8189-219e6d34e4cb" />

## 2) Business Tasks

### a) Portfolio overview

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
<img width="702" height="88" alt="Screenshot 2025-12-05 at 20 39 49" src="https://github.com/user-attachments/assets/cd8231a1-def1-487a-b10f-de8578a9180d" />

- The analysis reveals a substantial portfolio valued at **$2.74** billion spanning **10,000** unique clients.
- High average loan volume **(approximately $308,000)** indicates a focus on large-scale credit products (e.g., mortgages).
- With an average credit score of **716.6**, the portfolio appears generally healthy.


### b) Loan amount distribution

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
##### Answer: 
<img width="626" height="178" alt="Screenshot 2025-12-05 at 20 28 23" src="https://github.com/user-attachments/assets/99a48eb5-e299-487d-9745-55cf64c6c121" />

- **Most Loans are Large:** The data shows that the majority of loans are for large amounts. The "Very High (>200K)" category is the biggest group, making up **71.98%** of all loans.
- **Main Money Source:** Since most loans are in the >200K category, they make up the biggest part of the total money, summing up to about **$2.39 Billion**.
- **Few Small Loans:** Loans under 100K are rare in this dataset, representing less than **9%** of the total. This indicates that the bank mostly gives out large loans instead of small ones.

### c) Loan purpose analysis

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

##### Answer:
<img width="706" height="420" alt="Screenshot 2025-12-05 at 20 43 52" src="https://github.com/user-attachments/assets/8dfe0596-0dcd-43f9-ab65-1f2cd62fbe37" />

- **Main Reason for Loans:** Most customers (79%) use loans to pay off other debts (Debt Consolidation). This is the biggest category with $2.25 Billion in value.
- **Highest Risk:** Customers borrowing to "Buy a House" are the riskiest. About 25.7% of them (1 in 4) have a history of credit problems.
- **Safest Loans:** Loans for cars and small businesses have the fewest problems. Small business owners rarely have past issues (only 3.23%), making them very safe borrowers.


#### d) Risk segmentation
#### e) Loan term analysis
#### f) Home ownership analysis
#### g) Top 10 best customers
#### h) Top 10 riskiest customers
