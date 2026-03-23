--Part – A

--1. Create trigger for blocking student deletion.
	CREATE OR ALTER TRIGGER TR_STUDENT_DELETE
	ON STUDENT
	INSTEAD OF DELETE
	AS
	BEGIN
			PRINT 'STUDENT DELETION IS NOT ALLOWED'
	END

	DELETE FROM STUDENT
	WHERE StudentID=8

	DROP TRIGGER TR_STUDENT_DELETE

--2. Create trigger for making course read-only.
	CREATE OR ALTER TRIGGER TR_COURSE_READ
	ON COURSE
	INSTEAD OF INSERT,UPDATE,DELETE
	AS
	BEGIN
			PRINT 'COURSE READ ONLY'
	END

	INSERT INTO COURSE VALUES('ME106', 'Mechanics' ,5, 'MECH' ,1)
	DROP TRIGGER TR_COURSE_READ
--3. Create trigger for preventing faculty removal.
	CREATE OR ALTER TRIGGER TR_FACULTY_REMOVE
	ON FACULTY
	INSTEAD OF DELETE
	AS
	BEGIN
			PRINT 'preventing faculty removal.'
	END
	DELETE FROM FACULTY
	WHERE FacultyID=109
	DROP TRIGGER TR_FACULTY_REMOVE
--4. Create instead of trigger to log all operations on COURSE (INSERT/UPDATE/DELETE) into Log table.
--(Example: INSERT/UPDATE/DELETE operations are blocked for you in course table)
	CREATE OR ALTER TRIGGER TR_COU_LOG
	ON COURSE
	INSTEAD OF INSERT,UPDATE,DELETE
	AS
	BEGIN	
			DECLARE @I INT
			DECLARE @D INT
			
			SELECT @I=  COUNT(*) FROM inserted
			SELECT @D=  COUNT(*) FROM deleted

			IF @I>0 AND @D>0
				INSERT INTO LOG VALUES('UPDATE into Log table.',GETDATE())
			ELSE IF @I>0
				INSERT INTO LOG VALUES('INSERT into Log table.',GETDATE())
			ELSE
				INSERT INTO LOG VALUES('DELETE into Log table.',GETDATE())

	END

	INSERT INTO COURSE VALUES('ME107', 'Mechanics' ,6, 'MECH' ,1)
	INSERT INTO COURSE VALUES('ME108', 'Mechanics' ,7, 'MECH' ,4)
	SELECT * FROM LOG

	DROP TRIGGER TR_COU_LOG
--5. Create trigger to Block student to update their enrollment year and print message ‘students are not
--allowed to update their enrollment year’
SELECT * FROM STUDENT
	CREATE OR ALTER TRIGGER TR_STUDENT_UPDATE
	ON STUDENT
	AFTER UPDATE
	AS
	BEGIN	DECLARE @I INT, @N VARCHAR(50), @E VARCHAR(50), @P VARCHAR(50),@D VARCHAR(50),@B DATE, 
			IF UPDATE(stuEnrollmentYear)
			BEGIN
				PRINT ' students are not allowed to update their enrollment year'
			END
			BEGIN
				INSERT INTO STUDENT (StudentID,StuName, StuEmail, StuPhone,StuDepartment,StuDateOfBirth,StuEnrollmentYear)
				UPDATE STUDENT
				SET 
				SELECT * FROM inserted
			END
			
	END

	UPDATE STUDENT
	SET StuEnrollmentYear=2026
	WHERE StudentID=8
	DROP TRIGGER TR_STUDENT_UPDATE
--6. Create trigger for student age validation (Min 18).
CREATE OR ALTER TRIGGER trg_StudentAgeValidation
ON Student
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Age < 18)
    BEGIN
        PRINT 'Student age must be minimum 18.';
    END
    ELSE
    BEGIN
        INSERT INTO Student
        SELECT * FROM inserted;
    END
END;