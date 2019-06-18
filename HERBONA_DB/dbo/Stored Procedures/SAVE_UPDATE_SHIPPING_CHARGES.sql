CREATE PROCEDURE  [dbo].[SAVE_UPDATE_SHIPPING_CHARGES]
@ID   bigint  = NULL,
@DISTRICT_ID   bigint = NULL,
@CHARGE_PERCENTAGE   decimal (25, 13) = NULL,
@CHARGE_AMOUNT   decimal (25, 13) = NULL,
 
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

MERGE SHIPPING_CHARGES AS PS 
using (SELECT 
@ID   AS ID,
@DISTRICT_ID  AS DISTRICT_ID,
@CHARGE_PERCENTAGE   AS CHARGE_PERCENTAGE,
@CHARGE_AMOUNT   AS CHARGE_AMOUNT,

@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID
) AS UPS
ON ups.ID = PS.ID 
WHEN matched THEN 
  UPDATE SET PS.DISTRICT_ID = ISNULL(UPS.DISTRICT_ID,PS.DISTRICT_ID),
             PS.CHARGE_PERCENTAGE = ISNULL(UPS.CHARGE_PERCENTAGE,PS.CHARGE_PERCENTAGE), 
             PS.CHARGE_AMOUNT = ISNULL(UPS.CHARGE_AMOUNT,PS.CHARGE_AMOUNT),

             PS.IsActive = ISNULL(UPS.IsActive,PS.IsActive),
			 PS.UpdatedDate = GETUTCDATE(),
			 ps.UpdatedBy = @login_id
WHEN NOT matched THEN 
  INSERT (  [DISTRICT_ID]
      ,[CHARGE_PERCENTAGE]
      ,[CHARGE_AMOUNT],
           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID
		   ) 
  VALUES ( UPS.[DISTRICT_ID]
      ,UPS.[CHARGE_PERCENTAGE]
      ,UPS.[CHARGE_AMOUNT],
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