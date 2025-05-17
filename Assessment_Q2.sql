-- Assessment_Q2.sql

/*
Analyzes customer transaction frequency and categorizes them
Calculates months between current date and join date using DATEDIFF
Uses conditional aggregation for efficient calculation
Handles edge cases with NULLIF for tenure
*/

WITH customer_stats AS (
    SELECT 
        u.id,
        COUNT(s.id) + COUNT(w.id) AS total_transactions,
        -- Calculate months since joining using DATEDIFF divided by 30
        DATEDIFF(CURRENT_DATE, u.date_joined) / 30 AS tenure_months
    FROM 
        users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    LEFT JOIN withdrawals_withdrawal w ON u.id = w.owner_id
    GROUP BY 
        u.id, u.date_joined
)

SELECT 
    CASE 
        WHEN (total_transactions / NULLIF(tenure_months, 0)) >= 10 THEN 'High Frequency'
        WHEN (total_transactions / NULLIF(tenure_months, 0)) >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_transactions / NULLIF(tenure_months, 0)), 1) AS avg_transactions_per_month
FROM 
    customer_stats
GROUP BY 
    frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;