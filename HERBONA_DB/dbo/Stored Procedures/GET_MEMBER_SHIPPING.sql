-- [GET_MEMBER_SHIPPING] 7
CREATE PROCEDURE [dbo].[GET_MEMBER_SHIPPING]
@Order_Details_id bigint 
AS
BEGIN
	 
	SET NOCOUNT ON;

	select 
	   --[CHARGE_PERCENTAGE]
    --  ,[CHARGE_AMOUNT],
	  TOTAL_AMOUNT as SALES_AMOUNT,
	  isnull(CHARGE_AMOUNT,0) as SHIPPING,
	  (TOTAL_AMOUNT + isnull(CHARGE_AMOUNT,0)) as NET_AMOUNT  from [dbo].[Order_Details] as o
    left join [ADDRESS] as a
    on o.Address_ID = a.id
    left join [SHIPPING_CHARGES] as s
    on a.district_id = s.[DISTRICT_ID]
    left join ORDER_ENTRY as oe
    on oe.id = o.Order_ID
    where o.id = @Order_Details_id
 

END