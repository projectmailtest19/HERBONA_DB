
-- [GET_ITEM_DETAILS_ORDERED] @Company_ID='1',@Branch_ID='2',@ORDER_ID='1'
 CREATE PROCEDURE [dbo].[GET_ITEM_DETAILS_ORDERED] 
@ID bigint  = NULL,
@IsActive bit = 1,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT=null,
@ORDER_ID BIGINT = null
AS
BEGIN
	 
	SET NOCOUNT ON;

	SELECT   ID.[ID]
      ,ID.[CATEGORY_ID]
      ,I.[NAME]
      ,ID.[PBO_PRICE]
      ,ID.[PRODUCT_SVP]
      ,ID.[DISCOUNT_PERCENTAGE]
      ,ID.[DISCOUNT_AMOUNT]
      ,I.[CODE]
      ,ID.[GST_ID]
      ,ID.[MRP]
      ,ID.[SALE_PRICE]
      ,I.[ImageURL]
      ,ID.[IsActive]   
	  ,IC.NAME AS CATEGORY_NAME  
	  ,g.IGST_PERCENTAGE
	  ,g.CGST_PERCENTAGE
	  ,g.SGST_PERCENTAGE
	  ,QUANTITY
	  ,(QUANTITY*ID.[PRODUCT_SVP]) as Total_SVP
	  ,(QUANTITY*ID.[PBO_PRICE]) as Total_Amount
  FROM [ORDER_ENTRY_ITEMS] AS ID 
  INNER JOIN ITEM_CATEGORY AS IC ON ID.CATEGORY_ID = IC.ID
  inner join GST as g on id.GST_ID = g.ID
  inner join [ITEM_DETAILS] as I on I.id = ID.ITEM_ID
  inner join [ORDER_ENTRY] as o on o.id = ID.ORDER_ID
  WHERE ID.[Company_ID] = @Company_ID
  AND ID.[Branch_ID] = @Branch_ID 
  AND (@IsActive IS NULL OR ID.[IsActive] = @IsActive)
  and o.id = @ORDER_ID


  select ORDER_DATE, INVOICE_DATE, INVOICE_NUMBER, TOTAL_SVP, TOTAL_AMOUNT , ORDER_NUMBER from 
  [ORDER_ENTRY] 
  WHERE [Company_ID] = @Company_ID
  AND [Branch_ID] = @Branch_ID 
  AND (@IsActive IS NULL OR [IsActive] = @IsActive)
  and id = @ORDER_ID 

     
END