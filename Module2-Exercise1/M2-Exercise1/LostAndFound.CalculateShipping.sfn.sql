create function LostAndFound.CalculateShipping(@hotelstate varchar(255), @shippingstate varchar(255))
RETURNS table AS
	RETURN
	SELECT CASE WHEN
	@hotelstate = @shippingstate THEN 10 ELSE 25 END AS shipping_cost;

GO