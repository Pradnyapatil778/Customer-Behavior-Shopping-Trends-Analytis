"Item Purchased"select * from customer limit 20

-- 1.total revenue by male and female 
select "Gender" , SUM("Purchase Amount (USD)") As revenue
from Customer 
group by "Gender"


--2.Which c"Customer ID"ustomers used a discount but still spent more than the average purchase amount?
select ("Customer ID"),("Purchase Amount (USD)")
from customer
where ("Discount Applied")= 'Yes' and ("Purchase Amount (USD)") >= (select AVG ("Purchase Amount (USD)") from customer)


--3.Which are the top 5 products with the highest average review rating?
SELECT ("Item Purchased"), ROUND (AVG ("Review Rating"::numeric),2) AS "AVERAGE PRODUCT RATING"
FROM CUSTOMER
GROUP BY ("Item Purchased")
ORDER BY AVG("Review Rating") DESC
LIMIT 5;


--4.Compare the average Purchase Amounts between Standard and Express Shipping.
SELECT ("Shipping Type"),
ROUND (AVG ("Purchase Amount (USD)"),2)
FROM CUSTOMER
WHERE ("Shipping Type") IN ('Standard','Express')
GROUP BY ("Shipping Type");


--5.Do subscribed customers spend more ?Compare average spend and total revenue between subscribers 
--and non-subscribers
SELECT ("Subscription Status"),
COUNT ("Customer ID") AS "total customer",
ROUND (AVG ("Purchase Amount (USD)"),2) AS "avg spend",
ROUND (SUM ("Purchase Amount (USD)"),2) AS "total revenue"
from customer
group by ("Subscription Status")
order by ("avg spend"), ("total revenue") DESC;


--6.Which 5 products have the highest percentage of purchases with discounts applied?
SELECT ("Item Purchased"),
ROUND (SUM(CASE WHEN("Discount Applied")='Yes' then 1 else 0 end)/count (*) *100,2) as "discount rate"
from customer
group by ("Item Purchased")
order by "discount rate" desc
limit 5;


--7.Segment customers into New, Returning, and Loyal based on their total number of previous purchases, 
--and show the count of ech segment.
WITH customer_type AS (
    SELECT ("Customer ID"), 
           CASE 
               WHEN ("Previous Purchases") = 1 THEN 'New' 
               WHEN ("Previous Purchases") BETWEEN 2 AND 10 THEN 'Returning' 
               ELSE 'Loyal' 
           END AS customer_segment 
    FROM customer
)
SELECT customer_segment, COUNT(*) AS number_of_customers 
FROM customer_type 
GROUP BY customer_segment;


-- 8.What are the top 3 most purchased products within each category?
WITH item_counts AS (
    SELECT "Category", "Item Purchased",
    COUNT("Customer ID") AS total_orders,
    ROW_NUMBER() OVER (
           PARTITION BY "Category"
           ORDER BY COUNT("Customer ID") DESC
        ) AS item_rank
    FROM customer
    GROUP BY "Category", "Item Purchased"
)
SELECT 
    item_rank,
    "Category",
    "Item Purchased",
    total_orders
FROM item_counts
WHERE item_rank <= 3;


--9.Are customer who are repeat buyers (more than 5 previous purchases) also likely to subscribr? 
SELECT ("Subscription Status"), COUNT("Customer ID") AS repeat_buyers 
FROM customer 
WHERE ("Previous Purchases") > 5 
GROUP BY ("Subscription Status");


--10.what is the revenue contribution of each age group?
SELECT "Age_group", SUM("Purchase Amount (USD)") AS total_revenue
FROM customer
GROUP BY "Age_group"
ORDER BY total_revenue DESC;
