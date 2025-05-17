-- Assessment_Q1.sql
/*
High-Value Customers with Multiple Products
Identifies customers with both funded savings and investment plans
Optimized for performance with proper indexing assumptions
*/

WITH 
-- First identify customers with funded savings plans
savings_customers AS (
    SELECT DISTINCT
        p.owner_id
    FROM 
        plans_plan p
    JOIN 
        savings_savingsaccount s ON p.id = s.plan_id
    WHERE 
        p.is_regular_savings = 1
        AND s.confirmed_amount > 0  -- Ensure funded accounts only
),

-- Then identify customers with investment plans
investment_customers AS (
    SELECT DISTINCT
        p.owner_id
    FROM 
        plans_plan p
    WHERE 
        p.is_a_fund = 1
)

-- Main query joining the qualified customers with their details
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p_invest.id) AS investment_count,
    SUM(s.confirmed_amount) / 100.0 AS total_deposits
FROM 
    users_customuser u
-- Join only customers who appear in both CTEs
JOIN savings_customers sc ON u.id = sc.owner_id
JOIN investment_customers ic ON u.id = ic.owner_id
-- Get savings account details
JOIN plans_plan p_savings ON u.id = p_savings.owner_id AND p_savings.is_regular_savings = 1
JOIN savings_savingsaccount s ON p_savings.id = s.plan_id
-- Get investment plan details (count only, no amount needed)
LEFT JOIN plans_plan p_invest ON u.id = p_invest.owner_id AND p_invest.is_a_fund = 1
GROUP BY 
    u.id, u.first_name, u.last_name
ORDER BY 
    total_deposits DESC;
