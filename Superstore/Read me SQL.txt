

SELECT c.city, COUNT(c.customer_id) AS Total_Customer, DENSE_RANK() OVER(ORDER BY Total_Customer DESC) AS rank
FROM customer AS c
GROUP BY c.city
ORDER BY RANK;


SELECT c.city, COUNT(o.order_id) AS Total_orders, SUM(o.quantity) AS Total_quantity,
DENSE_RANK() OVER(ORDER BY Total_orders DESC) AS rank
FROM customer AS c INNER JOIN orders_dc_ AS o USING(customer_id)
GROUP BY c.city
ORDER BY RANK;



SELECT o.customer_id, c.customer_name, MIN(o.order_date) AS First_order
FROM orders_dc_ AS o INNER JOIN customer AS c USING(customer_id)
GROUP BY o.customer_id;



SELECT c.city, a.first_order, COUNT(a.customer_id) AS number_user
FROM 
(SELECT customer_id, MIN(order_date) AS first_order
from orders_dc_ GROUP BY 1) AS a LEFT JOIN customer AS c ON a.customer_id = c.customer_id
GROUP BY city, first_order;



SELECT b.city, b.customer_name, o.customer_id, b.City_quantity, MAX(o.quantity) AS max_quantity,
round(SUM((o.sales * o.quantity)-((o.sales * o.quantity)*o.discount)),2) AS Total_price
FROM
(SELECT  c.city, c.customer_name, a.customer_id, sum(a.Total_quantity) AS City_quantity, MAX(a.quantity) AS max_quantity
FROM 
(SELECT customer_id, SUM(quantity) AS Total_quantity, quantity,
DENSE_RANK() OVER(ORDER BY Total_quantity DESC) AS rank
FROM orders_dc_ GROUP BY customer_id, 1) AS a 
INNER JOIN customer AS c USING(customer_id)
GROUP BY c.city, a.customer_id, 1) b
INNER JOIN orders_dc_ AS o USING(customer_id)
GROUP BY b.city, o.customer_id;


SELECT d.city, SUM(d.City_quantity) AS Total_CQ, d.customer_name, MAX(d.City_quantity) AS Max_CQ, d.max_quantity, d.Total_price
FROM 
(SELECT b.city, b.customer_name, o.customer_id, b.City_quantity, MAX(o.quantity) AS max_quantity,
round(SUM((o.sales * o.quantity)-(o.sales * o.quantity)*o.discount),2) AS Total_price
FROM
(SELECT  c.city, c.customer_name, a.customer_id, sum(a.Total_quantity) AS City_quantity, MAX(a.quantity) AS max_quantity
FROM 
(SELECT customer_id, SUM(quantity) AS Total_quantity, quantity,
DENSE_RANK() OVER(ORDER BY Total_quantity DESC) AS rank
FROM orders_dc_ GROUP BY customer_id, 1) AS a 
INNER JOIN customer AS c USING(customer_id)
GROUP BY c.city, a.customer_id, 1) b
INNER JOIN orders_dc_ AS o USING(customer_id)
GROUP BY b.city, o.customer_id, 1) AS d
GROUP BY d.city;





SELECT o.category, o.sub_category, SUM(o.quantity) AS Total_qty, 
round(SUM((o.sales * o.quantity)-(o.sales * o.quantity * o.discount)),2) AS Total_price
FROM orders_dc_ AS o
GROUP BY o.sub_category
ORDER BY Total_price DESC;
