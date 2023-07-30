--Practice Exercises - DAY 5:	
-----------------------------TRIGGERS AND CURSORS----

USE EmployeeDatabase

----------Triggers:

--DML Triggers:
-----To create a DML trigger AFTER INSERT:
CREATE TRIGGER EmployeeTrigger ON Employee
AFTER INSERT
AS
	DECLARE @EmployeeAge int;
	DECLARE @EmployeeSalary varchar(50);
SELECT @EmployeeAge = i.Age FROM inserted i;
SELECT @EmployeeSalary = i.Salary FROM inserted i;

IF @EmployeeAge < 18		--Employee's Age must not be below 18
	BEGIN 
		PRINT 'Not Eigible - Age lesser than 18'
		ROLLBACK
	END

ELSE IF @EmployeeSalary > 150000		--Employee's Salary should not be greater than 150000
	BEGIN 
		PRINT 'Not Eligible - Salary greater than 150000'
		ROLLBACK
	END

ELSE
	BEGIN
		PRINT 'Employee Details inserted successfully'
	END


INSERT INTO Employee(EmployeeName, Age, Department, Salary) VALUES
('Lavanya', 11, 'Accounts', '75000');		--OUTPUT:  Not Eigible - Age lesser than 18

INSERT INTO Employee(EmployeeName, Age, Department, Salary) VALUES
('Tanusha', 21, 'Management', '160000');		--OUTPUT:  Not Eligible - Salary greater than 150000

INSERT INTO Employee(EmployeeName, Age, Department, Salary) VALUES
('Viraj', 23, 'Management', '80000');		--OUTPUT:  Employee Details inserted successfully


-----To create a DML trigger AFTER UPDATE:
CREATE TABLE EmployeeHistory		--Creating a table to record the old data and the new data
( EmployeeId int NOT NULL,
FieldName varchar(50) NOT NULL,
OldValue varchar(50) NOT NULL,
NewValue varchar(50) NOT NULL,
RecordDateTime datetime NOT NULL);

CREATE TRIGGER TriggerAfterUpdate ON Employee
AFTER UPDATE
AS
	DECLARE @EmployeeId int;
	DECLARE @EmployeeName varchar(50);
	DECLARE @OldEmployeeName varchar(50);
	DECLARE @EmployeeSalary varchar(50);
	DECLARE @OldEmployeeSalary varchar(50);
SELECT @EmployeeId = i.EmployeeId FROM inserted i;
SELECT @EmployeeName = i.EmployeeName FROM inserted i;
SELECT @OldEmployeeName = d.EmployeeName FROM deleted d;
SELECT @EmployeeSalary = i.Salary FROM inserted i;
SELECT @OldEmployeeSalary = d.Salary FROM deleted d;

IF UPDATE (EmployeeName)		--If Employee's Name is updated then record the data in EmployeeHistory Table
BEGIN
	INSERT INTO EmployeeHistory(EmployeeId, FieldName, OldValue, NewValue, RecordDateTime) VALUES
	(@EmployeeId, 'EmployeeName', @OldEmployeeName, @EmployeeName, GETDATE())
END

IF UPDATE (Salary)		--If Employee's Salary is updated then record the data in EmployeeHistory Table
BEGIN
	INSERT INTO EmployeeHistory(EmployeeId, FieldName, OldValue, NewValue, RecordDateTime) VALUES
	(@EmployeeId, 'EmployeeName', @OldEmployeeSalary, @EmployeeSalary, GETDATE())
END

SELECT * FROM Employee		--Table values before Updating Name

UPDATE Employee SET EmployeeName = 'Akshay' WHERE EmployeeId = 9;		--Updating the name where id is 9

SELECT * FROM Employee;		
SELECT * FROM EmployeeHistory;		--Table values after Updating Name


SELECT * FROM Employee		--Table values before Updating Salary

UPDATE Employee SET Salary = '75000' WHERE EmployeeId = 9;		--Updating the salary where id is 9

SELECT * FROM Employee;		
SELECT * FROM EmployeeHistory;		--Table values after Updating Salary


-----To create a DML trigger AFTER DELETE:
CREATE TABLE EmployeeBackUp		--Creating a table to record the deleted data
( EmployeeId int NOT NULL,
EmployeeName varchar(50) NOT NULL,
Age int NOT NULL,
Department varchar(50) NOT NULL,
Salary varchar(50) NOT NULL,
RecordDateTime datetime NOT NULL);

CREATE TRIGGER TriggerAfterDelete ON Employee
AFTER DELETE
AS
	DECLARE @EmployeeId int;
	DECLARE @EmployeeName varchar(50);
	DECLARE @Age int;
	DECLARE @Department varchar(50);
	DECLARE @Salary varchar(50);
SELECT @EmployeeId = d.EmployeeId FROM deleted d;
SELECT @EmployeeName = d.EmployeeName FROM deleted d;
SELECT @Age = d.Age FROM deleted d;
SELECT @Department = d.Department FROM deleted d;
SELECT @Salary = d.Salary FROM deleted d;

INSERT INTO EmployeeBackUp(EmployeeId, EmployeeName, Age, Department, Salary, RecordDateTime) VALUES
(@EmployeeId, @EmployeeName, @Age, @Department, @Salary, GETDATE())
PRINT 'Employee Details backed up successfully'


SELECT * FROM Employee		--Table values before Deleting

DELETE FROM EmployeeBirthDate WHERE EmployeeId = 10;
DELETE FROM Employee WHERE EmployeeId = 10;		--Deleting a data row

SELECT * FROM Employee;		
SELECT * FROM EmployeeBackUp;		--Table values after Deleting