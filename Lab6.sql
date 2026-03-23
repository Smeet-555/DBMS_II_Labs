CREATE TABLE Log(
    LogMessage VARCHAR(100),
    LogDate DATETIME
)
GO
-- 1. Create trigger for printing appropriate message after student registration.
CREATE TRIGGER trg_studentRegistration
ON STUDENT
AFTER INSERT
AS
BEGIN
    PRINT 'Student registered successfully'
END
GO
-- 2.Create trigger for printing appropriate message after faculty deletion.
CREATE TRIGGER trg_facultyDelete
ON FACULTY
AFTER DELETE
AS
BEGIN 
    PRINT 'Faculty deleted successfully'
END
GO
-- 3. Create trigger for monitoring all events on course table. (print only appropriate message)

CREATE TRIGGER trg_CourseAllEvents
ON COURSE
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        PRINT 'Course record updated.';
    ELSE IF EXISTS (SELECT * FROM inserted)
        PRINT 'New course added.';
    ELSE IF EXISTS (SELECT * FROM deleted)
        PRINT 'Course record deleted.';
END;

GO
-- 4. Create trigger for logging data on new student registration in Log table.
CREATE TRIGGER trg_LogStuData
ON STUDENT
AFTER INSERT
AS
BEGIN
    INSERT INTO Log (LogMessage , LogDate)
    SELECT
        'New Student :' + StuName + 'Registered',
        GETDATE()
    FROM inserted
END

GO
-- 5. Create trigger for auto-uppercasing faculty names.
CREATE TRIGGER trg_UpperFacNames
ON FACULTY
AFTER INSERT,UPDATE
AS
BEGIN
    UPDATE fac
    SET FacultyName = UPPER(Ins.FacultyName)
    FROM FACULTY fac
    JOIN inserted Ins
    ON fac.FacultyID = Ins.FacultyID
END
GO
-- 6 .Create trigger for calculating faculty experience (Note: Add required column in faculty table)
ALTER table FACULTY
ADD Experience INT 

CREATE TRIGGER trg_FacExperience
ON FACULTY
AFTER INSERT
AS 
BEGIN
    UPDATE fac
    SET Experience = DATEDIFF(YEAR , I.FacultyJoiningDate , GETDATE())
    FROM FACULTY fac
    JOIN inserted I
    ON fac.FacultyID = I.FacultyID
END  
GO
-- 7. Create trigger for auto-stamping enrollment dates.
CREATE TRIGGER trg_AutoStampEnrollmentDate
ON ENROLLMENT
AFTER INSERT
AS
BEGIN
    UPDATE E
    SET EnrollmentDate = GETDATE()
    FROM ENROLLMENT E
    INNER JOIN inserted I
    ON E.EnrollmentID = I.EnrollmentID;
END;

GO
-- 8. Create trigger for logging data After course assignment - log course and faculty detail.

CREATE TRIGGER trg_LogCourseAssignment
ON COURSE_ASSIGNMENT
AFTER INSERT
AS
BEGIN
    INSERT INTO Log(LogMessage, LogDate)
    SELECT 
        'Course: ' + C.CourseName +' assigned to: ' + F.FacultyName,
        GETDATE()
    FROM inserted I
    INNER JOIN COURSE C ON I.CourseID = C.CourseID
    INNER JOIN FACULTY F ON I.FacultyID = F.FacultyID;
END;
GO
-- 9. Create trigger for updating student phone and print the old and new phone number.
CREATE TRIGGER trg_UpdateStudentPhone
ON STUDENT
AFTER UPDATE
AS
BEGIN
    IF UPDATE(StuPhone)
    BEGIN
        SELECT 
            'Old Phone: ' + D.StuPhone + 
            ' | New Phone: ' + I.StuPhone
        FROM inserted I
        INNER JOIN deleted D
        ON I.StudentID = D.StudentID;
    END
END;
GO
-- 10. Create trigger for updating course credit log old and new credits in log table.
CREATE TRIGGER trg_UpdateCourseCredits
ON COURSE
AFTER UPDATE
AS
BEGIN
    IF UPDATE(CourseCredits)
    BEGIN
        INSERT INTO Log(LogMessage, LogDate)
        SELECT 
            'Course ' + I.CourseName +
            ' Credit Changed from ' + 
            CAST(D.CourseCredits AS VARCHAR) + 
            ' to ' + 
            CAST(I.CourseCredits AS VARCHAR),
            GETDATE()
        FROM inserted I
        INNER JOIN deleted D
        ON I.CourseID = D.CourseID;
    END
END;

