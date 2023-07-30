--Practice Exercises - DAY 5:	
-----------------------------TRIGGERS AND CURSORS----

CREATE DATABASE DemoDatabase
USE DemoDatabase

CREATE TABLE Test
( Id int)

----------Triggers:

--DDL Triggers:
-----Create a Trigger which will restrict creating a new table on a specific database:
CREATE TRIGGER TriggerToPreventCreateTable
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
	PRINT 'YOU CANNOT CREATE A TABLE IN THIS DATABASE'
ROLLBACK TRANSACTION
END

CREATE TABLE Test2
(Id int)		--OUTPUT: YOU CANNOT CREATE A TABLE IN THIS DATABASE


-----Alter a Trigger which will restrict to create, alter and drop a table on a specific database:
ALTER TRIGGER TriggerToPreventCreateTable
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
	PRINT 'YOU CANNOT CREATE, ALTER OR DROP A TABLE IN THIS DATABASE'
ROLLBACK TRANSACTION
END

ALTER TABLE Test
ADD Name varchar(50)		--OUTPUT: YOU CANNOT CREATE, ALTER OR DROP A TABLE IN THIS DATABASE

DROP TABLE Test		--OUTPUT: YOU CANNOT CREATE, ALTER OR DROP A TABLE IN THIS DATABASE

DROP TRIGGER TriggerToPreventCreateTable
ON DATABASE


-----Create a Trigger which will restrict operations on table on a specific database using EVENT GROUPS:
CREATE TRIGGER TriggerEventGroup
ON DATABASE
FOR DDL_TABLE_EVENTS
AS
BEGIN
	PRINT 'USE OF EVENT GROUP-- YOU CANNOT CREATE, ALTER OR DROP A TABLE IN THIS DATABASE'
ROLLBACK TRANSACTION
END

CREATE TABLE Test2
(Id int)		--OUTPUT: USE OF EVENT GROUP-- YOU CANNOT CREATE, ALTER OR DROP A TABLE IN THIS DATABASE

ALTER TABLE Test
ADD Name varchar(50)		--OUTPUT: USE OF EVENT GROUP-- YOU CANNOT CREATE, ALTER OR DROP A TABLE IN THIS DATABASE

DROP TABLE Test		--OUTPUT: USE OF EVENT GROUP-- YOU CANNOT CREATE, ALTER OR DROP A TABLE IN THIS DATABASE

DROP TRIGGER TriggerEventGroup
ON DATABASE


-----Create a Trigger using EVENT GROUP on server level:
CREATE TRIGGER TriggerServerAll
ON ALL SERVER
FOR DDL_TABLE_EVENTS
AS
BEGIN 
	PRINT 'YOU CANNOT CREATE, ALTER OR DROP A TABLE IN ANY DATABASE'
ROLLBACK TRANSACTION
END

CREATE TABLE Test2
(Id int)		--OUTPUT: YOU CANNOT CREATE, ALTER OR DROP A TABLE IN ANY DATABASE

Use EmployeeDatabase

CREATE TABLE Test3
(Id int)		--OUTPUT: YOU CANNOT CREATE, ALTER OR DROP A TABLE IN ANY DATABASE


-----Create a Table Audit:
USE DemoDatabase

CREATE TABLE TableAudit
( DatabaseName varchar(150),
TableName varchar(150),
EventType varchar(150),
LoginName varchar(150),
SQLCommand varchar(150),
AuditDateTime datetime)

CREATE TRIGGER TriggerAuditTableChangesInAllDatabases
ON ALL SERVER
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
	DECLARE @EventData XML
	SELECT @EventData = EVENTDATA()
	INSERT INTO DemoDatabase.dbo.TableAudit( DatabaseName, TableName, EventType, LoginName, SQLCommand, AuditDateTime) VALUES
	(@EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'varchar(150)'),
	@EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(150)'),
	@EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(150)'),
	@EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'varchar(150)'),
	@EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'varchar(150)'),
	GETDATE())
END

USE DemoDatabase

CREATE TABLE Test2
(Id int)

SELECT * FROM TableAudit