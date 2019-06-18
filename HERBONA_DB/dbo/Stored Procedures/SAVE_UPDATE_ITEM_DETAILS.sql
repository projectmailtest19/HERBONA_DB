CREATE PROCEDURE [dbo].[SAVE_UPDATE_ITEM_DETAILS]
@ID bigint = NULL,
@CATEGORY_ID bigint = NULL,
@NAME nvarchar(255) = NULL,
@PBO_PRICE decimal(25, 13) = NULL,
@PRODUCT_SVP decimal(25, 13) = NULL,
@DISCOUNT_PERCENTAGE decimal(25, 13) = NULL,
@DISCOUNT_AMOUNT decimal(25, 13) = NULL,
@CODE nvarchar(50) = NULL,
@GST_ID bigint = NULL,
@MRP decimal(25, 13) = NULL,
@SALE_PRICE decimal(25, 13) = NULL,
@ImageURL nvarchar(max) = NULL,

@IsActive bit = NULL,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT	 
AS
BEGIN
	 
	SET NOCOUNT ON;


DECLARE @OUTPUT_TABLE TABLE 
( 
  ID INT 
) 

MERGE ITEM_DETAILS AS PS 
using (SELECT 
@ID AS ID,
@CATEGORY_ID AS CATEGORY_ID,
@NAME AS NAME,
@PBO_PRICE AS PBO_PRICE,
@PRODUCT_SVP AS PRODUCT_SVP,
@DISCOUNT_PERCENTAGE AS DISCOUNT_PERCENTAGE,
@DISCOUNT_AMOUNT AS DISCOUNT_AMOUNT,
@CODE AS CODE,
@GST_ID AS GST_ID,
@MRP AS MRP,
@SALE_PRICE AS SALE_PRICE,
@ImageURL AS ImageURL,

@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID
) AS UPS
ON ups.ID = PS.ID 
WHEN matched THEN 
  UPDATE SET PS.CATEGORY_ID = ISNULL(UPS.CATEGORY_ID,PS.CATEGORY_ID), 
             PS.NAME = ISNULL(UPS.NAME,PS.NAME), 
             PS.PBO_PRICE = ISNULL(UPS.PBO_PRICE,PS.PBO_PRICE), 
			 PS.PRODUCT_SVP = ISNULL(UPS.PRODUCT_SVP,PS.PRODUCT_SVP), 
			 PS.DISCOUNT_PERCENTAGE = ISNULL(UPS.DISCOUNT_PERCENTAGE,PS.DISCOUNT_PERCENTAGE), 
			 PS.DISCOUNT_AMOUNT = ISNULL(UPS.DISCOUNT_AMOUNT,PS.DISCOUNT_AMOUNT), 
			 PS.CODE = ISNULL(UPS.CODE,PS.CODE), 
			 PS.GST_ID = ISNULL(UPS.GST_ID,PS.GST_ID), 
			 PS.MRP = ISNULL(UPS.MRP,PS.MRP), 
			 PS.SALE_PRICE = ISNULL(UPS.SALE_PRICE,PS.SALE_PRICE), 
			 PS.ImageURL = ISNULL(UPS.ImageURL,PS.ImageURL), 

             PS.IsActive = UPS.IsActive,
			 PS.UpdatedDate = GETUTCDATE(),
			 ps.UpdatedBy = @login_id
WHEN NOT matched THEN 
  INSERT ( CATEGORY_ID
          ,NAME
          ,PBO_PRICE
          ,PRODUCT_SVP
          ,DISCOUNT_PERCENTAGE
          ,DISCOUNT_AMOUNT
          ,CODE
          ,GST_ID
          ,MRP
          ,SALE_PRICE
          ,ImageURL,
           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID
		   ) 
  VALUES ( UPS.CATEGORY_ID
      ,UPS.NAME
      ,UPS.PBO_PRICE
      ,UPS.PRODUCT_SVP
      ,UPS.DISCOUNT_PERCENTAGE
      ,UPS.DISCOUNT_AMOUNT
      ,UPS.CODE
      ,UPS.GST_ID
      ,UPS.MRP
      ,UPS.SALE_PRICE
      ,UPS.ImageURL,
       UPS.IsActive, 
       GETUTCDATE(), 
       @login_id, 
       UPS.Company_ID, 
       UPS.Branch_ID) 
output inserted.id 
INTO @OUTPUT_TABLE; 


select ID,'0' as CustomErrorState,'sucess' as CustomMessage  
from @OUTPUT_TABLE


   
END