## 2) Credit Score Distribution

To categorize the entire customer base into standardized credit tiers (Fair, Good, Very Good). This segmentation provides a macro-level view of the bank's portfolio health, showing the proportion of low-risk vs high-risk customers.

```sql
SELECT
    CASE
        WHEN cp.credit_score >= 800 THEN 'Excellent'
        WHEN cp.credit_score >= 740 THEN 'Very Good'
        WHEN cp.credit_score >= 670 THEN 'Good'
        WHEN cp.credit_score >= 580 THEN 'Fair'
        ELSE 'Poor'
        END AS credit_score_distribution,
        COUNT(DISTINCT cp.customer_id) AS `Number Of Customer`,
        ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(),2) AS `Percentage`
FROM credit_profiles cp
WHERE cp.credit_score IS NOT NULL
GROUP BY credit_score_distribution
ORDER BY
    CASE credit_score_distribution
        WHEN 'Excellent' THEN 1
        WHEN 'Very Good' THEN 2
        WHEN 'Good' THEN 3
        WHEN 'Fair' THEN 4
        WHEN 'Poor' THEN 5
    END;
```

#### Answer: 
<img width="430" height="141" alt="Screenshot 2025-12-06 at 16 39 06" src="https://github.com/user-attachments/assets/672bab6c-77e9-4799-9cee-5a310a2f520a" />

<br><br>

- **Dominant "Good" Segment:** The largest majority of customers (69.27%) fall into the "Good" category. This indicates a stable and healthy loan portfolio where most customers have acceptable creditworthiness but may still need monitoring.

- **Strong "Very Good" Presence:** Approximately 23% of the customers have a "Very Good" rating. This is the ideal segment for offering premium services, lower interest rates, and higher credit limits, as they represent low default risk.

- **Low Proportion of "Fair" Scores:** Only 7.58% of customers are in the "Fair" category (the lowest tier in this specific dataset). This suggests the bank has relatively little exposure to subprime borrowers, minimizing the overall risk of bad debt.

- **Portfolio Stability:** The absence of "Poor" scores in this distribution result suggests that the bank's existing filtering or acquisition strategies are effective at keeping out the highest-risk individuals.
