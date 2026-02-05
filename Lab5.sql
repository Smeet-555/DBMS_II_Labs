-- Part – A

-- 1 Create a cursor Course_Cursor to fetch all rows from COURSE table and display them.
DECLARE Course_Cursor CURSOR FOR
SELECT CourseID, CourseName, CourseCredits, CourseDepartment, CourseSemester
FROM COURSE;

DECLARE @CID VARCHAR(10), @CName VARCHAR(100), @Credits INT, @Dept VARCHAR(50), @Sem INT;

OPEN Course_Cursor;
FETCH NEXT FROM Course_Cursor INTO @CID, @CName, @Credits, @Dept, @Sem;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @CID + ' | ' + @CName + ' | ' + CAST(@Credits AS VARCHAR);
    FETCH NEXT FROM Course_Cursor INTO @CID, @CName, @Credits, @Dept, @Sem;
END

CLOSE Course_Cursor;
DEALLOCATE Course_Cursor;

-- 2 Create a cursor Student_Cursor_Fetch to fetch records in form of StudentID_StudentName (Example:1_Raj Patel)
DECLARE Student_Cursor_Fetch CURSOR FOR
SELECT StudentId , StuName
FROM STUDENT

DECLARE @SID VARCHAR(10) , @Sname VARCHAR(100)

OPEN Student_Cursor_Fetch
FETCH NEXT FROM Student_Cursor_Fetch INTO @SID , @Sname

WHILE @@FETCH_STATUS = 0
BEGIN 
    PRINT @SID + '_' + @Sname
    FETCH NEXT FROM Student_Cursor_Fetch INTO @SID , @Sname;
END
CLOSE Student_Cursor_Fetch
DEALLOCATE Student_Cursor_Fetch

-- 3 Create a cursor to find and display all courses with Credits greater than 3.
DECLARE Course_Credit CURSOR FOR
SELECT CourseName , CourseCredits
FROM COURSE 
WHERE CourseCredits >3

DECLARE @Cname VARCHAR(30) , @Ccredits INT
OPEN Course_Credit
FETCH NEXT FROM Course_Credit INTO @Cname , @Ccredits

WHILE @@FETCH_STATUS = 0
BEGIN   
    PRINT @Cname + '-' + CAST(@Ccredits AS VARCHAR(5))
    FETCH NEXT FROM Course_Credit INTO @Cname , @Ccredits
END
CLOSE Course_Credit
DEALLOCATE Course_Credit

-- 4 Create a cursor to display all students who enrolled in year 2021 or later.
DECLARE Year_Cursor CURSOR FOR
SELECT StuName, StuEnrollmentYear FROM STUDENT WHERE StuEnrollmentYear >= 2021;

DECLARE @Year INT , @StuName VARCHAR(50);

OPEN Year_Cursor;
FETCH NEXT FROM Year_Cursor INTO @STUName, @Year;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @STUName + ' enrolled in ' + CAST(@Year AS VARCHAR);
    FETCH NEXT FROM Year_Cursor INTO @STUName, @Year;
END

CLOSE Year_Cursor;
DEALLOCATE Year_Cursor;

-- 5 Create a cursor Course_CursorUpdate that retrieves all courses and increases Credits by 1 for courses with Credits less than 4.
DECLARE Course_CursorUpdate CURSOR FOR
SELECT CourseID, CourseCredits FROM COURSE WHERE CourseCredits < 4;

DECLARE @CID VARCHAR(10) , @Credits INT;

OPEN Course_CursorUpdate;
FETCH NEXT FROM Course_CursorUpdate INTO @CID, @Credits;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE COURSE SET CourseCredits = CourseCredits + 1 WHERE CourseID = @CID;
    FETCH NEXT FROM Course_CursorUpdate INTO @CID, @Credits;
END
CLOSE Course_CursorUpdate
DEALLOCATE Course_CursorUpdate
-- 6 Create a Cursor to fetch Student Name with Course Name (Example: Raj Patel is enrolled in Database Management System)
DECLARE Enroll_Cursor CURSOR FOR
SELECT S.StuName, C.CourseName
FROM STUDENT S
JOIN ENROLLMENT E ON S.StudentID = E.StudentID
JOIN COURSE C ON E.CourseID = C.CourseID;

DECLARE @Sname VARCHAR(50) , @Cname VARCHAR(50)

OPEN Enroll_Cursor;
FETCH NEXT FROM Enroll_Cursor INTO @SName, @CName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @SName + ' is enrolled in ' + @CName;
    FETCH NEXT FROM Enroll_Cursor INTO @SName, @CName;
END

CLOSE Enroll_Cursor;
DEALLOCATE Enroll_Cursor;
-- 7 Create a cursor to insert data into new table if student belong to ‘CSE’ department. (create new table CSEStudent with relevant columns)
CREATE TABLE CSEStudent
(
    StudentID INT,
    StuName VARCHAR(100),
    StuDepartment VARCHAR(50)
);

DECLARE CSE_Cursor CURSOR FOR
SELECT StudentID, StuName, StuDepartment FROM STUDENT WHERE StuDepartment = 'CSE';

DECLARE @SID INT , @SName VARCHAR(100) , @Dept VARCHAR(100);

OPEN CSE_Cursor;
FETCH NEXT FROM CSE_Cursor INTO @SID, @SName, @Dept;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO CSEStudent VALUES (@SID, @SName, @Dept);
    FETCH NEXT FROM CSE_Cursor INTO @SID, @SName, @Dept;
END

CLOSE CSE_Cursor;
DEALLOCATE CSE_Cursor;

SELECT * FROM CSEStudent
-- Part – B
-- 8 Create a cursor to update all NULL grades to 'F' for enrollments with Status 'Completed'
DECLARE Grade_Cursor CURSOR FOR
SELECT EnrollmentID FROM ENROLLMENT
WHERE Grade IS NULL AND EnrollmentStatus = 'Completed';

DECLARE @EID INT;

OPEN Grade_Cursor;
FETCH NEXT FROM Grade_Cursor INTO @EID;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE ENROLLMENT SET Grade = 'F' WHERE EnrollmentID = @EID;
    FETCH NEXT FROM Grade_Cursor INTO @EID;
END

CLOSE Grade_Cursor;
DEALLOCATE Grade_Cursor;

SELECT * FROM ENROLLMENT 
-- 9 Cursor to show Faculty with Course they teach (EX: Dr. Sheth teaches Data structure)
DECLARE Faculty_Cursor CURSOR FOR
SELECT F.FacultyName, C.CourseName
FROM FACULTY F
JOIN COURSE_ASSIGNMENT CA ON F.FacultyID = CA.FacultyID
JOIN COURSE C ON CA.CourseID = C.CourseID;

DECLARE @FName VARCHAR(100) , @CName VARCHAR(100);

OPEN Faculty_Cursor;
FETCH NEXT FROM Faculty_Cursor INTO @FName, @CName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @FName + ' teaches ' + @CName;
    FETCH NEXT FROM Faculty_Cursor INTO @FName, @CName;
END

CLOSE Faculty_Cursor;
DEALLOCATE Faculty_Cursor;
-- Part – C
-- 10 Cursor to calculate total credits per student (Example: Raj Patel has total credits = 15)
DECLARE CreditSum_Cursor CURSOR FOR
SELECT S.StuName, SUM(C.CourseCredits)
FROM STUDENT S
JOIN ENROLLMENT E ON S.StudentID = E.StudentID
JOIN COURSE C ON E.CourseID = C.CourseID
GROUP BY S.StuName;

DECLARE @TotalCredits INT ,@SName VARCHAR(100);

OPEN CreditSum_Cursor;
FETCH NEXT FROM CreditSum_Cursor INTO @SName, @TotalCredits;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @SName + ' has total credits = ' + CAST(@TotalCredits AS VARCHAR);
    FETCH NEXT FROM CreditSum_Cursor INTO @SName, @TotalCredits;
END

CLOSE CreditSum_Cursor;
DEALLOCATE CreditSum_Cursor;