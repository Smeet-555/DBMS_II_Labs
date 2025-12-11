-- PART A
-- 1.	INSERT Procedures: Create stored procedures to insert records into STUDENT tables (SP_INSERT_STUDENT)
CREATE OR ALTER PROCEDURE SP_INSERT_STUDENT
    @StudentID INT,
    @StuName            VARCHAR(100),
    @StuEmail           VARCHAR(100),
    @StuPhone           VARCHAR(15),
    @StuDepartment      VARCHAR(50),
    @StuDOB             DATE,
    @StuEnrollmentYear  INT
AS
BEGIN
    INSERT INTO STUDENT(StudentID, StuName, StuEmail, StuPhone, StuDepartment, StuDateOfBirth, StuEnrollmentYear)
    VALUES(@StudentID, @StuName, @StuEmail, @StuPhone, @StuDepartment, @StuDOB, @StuEnrollmentYear);
END;


EXEC SP_INSERT_STUDENT 10, 'Harsh Parmar', 'harsh@univ.edu', '9876543219', 'CSE', '2005-09-18', 2023;
EXEC SP_INSERT_STUDENT 11, 'Om Patel', 'om@univ.edu', '9876543220', 'IT', '2002-08-22', 2022;
GO

-- 2.	INSERT Procedures: Create stored procedures to insert records into COURSE tables (SP_INSERT_COURSE)

CREATE OR ALTER PROCEDURE SP_INSERT_COURSE
    @CourseID              VARCHAR(10),
    @CourseName            VARCHAR(100),
    @Credits               INT,
    @Department            VARCHAR(50),
    @Semester              INT
AS
BEGIN
    INSERT INTO COURSE(CourseID, CourseName, CourseCredits, CourseDepartment, CourseSemester)
    VALUES(@CourseID, @CourseName, @Credits, @Department, @Semester);
END;
EXEC SP_INSERT_COURSE CS330, 'Computer Networks', 4 , 'CSE' , 5;
EXEC SP_INSERT_COURSE EC120, 'Electronic Circuits', 3 , 'ECE' , 2;
GO


-- 3.	UPDATE Procedures: Create stored procedure SP_UPDATE_STUDENT to update Email and Phone in STUDENT table. (Update using studentID)
CREATE OR ALTER PROCEDURE SP_UPDATE_STUDENT
    @StudentID  INT,
    @StuEmail   VARCHAR(100),
    @StuPhone   VARCHAR(15)
AS
BEGIN
    UPDATE STUDENT
    SET StuEmail = @StuEmail,
        StuPhone = @StuPhone
    WHERE StudentID = @StudentID;
END;
GO


-- 4.	DELETE Procedures: Create stored procedure SP_DELETE_STUDENT to delete records from STUDENT where Student Name is Om Patel.
CREATE OR ALTER PROCEDURE SP_DELETE_STUDENT
@studentName    VARCHAR(50)
AS
BEGIN
    DELETE FROM STUDENT
    WHERE StuName = @studentName;
END;

EXEC SP_DELETE_STUDENT 'Om Patel'
GO


-- 5.	SELECT BY PRIMARY KEY: Create stored procedures to select records by primary key (SP_SELECT_STUDENT_BY_ID) from Student table.
CREATE OR ALTER PROCEDURE SP_SELECT_STUDENT_BY_ID
    @StudentID INT
AS
BEGIN
    SELECT *
    FROM STUDENT
    WHERE StudentID = @StudentID;
END;
GO


-- 6.	Create a stored procedure that shows details of the first 5 students ordered by EnrollmentYear.
CREATE OR ALTER PROCEDURE SP_FIRST_5_STUDENTS
AS
BEGIN
    SELECT TOP 5 *
    FROM STUDENT
    ORDER BY StuEnrollmentYear;
END;
GO

-- PART B
-- 7.	Create a stored procedure which displays faculty designation-wise count.
CREATE OR ALTER PROCEDURE SP_FACULTY_DESIGNATION_COUNT
AS
BEGIN
    SELECT FacultyDesignation, COUNT(*) AS TotalFaculty
    FROM FACULTY
    GROUP BY FacultyDesignation;
END;
GO


-- 8.	Create a stored procedure that takes department name as input and returns all students in that department
CREATE OR ALTER PROCEDURE SP_STUDENTS_BY_DEPARTMENT
    @Department VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM STUDENT
    WHERE StuDepartment = @Department;
END;


GO


-- PART C
-- 9.	Create a stored procedure which displays department-wise maximum, minimum, and average credits of courses.
CREATE OR ALTER PROCEDURE SP_COURSE_CREDIT_STATS
AS
BEGIN
    SELECT CourseDepartment,
           MAX(CourseCredits) AS MaxCredits,
           MIN(CourseCredits) AS MinCredits,
           AVG(CourseCredits) AS AvgCredits
    FROM COURSE
    GROUP BY CourseDepartment;
END;
GO


-- 10.	Create a stored procedure that accepts StudentID as parameter and returns all courses the student is enrolled in with their grades.
CREATE OR ALTER PROCEDURE SP_STUDENT_COURSE_DETAILS
    @StudentID INT
AS
BEGIN
    SELECT E.CourseID, C.CourseName, E.Grade, E.EnrollmentStatus
    FROM ENROLLMENT E
    JOIN COURSE C ON E.CourseID = C.CourseID
    WHERE E.StudentID = @StudentID;
END;
GO
