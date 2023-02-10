-- 1
CREATE PROCEDURE [usp_GetEmployeesSalaryAbove35000]
AS
BEGIN
SELECT [FirstName], [LastName] FROM [Employees]
WHERE [Salary] > 35000
END

EXEC [dbo].[usp_GetEmployeesSalaryAbove35000]

-- 2
CREATE PROCEDURE [usp_GetEmployeesSalaryAboveNumber] @minSalary DECIMAL(18, 4)
AS
BEGIN
SELECT [FirstName], [LastName] FROM [Employees]
WHERE [Salary] >= @minSalary
END

-- 3
CREATE PROCEDURE [usp_GetTownsStartingWith] (@firstLetter VARCHAR(50))
AS
SELECT [Name] AS [Town] FROM [Towns]
WHERE SUBSTRING ([Name], 1, LEN(@firstLetter)) = @firstLetter

-- 4
CREATE PROCEDURE [usp_GetEmployeesFromTown] (@townName VARCHAR(50))
AS
SELECT [FirstName], [LastName] FROM [Employees] AS [e]
JOIN [Addresses] AS [a] ON [e].[AddressID] = [a].[AddressID]
JOIN [Towns] AS [t] ON a.[TownID] = t.[TownID]
WHERE t.[Name] = @townName

-- 5
CREATE FUNCTION [ufn_GetSalaryLevel] (@salary DECIMAL(18,4)) 
RETURNS VARCHAR(8)
BEGIN
RETURN CASE
    WHEN @salary < 30000 THEN 'Low'
     WHEN @salary BETWEEN 30000 AND 50000 THEN 'Average'
      ELSE 'High'
    END
END

-- 6
CREATE PROCEDURE [usp_EmployeesBySalaryLevel] (@salaryLevel VARCHAR(8))
AS
BEGIN
    SELECT [FirstName], [LastName] FROM Employees
    WHERE [dbo].[ufn_GetSalaryLevel] ([Salary]) = @salaryLevel
END

-- 7
CREATE FUNCTION [ufn_IsWordComprised] (@setOfLetters VARCHAR(50), @word VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @wordIndex INT = 1;
    WHILE (@wordIndex <= LEN(@word))
    BEGIN
    DECLARE @currentChar CHAR = SUBSTRING(@word, @wordIndex, 1);

    IF CHARINDEX(@currentChar, @setOfLetters) = 0
    BEGIN
    RETURN 0;
    END
    SET @wordIndex += 1;
END
RETURN 1;
END

-- 8
CREATE PROCEDURE [usp_DeleteEmployeesFromDepartment] (@departmentId INT)
AS
BEGIN

    ALTER TABLE [Departments]
	ALTER COLUMN [ManagerID] INT NULL

    DELETE FROM [EmployeesProjects]
    WHERE [EmployeeID] IN 
    (
        SELECT [EmployeeID] FROM [Employees]
        WHERE [DepartmentID] = @departmentId
    )

    UPDATE [Employees]
    SET [ManagerID] = NULL
    WHERE [ManagerID] IN 
    (
        SELECT [EmployeeID] FROM [Employees]
        WHERE [DepartmentID] = @departmentId
    )

    UPDATE [Departments]
    SET [ManagerID] = NULL
    WHERE [DepartmentID] = @departmentId

    DELETE FROM [Employees]
    WHERE [DepartmentID] = @departmentId

    DELETE FROM [Departments]
    WHERE [DepartmentID] = @departmentId

    SELECT COUNT(*) FROM [Departments]
    WHERE [DepartmentID] = @departmentId
END

-- 9
CREATE PROCEDURE [usp_GetHoldersFullName]
AS
BEGIN
    SELECT CONCAT([FirstName], + ' ' + [LastName]) AS [Full Name]  FROM [AccountHolders]
END

-- 10
CREATE PROCEDURE [usp_GetHoldersWithBalanceHigherThan] (@num DECIMAL(18, 4))
AS
    SELECT ah.[FirstName], ah.[LastName] FROM [AccountHolders] AS [ah]
    JOIN
	(
		SELECT 
			[AccountHolderId],
			SUM(Balance) AS [TotalMoney]
		FROM [Accounts]
		GROUP BY [AccountHolderId]
	) AS [acc] ON ah.[Id] = acc.[AccountHolderId]

    WHERE acc.[TotalMoney] > @num
    ORDER BY ah.[FirstName], ah.[LastName]

-- 11
CREATE FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(18, 4), @annualRate FLOAT, @years INT)
RETURNS DECIMAL(18, 4)
AS
	BEGIN
		RETURN @sum * POWER(1 + @annualRate, @years)
	END

-- 12
CREATE PROC usp_CalculateFutureValueForAccount (@accountId INT, @annualRate FLOAT)
AS
    SELECT acc.[Id] AS [Account Id],
		h.[FirstName] AS [First Name],
		h.[LastName] AS [Last Name],
		acc.[Balance] AS [Current Balance],
		dbo.ufn_CalculateFutureValue(acc.[Balance], @annualRate, 5) AS [Balance in 5 years]
	FROM [Accounts] AS [acc]
	JOIN [AccountHolders] AS [h]
		ON acc.[AccountHolderId] = h.[Id]
	WHERE acc.[Id] = @accountId

