CREATE PROCEDURE [dbo].[SAVE_UPDATE_ORDER_ENTRY]
@ID  bigint = NULL,
@MEMEBER_ID  bigint = NULL,
@TOTAL_SVP  decimal(18, 2) = NULL,
@TOTAL_AMOUNT  decimal(18, 2) = NULL,
@ORDER_TYPE  nvarchar(50) = NULL, -- PURCHASE/REPURCHASE

@ITEM_IDS UDT_ORDER_ENTRY_ITEMS READONLY,

@IsActive bit = NULL,
@Company_ID bigint,
@Branch_ID bigint,
@Login_user_ID BIGINT	 
AS
BEGIN
	 
	SET NOCOUNT ON;

declare @ORDER_DATE  datetime = NULL,
        @ORDER_NUMBER nvarchar(max)

set @ORDER_DATE = getutcdate()
set @ORDER_NUMBER = 'ORD'+convert(varchar,CAST(round(RAND()*1000000000000000,0) AS bigint))

DECLARE @_ORDER_ID BIGINT

DECLARE @OUTPUT_TABLE TABLE 
( 
  ID INT 
) 

MERGE ORDER_ENTRY AS PS 
using (SELECT 
@ID  AS ID,
@MEMEBER_ID  AS MEMEBER_ID,
@ORDER_DATE  AS ORDER_DATE,
@TOTAL_SVP  AS TOTAL_SVP,
@TOTAL_AMOUNT AS TOTAL_AMOUNT,
@ORDER_TYPE AS ORDER_TYPE,

@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID
) AS UPS
ON ups.ID = PS.ID 
WHEN matched THEN 
  UPDATE SET PS.MEMEBER_ID = ISNULL(UPS.MEMEBER_ID,PS.MEMEBER_ID), 
             PS.ORDER_DATE = ISNULL(UPS.ORDER_DATE,PS.ORDER_DATE), 
			 PS.TOTAL_SVP = ISNULL(UPS.TOTAL_SVP,PS.TOTAL_SVP), 
			 PS.TOTAL_AMOUNT = ISNULL(UPS.TOTAL_AMOUNT,PS.TOTAL_AMOUNT), 
			 PS.ORDER_TYPE = ISNULL(UPS.ORDER_TYPE,PS.ORDER_TYPE), 
             PS.IsActive = UPS.IsActive,
			 PS.UpdatedDate = GETUTCDATE(),
			 ps.UpdatedBy = @Login_user_ID
WHEN NOT matched THEN 
  INSERT (  MEMEBER_ID 
      , ORDER_DATE 
      , TOTAL_SVP 
      , TOTAL_AMOUNT 
      , ORDER_TYPE, 	      
           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID,
		   ORDER_NUMBER
		   ) 
  VALUES ( UPS.MEMEBER_ID 
      , UPS.ORDER_DATE 
      , UPS.TOTAL_SVP 
      , UPS.TOTAL_AMOUNT 
      , UPS.ORDER_TYPE,    
       UPS.IsActive, 
       GETUTCDATE(), 
       @Login_user_ID, 
       UPS.Company_ID, 
       UPS.Branch_ID,
	   @ORDER_NUMBER) 
output inserted.id 
INTO @OUTPUT_TABLE; 


select @_ORDER_ID = ID 
from @OUTPUT_TABLE


IF(@ID IS NOT NULL)
BEGIN

 UPDATE ORDER_ENTRY_ITEMS SET IsActive = '0'
 WHERE ORDER_ID = @_ORDER_ID


END




MERGE ORDER_ENTRY_ITEMS AS PS 
using (SELECT 
@_ORDER_ID AS [ORDER_ID]
      ,I.ID AS [ITEM_ID]
      ,I.[QUANTITY]
	  ,IDS.[CATEGORY_ID]     
      ,IDS.[PBO_PRICE]
      ,IDS.[PRODUCT_SVP]
      ,IDS.[DISCOUNT_PERCENTAGE]
      ,IDS.[DISCOUNT_AMOUNT]      
      ,IDS.[GST_ID]
      ,IDS.[MRP]
      ,IDS.[SALE_PRICE],

@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID

FROM @ITEM_IDS AS I
INNER JOIN ITEM_DETAILS AS IDS ON I.ID = IDS.ID
) AS UPS
ON ups.[ORDER_ID] = PS.[ORDER_ID] 
WHEN NOT matched THEN 
  INSERT (  [ORDER_ID]
      ,[ITEM_ID]
      ,[QUANTITY]
      ,[CATEGORY_ID]     
      ,[PBO_PRICE]
      ,[PRODUCT_SVP]
      ,[DISCOUNT_PERCENTAGE]
      ,[DISCOUNT_AMOUNT]      
      ,[GST_ID]
      ,[MRP]
      ,[SALE_PRICE],

           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID
		   ) 
  VALUES ( UPS.[ORDER_ID]
      ,UPS.[ITEM_ID]
      ,UPS.[QUANTITY]
      ,UPS.[CATEGORY_ID]     
      ,UPS.[PBO_PRICE]
      ,UPS.[PRODUCT_SVP]
      ,UPS.[DISCOUNT_PERCENTAGE]
      ,UPS.[DISCOUNT_AMOUNT]      
      ,UPS.[GST_ID]
      ,UPS.[MRP]
      ,UPS.[SALE_PRICE], 
   
       UPS.IsActive, 
       GETUTCDATE(), 
       @Login_user_ID, 
       UPS.Company_ID, 
       UPS.Branch_ID); 


select ID,'0' as CustomErrorState,'sucess' as CustomMessage  
from @OUTPUT_TABLE


   
END