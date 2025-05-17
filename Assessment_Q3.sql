-- Assessment_Q3.sql
/*
Identifies inactive accounts with no transactions in over 1 year
Uses proper timestamp columns from the database schema
Handles both savings and investment accounts
Calculates exact inactivity duration in days
*/

WITH account_transactions AS (
    -- Combine all transaction dates from both savings and withdrawals
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
        END AS type,
        MAX(s.transaction_date) AS last_deposit_date,
        MAX(w.transaction_date) AS last_withdrawal_date
    FROM 
        plans_plan p
    LEFT JOIN savings_savingsaccount s ON p.id = s.plan_id
    LEFT JOIN withdrawals_withdrawal w ON p.id = w.plan_id
    WHERE 
        p.is_regular_savings = 1 OR p.is_a_fund = 1
    GROUP BY 
        p.id, p.owner_id, p.is_regular_savings, p.is_a_fund
)

SELECT 
    plan_id,
    owner_id,
    type,
    GREATEST(last_deposit_date, last_withdrawal_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, GREATEST(last_deposit_date, last_withdrawal_date)) AS inactivity_days
FROM 
    account_transactions
WHERE 
    -- Accounts with no transactions at all (both dates NULL)
    (last_deposit_date IS NULL AND last_withdrawal_date IS NULL)
    OR 
    -- Accounts with transactions older than 1 year
    GREATEST(last_deposit_date, last_withdrawal_date) < DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
ORDER BY 
    inactivity_days DESC;