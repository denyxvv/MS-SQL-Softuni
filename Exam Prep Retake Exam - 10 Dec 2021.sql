-- 1
CREATE TABLE [Passengers]
(
    [Id] INT PRIMARY KEY IDENTITY,
    [FullName] VARCHAR(100) UNIQUE NOT NULL,
    [Email] VARCHAR(50) UNIQUE NOT NULL,
)
CREATE TABLE [Pilots]
(
    [Id] INT PRIMARY KEY IDENTITY,
    [FirstName] VARCHAR(30) UNIQUE NOT NULL,
    [LastName] VARCHAR(30) UNIQUE NOT NULL,
    [Age] TINYINT NOT NULL CHECK(Age >= 21 AND Age <= 62),
    [Rating] DECIMAL(18, 2)  CHECK(Rating >= 0.0 AND Rating <= 10.0)
)
CREATE TABLE [AircraftTypes]
(
    [Id] INT PRIMARY KEY IDENTITY,
    [TypeName] VARCHAR(30) UNIQUE NOT NULL
)
CREATE TABLE [Aircraft]
(
    [Id] INT PRIMARY KEY IDENTITY,
    [Manufacturer] VARCHAR(25) NOT NULL,
    [Model] VARCHAR(30) NOT NULL,
    [Year] INT NOT NULL,
    [FlightHours] INT,
    [Condition] CHAR NOT NULL,
    [TypeId] INT FOREIGN KEY REFERENCES [AircraftTypes]([Id]) NOT NULL 
)
CREATE TABLE [PilotsAircraft]
(
    [AircraftId] INT FOREIGN KEY REFERENCES [Aircraft]([Id]),
    [PilotId] INT FOREIGN KEY REFERENCES [Pilots]([Id])
    PRIMARY KEY ([AircraftId], [PilotId])
)
CREATE TABLE [Airports]
(
    [Id] INT PRIMARY KEY IDENTITY,
    [AirportName] VARCHAR(70) UNIQUE NOT NULL,
    [Country] VARCHAR(100) UNIQUE NOT NULL
)
CREATE TABLE [FlightDestinations]
(
    [Id] INT PRIMARY KEY IDENTITY,
    [AirportId] INT FOREIGN KEY REFERENCES [Airports]([Id]) NOT NULL,
    [Start] DATETIME NOT NULL,
    [AircraftId] INT FOREIGN KEY REFERENCES [Aircraft]([Id]) NOT NULL,
    [PassengerId] INT FOREIGN KEY REFERENCES [Passengers]([Id]) NOT NULL,
    [TicketPrice] DECIMAL(18, 2) DEFAULT 15 NOT NULL
)

-- 2
INSERT INTO [Passengers]
(FullName, Email)
SELECT CONCAT([FirstName], ' ', [LastName]),
CONCAT([FirstName], [LastName], '@gmail.com') FROM Pilots
WHERE [Id] BETWEEN 5 AND 15

-- 3
UPDATE [Aircraft]
SET [Condition] = 'A'
WHERE ([Condition] = 'C' OR [Condition] = 'B') AND ([FlightHours] IS NULL OR [FlightHours] <= 100) AND ([Year] >= 2013)

-- 4
DELETE [Passengers] 
WHERE LEN(FullName) <= 10

-- 5
SELECT [Manufacturer], [Model], [FlightHours], [Condition] FROM [Aircraft]
ORDER BY [FlightHours] DESC

-- 6
SELECT p.[FirstName], p.[LastName] ,a.[Manufacturer], a.[Model], a.[FlightHours] FROM [Aircraft] AS [a]
JOIN [PilotsAircraft] AS [pa] ON a.[Id] = pa.[AircraftId]
JOIN [Pilots] AS [p] ON pa.[PilotId] = p.[Id]
WHERE [FlightHours] IS NOT NULL AND [FlightHours] < 304
ORDER BY [FlightHours] DESC, [FirstName]

-- 7
SELECT TOP(20) fd.[Id] AS [DestinationId] ,fd.[Start], p.[FullName], a.[AirportName] ,fd.[TicketPrice] FROM [FlightDestinations] AS [fd]
JOIN [Passengers] AS [p] ON fd.[PassengerId] = p.[Id]
JOIN [Airports] AS [a] ON fd.[AirportId] = a.[Id]
WHERE DAY([Start]) % 2 = 0
ORDER BY fd.[TicketPrice] DESC, a.[AirportName]

-- 8
SELECT a.[Id] AS [AircraftId], a.[Manufacturer], a.[FlightHours], COUNT(fd.Id) AS [FlightDestinationsCount],
ROUND(AVG(fd.[TicketPrice]), 2) AS [AvgPrice]  FROM [Aircraft] AS [a]
JOIN [FlightDestinations] AS [fd] ON a.[Id] = fd.[AircraftId]
GROUP BY a.Id, a.Manufacturer, a.FlightHours
HAVING COUNT(fd.Id) >= 2
ORDER BY [FlightDestinationsCount] DESC, a.Id

-- 9
SELECT p.FullName, COUNT(fd.AircraftId) AS [CountOfAircraft], SUM(fd.TicketPrice) AS [TotalPayed] FROM Passengers AS p
JOIN FlightDestinations AS fd ON p.Id = fd.PassengerId
JOIN Aircraft AS a ON fd.AircraftId = a.Id
WHERE SUBSTRING(p.FullName, 2, 1) = 'a'
GROUP BY p.FullName
HAVING COUNT(fd.AircraftId) > 1
ORDER BY p.FullName

-- 10
SELECT ap.AirportName, fd.[Start] AS [DayTime], fd.TicketPrice, p.FullName, a.Manufacturer, a.Model FROM FlightDestinations AS fd
JOIN Passengers AS p ON fd.PassengerId = p.Id
JOIN Aircraft AS a ON fd.AircraftId = a.Id
JOIN Airports AS ap ON fd.AirportId = ap.Id
WHERE DATEPART(HOUR, [Start]) >= 6 AND DATEPART(HOUR, [Start]) <= 20 AND fd.TicketPrice > 2500
ORDER BY a.Model

-- 11
GO
CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT AS 
BEGIN
DECLARE @destinationCount INT;
SET @destinationCount = 
(
SELECT COUNT(fd.Id ) FROM Passengers AS p
JOIN FlightDestinations AS fd ON p.Id = fd.PassengerId
WHERE p.Email = @email
GROUP BY p.Id

)

IF @destinationCount IS NULL
SET @destinationCount = 0

RETURN @destinationCOunt

END
GO

-- 12
GO
CREATE PROCEDURE [usp_SearchByAirportName] (@airportName VARCHAR(70))
AS
BEGIN

SELECT a.AirportName, p.FullName, 
CASE 
WHEN fd.TicketPrice <= 400 THEN 'Low'
WHEN fd.TicketPrice BETWEEN 401 AND 1500 THEN 'Medium'
ELSE 'High' 
END 
AS [LevelOfTickerPrice],
ac.Manufacturer, ac.Condition, t.TypeName FROM Airports AS a
JOIN FlightDestinations AS fd ON a.Id = fd.AirportId
JOIN Passengers AS p ON fd.PassengerId = p.Id
JOIN Aircraft AS ac ON fd.AircraftId = ac.Id
JOIN AircraftTypes AS t ON ac.TypeId = t.Id
WHERE a.AirportName = @airportName
ORDER BY ac.Manufacturer, p.FullName

END
GO