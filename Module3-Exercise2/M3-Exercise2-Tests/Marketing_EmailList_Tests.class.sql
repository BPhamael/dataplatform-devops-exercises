EXEC tSQLt.NewTestClass 'Marketing_EmailList_Tests';
GO

CREATE PROCEDURE Marketing_EmailList_Tests.[test opt in to email list is 1]
AS
BEGIN
	EXEC tSQLt.FakeTable 'Booking.Customers';

	INSERT INTO Booking.Customers (CustomerID, FirstName, LastName, Email, OptIn)
							VALUES(1, 'Dan', 'Koen', 'dan.koen@aimco.ca', 1);

	SELECT  CustomerID, FirstName, LastName, Email, OptIn
	INTO #actual
	from Marketing.EmailList;

	SELECT TOP (0) A.* INTO #expected FROM #actual A RIGHT JOIN #actual X ON 1=0;

	INSERT INTO #expected(CustomerId, FirstName, LastName, Email, OptIn)
					VALUES(1, 'Dan', 'Koen', 'dan.koen@aimco.ca', 1)

	EXEC tsqlt.assertequalstable #expected, #actual;

END
GO

CREATE PROCEDURE Marketing_EmailList_Tests.[test opt in to email list is 0]
AS
BEGIN
	EXEC tSQLt.FakeTable 'Booking.Customers';

	INSERT INTO Booking.Customers (CustomerID, FirstName, LastName, Email, OptIn)
							VALUES(1, 'Dan', 'Koen', 'dan.koen@aimco.ca', 0);

	SELECT  CustomerID, FirstName, LastName, Email, OptIn
	INTO #actual
	from Marketing.EmailList;

	EXEC tsqlt.AssertEmptyTable #actual;

END
GO

CREATE PROCEDURE Marketing_EmailList_Tests.[test opt in to email list is 1 for 3 users]
AS
BEGIN
	EXEC tSQLt.FakeTable 'Booking.Customers';

	INSERT INTO Booking.Customers (CustomerID, FirstName, LastName, Email, OptIn)
							VALUES(1, 'Dan', 'Koen', 'dan.koen@aimco.ca', 1),
								  (2, 'Dan1', 'Koen1', 'dan1.koen1@aimco.ca', 1),
								  (3, 'Dan2', 'Koen2', 'dan2.koen2@aimco.ca', 1);

	SELECT  CustomerID, FirstName, LastName, Email, OptIn
	INTO #actual
	from Marketing.EmailList;

	SELECT TOP (0) A.* INTO #expected FROM #actual A RIGHT JOIN #actual X ON 1=0;

	INSERT INTO #expected(CustomerId, FirstName, LastName, Email, OptIn)
					VALUES(1, 'Dan', 'Koen', 'dan.koen@aimco.ca', 1),
						  (2, 'Dan1', 'Koen1', 'dan1.koen1@aimco.ca', 1),
					      (3, 'Dan2', 'Koen2', 'dan2.koen2@aimco.ca', 1);

	EXEC tsqlt.assertequalstable #expected, #actual;

END
GO

CREATE PROCEDURE Marketing_EmailList_Tests.[test opt in to email list is 1 for 1 users, and 0 for 2 users]
AS
BEGIN
	EXEC tSQLt.FakeTable 'Booking.Customers';

	INSERT INTO Booking.Customers (CustomerID, FirstName, LastName, Email, OptIn)
							VALUES(1, 'Dan', 'Koen', 'dan.koen@aimco.ca', 1),
								  (2, 'Dan1', 'Koen1', 'dan1.koen1@aimco.ca', 0),
								  (3, 'Dan2', 'Koen2', 'dan2.koen2@aimco.ca', 0);

	SELECT  CustomerID, FirstName, LastName, Email, OptIn
	INTO #actual
	from Marketing.EmailList;

	SELECT TOP (0) A.* INTO #expected FROM #actual A RIGHT JOIN #actual X ON 1=0;

	INSERT INTO #expected(CustomerId, FirstName, LastName, Email, OptIn)
					VALUES(1, 'Dan', 'Koen', 'dan.koen@aimco.ca', 1);

	EXEC tsqlt.assertequalstable #expected, #actual;

END
GO