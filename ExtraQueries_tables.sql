-- Create Department Table
CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- Create Employee Table
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    Mobile VARCHAR(20),
    JoiningDate DATE,
    Salary DECIMAL(10, 2),
    DeptID INT FOREIGN KEY REFERENCES Department(DeptID)
);

-- Insert Sample Departments
INSERT INTO Department (DeptID, DeptName) VALUES
(1, 'Computer'),
(2, 'Civil'),
(3, 'Mechanical'),
(4, 'HR'),
(5, 'Finance');

-- Insert Sample Employees
INSERT INTO Employee (EmpID, Name, Email, City, Mobile, JoiningDate, Salary, DeptID) VALUES
-- Q1: Changa
(101, 'Sandeep', 'sandeep@test.com', 'Mumbai', '1112223334', '2021-05-15', 50000.00, 1),
(102, 'Rajesh Kumar', 'rajesh@test.com', 'Changa', '2223334445', '2022-03-10', 55000.00, 1),

-- Q2: Joined after 01 Jun 2022, Computer or Civil
(103, 'Priya Sharma', 'priya@test.com', 'Pune', '3334445556', '2022-06-05', 60000.00, 1),
(104, 'Amit Singh', 'amit@test.com', 'Delhi', '4445556667', '2022-07-20', 62000.00, 2),

-- Q3: No mobile or email
(105, 'Sneha Patel', 'sneha@test.com', 'Pune', NULL, '2021-08-01', 58000.00, 1),
(106, 'Vikram Rathod', NULL, 'Mumbai', '6667778889', '2022-01-12', 53000.00, 2),

-- Q4/Q5: Top salaries
(107, 'Anjali Mehta', 'anjali@test.com', 'Delhi', '7778889990', '2020-02-18', 90000.00, 1),
(108, 'Manish Jain', 'manish@test.com', 'Changa', '8889990001', '2021-11-05', 85000.00, 2),
(109, 'Kavita Iyer', 'kavita@test.com', 'Pune', '9990001112', '2022-04-30', 88000.00, 1),

-- Q5: Top 3 dept wise
(110, 'Rahul Dave', 'rahul@test.com', 'Mumbai', '1231231234', '2021-09-22', 82000.00, 2),
(111, 'Meera Krishnan', 'meera@test.com', 'Delhi', '2342342345', '2022-08-14', 86000.00, 1),

-- Q9: Dept with > 9 (Computer will have 10)
(112, 'Varun Gill', 'varun@test.com', 'Pune', '3453453456', '2023-01-01', 50000.00, 1),
(113, 'Deepak Shah', 'deepak@test.com', 'Changa', '4564564567', '2023-02-11', 48000.00, 1),
(114, 'Nisha Verma', 'nisha@test.com', 'Mumbai', '5675675678', '2023-03-15', 47000.00, 1),
(115, 'Suresh Reddy', 'suresh@test.com', 'Delhi', '6786786789', '2023-04-20', 46000.00, 1),

-- Q10: Mechanical
(116, 'Rina Desai', 'rina@test.com', 'Pune', '7897897890', '2022-05-10', 60000.00, 3),
(117, 'Gaurav Kumar', 'gaurav@test.com', 'Mumbai', '8908908901', '2022-06-12', 65000.00, 3),

-- Q12: HR > 45k
(118, 'Pooja Singh', 'pooja@test.com', 'Delhi', '9019019012', '2021-07-07', 48000.00, 4),
(119, 'Alok Nath', 'alok@test.com', 'Pune', '0120120123', '2022-09-30', 40000.00, 4),

-- Q13: Same name
(120, 'Amit Singh', 'amit2@test.com', 'Pune', '1122112211', '2023-05-01', 51000.00, 5),
(121, 'Priya Sharma', 'priya2@test.com', 'Mumbai', '2233223322', '2023-06-10', 70000.00, 5);


--PAPER - 2--

-- Create color Table
CREATE TABLE color (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50) NOT NULL,
    extra_fee DECIMAL(5,2) DEFAULT 0
);

-- Create customer Table
CREATE TABLE customer (
    id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    favorite_color_id INT FOREIGN KEY REFERENCES color(id)
);

-- Create category Table
CREATE TABLE category (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50) NOT NULL,
    parent_id INT FOREIGN KEY REFERENCES category(id) NULL
);

-- Create clothing Table
CREATE TABLE clothing (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    size VARCHAR(5) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    color_id INT FOREIGN KEY REFERENCES color(id),
    category_id INT FOREIGN KEY REFERENCES category(id)
);

-- Create clothing_order Table
CREATE TABLE clothing_order (
    id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES customer(id),
    clothing_id INT FOREIGN KEY REFERENCES clothing(id),
    items INT NOT NULL,
    order_date DATE NOT NULL
);


