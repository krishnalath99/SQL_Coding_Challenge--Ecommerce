CREATE DATABASE ECommerce;
USE ECommerce;

CREATE TABLE CUSTOMERS (
    customerID INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(40),
    address VARCHAR(255)
);

INSERT INTO CUSTOMERS(customerID, name, email, address)
VALUES
    	(1, 'John Doe', 'johndoe@example.com', '123 Main St, City'),
	(2, 'Jane Smith', 'janesmith@example.com', '456 Elm St, Town'),
	(3, 'Robert Johnson', 'robert@example.com', '789 Oak St, Village'),
	(4, 'Sarah Brown', 'sarah@example.com', '101 Pine St, Suburb'),
	(5, 'David Lee', 'david@example.com', '234 Cedar St, District'),
	(6, 'Laura Hall', 'laura@example.com', '567 Birch St, County'),
	(7, 'Michael Davis', 'michael@example.com', '890 Maple St, State'),
	(8, 'Emma Wilson', 'emma@example.com', '321 Redwood St, Country'),
	(9, 'William Taylor', 'william@example.com', '432 Spruce St, Province'),
	(10, 'Olivia Adams', 'olivia@example.com', '765 Fir St, Territory');

CREATE TABLE PRODUCTS (
    productID INT PRIMARY KEY,
    name VARCHAR(40),
    description VARCHAR(255),
    price DECIMAL(10, 2),
    stockQuantity INT
);

INSERT INTO PRODUCTS (productID, name, description, price, stockQuantity)
VALUES
	(1, 'Laptop', 'High-performance laptop', 800.00, 10),
	(2, 'Smartphone', 'Latest smartphone', 600.00, 15),
	(3, 'Tablet', 'Portable tablet', 300.00, 20),
	(4, 'Headphones', 'Noise-canceling', 150.00, 30),
	(5, 'TV', '4K Smart TV', 900.00, 5),
	(6, 'Coffee Maker', 'Automatic coffee maker', 50.00, 25),
	(7, 'Refrigerator', 'Energy-efficient', 700.00, 10),
	(8, 'Microwave', 'Oven Countertop microwave', 80.00, 15),
	(9, 'Blender', 'High-speed blender', 70.00, 20),
	(10, 'Vacuum Cleaner', 'Bagless vacuum cleaner', 120.00, 10);

CREATE TABLE CART (
    cartID INT PRIMARY KEY,
    customerID INT,
    productID INT,
    quantity INT,
    FOREIGN KEY (customerID) REFERENCES customers(customerID) ON DELETE CASCADE,
    FOREIGN KEY (productID) REFERENCES products(productID) ON DELETE CASCADE
);

INSERT INTO CART (cartID, customerID, productID, quantity)
VALUES
	(1, 1, 1, 2),
	(2, 1, 3, 1),
	(3, 2, 2, 3),
	(4, 3, 4, 4),
	(5, 3, 5, 2),
	(6, 4, 6, 1),
	(7, 5, 1, 1),
	(8, 6, 10, 2),
	(9, 6, 9, 3),
	(10, 7, 7, 2);

CREATE TABLE ORDERS (
    orderID INT PRIMARY KEY,
    customerID INT,
    orderDate DATE,
    totalPrice DECIMAL(10, 2),
    FOREIGN KEY (customerID) REFERENCES customers(customerID) ON DELETE CASCADE
);

INSERT INTO ORDERS (orderID, customerID, orderDate, totalPrice)
VALUES
	(1, 1, '2023-01-05', 1200.00),
	(2, 2, '2023-02-10', 900.00),
	(3, 3, '2023-03-15', 300.00),
	(4, 4, '2023-04-20', 150.00),
	(5, 5, '2023-05-25', 1800.00),
	(6, 6, '2023-06-30', 400.00),
	(7, 7, '2023-07-05', 700.00),
	(8, 8, '2023-08-10', 160.00),
	(9, 9, '2023-09-15', 140.00),
	(10, 10, '2023-10-20', 1400.00);


CREATE TABLE ORDER_ITEMS (
    orderItemID INT PRIMARY KEY,
    orderID INT,
    productID INT,
    quantity INT,
    itemAmount DECIMAL(8, 2),
    FOREIGN KEY (orderID) REFERENCES orders(orderID) ON DELETE CASCADE,
    FOREIGN KEY (productID) REFERENCES products(productID) ON DELETE CASCADE
);

INSERT INTO ORDER_ITEMS (orderItemID, orderID, productID, quantity, itemAmount)
VALUES
	(1, 1, 1, 2, 1600.00),
	(2, 1, 3, 1, 300.00),
	(3, 2, 2, 3, 1800.00),
	(4, 3, 5, 2, 1800.00),
	(5, 4, 4, 4, 600.00),
	(6, 4, 6, 1, 50.00),
	(7, 5, 1, 1, 800.00),
	(8, 5, 2, 2, 1200.00),
	(9, 6, 10, 2, 240.00),
	(10, 6, 9, 3, 210.00);



--QUERIES
--1. Update refrigerator product price to 800.
UPDATE PRODUCTS SET price = 800 WHERE name = 'Refrigerator';

--2. Remove all cart items for a specific customer
DELETE FROM CART WHERE customerID = 6;

--3. Retrieve Products Priced Below $100.
SELECT * FROM PRODUCTS
WHERE price < 100;

--4. Find Products with Stock Quantity Greater Than 5.
SELECT * FROM PRODUCTS
WHERE stockQuantity > 5;

--5. Retrieve Orders with Total Amount Between $500 and $1000.
SELECT * FROM ORDERS
WHERE totalPrice BETWEEN 500 AND 1000;

--6. Find Products which name end with letter  r .
SELECT * FROM PRODUCTS
WHERE name LIKE '%r';

--7. Retrieve Cart Items for Customer 5.
SELECT c.customerID, c.cartID, c.productID, p.name as productName, c.quantity
FROM CART c, PRODUCTS p
WHERE c.productID = p.productID
AND c.customerID = 5;

--8. Find Customers Who Placed Orders in 2023.
SELECT DISTINCT c.customerID, c.name
FROM CUSTOMERS c, ORDERS o
WHERE c.customerID = o.customerID
AND YEAR(o.orderDate) = 2023;

--9. Determine the Minimum Stock Quantity for Each Product Category.
--Since there is no product category column we will min min stock quantity for each product.
SELECT p.productID, p.name, MIN(p.stockQuantity) as MinStockQuantity
FROM PRODUCTS p
GROUP BY p.productID, p.name;

--10. Calculate the Total Amount Spent by Each Customer.
SELECT c.customerID, c.name, SUM(o.totalPrice) as TotalAmountSpent
FROM CUSTOMERS c, ORDERS o
WHERE c.customerID = o.customerID
GROUP BY c.customerID, c.name;

--11. Find the Average Order Amount for Each Customer
SELECT c.customerID, c.name, AVG(o.totalPrice) as TotalAmountSpent
FROM CUSTOMERS c, ORDERS o
WHERE c.customerID = o.customerID
GROUP BY c.customerID, c.name;

--12. Count the Number of Orders Placed by Each Customer
SELECT c.customerID, c.name, COUNT(o.customerID) as NumberOfOrdersPlaced
FROM CUSTOMERS c, ORDERS o
WHERE c.customerID = o.customerID
GROUP BY c.customerID, c.name;

--13. Find the Maximum Order Amount for Each Customer.
SELECT c.customerID, c.name, MAX(o.totalPrice) as MaxOrderAmount
FROM CUSTOMERS c, ORDERS o
WHERE c.customerID = o.customerID
GROUP BY c.customerID, c.name;

--14. Get Customers Who Placed Orders Totaling Over $1000.
SELECT c.customerID, c.name, o.orderID, o.totalPrice
FROM CUSTOMERS c, ORDERS o
WHERE c.customerID = o.customerID
AND o.totalPrice >= 1000;

--15. Subquery to Find Products Not in the Cart
SELECT * FROM PRODUCTS p
WHERE p.productID NOT IN (SELECT productID FROM CART)

--16. Subquery to Find Customers Who Haven't Placed Orders.
SELECT * FROM CUSTOMERS c
WHERE c.customerID NOT IN (SELECT customerID FROM ORDERS)

--17. Subquery to Calculate the Percentage of Total Revenue for a Product.
SELECT *, price * 100.0 / (SELECT SUM(price) FROM products) as percentage_of_revenue
FROM products;

--18. Subquery to Find Products with Low Stock.
DECLARE @lowStocK INT = 10
SELECT * FROM PRODUCTS
WHERE productID IN (SELECT productID FROM PRODUCTS 
WHERE stockQuantity <= @lowStocK);

--19. Subquery to Find Customers Who Placed High-Value Orders.
SELECT * FROM CUSTOMERS
WHERE customerID IN (SELECT customerID FROM orders
WHERE totalPrice > 1000);