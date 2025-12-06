## 5) Top 10 Riskiest Customers

To identify customers with the lowest credit scores in the dataset. This segment represents the highest risk of default. Analyzing this group helps the bank decide where to tighten lending criteria or increase monitoring to minimize potential losses.

```sql
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
```

#### Answer:
<img width="1112" height="328" alt="Screenshot 2025-12-06 at 16 35 46" src="https://github.com/user-attachments/assets/059106f0-065d-4b6e-8b83-94185482cf45" />

<br><br>

- **Critical Risk Zone:** These customers have credit scores ranging from 585 to 596. In financial terms, this is considered "Subprime" or poor credit. This indicates a significantly higher probability of missed payments compared to the top tier (751).

- **Income vs. Credit Mismatch:** Interestingly, some customers in this high-risk group have very high annual incomes (e.g., badbb5dc-9aef-4f7b-8d66-5233a296a5e7 has 4.976 Million). This shows that high income does not guarantee a good credit score; factors like high debt utilization or past financial behavior are weighing them down.

- **Debt Burden:** Several customers in this list have substantial monthly debt obligations (e.g., e1e4f725-6d3c-4b93-9b64-66398db4e303 pays over 81,000 per month). Combined with a low credit score, this high debt load makes issuing new loans very risky.

- **Actionable Strategy:** The bank should either decline new loan applications for this segment or require collateral (secured loans) and charge higher interest rates to offset the risk.
