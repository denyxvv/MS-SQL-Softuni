-- 1
CREATE DATABASE Minions

USE [Minions]

CREATE TABLE Minions
(
Id int PRIMARY KEY , [Name] varchar(100), Age int
)
-- 2
CREATE TABLE Towns
(
Id int PRIMARY KEY, [Name] varchar(100)
)
-- 3
ALTER TABLE Minions
ADD [TownId] int FOREIGN KEY REFERENCES Towns(Id)
-- 4
INSERT INTO Towns
VALUES 
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO Minions
VALUES 
(1, 'Kevin', 22 , 1) ,
(2, 'Bob', 15, 3) ,
(3, 'Steward', NULL,  2)

SELECT * FROM Towns
SELECT * FROM Minions
-- 5
TRUNCATE TABLE Minions

-- 6
DROP TABLE Minions
DROP TABLE Towns

-- 7
CREATE TABLE People
(
[Id] INT PRIMARY KEY IDENTITY(1,1),
[Name] NVARCHAR(200) NOT NULL,
[Picture] VARBINARY(MAX) CHECK (DATALENGTH([Picture]) <= 2000000),
[Height] DECIMAL(3, 2),
[Weight] DECIMAL(3, 2),
[Gender] CHAR(1) CHECK([Gender] = 'm' OR [Gender] = 'f'),
[Birthdate] DATE NOT NULL,
[Biography] NCHAR (5)
)

INSERT INTO [People]([Name], [Gender], [Birthdate])
VALUES
('Petyo', 'm' , '2007-08-10'),
('Cvetan', 'm' , '2007-04-02'),
('Deyan', 'm' , '2007-06-10'),
('Monika', 'f' , '2007-03-10'),
('Pesho', 'm' , '2007-06-10')

-- 8
CREATE TABLE Users
(
[Id] BIGINT PRIMARY KEY IDENTITY,
[Username] VARCHAR(30) NOT NULL,
[Password] VARCHAR(26) NOT NULL,
[ProfilePicture] VARBINARY(MAX) CHECK (DATALENGTH([ProfilePicture]) <= 900000),
[LastLoginTime] DATETIME2,
[IsDeleted] BIT
)

INSERT INTO [Users]([Username], [Password])
VALUES
('Petyo', 'Petyo123' ),
('Cvetan', 'Cvetan123'),
('Pesho', 'Pesho123'),
('Moni', 'Moni123'),
('Vladislav', 'Vladi123')

-- 9
ALTER TABLE [Users] DROP CONSTRAINT PK__Users__3214EC07B4B134F7
ALTER TABLE [Users] ADD CONSTRAINT PK_Id_Username PRIMARY KEY(Id, Username)

-- 10
ALTER TABLE [Users] ADD CONSTRAINT CHK_PasswordMinLenght CHECK(LEN(Password) >= 5);

-- 11
ALTER TABLE [Users] ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR [LastLoginTime]

-- 12
ALTER TABLE [Users] DROP CONSTRAINT PK_Id_Username
ALTER TABLE [Users] ADD CONSTRAINT PK_Id PRIMARY KEY (Id)

ALTER TABLE [Users] ADD CONSTRAINT UC_Username UNIQUE (Username);
ALTER TABLE [Users] ADD CONSTRAINT  CHK_Username CHECK (LEN(Username) >= 3)

-- 13
CREATE DATABASE Movies
USE [Movies]

CREATE TABLE Directors
(
     [Id] INT PRIMARY KEY ,
    [DirectorName] NVARCHAR NOT NULL,
    [Notes] NVARCHAR,

)
CREATE TABLE Genres 
(
     [Id] int PRIMARY KEY ,
    [GenreName] NVARCHAR NOT NULL,
    [Notes] NVARCHAR,

)
CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY,
	[CategoryName] NVARCHAR NOT NULL,
	[Notes] NVARCHAR

)
CREATE TABLE [Movies] 
(
    [Id] int PRIMARY KEY ,
    [Title] NVARCHAR NOT NULL,
    [Notes] NVARCHAR,
    [DirectorId] int FOREIGN KEY REFERENCES [Directors]([Id]) ,
    [CopyrightYear] DATE,
    [Lenght] NVARCHAR,
    [GenreId] INT FOREIGN KEY REFERENCES [Genres]([Id]),
    [CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]),
    [Rating] SMALLINT,
)

INSERT INTO [Categories]([Id], [CategoryName])
	VALUES
	(1, 'Action'),
	(2, 'Comedy'),
	(3, 'Fantasy'),
	(4, 'Adventure'),
	(5, 'Horror')

INSERT INTO [Directors]([Id], [DirectorName])
	VALUES
	(1, 'John'),
	(2, 'Fury'),
	(3, 'Martin'),
	(4, 'Tom'),
	(5, 'Eddy')

INSERT INTO [Genres]([Id], [GenreName])
	VALUES
	(1, 'Best Audio'),
	(2, 'Best Vibes'),
	(3, 'Something1'),
	(4, 'Something2'),
	(5, 'Something3')

INSERT INTO [Movies]([Id], [Title], [DirectorId], [CategoryId], [GenreId])
	VALUES
	(1, 'LOTR', 2, 1, 1),
	(2, 'LOTR', 3, 5, 2),
	(3, 'LOTR', 4, 4, 3),
	(4, 'LOTR', 5, 3, 4),
	(5, 'LOTR', 1, 2, 5)

SELECT * FROM [Categories]
SELECT * FROM [Directors]
SELECT * FROM [Genres]
SELECT * FROM [Movies]

-- 14
CREATE DATABASE CarRental
USE [CarRental]

CREATE TABLE Categories
(
    [Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] VARCHAR(50) NOT NULL,
	[DailyRate] DECIMAL(6, 2) NOT NULL,
	[WeeklyRate] DECIMAL(6, 2) NOT NULL,
	[MonthlyRate] DECIMAL(6, 2) NOT NULL,
	[WeekendRate] DECIMAL(6, 2) NOT NULL
)

-- Use Minions
-- DROP DATABASE CarRental

CREATE TABLE [Cars]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[PlateNumber] VARCHAR(30) NOT NULL,
	[Manufacturer] VARCHAR(50) NOT NULL,
	[Model] VARCHAR(50) NOT NULL,
	[CarYear] INT NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories](Id) NOT NULL,
	[Doors] INT NOT NULL,
	[Picture] IMAGE,
	[Condition] NVARCHAR(1000) NOT NULL,
	[Available] BIT NOT NULL
)

CREATE TABLE Employees 
(
    [Id] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(30) NOT NULL,
	[LastName] VARCHAR(30) NOT NULL,
	[Title] VARCHAR(50) NOT NULL,
	[Notes] NVARCHAR(1000)

)

CREATE TABLE Customers 
(
    [Id] INT PRIMARY KEY IDENTITY,
	[DriverLicenceNumber] INT NOT NULL,
	[FullName] VARCHAR(50) NOT NULL,
	[Address] VARCHAR(200) NOT NULL,
	[City] VARCHAR(50) NOT NULL,
	[ZIPCode] INT NOT NULL,
	[Notes] NVARCHAR(1000)
)

CREATE TABLE RentalOrders  
(
    [Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees](Id) NOT NULL,
    [CustomerId] INT FOREIGN KEY REFERENCES [Customers](Id) NOT NULL,
    [CarId] INT FOREIGN KEY REFERENCES [Cars](Id) NOT NULL,
    [TankLevel] INT NOT NULL,
    [KilometrageStart] INT NOT NULL,
    [KilometrageEnd] INT NOT NULL,
    [TotalKilometrage] INT NOT NULL,
    [StartDate] DATE NOT NULL,
    [EndDate] DATE NOT NULL,
    [TotalDays] INT NOT NULL,
    [RateApplied] DECIMAL(6, 2) NOT NULL,
    [TaxRate] DECIMAL(4, 2) NOT NULL,
    [OrderStatus] VARCHAR(50) NOT NULL,
    [Notes] NVARCHAR(1000),
)

INSERT INTO [Categories]
VALUES
('First category name', 10.00, 50.00, 150.00, 20.00),
('Second category name', 50.00, 250.00, 750.00, 100.00),
('Third category name', 100.00, 500.00, 1500.00, 200.00)

INSERT INTO [Cars]
VALUES
('PLN 0001', 'Ford', 'Model A', 1994, 1, 4, NULL, 'Good', 1),
('PLN 0002', 'Tesla', 'Model B', 2021, 2, 4, NULL, 'Great', 1),
('PLN 0003', 'Capsule Corp', 'Model C', 2054, 3, 10, NULL, 'Best', 0)
    
 INSERT INTO [Employees]
VALUES
('Tyler', 'Durden', 'Edward Norton`s Alter Ego', NULL),
('Plain', 'Jane', 'some gal', NULL),
('Average', 'Joe', 'some dude', NULL)
 
 INSERT INTO [Customers]
VALUES
('123456', 'Jimmy Carr', 'Britain', 'London', 1000, NULL),
('654321', 'Bill Burr', 'USA', 'Washington', 2000, NULL),
('999999', 'Louis CK', 'Mexico', 'Mexico City', 3000, NULL)

INSERT INTO [RentalOrders]
VALUES
(1, 1, 1, 70, 90000, 100000, 10000, '1994-10-01', '1994-10-21', 20, 100.00, 14.00, 'Pending', NULL),
(2, 2, 2, 85, 250000, 2750000, 25000, '2011-11-12', '2011-11-24', 12, 150.00, 17.50, 'Canceled', NULL),
(3, 3, 3, 90, 0, 120000, 120000, '2025-04-05', '2025-05-02', 27, 220.00, 21.25, 'Delivered', NULL)

-- 15
CREATE DATABASE [Hotel]

USE [Hotel]

CREATE TABLE [Employees]
(
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] VARCHAR(20) NOT NULL,
[LastName] VARCHAR(20) NOT NULL,
[Title] VARCHAR(20) NOT NULL,
[Notes] VARCHAR(2000),
)

CREATE TABLE [Customers]
(
[AccountNumber] INT PRIMARY KEY IDENTITY,
[FirstName] VARCHAR(20) NOT NULL,
[LastName] VARCHAR(20) NOT NULL,
[PhoneNumber] INT NOT NULL,
[EmergencyName] VARCHAR(20) NOT NULL,
[EmergencyNumber] INT NOT NULL,
[Notes] VARCHAR(2000),
)

CREATE TABLE [RoomStatus]
(
[RoomStatus] VARCHAR(50) PRIMARY KEY NOT NULL,
[Notes] VARCHAR(2000),
)

CREATE TABLE [RoomTypes]
(
[RoomType] VARCHAR(50) PRIMARY KEY NOT NULL,
[Notes] VARCHAR(2000),
)

CREATE TABLE [BedTypes]
(
[BedType] VARCHAR(50) PRIMARY KEY NOT NULL,
[Notes] VARCHAR(2000),
)

CREATE TABLE [Rooms]
(
[RoomNumber] INT PRIMARY KEY IDENTITY,
[RoomType] VARCHAR(50) NOT NULL,
[BedType] VARCHAR(50) NOT NULL,
[Rate] DECIMAL NOT NULL,
[RoomStatus] VARCHAR(50) NOT NULL,
[Notes] VARCHAR(2000),
)

CREATE TABLE [Payments]
(
[Id] INT PRIMARY KEY IDENTITY,
[EmployeeId] INT FOREIGN KEY REFERENCES [Employees](Id) NOT NULL,
[PaymentDate] DATE NOT NULL,
[AccountNumber] INT FOREIGN KEY REFERENCES [Customers](AccountNumber) NOT NULL,
[FirstDateOccupied] DATE NOT NULL,
[LastDateOccupied] DATE NOT NULL,
[TotalDays] INT NOT NULL,
[AmountCharged] DECIMAL(6, 2) NOT NULL,
[TaxRate] DECIMAL(4, 2) NOT NULL,
[TaxAmount] DECIMAL(6, 2) NOT NULL,
[PaymentTotal] DECIMAL(6, 2) NOT NULL,
[Notes] VARCHAR(2000),
)

CREATE TABLE [Occupancies]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees](Id) NOT NULL,
	[DateOccupied] DATE NOT NULL,
	[AccountNumber] INT FOREIGN KEY REFERENCES [Customers](AccountNumber) NOT NULL,
	[RoomNumber] INT FOREIGN KEY REFERENCES [Rooms](RoomNumber) NOT NULL,
	[RateApplied] DECIMAL(4, 2) NOT NULL,
	[PhoneCharge] DECIMAL(4, 2) NOT NULL,
	[Notes] NVARCHAR(1000)
)

INSERT INTO [Employees] VALUES
	('Jim', 'McJim', 'Supervisor', NULL),
	('Jane', 'McJane', 'Cook', NULL),
	('John', 'McJohn', 'Waiter', NULL)
		
INSERT INTO [Customers] VALUES
	('Mickey', 'Mouse', 12345678, 'Minnie', 11111111, NULL),
	('Donald', 'Duck', 87654321, 'Daisy', 22222222, NULL),
	('Scrooge', 'McDuck', 9999999, 'Richie', 33333333, NULL)
		
INSERT INTO [RoomStatus] VALUES
	('Free', NULL),
	('Occupied', NULL),
	('No idea', NULL)
		
INSERT INTO [RoomTypes] VALUES
	('Room', NULL),
	('Studio', NULL),
	('Apartment', NULL)
		
INSERT INTO [BedTypes] VALUES
	('Big', NULL),
	('Small', NULL),
	('Child', NULL)
		
INSERT INTO [Rooms] VALUES
	('Room', 'Big', 15.00, 'Free', NULL),
	('Studio', 'Small', 12.50, 'Occupied', NULL),
	('Apartment', 'Child', 10.25, 'No idea', NULL)
		
INSERT INTO [Payments] VALUES
	(1, '2023-02-01', 1, '2023-01-11', '2023-01-14', 3, 250.00, 20.00, 50.00, 300.00, NULL),
	(2, '2023-02-02', 2, '2023-01-12', '2023-01-15', 3, 199.90, 20.00, 39.98, 239.88, NULL),
	(3, '2023-02-03', 3, '2023-01-13', '2023-01-16', 3, 330.50, 20.00, 66.10, 396.60, NULL)
	   	
INSERT INTO [Occupancies] VALUES
	(1, '2023-01-01', 1, 1, 20.00, 15.00, NULL),
	(2, '2023-01-02', 2, 2, 20.00, 12.50, NULL),
	(3, '2023-01-03', 3, 3, 20.00, 18.90, NULL)

    -- 19
SELECT * FROM [Towns]	

SELECT * FROM [Departments]	

SELECT * FROM [Employees]

-- 20
SELECT [Name] FROM [Towns]	
	ORDER BY [Name]

SELECT [Name] FROM [Departments]	
	ORDER BY [Name]

SELECT [FirstName], [LastName], [JobTitle], [Salary] FROM [Employees]
	ORDER BY [Salary] DESC

-- 21
SELECT [Name] FROM [Towns]	
	ORDER BY [Name]

SELECT [Name] FROM [Departments]	
	ORDER BY [Name]

SELECT [FirstName], [LastName], [JobTitle], [Salary] FROM [Employees]
	ORDER BY [Salary] DESC

    -- 22
    UPDATE [Employees]
	SET [Salary] *= 1.1

SELECT [Salary] FROM [Employees]

-- 23
UPDATE [Payments]
	SET [TaxRate] -= 0.03

SELECT [TaxRate] FROM [Payments]

-- 24
DELETE [Occupancies]

