 CREATE PROCEDURE [dbo].[GET_ITEMS_STOCK]
@ID bigint  = NULL,
@IsActive bit = 1,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT	
AS
BEGIN
	 
	SET NOCOUNT ON;

	SELECT   ID.[ID]
      ,ID.[CATEGORY_ID]
      ,ID.[NAME]
      ,ID.[PBO_PRICE]
      ,ID.[PRODUCT_SVP]
      ,ID.[DISCOUNT_PERCENTAGE]
      ,ID.[DISCOUNT_AMOUNT]
      ,ID.[CODE]
      ,ID.[GST_ID]
      ,ID.[MRP]
      ,ID.[SALE_PRICE]
      ,ID.[ImageURL]
      ,ID.[IsActive]   
	  ,IC.NAME AS CATEGORY_NAME  
	  ,g.IGST_PERCENTAGE
	  ,g.CGST_PERCENTAGE
	  ,g.SGST_PERCENTAGE
	  ,isnull(s.QUANTITY,0) as [QUANTITY]
  FROM [ITEM_DETAILS] AS ID 
  INNER JOIN ITEM_CATEGORY AS IC ON ID.CATEGORY_ID = IC.ID
  inner join GST as g on id.GST_ID = g.ID
  left join 
  (
  SELECT  [ITEM_ID]
      ,sum([QUANTITY]) as [QUANTITY]      
  FROM [ITEMS_STOCK]
  WHERE [Company_ID] = @Company_ID
  AND [Branch_ID] = @Branch_ID 
  AND [IsActive] = @IsActive
  group by [ITEM_ID]
  ) as s on id.ID = s.ITEM_ID
  WHERE ID.[Company_ID] = @Company_ID
  AND ID.[Branch_ID] = @Branch_ID 
  AND ID.[IsActive] = @IsActive

	
     
END