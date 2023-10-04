-- CONNECT TO CS2DB3;
--++++++++++++++++++++++++++++++++++++++++++++++
-- CREATE TABLES 
--++++++++++++++++++++++++++++++++++++++++++++++

------------------------------------------------
--  DDL Statements for table Employees 
------------------------------------------------
CREATE TABLE Employees
(ID				    SMALLINT 		NOT NULL
,LastName 			VARCHAR(20)     NOT NULL
,FirstName			VARCHAR(20)		NOT NULL
,PhoneNum			VARCHAR(20)		
,HomeAddr			VARCHAR(200)	
,SalaryPerMonth		REAL			NOT NULL
,YearsOfService		REAL
,BirthDate			DATE	
,Gender				CHAR(1)			NOT NULL CHECK (Gender IN ('M','F'))
,PRIMARY KEY (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table Departments
------------------------------------------------
CREATE TABLE Departments
(ID			    SMALLINT    NOT NULL
,DeptName		VARCHAR(40)	NOT NULL
,ChairEmpID		SMALLINT	NOT NULL
,PRIMARY KEY (ID)
,CONSTRAINT FK_DPT_CHR FOREIGN KEY (ChairEmpID) REFERENCES Employees (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table ResearchGroups
------------------------------------------------
CREATE TABLE ResearchGroups
(ID			        SMALLINT		NOT NULL
,GroupName		    VARCHAR(100)	NOT NULL
,Budget			    REAL
,DepartmentID		SMALLINT		NOT NULL
,PRIMARY KEY (ID)
,CONSTRAINT FK_RGRP_DPT FOREIGN KEY (DepartmentID) REFERENCES Departments (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table Rel_EmpWorkInGroup
------------------------------------------------
CREATE TABLE Rel_EmpWorkInGroup
(ResearchGroupID		SMALLINT	NOT NULL
,EmployeeID			    SMALLINT    NOT NULL
,PRIMARY KEY (ResearchGroupID, EmployeeID)
,CONSTRAINT FK_REWG_RGRP FOREIGN KEY (ResearchGroupID) REFERENCES ResearchGroups (ID)
,CONSTRAINT FK_REWG_EMP FOREIGN KEY (EmployeeID) REFERENCES Employees (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table Buildings
------------------------------------------------
CREATE TABLE Buildings
(ID			    SMALLINT	NOT NULL
,Name			VARCHAR(40)	NOT NULL
,NumOfFloors	SMALLINT
,NumOfRooms		SMALLINT
,NumOfMeters	SMALLINT
,AdminEmpID		SMALLINT	NOT NULL
,PRIMARY KEY (ID)
,CONSTRAINT FK_BLD_ADM FOREIGN KEY (AdminEmpID) REFERENCES Employees (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table BuildingAreaType
------------------------------------------------
CREATE TABLE BuildingAreaType
(ID			    SMALLINT	NOT NULL
,TypeName		VARCHAR(20)	NOT NULL
,PRIMARY KEY (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table HasArea
------------------------------------------------
CREATE TABLE HasArea
(ID				        SMALLINT	NOT NULL
,Description			VARCHAR(40)	NOT NULL
,BuildingAreaTypeID		SMALLINT	NOT NULL
,BuildingID			    SMALLINT	NOT NULL
,PRIMARY KEY (ID)
,CONSTRAINT FK_BLDA_BAT FOREIGN KEY (BuildingAreaTypeID) REFERENCES BuildingAreaType (ID)
,CONSTRAINT FK_BLDA_BLD FOREIGN KEY (BuildingID) REFERENCES Buildings (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table RoomType
------------------------------------------------
CREATE TABLE RoomType
(ID		    SMALLINT 	NOT NULL
,TypeName	VARCHAR(40)	NOT NULL
,PRIMARY KEY (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table Rooms
------------------------------------------------
CREATE TABLE Rooms
(ID				    SMALLINT	NOT NULL
,RoomNum			VARCHAR(10)	NOT NULL
,RoomTypeID			SMALLINT	NOT NULL
,BuildingID			SMALLINT	NOT NULL
,ResearchGroupID	SMALLINT
,PRIMARY KEY (ID)
,CONSTRAINT FK_RM_RMT   FOREIGN KEY (RoomTypeID) REFERENCES RoomType (ID)
,CONSTRAINT FK_RM_BLD   FOREIGN KEY (BuildingID) REFERENCES Buildings (ID)
,CONSTRAINT FK_RM_RGRP  FOREIGN KEY (ResearchGroupID) REFERENCES ResearchGroups (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table Rates
------------------------------------------------
CREATE TABLE Rates
(ID				SMALLINT	NOT NULL
,CostPerUnit	FLOAT		NOT NULL
,PRIMARY KEY (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table MeterType
------------------------------------------------
CREATE TABLE MeterType
(ID		    SMALLINT	NOT NULL
,TypeName	VARCHAR(20)	NOT NULL
,Units		VARCHAR(20)	NOT NULL
,RateID		SMALLINT	
,PRIMARY KEY (ID)
,CONSTRAINT FK_MTYP_RAT FOREIGN KEY (RateID) REFERENCES Rates (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table Meters
------------------------------------------------
CREATE TABLE Meters
(ID			        SMALLINT	NOT NULL
,ModelName		    VARCHAR(20)	NOT NULL
,MeterTypeID		SMALLINT	NOT NULL
,PRIMARY KEY (ID)
,CONSTRAINT FK_MTR_MTYP FOREIGN KEY (MeterTypeID) REFERENCES MeterType (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table Rel_MeterInstalledInRoom
------------------------------------------------
CREATE TABLE Rel_MeterInstalledInRoom
(MeterID		SMALLINT	NOT NULL
,RoomID			SMALLINT	NOT NULL
,DateOfRecord	DATE		NOT NULL
,Reading		FLOAT
,PRIMARY KEY (MeterID, RoomID, DateOfRecord)
,CONSTRAINT FK_RMIR_MTR FOREIGN KEY (MeterID) REFERENCES Meters (ID)
,CONSTRAINT FK_RMIR_RM FOREIGN KEY (RoomID) REFERENCES Rooms (ID))
IN USERSPACE1;

------------------------------------------------
--  DDL Statements for table Rel_MeterInstalledInArea
------------------------------------------------
CREATE TABLE Rel_MeterInstalledInArea
(MeterID		    SMALLINT	NOT NULL
,BuildingAreaID		SMALLINT	NOT NULL
,DateOfRecord		DATE		NOT NULL
,Reading			FLOAT
,PRIMARY KEY (MeterID, BuildingAreaID, DateOfRecord)
,CONSTRAINT FK_RMIA_MTR FOREIGN KEY (MeterID) REFERENCES Meters (ID)
,CONSTRAINT FK_RMIA_BLDA FOREIGN KEY (BuildingAreaID) REFERENCES HasArea (ID))
IN USERSPACE1;

list tables;

-- connect reset;


