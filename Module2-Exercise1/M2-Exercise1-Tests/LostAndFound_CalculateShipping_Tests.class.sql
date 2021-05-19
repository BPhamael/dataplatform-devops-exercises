EXEC tSQLt.NewTestClass 'LostAndFound_CalculateShipping_Tests';
GO

CREATE PROCEDURE LostAndFound_CalculateShipping_Tests.[test same state returns 10]
AS
BEGIN
  DECLARE @shippingstate varchar(255) = 'California';
  DECLARE @hotelstate varchar(255) = 'California';
  DECLARE @shippingcost int; 

  SELECT @shippingcost = C.shipping_cost from LostAndFound.CalculateShipping(@hotelstate, @shippingstate) C;

  DECLARE @expected int = 10;
  EXEC tsqlt.assertequals @expected, @actual = @shippingcost;

END
GO