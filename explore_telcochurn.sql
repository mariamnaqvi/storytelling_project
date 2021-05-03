/* Is there a difference in the rate of churn for month-to-month fiber customers
 who are on automatic payment vs. customers who do not? */

-- rate of churn = number of churned customers / total number of customers

-- using telco churn db

SELECT distinct count(customer_id)
FROM customers;
-- total customers = 7043

SELECT count(customer_id)
FROM customers
JOIN internet_service_types USING (internet_service_type_id)
WHERE internet_service_type_id = 2
AND contract_type_id = 1;
-- 2128 month to month customers have fiber

SELECT count(customer_id)
FROM customers
JOIN internet_service_types USING (internet_service_type_id)
WHERE internet_service_type_id = 2
AND contract_type_id = 1
AND churn = 'Yes';
-- 3096 fiber customers
-- 2128 fiber customers are on month to month plan
-- 1162 customers have fiber, month to month and have churned = 16.5%

SELECT count(customer_id)
FROM customers
JOIN internet_service_types USING (internet_service_type_id)
WHERE internet_service_type_id = 1
AND contract_type_id = 1
AND churn = 'Yes';
-- 394 DSL customers on month to month have churned

SELECT count(customer_id)
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1
AND churn = 'Yes'
AND payment_type_id =4; 
-- 149 customers have fiber, month to month, churned and automatic bank transfer = 2.1%
-- 122 customers have fiber, month to month, churned and automatic card = 1.8%
-- 271 customers have fiber, month to month, churned and auto bank or card = 3.8%

SELECT count(customer_id)
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1
AND churn = 'Yes'
AND (payment_type_id !=4 OR payment_type_id != 3); 
-- 1162 customers have fiber, month to month, churned and non auto payment type = 16.5%

-- customers with auto payments have a lower churn rate
-- recommendation: discount for customers enrolling in auto pay

-- total revenue from month to month fiber customers >>$185,181
SELECT sum(monthly_charges)
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1;

SELECT sum(total_charges)
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1; -- $4,191,552

-- revenue from fiber, month to month, auto pay customers who have churned >> returns 1,731,652.4
SELECT sum(total_charges)
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1
AND churn ='Yes'
AND (payment_type_id !=4 OR payment_type_id != 3);

-- total revenue from month to month fiber customers who churned >> $100.482
SELECT sum(monthly_charges)
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1
AND churn ='Yes';

-- total revenue from customers who churned grouped by tenure 
SELECT round(sum(monthly_charges),2), tenure
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1
AND churn ='Yes'
GROUP BY tenure
ORDER BY tenure;

-- shows fiber, month to month customers w/auto pay who churned decreasing as tenure increases
SELECT count(customer_id), tenure
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1
AND churn ='Yes'
AND (payment_type_id !=4 OR payment_type_id != 3)
GROUP BY tenure
ORDER BY tenure;

-- number of monthly fiber customers with auto pay >> 620
SELECT count(customer_id)
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1
AND (payment_type_id =4 OR payment_type_id =3); 

-- number of monthly fiber customers without auto pay >> 1508
SELECT count(customer_id)
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1
AND (payment_type_id NOT IN (3,4));

-- monthly fiber auto pay customer with churn rate
SELECT count(customer_id), tenure, (count(customer_id)/2128)*100
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1
AND churn ='Yes'
AND (payment_type_id NOT IN (3,4))
GROUP BY tenure
ORDER BY tenure;

-- avg monthly charge for non auto pay >> $86
SELECT AVG(monthly_charges)
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1
AND (payment_type_id NOT IN (3,4));

-- avg monthly charge for auto pay >> $88
SELECT AVG(monthly_charges)
FROM customers
WHERE internet_service_type_id = 2
AND contract_type_id = 1
AND (payment_type_id NOT IN (1,2));