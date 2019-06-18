CREATE PROCEDURE [dbo].[SAVE_UPDATE_ITEM_CATEGORY]
@ID bigint  = NULL,
@NAME nvarchar (255) = NULL,
@CODE nvarchar (50) = NULL,
@ImageURL nvarchar (max) = NULL,

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

MERGE ITEM_CATEGORY AS PS 
using (SELECT 
@ID AS ID,
@NAME AS NAME,
@CODE AS CODE,
@ImageURL AS ImageURL,
@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID
) AS UPS
ON ups.ID = PS.ID 
WHEN matched THEN 
  UPDATE SET PS.NAME = ISNULL(UPS.NAME,PS.NAME),
             PS.CODE = ISNULL(UPS.CODE,PS.CODE), 
             PS.ImageURL = ISNULL(UPS.ImageURL,PS.ImageURL), 
             PS.IsActive = ISNULL(UPS.IsActive,PS.IsActive),
			 PS.UpdatedDate = GETUTCDATE(),
			 ps.UpdatedBy = @login_id
WHEN NOT matched THEN 
  INSERT ( NAME, 
           CODE, 
           ImageURL, 
           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID
		   ) 
  VALUES ( UPS.NAME ,
           UPS.CODE, 
           UPS.ImageURL, 
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