
/* 
SQL Queries for GhostKitchen database
Team: Jiayi Li (queries 1-3) , Katerina Bosko (queries 4-6)
*/

/*
################################################
1. How many customers ordered burgers on Doordash?
################################################
*/

SELECT COUNT(customer_id)
FROM Meal, Pickup_Type
INNER JOIN Customer ON Orders.customer_id = Customer.id
INNER JOIN Orders ON Pickup_Type.id = Orders.pickup_id AND Meal.id = Orders.meal_id
WHERE Meal.meal_name LIKE "%burger%" AND Pickup_Type.type LIKE "%Doordash%"

/*
################################################
2. What are the virtual brands that customers 
give at least 30 5-star ratings?
################################################
*/

SELECT Virtual_Brand.brand_name
FROM Virtual_Brand
INNER JOIN Customer ON Rating.customer_id = Customer.id
INNER JOIN Rating ON Meal.id = Rating.meal_id
INNER JOIN Meal ON Virtual_Brand.id = Meal.brand_id
GROUP BY Virtual_Brand.brand_name
HAVING COUNT(Rating.rating LIKE "%5%") > 30

/*
################################################
3. What are all the order ids for orders picked 
up by drive-through?
################################################
*/
SELECT Orders.id
FROM Orders
WHERE Orders.pickup_id = (
  SELECT Pickup_Type.id
  FROM Pickup_Type
  WHERE Pickup_Type.type = "drive_through"
);


/*
################################################
4. Which state has most customers’ aged between 20 to 30?
################################################
*/
SELECT l.state, COUNT(o.customer_id) AS "Num customers aged bw 20 and 30" 
FROM Location AS l 
JOIN Orders AS o 
ON l.id = o.location_id
JOIN Customer AS c
ON c.id = o.customer_id
WHERE c.age >=20 ANDd c.age <= 30
GROUP BY l.state
ORDER BY COUNT(o.customer_id) DESC
LIMIT 1;

/*
################################################
5. What are popular pickup types in California 
among young customers (age 20-30) who left a rating of at least 4 stars? 
################################################
*/

SELECT pt.type AS "pickup type", COUNT(o.customer_id) AS "number"
FROM Pickup_Type AS pt
JOIN Orders AS o
ON pt.id = o.pickup_id
JOIN Location AS l
ON o.location_id = l.id
JOIN Customer AS c 
ON o.customer_id=c.id
JOIN Rating AS r 
ON c.id=r.customer_id
WHERE l.state == "CA" AND c.age >=20 AND c.age <= 30 AND r.rating >= 4
GROUP BY type
ORDER BY COUNT(o.customer_id) DESC

/*
################################################
6. What is the revenue per virtual brand? 
################################################
*/
SELECT vb.brand_name, ROUND(SUM(o.quantity * m.price), 2) AS "revenue"
FROM Orders as o
JOIN Meal AS m 
ON o.meal_id=m.id
JOIN Virtual_Brand AS vb
ON vb.id=m.brand_id
GROUP BY vb.brand_name
