## 6) Home Ownership Analysis

Evaluating how asset ownership (Rent, Mortgage, Own) impacts borrowing capacity and income levels.

```sql
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
```

#### Answer:
<img width="687" height="187" alt="Screenshot 2025-12-06 at 16 05 21" src="https://github.com/user-attachments/assets/d7689af7-3573-418c-a572-c9dadf8e0680" />

<br> <br>

- **Wealthiest Borrowers:** People paying a "Home Mortgage" are the largest group (49%) and they earn the most money (avg. $1.56 Million/year). Because they earn more, they also take out the biggest loans ($347k).

- **Renters Borrow Less:** Customers who rent tend to have lower incomes ($1.18 Million) and take smaller loans ($267k) compared to homeowners.

- **Scores are the Same:** Surprisingly, owning a home or renting doesn't really change the credit score. All groups have very similar, good scores (around 716-717). This shows that renters are just as reliable as homeowners.
