CREATE VIEW Marketing.EmailList AS
SELECT CustomerID, FirstName, LastName, Email, OptIn
FROM [Booking].[Customers]
WHERE OptIn = 1;

GO