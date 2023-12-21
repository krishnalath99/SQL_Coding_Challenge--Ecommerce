CREATE DATABASE CarRentalSystem;
USE [CarRentalSystem];

CREATE TABLE VEHICLE
(
vehicleID INT PRIMARY KEY,
make VARCHAR(20),
model VARCHAR(20),
year INT,
dailyRate DECIMAL(4,2),
status VARCHAR(15),
passengerCapacity INT,
engineCapacity INT
);

INSERT INTO VEHICLE VALUES (1, 'Toyota', 'Camry', 2022, 50.00, 'Available', 4, 1450);
INSERT INTO VEHICLE VALUES (2, 'Honda', 'Civic', 2023, 45.00, 'Available', 7, 1500);
INSERT INTO VEHICLE VALUES (3, 'Ford', 'Focus', 2022, 48.00, 'Not Available', 4, 1400);
INSERT INTO VEHICLE VALUES (4, 'Nissan', 'Altima', 2023, 52.00, 'Available', 7, 1200);
INSERT INTO VEHICLE VALUES (5, 'Chevrolet', 'Malibu', 2022, 47.00, 'Available', 4, 1800);
INSERT INTO VEHICLE VALUES (6, 'Hyundai', 'Sonata', 2023, 49.00, 'Not Available', 7, 1400);
INSERT INTO VEHICLE VALUES (7, 'BMW', '3 Series', 2023, 60.00, 'Available', 7, 2499);
INSERT INTO VEHICLE VALUES (8, 'Mercedes', 'C-Class', 2022, 58.00, 'Available', 8, 2599);
INSERT INTO VEHICLE VALUES (9, 'Audi', 'A4', 2022, 55.00, 'Not Available', 4, 2500);
INSERT INTO VEHICLE VALUES (10, 'Lexus', 'ES', 2023, 54.00, 'Available', 4, 2500);

CREATE TABLE Customer
(
customerID INT PRIMARY KEY,
firstName VARCHAR(30),
lastName VARCHAR(30),
email VARCHAR(50),
phoneNumber CHAR(15)
);

INSERT INTO Customer VALUES (1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555');
INSERT INTO Customer VALUES (2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567');
INSERT INTO Customer VALUES (3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234');
INSERT INTO Customer VALUES (4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890');
INSERT INTO Customer VALUES (5, 'David', 'Lee', 'david@example.com', '555-987-6543');
INSERT INTO Customer VALUES (6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678');
INSERT INTO Customer VALUES (7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432');
INSERT INTO Customer VALUES (8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098');
INSERT INTO Customer VALUES (9, 'William', 'Taylor', 'william@example.com', '555-321-6547');
INSERT INTO Customer VALUES (10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');

CREATE TABLE Lease
(
leaseID INT PRIMARY KEY,
vehicleID INT,
FOREIGN KEY (vehicleID) REFERENCES VEHICLE(vehicleID) ON DELETE CASCADE,
customerID INT,
FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON DELETE CASCADE,
startDate DATE,
endDate DATE,
leaseType VARCHAR(20)
);

INSERT INTO Lease (leaseID, vehicleID, customerID, startDate, endDate, leaseType)
VALUES
    (1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
    (2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
    (3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
    (4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
    (5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
    (6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
    (7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
    (8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
    (9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
    (10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly');

CREATE TABLE Payment
(
paymentID INT PRIMARY KEY,
leaseID INT,
FOREIGN KEY (leaseID) REFERENCES Lease(leaseID) ON DELETE CASCADE,
paymentDate DATE,
amount FLOAT
);

INSERT INTO Payment (paymentID, leaseID, paymentDate, amount)
VALUES
	(1, 1, '2023-01-03', 200.00),
	(2, 2, '2023-02-20', 1000.00),
	(3, 3, '2023-03-12', 75.00),
	(4, 4, '2023-04-25', 900.00),
	(5, 5, '2023-05-07', 60.00);



--QUERIES
--1. Update the daily rate for a Mercedes car to 68.
UPDATE VEHICLE SET dailyRate = 68 WHERE make = 'Mercedes';

--2. Delete a specific customer and all associated leases and payments.
DELETE FROM Customer WHERE customerID = 3;

--3. Rename the "paymentDate" column in the Payment table to "transactionDate".
--ALTER TABLE Payment 

--4. Find a specific customer by email.
SELECT *FROM Customer WHERE email = 'janesmith@example.com'; 

--5. Get active leases for a specific customer.
SELECT * 
FROM Customer as c JOIN Lease as l
ON l.customerID = c.customerID
WHERE c.customerID = 10;

--6. Find all payments made by a customer with a specific phone number.
SELECT Payment.*
FROM Payment, Lease, Customer
WHERE Payment.leaseID = Lease.leaseID
AND Lease.customerID = Customer.customerID
AND Customer.phoneNumber = '555-555-5555';


--7. Calculate the average daily rate of all available cars.
SELECT AVG(dailyRate) AS AverageDailyRate
FROM VEHICLE;


--8. Find the car with the highest daily rate.
SELECT *
FROM VEHICLE
WHERE dailyRate = (SELECT MAX(dailyRate) FROM VEHICLE);

--9. Retrieve all cars leased by a specific customer.
SELECT *
FROM Vehicle
WHERE vehicleID IN (SELECT vehicleID FROM Lease WHERE customerID = 1);

--10. Find the details of the most recent lease.
SELECT TOP 1 l.*, v.make, v.model
FROM VEHICLE v, Lease l
WHERE l.vehicleID = v.vehicleID
ORDER BY l.startDate DESC;

--11. List all payments made in the year 2023.
SELECT * FROM Payment
WHERE YEAR(paymentDate) = 2023;

--12. Retrieve customers who have not made any payments.
SELECT * FROM Customer
WHERE customerID NOT IN (SELECT DISTINCT c.customerID
FROM Customer c, Lease l, Payment p
WHERE c.customerID = l.customerID AND l.leaseID = p.leaseID);

--13. Retrieve Car Details and Their Total Payments.
SELECT v.vehicleID, v.make, v.model, ISNULL(SUM(p.amount), 0) AS TotalPayments
FROM Vehicle v LEFT JOIN Lease as l 
ON v.vehicleID = l.vehicleID
LEFT JOIN Payment as p
ON l.leaseID = p.leaseID
GROUP BY v.vehicleID, v.make, v.model;

--14. Calculate Total Payments for Each Customer
SELECT c.*, ISNULL(SUM(p.amount), 0) AS TotalPayments
FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName, c.email, c.phoneNumber;

--15. List Car Details for Each Lease.
Select l.*, v.make, v.model
FROM Lease l, VEHICLE v
WHERE l.vehicleID = v.vehicleID;

--16. Retrieve Details of Active Leases with Customer and Car Information.
DECLARE @today DATE = '2023-06-06'
SELECT l.*, c.firstName, c.lastName, v.make, v.model
FROM Lease l, Customer c, Vehicle v
WHERE l.customerID = c.customerID
AND l.vehicleID = v.vehicleID
AND l.endDate >= @today;

--17. Find the Customer Who Has Spent the Most on Leases.
SELECT TOP 1 c.customerID, c.firstName, c.lastName
FROM Customer c, Lease l, Payment p
WHERE c.customerID = l.customerID
AND l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName
ORDER BY SUM(p.amount) DESC;

--18. List All Cars with Their Current Lease Information.
SELECT v.vehicleID, v.make, v.model, l.startDate, l.endDate, l.leaseType
FROM Vehicle v, Lease l
WHERE v.vehicleID = l.vehicleID;