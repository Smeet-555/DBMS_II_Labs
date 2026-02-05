CREATE OR ALTER FUNCTION fn_WelcomeMessage()
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN 'Welcome to DBMS Lab'
END;

SELECT dbo.fn_WelcomeMessage()

CREATE OR ALTER FUNCTION fn_SimpleInterest
(
    @P FLOAT,
    @R FLOAT,
    @T FLOAT
)
RETURNS FLOAT
AS
BEGIN
    RETURN (@P * @R * @T) / 100
END;

SELECT dbo.fn_SimpleInterest(2.0 , 3.0 , 4.0)

CREATE OR ALTER FUNCTION fn_DateDifference
(
    @Date1 DATE,
    @Date2 DATE
)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @Date1, @Date2)
END;


CREATE OR ALTER FUNCTION fn_SumCredits_TwoCourses
(
    @CourseID1 VARCHAR(10),
    @CourseID2 VARCHAR(10)
)
RETURNS INT
AS
BEGIN
    DECLARE @Sum INT;

    SELECT @Sum = SUM(CourseCredits)
    FROM COURSE
    WHERE CourseID IN (@CourseID1, @CourseID2);

    RETURN @Sum;
END;


CREATE OR ALTER FUNCTION fn_OddEven (@Num INT)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN CASE WHEN @Num % 2 = 0 THEN 'EVEN' ELSE 'ODD' END
END;


CREATE FUNCTION fn_PrintNumbers (@N INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @i INT = 1, @Result VARCHAR(MAX) = '';

    WHILE @i <= @N
    BEGIN
        SET @Result = @Result + CAST(@i AS VARCHAR) + ' ';
        SET @i += 1;
    END

    RETURN @Result;
END;



CREATE OR ALTER FUNCTION fn_FactorialCourseCredits (@CourseID VARCHAR(10))
RETURNS BIGINT
AS
BEGIN
    DECLARE @Credits INT, @Fact BIGINT = 1, @i INT = 1;

    SELECT @Credits = CourseCredits FROM COURSE WHERE CourseID = @CourseID;

    WHILE @i <= @Credits
    BEGIN
        SET @Fact = @Fact * @i;
        SET @i += 1;
    END

    RETURN @Fact;
END;

CREATE FUNCTION fn_EnrollmentYearStatus (@Year INT)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN 
    CASE 
        WHEN @Year < YEAR(GETDATE()) THEN 'PAST'
        WHEN @Year = YEAR(GETDATE()) THEN 'CURRENT'
        ELSE 'FUTURE'
    END
END;


CREATE OR ALTER FUNCTION dbo.fn_StudentsByFirstLetter (@Letter CHAR(1))
RETURNS TABLE
AS
RETURN
(
    SELECT * 
    FROM STUDENT
    WHERE StuName LIKE @Letter + '%'
);


CREATE FUNCTION dbo.fn_UniqueDepartments()
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT StuDepartment FROM STUDENT
);


CREATE FUNCTION dbo.fn_CalculateAge (@DOB DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @DOB, GETDATE())
END;


CREATE FUNCTION dbo.fn_Palindrome (@Num INT)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Rev INT = 0, @Temp INT = @Num;

    WHILE @Temp > 0
    BEGIN
        SET @Rev = (@Rev * 10) + (@Temp % 10);
        SET @Temp = @Temp / 10;
    END

    RETURN CASE WHEN @Rev = @Num THEN 'PALINDROME' ELSE 'NOT PALINDROME' END
END;




CREATE FUNCTION dbo.fn_TotalCSECredits()
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;

    SELECT @Total = SUM(CourseCredits)
    FROM COURSE
    WHERE CourseDepartment = 'CSE';

    RETURN @Total;
END;


CREATE FUNCTION dbo.fn_CoursesByDesignation (@Designation VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT C.CourseName, F.FacultyName, F.FacultyDesignation
    FROM COURSE C
    JOIN COURSE_ASSIGNMENT CA ON C.CourseID = CA.CourseID
    JOIN FACULTY F ON CA.FacultyID = F.FacultyID
    WHERE F.FacultyDesignation = @Designation
);



CREATE FUNCTION dbo.fn_TotalActiveCredits (@StudentID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;

    SELECT @Total = SUM(C.CourseCredits)
    FROM ENROLLMENT E
    JOIN COURSE C ON E.CourseID = C.CourseID
    WHERE E.StudentID = @StudentID
      AND E.EnrollmentStatus = 'Active';

    RETURN ISNULL(@Total, 0);
END;


CREATE FUNCTION dbo.fn_FacultyJoinedBetween
(
    @FromDate DATE,
    @ToDate DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM FACULTY
    WHERE FacultyJoiningDate BETWEEN @FromDate AND @ToDate;

    RETURN @Count;
END;

