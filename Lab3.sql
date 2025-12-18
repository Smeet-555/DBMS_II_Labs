-- 1.	Create a stored procedure that accepts a date and returns all faculty members who joined on that date.

CREATE OR ALTER PROCEDURE SP_FACULTY_JOINING_DATE
@JoiningDate DATE
AS
BEGIN
    SELECT FacultyName FROM FACULTY
    WHERE FacultyJoiningDate = @JoiningDate
END
GO


-- 2.	Create a stored procedure for ENROLLMENT table where user enters either StudentID and returns EnrollmentID, EnrollmentDate, Grade, and Status.

CREATE OR ALTER PROCEDURE SP_ENROLL_STATS_OR_CID
@StuId INT = NULL,
@CID VARCHAR(10) = NULL

AS
BEGIN
    SELECT EnrollmentID , EnrollmentDate , Grade , EnrollmentStatus
    FROM ENROLLMENT
    WHERE StudentID = @StuId
    OR  CourseID = @CID
END
EXEC SP_ENROLL_STATS_OR_CID '1'
EXEC SP_ENROLL_STATS_OR_CID @CID = 'CS101'
GO

-- 3.	Create a stored procedure that accepts two integers (min and max credits) and returns all courses whose credits fall between these values.

CREATE OR ALTER PROCEDURE SP_COURSE_CREDIT_STATS
@minCredit INT,
@maxCredit INT
AS
BEGIN
    SELECT CourseName
    FROM COURSE
    -- WHERE CourseCredits BETWEEN @minCredit AND @maxCredit;
    WHERE CourseCredits > @minCredit AND CourseCredits < @maxCredit
END
GO


-- 4.	Create a stored procedure that accepts Course Name and returns the list of students enrolled in that course.
CREATE OR ALTER PROCEDURE SP_COURSE_WITH_STUDENTS
@courseName varchar(50)
AS 
BEGIN
    SELECT C.CourseName , S.StuName 
    FROM COURSE C 
    JOIN ENROLLMENT E
    ON C.CourseID = E.CourseID
    JOIN STUDENT S
    ON E.StudentID = S.StudentID  
    WHERE C.CourseName = @courseName
END
GO

-- 5.	Create a stored procedure that accepts Faculty Name and returns all course assignments.
CREATE OR ALTER PROCEDURE SP_FACULTY_WITH_COURSE
@facultyName VARCHAR(50)
AS
BEGIN
    SELECT F.FacultyName, C.CourseName, CA.Semester, CA.Year, CA.ClassRoom
    FROM FACULTY F
    JOIN COURSE_ASSIGNMENT CA
    ON F.FacultyID = CA.FacultyID
    JOIN COURSE C
    ON CA.CourseID = C.CourseID
    WHERE F.FacultyName = @facultyName 
END
GO

-- 6.	Create a stored procedure that accepts Semester number and Year, and returns all course assignments with faculty and classroom details.
CREATE OR ALTER PROCEDURE SP_COURSE_ASSIGNMENTS_BY_SEMESTER
@semester INT,
@year INT
AS
BEGIN
    SELECT C.CourseName, F.FacultyName, CA.Semester, CA.Year, CA.ClassRoom
    FROM COURSE_ASSIGNMENT CA
    JOIN COURSE C
    ON CA.CourseID = C.CourseID
    JOIN FACULTY F
    ON CA.FacultyID = F.FacultyID
    WHERE CA.Semester = @semester AND CA.Year = @year
END
GO

-- Part B

-- 7. Create a stored procedure that accepts the first letter of Status ('A', 'C', 'D') and returns enrollment details.
CREATE OR ALTER PROCEDURE SP_ENROLLMENT_BY_STATUS_LETTER
@statusLetter CHAR(1)
AS
BEGIN
    SELECT E.EnrollmentID, E.StudentID, S.StuName, E.CourseID, C.CourseName, 
           E.EnrollmentDate, E.Grade, E.EnrollmentStatus
    FROM ENROLLMENT E
    JOIN STUDENT S ON E.StudentID = S.StudentID
    JOIN COURSE C ON E.CourseID = C.CourseID
    WHERE LEFT(E.EnrollmentStatus, 1) = @statusLetter
END
GO

-- 8. Create a stored procedure that accepts either Student Name OR Department Name and returns student data accordingly.
CREATE OR ALTER PROCEDURE SP_STUDENT_BY_NAME_OR_DEPT
@Name VARCHAR(100)
AS 
BEGIN 
    SELECT * FROM STUDENT
    WHERE StuName = @Name OR StuDepartment = @Name
END
EXEC SP_STUDENT_BY_NAME_OR_DEPT 'Raj Patel'
GO

-- 9. Create a stored procedure that accepts CourseID and returns all students enrolled grouped by enrollment status with counts.
CREATE OR ALTER PROCEDURE SP_STUDENTS_BY_COURSE_STATUS
@courseID VARCHAR(10)
AS
BEGIN
    SELECT E.EnrollmentStatus, COUNT(*) as StudentCount ,S.StuName
    FROM ENROLLMENT E
    JOIN STUDENT S ON E.StudentID = S.StudentID
    WHERE E.CourseID = @courseID
    GROUP BY E.EnrollmentStatus
END
GO

-- Part C

-- 10. Create a stored procedure that accepts a year as input and returns all courses assigned to faculty in that year with classroom details.
CREATE OR ALTER PROCEDURE SP_COURSES_BY_YEAR
@year INT
AS
BEGIN
    SELECT C.CourseID, C.CourseName, F.FacultyName, CA.Semester, CA.Year, CA.ClassRoom
    FROM COURSE_ASSIGNMENT CA
    JOIN COURSE C ON CA.CourseID = C.CourseID
    JOIN FACULTY F ON CA.FacultyID = F.FacultyID
    WHERE CA.Year = @year
    ORDER BY CA.Semester, C.CourseName
END
GO

-- 11. Create a stored procedure that accepts From Date and To Date and returns all enrollments within that range with student and course details.
CREATE OR ALTER PROCEDURE SP_ENROLLMENTS_BY_DATE_RANGE
@fromDate DATE,
@toDate DATE
AS
BEGIN
    SELECT E.EnrollmentID, E.EnrollmentDate, S.StuName, S.StuDepartment,
           C.CourseName, C.CourseCredits, E.Grade, E.EnrollmentStatus
    FROM ENROLLMENT E
    JOIN STUDENT S ON E.StudentID = S.StudentID
    JOIN COURSE C ON E.CourseID = C.CourseID
    WHERE E.EnrollmentDate BETWEEN @fromDate AND @toDate
    ORDER BY E.EnrollmentDate
END
GO

-- 12. Create a stored procedure that accepts FacultyID and calculates their total teaching load (sum of credits of all courses assigned).
CREATE OR ALTER PROCEDURE SP_FACULTY_TEACHING_LOAD
@facultyID INT
AS
BEGIN
    SELECT F.FacultyID, F.FacultyName, F.FacultyDepartment,
           SUM(C.CourseCredits) as TotalTeachingLoad,
           COUNT(CA.CourseID) as TotalCoursesAssigned
    FROM FACULTY F
    JOIN COURSE_ASSIGNMENT CA ON F.FacultyID = CA.FacultyID
    JOIN COURSE C ON CA.CourseID = C.CourseID
    WHERE F.FacultyID = @facultyID
    GROUP BY F.FacultyID, F.FacultyName, F.FacultyDepartment
END
GO



-- OUTPUT PARAMETER
-- find the number of courses offered by given department

CREATE OR ALTER PROC SP_COURSE_BY_DEPARTMENT
@department VARCHAR(100),
@count INT OUT

AS 
BEGIN   
    SELECT @count = COUNT(*) 
    FROM COURSE
    WHERE CourseDepartment = @department
END
GO

DECLARE @COUNT INT
EXEC SP_COURSE_BY_DEPARTMENT @department = 'CSE' , @COUNT = @count OUTPUT

SELECT @COUNT AS Course_count

-- SELECT * FROM COURSE