--Practice Exercises - DAY 5:	
-----------------------------TRIGGERS AND CURSORS----

CREATE DATABASE DatabaseCursor		--Creating a new Database
USE DatabaseCursor

CREATE TABLE StudentDetails		--Creating a new table to store student marks
( RollNo int NOT NULL,
StudentName varchar(50) NOT NULL,
Class varchar(20) NOT NULL,
ScienceMarks int NOT NULL,
MathMarks int NOT NULL,
EnglishMarks int NOT NULL)

INSERT INTO StudentDetails VALUES		--Inserting values into Student table
(1, 'Vishveshwar', '5th', 34, 78, 54),
(2, 'Haripriya', '7th', 78, 43, 87),
(3, 'Manjunath', '5th', 45, 32, 78),
(4, 'Tejaswini', '4th', 36, 78, 32),
(5, 'Hemanth', '5th', 12, 24, 56),
(6, 'Joyce', '8th', 34, 88, 54),
(7, 'Paul', '4th', 45, 74, 94),
(8, 'Nida', '9th', 34, 67, 93),
(9, 'Lakshith', '12th', 76, 78, 64),
(10, 'Sameera', '11th', 48, 98, 63)

SELECT * FROM StudentDetails		---Displaying the student table

----------Cursors:
DECLARE
@RollNo int,
@StudentName varchar(50),
@ScienceMarks int,
@MathMarks int,
@EnglishMarks int		

DECLARE
@MarksTotal int,
@Percentage int		--Declaring all the local variables to view total marks an percentage using cursor

DECLARE StudentCursor CURSOR
FOR 
SELECT RollNo, StudentName, ScienceMarks, MathMarks, EnglishMarks FROM StudentDetails;		--Declaring an SQL cursor to pint the result set

OPEN StudentCursor		--Open the SQL Cursor and point to nothing

FETCH NEXT FROM StudentCursor INTO @RollNo, @StudentName, @ScienceMarks, @MathMarks, @EnglishMarks		--Pointing the SQL Cursor to the next Row

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT CONCAT('Name: ', @StudentName);
	PRINT CONCAT('Roll Number: ', @RollNo);
	PRINT 'MARKS IN SUBJECTS:'
	PRINT CONCAT('Science: ', @ScienceMarks);
	PRINT CONCAT('Math: ', @MathMarks);
	PRINT CONCAT('English: ', @EnglishMarks);		--Displaying values row wise

	SET @MarksTotal = @ScienceMarks + @MathMarks + @EnglishMarks;
	PRINT CONCAT('TOTAL MARKS: ', @MarksTotal);		--Calculating Total Marks and Displaying row wise

	SET @Percentage = @MarksTotal / 3;
	PRINT CONCAT('PERCENTAGE: ', @Percentage, '%');		--Calculating Percentage and Displaying row wise

	PRINT '----------------------------------'

	IF @Percentage > 80
	BEGIN
		PRINT 'GRADE: "A"'
	END

	ELSE IF @Percentage > 60 AND @Percentage < 80
	BEGIN
		PRINT 'GRADE: "B"'
	END

	ELSE
	BEGIN
		PRINT 'GRADE: "C"'
	END		--Calculating Grade and Displaying row wise

	PRINT '=================================================================================='

	FETCH NEXT FROM StudentCursor INTO @RollNo, @StudentName, @ScienceMarks, @MathMarks, @EnglishMarks		--Moving cursor to the next row
END

CLOSE StudentCursor		--Closing the Cursor

DEALLOCATE StudentCursor		--Deallocate the Cursor and release all the system related to the Cursor
