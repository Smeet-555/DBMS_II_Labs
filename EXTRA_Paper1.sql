-- Question 1: List all Employees which belongs to Changa.

SELECT EmpID , Name , City 
FROM Employee
WHERE City = 'CHANGA';

-- Question 2: List all Employees who joined after 01 Jun, 2022 and belongs to either Computer or Civil.

SELECT E.EmpID , E.Name , E.JoiningDate, D.DeptName
FROM Employee E
JOIN Department D
ON E.DeptID = D.DeptID
WHERE JoiningDate > '2022-06-01'
AND DeptName = 'Computer'
OR DeptName = 'Civil'

-- Question 3: List all Employees with department name who don't have either mobile or email.

SELECT E.EmpId , E.Name , Email , E.Mobile , D.DeptName
FROM Employee E
JOIN Department D
ON E.DeptID = D.DeptID
WHERE  E.Mobile  IS NULL
OR E.Email  IS NULL

-- Question 4: List top 5 employees as per salaries.
SELECT   TOP 5 EmpId, Name, Salary
FROM Employee
ORDER BY SALARY DESC

-- Question 5: List top 3 employees department wise as per salaries.      //Doubt
SELECT TOP 3 D.DeptName , E.Name , E.Salary 
FROM Employee E
JOIN Department D
ON E.DeptID = D.DeptID
GROUP BY D.DeptName 
ORDER BY E.Salary DESC

-- Question 6: List City with Employee Count.
SELECT City , COUNT(EmpId) as EmployeeCount
FROM Employee 
GROUP BY City

-- Question 7: List City Wise Maximum, Minimum & Average Salaries & Give Proper Name As MaxSal, MinSal & AvgSal.

SELECT City , MAX(Salary) as MaxSalary , MIN(Salary) as MinSalary , AVG(Salary) as Avgsalary
FROM Employee 
GROUP BY City

-- Question 8: List Department wise City wise Employee Count.
SELECT D.DeptName , E.City , COUNT(E.EmpID) AS EmployeeCount
FROM Employee E
JOIN Department D
ON E.DeptID = D.DeptID
GROUP BY E.City , D.DeptName

-- Question 9: List Departments with more than 9 employees.
SELECT 
    D.DeptName,
    COUNT(E.EmpID) AS EmployeeCount
FROM Department D
JOIN Employee E
    ON D.DeptID = E.DeptID
GROUP BY D.DeptName
HAVING COUNT(E.EmpID) > 9;

-- Question 10: Give 10% increment in salary to all employees who belongs to Mechanical Department.
UPDATE E
SET E.Salary = E.Salary * 1.10
FROM Employee E
JOIN Department D
    ON E.DeptID = D.DeptID
WHERE D.DeptName = 'Mechanical';

-- Question 11: Update City of Sandeep from Mumbai to Pune having 101 as Employee ID.
UPDATE Employee
SET City = 'Pune'
WHERE EmpID = 101
  AND Name = 'Sandeep';

-- Question 12: Delete all the employees who belongs to HR Department & Salary is more than 45,000.
DELETE E
FROM Employee E
JOIN Department D
    ON E.DeptID = D.DeptID
WHERE D.DeptName = 'HR'
  AND E.Salary > 45000;

-- Question 13: List Employees with same name with occurrence of name.
SELECT 
    Name,
    COUNT(*) AS NameCount
FROM Employee
GROUP BY Name
HAVING COUNT(*) > 1;


-- Question 14: List Department wise Average Salary.
SELECT 
    D.DeptName,
    AVG(E.Salary) AS AvgSalary
FROM Department D
JOIN Employee E
    ON D.DeptID = E.DeptID
GROUP BY D.DeptName;


-- Question 15: List City wise highest paid employee.     
SELECT City , Name , MAX(Salary)
FROM Employee


