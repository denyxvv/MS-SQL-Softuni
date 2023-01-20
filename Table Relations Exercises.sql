-- 1
CREATE TABLE [Passports] 
(
 [PassportID] INT PRIMARY KEY IDENTITY(101, 1),
 [PassportNumber] VARCHAR(8) NOT NULL
)
CREATE TABLE [Persons] 
(
 [PersonID] INT PRIMARY KEY IDENTITY(101, 1),
 [FirstName] VARCHAR(50) NOT NULL,
 [Salary] DECIMAL(10,2) NOT NULL,
 [PassportID] INT FOREIGN KEY REFERENCES[Passports](PassportID) UNIQUE NOT NULL,

)

-- 2
CREATE TABLE [Manufacturers] 
(
 [ManufacturerID] INT PRIMARY KEY IDENTITY,
 [Name] VARCHAR(50) NOT NULL,
 [EstablishedOn] DATETIME2 NOT NULL
)
CREATE TABLE [Models] 
(
 [ModelID] INT PRIMARY KEY IDENTITY(101, 1),
 [Name] VARCHAR(50) NOT NULL,
 [ManufacturerID] INT FOREIGN KEY REFERENCES [Manufacturers]([ManufacturerID]) NOT NULL
)

-- 3
CREATE TABLE [Students] 
(
 [StudentID] INT PRIMARY KEY IDENTITY,
 [Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Exams] 
(
 [ExamID] INT PRIMARY KEY IDENTITY(101, 1),
 [Name] NVARCHAR(100) NOT NULL
)

CREATE TABLE [StudentsExams] 
(
 [StudentID] INT FOREIGN KEY REFERENCES[Students]([StudentID]),
 [ExamID] INT FOREIGN KEY REFERENCES[Exams]([ExamID]),
 PRIMARY KEY ([StudentID],[ExamID])
)

-- 4
CREATE TABLE [Teachers]
(
    [TeacherID] INT PRIMARY KEY IDENTITY(101, 1),
    [Name] VARCHAR(50) NOT NULL,
    [ManagerID] INT FOREIGN KEY REFERENCES[Teachers]([TeacherID]) NULL
)

-- 5
CREATE TABLE [Cities]
(
    [CityID] INT PRIMARY KEY NOT NULL,
    [Name] VARCHAR(50) NOT NULL,
)

CREATE TABLE [Customers]
(
    [CustomerID] INT PRIMARY KEY,
    [Name] VARCHAR(50) NOT NULL,
    [Birthday] DATE NOT NULL,
    [CityID] INT NOT NULL FOREIGN KEY REFERENCES[Cities](CityID)
)

CREATE TABLE [Orders]
(
    [OrderID] INT PRIMARY KEY,
    [CustomerID] INT NOT NULL FOREIGN KEY REFERENCES[Customers](CustomerID)
)

CREATE TABLE [ItemTypes]
(
    [ItemTypeID] INT PRIMARY KEY,
    [Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Items]
(
    [ItemID] INT PRIMARY KEY,
    [Name] VARCHAR(50) NOT NULL,
    [ItemTypeID] INT NOT NULL FOREIGN KEY REFERENCES[ItemTypes](ItemTypeID)
)

CREATE TABLE [OrderItems]
(
    [OrderID] INT NOT NULL FOREIGN KEY REFERENCES[Orders](OrderID),
    [ItemID] INT NOT NULL FOREIGN KEY REFERENCES[Items](ItemID) 
    CONSTRAINT PK_OrderItems
    PRIMARY KEY (OrderID, ItemID)
)

-- 6
CREATE TABLE [Majors]
(
	[MajorID] INT NOT NULL PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Subjects]
(
    [SubjectID] INT NOT NULL PRIMARY KEY,
    [SubjectName] VARCHAR(50) NOT NULL
)

CREATE TABLE [Students]
(
    [StudentID] INT NOT NULL PRIMARY KEY,
    [StudentNumber] INT NOT NULL,
    [StudentName] NVARCHAR(50) NOT NULL,
    [MajorID] INT FOREIGN KEY REFERENCES[Majors](MajorID),
)

CREATE TABLE [Agenda]
(
    [StudentID] INT NOT NULL FOREIGN KEY REFERENCES[Students](StudentID),
    [SubjectID] INT NOT NULL FOREIGN KEY REFERENCES[Subjects](SubjectID),
    PRIMARY KEY (StudentID, SubjectID)
)

CREATE TABLE [Payments]
(
    [PaymentID] INT PRIMARY KEY,
    [PaymentDate] DATETIME2 NOT NULL,
    [PaymentAmount] DECIMAL(8,2) NOT NULL,
    [StudentID] INT FOREIGN KEY REFERENCES[Students](StudentID),
)

-- 9

SELECT m.MountainRange, p.PeakName, p.Elevation
FROM [Peaks] AS p
JOIN [Mountains] AS m
ON p.MountainId = m.Id
WHERE m.MountainRange = 'Rila'
ORDER BY p.Elevation DESC