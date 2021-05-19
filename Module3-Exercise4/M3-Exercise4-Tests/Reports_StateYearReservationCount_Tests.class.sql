EXEC tSQLt.NewTestClass 'Reports_StateYearReservationCount_Tests';
GO

CREATE PROCEDURE Reports_StateYearReservationCount_Tests.[test returns an empty table when there is no hotel and no reservation] 
AS
BEGIN
	EXEC tSQLt.FakeTable 'Vendors.Hotels';
	EXEC tSQLt.FakeTable 'Booking.Reservations';

	SELECT ReservationYear, ReservationState, ReservationCount
	INTO #actual 
	FROM Reports.StateYearReservationCount;

	EXEC tsqlt.assertemptytable #actual;
END;
GO

CREATE PROCEDURE Reports_StateYearReservationCount_Tests.[test returns 1 row for 1 HotelState and 1 Year and 1 reservation] 
AS
BEGIN
	EXEC tSQLt.FakeTable 'Vendors.Hotels';
	
	INSERT INTO Vendors.Hotels ([HotelId],[Name],[HotelState],[CostPerNight])
						 VALUES(100, 'Hilton', 'CA', 200);

	EXEC tSQLt.FakeTable 'Booking.Reservations';

	INSERT INTO Booking.Reservations ([ReservationId],[CustomerId],[HotelId],[ReservationDate])
							  VALUES (100, 21, 100, CAST('2021-05-10' AS Date));

	SELECT ReservationYear, ReservationState, ReservationCount
	INTO #actual 
	FROM Reports.StateYearReservationCount;

	SELECT TOP (0) A.* INTO #expected FROM #actual A RIGHT JOIN #actual X ON 1=0;
	
	INSERT INTO #expected(ReservationYear, ReservationState, ReservationCount)
				   VALUES(2021, 'CA', 1)

	EXEC tsqlt.assertequalstable #expected, #actual; 
END
GO

CREATE PROCEDURE Reports_HotelReservationCount_Tests.[test returns multiple rows for mulitple hotel, years and reservations] 
AS
BEGIN
	EXEC tSQLt.FakeTable 'Booking.Reservations';

	INSERT INTO Vendors.Hotels ([HotelId],[Name],[HotelState],[CostPerNight])
						 VALUES(100, 'Hilton', 'CA', 200), 
							   (200, 'Trump', 'NY', 250);

	EXEC tSQLt.FakeTable 'Booking.Reservations';

	INSERT INTO Booking.Reservations ([ReservationId],[CustomerId],[HotelId],[ReservationDate])
							  VALUES (100, 21, 100, CAST('2021-05-10' AS Date)),
									 (101, 35, 200, CAST('2021-12-19' AS Date)),
									 (102, 61, 100, CAST('2021-05-15' AS Date)),
									 (103, 95, 200, CAST('2020-12-19' AS Date)),
									 (104, 97, 100, CAST('2021-01-01' AS Date));

	SELECT ReservationYear, ReservationState, ReservationCount
	into #actual
	FROM Reports.StateYearReservationCount
	
	SELECT TOP (0) A.* INTO #expected FROM #actual A RIGHT JOIN #actual X ON 1=0;

	INSERT INTO #expected(ReservationYear, ReservationState, ReservationCount)
				VALUES(2021, 'CA', 1),
					  (2020, 'CA', 2);

	EXEC tsqlt.assertequalstable #expected, #actual; 
END;
GO