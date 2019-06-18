CREATE PROCEDURE [dbo].[GET_ORDER_ENTRY_ITEMS]
@ORDER_ID bigint  = NULL,
@IsActive bit = NULL,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT
AS
BEGIN
	 
	SET NOCOUNT ON;

SELECT [ID]
      ,[ORDER_ID]
      ,[ITEM_ID]
      ,[QUANTITY]
      ,[PBO_PRICE]
      ,[PRODUCT_SVP]     
      ,[IsActive]    
  FROM [ORDER_ENTRY_ITEMS]
  WHERE [Company_ID] = @Company_ID
  AND [Branch_ID] = @Branch_ID 
  AND [IsActive] = @IsActive 
  AND [ORDER_ID] = @ORDER_ID

     
END