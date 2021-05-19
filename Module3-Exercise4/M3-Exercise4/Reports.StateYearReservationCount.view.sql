CREATE VIEW Reports.StateYearReservationCount AS 
SELECT 
	YEAR(r.ReservationDate) AS ReservationYear, 
	h.HotelState AS ReservationState, 
	COUNT(r.ReservationId) AS ReservationCount
FROM Vendors.Hotels h
JOIN Booking.Reservations r
	ON r.HotelId = h.HotelId
GROUP BY YEAR(r.ReservationDate), h.HotelState