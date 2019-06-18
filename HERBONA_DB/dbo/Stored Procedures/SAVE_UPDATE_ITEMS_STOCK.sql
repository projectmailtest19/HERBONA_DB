CREATE PROCEDURE   [dbo].[SAVE_UPDATE_ITEMS_STOCK] 
@UDT_ITEMS_STOCK UDT_ITEMS_STOCK readonly, 
@IsActive bit = 1,
@Company_ID bigint,
@Branch_ID bigint,
@Login_user_ID BIGINT	 
AS
BEGIN
	 
	SET NOCOUNT ON;


DECLARE @OUTPUT_TABLE TABLE 
( 
  ID INT 
) 

MERGE [ITEMS_STOCK] AS PS 
using (SELECT 
'' as ID,
ITEM_ID,
QUANTITY, 
@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID
from @UDT_ITEMS_STOCK
) AS UPS
ON ups.ID = PS.ID 
WHEN NOT matched THEN 
 INSERT (  ITEM_ID,
           QUANTITY,
           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID
		   ) 
  VALUES ( UPS.ITEM_ID,
       UPS.QUANTITY, 
       UPS.IsActive, 
       GETUTCDATE(), 
       @Login_user_ID, 
       UPS.Company_ID, 
       UPS.Branch_ID) 
output inserted.id 
INTO @OUTPUT_TABLE; 


select top 1 ID,'0' as CustomErrorState,'sucess' as CustomMessage  
from @OUTPUT_TABLE


   
END