## TOP 10 Best Customers

To identify the bank's most valuable and lowest-risk customers (the "Premium" segment). This analysis filters for customers with the highest credit scores and zero history of credit problems. The list is ranked first by credit score, then by annual income, to highlight those with the strongest financial profiles.

```sql
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
```

#### Answer:
<img width="739" height="330" alt="Screenshot 2025-12-06 at 16 16 53" src="https://github.com/user-attachments/assets/00fe0d78-04bd-41a7-b6df-81839af80745" />

<br><br>

- **Top-Tier Creditworthiness:** All customers in this list share a credit score of 751, which is the highest in this dataset, along with 0 credit problems. This indicates excellent repayment discipline.

- **High Repayment Capacity:** With annual incomes ranging from 2.2M to 7.67M, these customers have a very high capacity to take on and repay large loans.

- **Opportunity for Cross-Selling:** Several customers (e.g., f57990..., c6ee47...) have high incomes but show NULL for current loan amounts. These are prime candidates for marketing new premium loan products, mortgages, or exclusive credit lines, as they are currently under-utilized by the bank.

