-- Assessment_Q4.sql
/*
Calculates Customer Lifetime Value based on transaction patterns
Uses MySQL-compatible date functions instead of AGE()
Converts kobo to currency and calculates 0.1% profit per transaction
Handles edge cases with NULL values
*/

WITH customer_transactions AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        -- Calculate tenure in months using TIMESTAMPDIFF (MySQL compatible)
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months,
        COUNT(s.id) + COUNT(w.id) AS total_transactions,
        COALESCE(SUM(s.confirmed_amount), 0) + COALESCE(SUM(w.amount_withdrawn), 0) AS total_amount_kobo
    FROM 
        users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    LEFT JOIN withdrawals_withdrawal w ON u.id = w.owner_id
    GROUP BY 
        u.id, u.first_name, u.last_name, u.date_joined
)

SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(
        -- CLV formula: (total_transactions/tenure) * 12 * avg_profit_per_transaction
        (total_transactions / NULLIF(tenure_months, 0)) * 12 * 
        ((total_amount_kobo * 0.001 / 100) / NULLIF(total_transactions, 0)),
        2
    ) AS estimated_clv
FROM 
    customer_transactions
WHERE 
    tenure_months > 0  -- Exclude customers who joined this month
    AND total_transactions > 0  -- Exclude customers with no transactions
ORDER BY 
    estimated_clv DESC;