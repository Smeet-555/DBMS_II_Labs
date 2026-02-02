CREATE DATABASE Sportswear;
USE Sportswear;


-- COLOUR TABLE
CREATE TABLE color (
    id INT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    extra_fee DECIMAL(6,2) CHECK (extra_fee >= 0)
);

INSERT INTO color VALUES
(1,'Red',50),
(2,'Green',30),
(3,'Blue',0),
(4,'Black',20),
(5,'White',0),
(6,'Yellow',0);


-- CUSTOMER TABLE
CREATE TABLE customer (
    id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    favorite_color_id INT,
    FOREIGN KEY (favorite_color_id) REFERENCES color(id)
);

INSERT INTO customer VALUES
(101,'Jay','Patel',1),
(102,'Dhruv','Shah',2),
(103,'Amit','Joshi',3),
(104,'Neha','Mehta',4),
(105,'Priya','Desai',5),
(106,'Rahul','Modi',6),
(107,'Riya','Kapoor',3);


-- CATEGORY TABLE
CREATE TABLE category (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    parent_id INT NULL,
    FOREIGN KEY (parent_id) REFERENCES category(id)
);

INSERT INTO category VALUES
(1,'Top Wear',NULL),
(2,'Bottom Wear',NULL),
(3,'T-Shirt',1),
(4,'Jacket',1),
(5,'Joggers',2),
(6,'Shorts',2);


-- CLOTHING TABLE
CREATE TABLE clothing (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    size VARCHAR(10) CHECK (size IN ('S','M','L','XL','2XL','3XL')),
    price DECIMAL(8,2) CHECK (price > 0),
    color_id INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (color_id) REFERENCES color(id),
    FOREIGN KEY (category_id) REFERENCES category(id)
);
    
INSERT INTO clothing VALUES
(201,'Sports T-Shirt','M',800,1,3),
(202,'Sports T-Shirt','L',850,2,3),
(203,'Sports T-Shirt','XL',900,3,3),
(204,'Winter Jacket','XL',2000,4,4),
(205,'Training Joggers','M',1200,5,5),
(206,'Training Joggers','L',1300,3,5),
(207,'Training Joggers','XL',1400,2,5),
(208,'Running Shorts','M',700,6,6),
(209,'Running Shorts','XL',750,1,6);

-- CLOTHING_ORDER TABLE
CREATE TABLE clothing_order (
    id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    clothing_id INT NOT NULL,
    items INT CHECK (items > 0),
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (clothing_id) REFERENCES clothing(id)
);


INSERT INTO clothing_order VALUES
(301,101,201,2,'2024-04-10'),
(302,101,203,1,'2024-05-12'),
(303,102,205,3,'2024-03-22'),
(304,103,204,1,'2024-06-18'),
(305,104,207,2,'2024-04-25'),
(306,105,208,4,'2024-07-02'),
(307,101,205,1,'2025-01-10');




-- 1
SELECT C.first_name, COL.name AS favorite_color
FROM customer C
JOIN color COL
    ON C.favorite_color_id = COL.id
WHERE COL.name IN ('Red', 'Green')
  AND C.first_name IN ('Jay', 'Dhruv');

-- 2
SELECT name , size from clothing
WHERE name LIKE '%Joggers' 

-- 3
SELECT 
    O.id AS order_id,
    O.order_date,
    CL.name AS clothing_name,
    CL.size,
    CL.price,
    O.items
FROM clothing_order O
JOIN customer C
    ON O.customer_id = C.id
JOIN clothing CL
    ON O.clothing_id = CL.id
JOIN category CAT
    ON CL.category_id = CAT.id
WHERE C.first_name = 'Jay'
  AND CAT.name = 'T-Shirt'
  AND O.order_date > '2024-04-01';

-- 4
SELECT C.first_name
FROM customer C
JOIN color col
    ON C.favorite_color_id = col.id
WHERE col.extra_fee > 0;

-- 5

SELECT
    CAT.name AS category_name,
    MAX(CL.price) AS max_price,
    MIN(CL.price) AS min_price,
    AVG(CL.price) AS avg_price,
    COUNT(CL.id) AS total_items
FROM clothing CL
JOIN category CAT
    ON CL.category_id = CAT.id
GROUP BY CAT.name
ORDER BY CAT.name;

-- 6
SELECT
    C.id,
    C.first_name,
    C.last_name
FROM customer C
LEFT JOIN clothing_order O
    ON C.id = O.customer_id
WHERE O.id IS NULL;


-- 7
