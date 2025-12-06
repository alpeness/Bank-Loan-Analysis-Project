## 7) Loan Term Analysis

Comparing the performance and volume of Short-Term vs. Long-Term loans to understand customer preferences and risk profiles.

```sql
SELECT
    l.term AS `Term`,
    COUNT(DISTINCT l.loan_id) AS `Number Of Loans`,
    ROUND(SUM(l.current_loan_amount) / 1000000000, 2) AS `Total Loan Volume in Billion`,
    ROUND(AVG(l.current_loan_amount), 0) AS `Average Loan Amount`,
    ROUND(AVG(cp.credit_score), 1) AS `Average Credit Score`

FROM loans l
JOIN credit_profiles cp ON l.customer_id = cp.customer_id
GROUP BY l.term
ORDER BY COUNT(*) DESC;
```

#### Answer:
<img width="687" height="168" alt="Screenshot 2025-12-06 at 15 59 38" src="https://github.com/user-attachments/assets/a374c26e-db12-40bd-af89-ed3f155f4732" />

<br> <br>

- **Most Popular Choice:** The majority of customers (about 73%) prefer "Short Term" loans. This is the dominant category with $1.65 Billion in total volume.

- **Bigger Loans Need More Time:** "Long Term" loans are much larger on average ($435k) compared to short-term ones ($259k). Customers likely choose long terms to make monthly payments easier on these big amounts.

- **Hidden Risk:** Long-term borrowers have lower credit scores (695) compared to short-term borrowers (725). This means the bank is lending larger amounts for longer periods to slightly riskier customers.
