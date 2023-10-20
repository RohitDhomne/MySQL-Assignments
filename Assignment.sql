USE classicmodels;
SELECT * FROM customers;

-- Day 3 
/*
Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of creditLimit.

●	State should not contain null values
●	credit limit should be between 50000 and 100000

*/
SELECT customerNumber, customerName, state, creditLimit
FROM customers
WHERE state IS NOT NULL
AND creditLimit BETWEEN 50000 AND 100000
ORDER BY creditLimit DESC;

/*
Show the unique productline values containing the word cars at the end from products table.
*/
SELECT DISTINCT productLine
FROM products
WHERE productLine LIKE '%cars';


-- Day 4 
/*
Show the orderNumber, status and comments from orders table for shipped status only. 
If some comments are having null values then show them as “-“.
*/
SELECT orderNumber, 
       status, 
       COALESCE(comments, '-') AS comments
FROM orders
WHERE status = 'Shipped';

/*
2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
If job title is one among the below conditions, then job title abbreviation column should show below forms.
●	President then “P”
●	Sales Manager / Sale Manager then “SM”
●	Sales Rep then “SR”
●	Containing VP word then “VP”

*/
SELECT
    employeeNumber,
    firstName,
    jobTitle,
    CASE
        WHEN jobTitle = 'President' THEN 'P'
        WHEN jobTitle IN ('Sales Manager', 'Sale Manager') THEN 'SM'
        WHEN jobTitle = 'Sales Rep' THEN 'SR'
        WHEN jobTitle LIKE '%VP%' THEN 'VP'
        ELSE jobTitle -- If none of the conditions match, keep the original job title
    END AS jobTitleAbbreviation
FROM
    employees;
    
    
-- Day 5
/*
For every year, find the minimum amount value from payments table.
*/
SELECT YEAR(paymentDate) AS paymentYear, MIN(amount) AS minPayment
FROM payments
GROUP BY paymentYear
ORDER BY paymentYear;

/*
For every year and every quarter, find the unique customers and total orders from orders table. 
Make sure to show the quarter as Q1,Q2 etc.
*/
SELECT
    YEAR(orderDate) AS orderYear,
    CONCAT('Q', QUARTER(orderDate)) AS orderQuarter,
    COUNT(DISTINCT customerNumber) AS uniqueCustomers,
    COUNT(*) AS totalOrders
FROM
    orders
GROUP BY
    orderYear,
    orderQuarter
ORDER BY
    orderYear,
    orderQuarter;
    
/*
Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) 
for every month (e.g. Jan, Feb etc.) with filter on total amount as 500000 to 1000000. 
Sort the output by total amount in descending mode. [ Refer. Payments Table]
*/
SELECT
    DATE_FORMAT(paymentDate, '%b') AS paymentMonth,
    CONCAT(FORMAT(SUM(amount) / 1000, 0), 'K') AS formattedAmount
FROM
    payments
GROUP BY
    paymentMonth
HAVING
    SUM(amount) BETWEEN 500000 AND 1000000
ORDER BY
    SUM(amount) DESC;
    

-- Day 6
/*
Create a journey table with following fields and constraints.

●	Bus_ID (No null values)
●	Bus_Name (No null values)
●	Source_Station (No null values)
●	Destination (No null values)
●	Email (must not contain any duplicates)
*/
CREATE TABLE journey (
    Bus_ID INT NOT NULL,
    Bus_Name VARCHAR(255) NOT NULL,
    Source_Station VARCHAR(255) NOT NULL,
    Destination VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    PRIMARY KEY (Bus_ID)
);

/*
Create vendor table with following fields and constraints.

●	Vendor_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Email (must not contain any duplicates)
●	Country (If no data is available then it should be shown as “N/A”)
*/
CREATE TABLE vendor (
    Vendor_ID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    Country VARCHAR(255) DEFAULT 'N/A'
);

/*
Create movies table with following fields and constraints.

●	Movie_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Release_Year (If no data is available then it should be shown as “-”)
●	Cast (No null values)
●	Gender (Either Male/Female)
●	No_of_shows (Must be a positive number)
*/
CREATE TABLE movies (
    Movie_ID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Release_Year VARCHAR(4) DEFAULT '-',
    Cast VARCHAR(255) NOT NULL,
    Gender ENUM('Male', 'Female'),
    No_of_shows INT CHECK (No_of_shows > 0)
);

/*
Create the following tables. Use auto increment wherever applicable

a. Product
✔	product_id - primary key
✔	product_name - cannot be null and only unique values are allowed
✔	description
✔	supplier_id - foreign key of supplier table

b. Suppliers
✔	supplier_id - primary key
✔	supplier_name
✔	location

c. Stock
✔	id - primary key
✔	product_id - foreign key of product table
✔	balance_stock
*/
-- Create the Product table
CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Create the Suppliers table
CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    location VARCHAR(255)
);

-- Create the Stock table
CREATE TABLE Stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    balance_stock INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- Day 7
/*
Show employee number, Sales Person (combination of first and last names of employees), 
unique customers for each employee number and sort the data by highest to lowest unique customers.
Tables: Employees, Customers
*/
SELECT
    e.employeeNumber AS employeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS SalesPerson,
    COUNT(DISTINCT c.customerNumber) AS UniqueCustomers
FROM
    Employees e
LEFT JOIN
    Customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY
    e.employeeNumber, SalesPerson
ORDER BY
    UniqueCustomers DESC;

/*
Show total quantities, total quantities in stock, left over quantities for each product 
and each customer. Sort the data by customer number.

Tables: Customers, Orders, Orderdetails, Products
*/
SELECT
    c.customerNumber AS CustomerNumber,
    c.customerName AS CustomerName,
    p.productCode AS ProductCode,
    p.productName AS ProductName,
    SUM(od.quantityOrdered) AS TotalQuantitiesOrdered,
    SUM(p.quantityInStock) AS TotalQuantitiesInStock,
    SUM(p.quantityInStock - od.quantityOrdered) AS LeftoverQuantities
FROM
    Customers c
JOIN
    Orders o ON c.customerNumber = o.customerNumber
JOIN
    Orderdetails od ON o.orderNumber = od.orderNumber
JOIN
    Products p ON od.productCode = p.productCode
GROUP BY
    CustomerNumber, ProductCode
ORDER BY
    CustomerNumber;

/*
Create below tables and fields. (You can add the data as per your wish)

●	Laptop: (Laptop_Name)
●	Colours: (Colour_Name)
Perform cross join between the two tables and find number of rows.
*/
CREATE TABLE Laptop (
    Laptop_Name VARCHAR(255)
);

CREATE TABLE Colours (
    Colour_Name VARCHAR(255)
);

-- Insert data into the Laptop table
INSERT INTO Laptop (Laptop_Name)
VALUES ('Dell'), ('Asus'), ('MSI');

-- Insert data into the Colours table
INSERT INTO Colours (Colour_Name)
VALUES ('Red'), ('Blue'), ('Black');

SELECT * FROM Laptop;
SELECT * FROM Colours;
SELECT COUNT(*) AS NumberOfRows
FROM Laptop
CROSS JOIN Colours;
SELECT Laptop_Name,Colour_Name
FROM Laptop
CROSS JOIN Colours;

/*
Create table project with below fields.

●	EmployeeID
●	FullName
●	Gender
●	ManagerID
Add below data into it.
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
Find out the names of employees and their related managers.
*/
-- Create the Project table
CREATE TABLE Project (
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(255),
    Gender VARCHAR(10),
    ManagerID INT
);

-- Insert data into the Project table
INSERT INTO Project (EmployeeID, FullName, Gender, ManagerID)
VALUES
    (1, 'Pranaya', 'Male', 3),
    (2, 'Priyanka', 'Female', 1),
    (3, 'Preety', 'Female', NULL),
    (4, 'Anurag', 'Male', 1),
    (5, 'Sambit', 'Male', 1),
    (6, 'Rajesh', 'Male', 3),
    (7, 'Hina', 'Female', 3);
SELECT
    E.FullName AS EmployeeName,
    M.FullName AS ManagerName
FROM
    Project E
LEFT JOIN
    Project M ON E.ManagerID = M.EmployeeID;
    

/*
Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country

i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values.
*/
CREATE TABLE facility (
    Facility_ID INT,
    Name VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255)
);
-- Add primary key constraint
ALTER TABLE facility
ADD PRIMARY KEY (Facility_ID);
-- Add auto-increment to Facility_ID
ALTER TABLE facility
MODIFY COLUMN Facility_ID INT AUTO_INCREMENT;
--  Add new column City after Name 
ALTER TABLE facility
ADD COLUMN City VARCHAR(255) NOT NULL
AFTER Name;

DESCRIBE facility;


-- Day 9
/*
Create table university with below fields.
●	ID
●	Name
Add the below data into it as it is.
INSERT INTO University
VALUES (1, "Pune University"), 
	   (2, "Mumbai University"),
	   (3, "Delhi University"),
	   (4, "Madras University"),
	   (5, "Nagpur University");
Remove the spaces from everywhere and update the column like Pune University etc.
*/
-- Create the university table
CREATE TABLE University (
    ID INT PRIMARY KEY,
    Name VARCHAR(255)
);

-- Insert data into the university table
INSERT INTO University
VALUES
    (1, "Pune University"),
    (2, "Mumbai University"),
    (3, "Delhi University"),
    (4, "Madras University"),
    (5, "Nagpur University");

-- Update the names to remove spaces
UPDATE University
SET Name = TRIM(BOTH ' ' FROM Name);

-- Display the updated data
SELECT * FROM University;


-- Day 10
/*
Create the view products status. Show year wise total products sold. 
Also find the percentage of total value for each year. 
The output should look as shown in below figure.
*/
CREATE VIEW products_status AS
SELECT
    YEAR(o.orderDate) AS Year,
    SUM(od.quantityOrdered) AS TotalProductsSold,
    SUM(od.quantityOrdered * od.priceEach) AS TotalValue
FROM
    orders o
JOIN
    orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY
    Year
ORDER BY
    Year;
SELECT
    Year,
    CONCAT(TotalValue,' (',FORMAT((TotalValue / SUM(TotalValue) OVER ()) * 100,2), '%)') AS Value
FROM
    products_status;


-- DAY 11
/*
Create a stored procedure GetCustomerLevel which takes input as customer number 
and gives the output as either Platinum, Gold or Silver as per below criteria.

Table: Customers

●	Platinum: creditLimit > 100000
●	Gold: creditLimit is between 25000 to 100000
●	Silver: creditLimit < 25000
*/
DELIMITER //

CREATE PROCEDURE GetCustomerLevel(IN customerNumber INT, OUT customerLevel VARCHAR(255))
BEGIN
    DECLARE creditLimit DECIMAL(10, 2);
    
    SELECT creditLimit INTO creditLimit
    FROM Customers
    WHERE customerNumber = customerNumber
    LIMIT 1;  -- Limit the result to one row
    
    IF creditLimit > 100000 THEN
        SET customerLevel = 'Platinum';
    ELSEIF creditLimit BETWEEN 25000 AND 100000 THEN
        SET customerLevel = 'Gold';
    ELSE
        SET customerLevel = 'Silver';
    END IF;
END //

DELIMITER ;

CALL GetCustomerLevel(123, @customerLevel);
SELECT @customerLevel AS CustomerLevel;


/*
Create a stored procedure Get_country_payments which takes in year and country as inputs 
and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)

Tables: Customers, Payments
*/
DELIMITER //

CREATE PROCEDURE Get_country_payments(IN p_year INT, IN p_country VARCHAR(255), OUT p_total_amount_formatted VARCHAR(255))
BEGIN
    DECLARE total_amount DECIMAL(10, 2);
    
    SELECT ROUND(SUM(p.amount) / 1000) INTO total_amount
    FROM Payments p
    JOIN Customers c ON p.customerNumber = c.customerNumber
    WHERE YEAR(p.paymentDate) = p_year AND c.country = p_country;
    
    SET p_total_amount_formatted = CONCAT(total_amount, 'K');
END //

DELIMITER ;

CALL Get_country_payments(2003, 'France', @total_amount_formatted);
SELECT @total_amount_formatted AS TotalAmountFormatted;


-- Day 12
/*
Create the table emp_udf with below fields.

●	Emp_ID
●	Name
●	DOB
Add the data as shown in below query.
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months) by accepting DOB column as a parameter.
*/
-- Create the emp_udf table and insert data:
-- Create the emp_udf table
CREATE TABLE emp_udf (
    Emp_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    DOB DATE
);
INSERT INTO emp_udf (Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
select * from emp_udf;

DROP FUNCTION IF EXISTS calculate_age;

DELIMITER //

CREATE FUNCTION calculate_age(dob DATE)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE years INT;
    DECLARE months INT;
    DECLARE age VARCHAR(50);
    
    SET years = DATEDIFF(CURRENT_DATE(), dob) DIV 365;
    SET months = (DATEDIFF(CURRENT_DATE(), dob) MOD 365) DIV 30;
    
    SET age = CONCAT(years, " years ", months, " months");
    
    RETURN age;
END //

DELIMITER ;

select 
	Emp_ID,
    Name,
    DOB,
    calculate_age(DOB) as Age from emp_udf;


-- Day 13
/*
Display the customer numbers and customer names from customers table who have not placed any orders using subquery

Table: Customers, Orders
*/
SELECT customerNumber, customerName
FROM Customers
WHERE customerNumber NOT IN (
    SELECT customerNumber
    FROM Orders
);

/*
Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer.
Table: Customers, Orders
*/
-- Get the customer number, customer name, and count of orders for every customer
SELECT
    c.customerNumber,
    c.customerName,
    COUNT(o.orderNumber) AS OrderCount
FROM
    Customers c
LEFT JOIN
    Orders o ON c.customerNumber = o.customerNumber
GROUP BY
    c.customerNumber, c.customerName

UNION

SELECT
    c.customerNumber,
    c.customerName,
    COUNT(o.orderNumber) AS OrderCount
FROM
    Customers c
RIGHT JOIN
    Orders o ON c.customerNumber = o.customerNumber
GROUP BY
    c.customerNumber, c.customerName;

/*
Show the second highest quantity ordered value for each order number.
Table: Orderdetails
*/
SELECT
    orderNumber,
    MAX(quantityOrdered) AS SecondHighestQuantity
FROM
    Orderdetails od1
WHERE
    quantityOrdered < (
        SELECT
            MAX(quantityOrdered)
        FROM
            Orderdetails od2
        WHERE
            od1.orderNumber = od2.orderNumber
    )
GROUP BY
    orderNumber;

/*
For each order number count the number of products and then find the min and max of the values among count of orders.
Table: Orderdetails
*/
SELECT
    MIN(ProductCount) AS `Min(Total)`,
    MAX(ProductCount) AS `Max(Total)`
FROM
    (SELECT
        orderNumber,
        COUNT(*) AS ProductCount
    FROM
        Orderdetails
    GROUP BY
        orderNumber) AS ProductCounts;

/*
Find out how many product lines are there for which the buy price value is greater than the average of buy price value. 
Show the output as product line and its count.
*/
SELECT
    productLine,
    COUNT(*) AS Total
FROM
    Products
WHERE
    buyPrice > (
        SELECT
            AVG(buyPrice)
        FROM
            Products
    )
GROUP BY
    productLine;


-- Day 14
/*
Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong.

*/
DELIMITER //

CREATE TABLE Emp_EH (
    EmpID INT AUTO_INCREMENT PRIMARY KEY,
    EmpName VARCHAR(255),
    EmailAddress VARCHAR(255)
);

CREATE PROCEDURE InsertEmp_EH(
    IN p_EmpName VARCHAR(255),
    IN p_EmailAddress VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error occurred' AS Message;
    END;

    START TRANSACTION;

    INSERT INTO Emp_EH (EmpName, EmailAddress)
    VALUES (p_EmpName, p_EmailAddress);

    COMMIT;
    SELECT 'Record inserted successfully' AS Message;
END //

DELIMITER ;

CALL InsertEmp_EH('John Doe', 'john.doe@example.com');


-- Day 15
/*
Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours

Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
 
Create before insert trigger to make sure any new value of Working_hours, if it is negative, 
then it should be inserted as positive.
*/
-- Create the Emp_BIT table
CREATE TABLE Emp_BIT (
    Name VARCHAR(255),
    Occupation VARCHAR(255),
    Working_date DATE,
    Working_hours INT
);

-- Insert data into Emp_BIT
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

-- Create a "before insert" trigger
DELIMITER //

CREATE TRIGGER Before_Insert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = ABS(NEW.Working_hours);
    END IF;
END //

DELIMITER ;

INSERT INTO Emp_BIT VALUES ('John', 'Engineer', '2022-01-15', -8);

SELECT * FROM Emp_BIT;
