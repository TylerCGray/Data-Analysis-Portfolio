-- How many customer orders each day?
-- COUNT function used to calculate total orders

SELECT  date,
	COUNT(order_id) AS total_orders
FROM orders
GROUP BY date
ORDER BY date 

-- Peak hours for the business?
-- Used DATEPART to extract hour of day

SELECT  DATEPART(hour, time) AS hour_of_day,
	COUNT(order_id) AS total_orders
FROM orders
GROUP BY DATEPART(hour, time)
ORDER BY total_orders DESC

-- How many pizzas are typically in an order?
-- Utilized a total pizzas per order CTE and then calculated average on the count of pizzas per order)

WITH total_pizzas_per_order AS
	(SELECT  order_id,
	 COUNT(pizza_id) AS total_pizzas
	FROM order_details
	GROUP BY order_id)

SELECT AVG(total_pizzas) AS average_order_quantity
FROM total_pizzas_per_order

-- How much money made in the year rounded to 2nd decimal place (only 2015 available in dataset) 
-- Used DATEPART to extract year and aggregate function SUM to calculate total revenue)
-- Multiple INNER JOINS used to join order details and pizzas table. This was needed to obtain pricing information per pizza type

SELECT  DATEPART(Year, date) AS year,
	ROUND(SUM(price),2) AS total_revenue
FROM orders o
JOIN order_details d
ON o.order_id = d.order_id
JOIN pizzas p
ON d.pizza_id = p.pizza_id
GROUP BY DATEPART(Year, date)


-- Can we indentify any seasonality in the sales?
-- Used DATEPART to extract month number. SUM aggregate function used to calculate total revenue

SELECT  DATEPART(Month, date) AS month,
	ROUND(SUM(price),2) AS total_revenue
FROM orders o
JOIN order_details d
ON o.order_id = d.order_id
JOIN pizzas p
ON d.pizza_id = p.pizza_id
GROUP BY DATEPART(Month, date)
ORDER BY total_revenue DESC

-- Are there any pizzas we should take of the menu?
-- Ranking CTE created to rank total ordered quantities smallest to largest
-- Selected 5 lowest performing pizzas

WITH ranking AS
	(SELECT	pizza_id,
	SUM(quantity) AS total_pizzas_purchased,
	DENSE_RANK () OVER (order by SUM(quantity) ASC) AS ranking
	FROM order_details
	GROUP BY pizza_id)

SELECT pizza_id
FROM ranking
WHERE ranking <=5


-- Top 5 orders placed ordered by total value

SELECT	TOP 5
	order_id,
	ROUND(SUM(price * quantity),2) AS order_value
FROM order_details o
JOIN pizzas p
ON o.pizza_id = p.pizza_id
GROUP BY order_id
ORDER BY SUM(price * quantity) DESC


-- Change sizes from single letter to full word description
-- Using a CASE statment to create new column as required

SELECT	size,
	   CASE
		WHEN size = 'L' THEN 'Large' 
		WHEN size = 'M' THEN 'Medium'
		WHEN size = 'S' THEN 'Small'	
		ELSE NULL
	END AS size_name
FROM pizzas





