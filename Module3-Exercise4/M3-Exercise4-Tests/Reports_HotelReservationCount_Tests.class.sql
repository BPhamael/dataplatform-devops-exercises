EXEC tSQLt.NewTestClass 'Reports_HotelReservationCount_Tests';
GO

CREATE PROCEDURE Reports_HotelReservationCount_Tests.[test Hotel Reservation Count 1 to 1] 
AS
BEGIN
	EXEC tSQLt.FakeTable 'Vendors.Hotels';
	
	INSERT INTO Vendors.Hotels ([HotelId],[Name],[HotelState],[CostPerNight])
						 VALUES(100, 'Hilton', 'CA', 200);

	EXEC tSQLt.FakeTable 'Booking.Reservations';

	INSERT INTO Booking.Reservations ([ReservationId],[CustomerId],[HotelId])
							  VALUES (100, 21, 100);

	SELECT HotelId, HotelName, HotelState, ReservationCount
	INTO #actual 
	FROM Reports.HotelReservationCount;

	SELECT TOP (0) A.* INTO #expected FROM #actual A RIGHT JOIN #actual X ON 1=0;
	
	INSERT INTO #expected(HotelId, HotelName, HotelState, ReservationCount)
				   VALUES(100, 'Hilton', 'CA', 1)

	EXEC tsqlt.assertequalstable #expected, #actual; 
END
GO

CREATE PROCEDURE Reports_HotelReservationCount_Tests.[test return empty table when no ] 
AS
BEGIN
	SELECT HotelId, HotelName, HotelState, ReservationCount
	INTO #actual 
	FROM Reports.HotelReservationCount;

	EXEC tsqlt.assertemptytable #actual; 
END;
GO

CREATE PROCEDURE Reports_HotelReservationCount_Tests.[test 1 Hotel and multiple reservations] 
AS
BEGIN
	EXEC tSQLt.FakeTable 'Vendors.Hotels';
	
	INSERT INTO Vendors.Hotels ([HotelId],[Name],[HotelState],[CostPerNight])
						 VALUES(100, 'Hilton', 'CA', 200);

	EXEC tSQLt.FakeTable 'Booking.Reservations';

	INSERT INTO Booking.Reservations ([ReservationId],[CustomerId],[HotelId])
							  VALUES (100, 21, 100),
									 (129, 23, 100),
									 (130, 26, 100);

	SELECT HotelId, HotelName, HotelState, ReservationCount
	INTO #actual 
	FROM Reports.HotelReservationCount;

	SELECT TOP (0) A.* INTO #expected FROM #actual A RIGHT JOIN #actual X ON 1=0;
	
	INSERT INTO #expected(HotelId, HotelName, HotelState, ReservationCount)
				   VALUES(100, 'Hilton', 'CA', 3)

	EXEC tsqlt.assertequalstable #expected, #actual; 
END
GO



