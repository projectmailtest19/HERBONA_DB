CREATE PROCEDURE [dbo].[GET_ORDER_ENTRY]
@ID bigint  = NULL,
@IsActive bit = 1,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT,
@MEMEBER_ID BIGINT = NULL,
@ORDER_NUMBER nvarchar(max) = null,	
@FROM_ORDER_DATE DATE = NULL,
@TO_ORDER_DATE DATE = NULL
AS
BEGIN
	 
	SET NOCOUNT ON;

SELECT oe.[ID]
      ,oe.[MEMEBER_ID]
	  ,oe.ORDER_NUMBER
      ,oe.[ORDER_DATE]
      ,oe.[INVOICE_DATE]
      ,oe.[INVOICE_NUMBER]
      ,oe.[TOTAL_SVP]
      ,oe.[TOTAL_AMOUNT]
      ,oe.[ORDER_TYPE]      
      ,oe.[IsActive]    
	  ,c.Name as [MEMEBER_NAME]
  FROM [ORDER_ENTRY] as oe
  inner join CONTACT as c 
  on c.id = oe.[MEMEBER_ID]
  WHERE oe.[Company_ID] = @Company_ID
  AND oe.[Branch_ID] = @Branch_ID 
  AND oe.[IsActive] = @IsActive
  AND (@MEMEBER_ID is null or oe.MEMEBER_ID = @MEMEBER_ID)
  AND (@ORDER_NUMBER IS NULL OR oe.ORDER_NUMBER = @ORDER_NUMBER)
  AND (@FROM_ORDER_DATE IS NULL OR convert(date,oe.[ORDER_DATE]) >= @FROM_ORDER_DATE)
  AND (@TO_ORDER_DATE IS NULL OR convert(date,oe.[ORDER_DATE]) <= @TO_ORDER_DATE)


     
END