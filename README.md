# Data Analytics Assessment Solutions

## Question 1: High-Value Customers
**Approach**: Used CTEs to efficiently identify customers with both product types. Joined user data with transaction details.

**Challenge**: Initially had column name issues but resolved by reviewing schema hints.

## Question 2: Transaction Frequency
**Approach**: Calculated monthly averages using DATEDIFF. Implemented frequency categorization.

**Challenge**: Adapted date calculations for MySQL compatibility.

## Question 3: Inactivity Alert
**Approach**: Tracked last transaction dates across account types with proper NULL handling.

**Challenge**: Needed multiple iterations to handle edge cases.

## Question 4: CLV Estimation
**Approach**: Calculated lifetime value using transaction patterns and tenure.

**Challenge**: Implemented accurate kobo-to-currency conversion.
