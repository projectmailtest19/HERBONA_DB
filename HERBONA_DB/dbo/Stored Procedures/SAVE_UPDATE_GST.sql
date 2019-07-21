CREATE PROCEDURE  [dbo].[SAVE_UPDATE_GST] 
@ID   bigint  = NULL,
@CGST_PERCENTAGE   decimal (18, 2) = NULL,
@SGST_PERCENTAGE   decimal (18, 2) = NULL,
@IGST_PERCENTAGE   decimal (18, 2) = NULL,

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

MERGE GST AS PS 
using (SELECT 
@ID   AS ID,
@CGST_PERCENTAGE  AS CGST_PERCENTAGE,
@SGST_PERCENTAGE  AS SGST_PERCENTAGE,
@IGST_PERCENTAGE  AS IGST_PERCENTAGE,
@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID
) AS UPS
ON ups.ID = PS.ID 
WHEN matched THEN 
  UPDATE SET PS.CGST_PERCENTAGE = ISNULL(UPS.CGST_PERCENTAGE,PS.CGST_PERCENTAGE),
             PS.SGST_PERCENTAGE = ISNULL(UPS.SGST_PERCENTAGE,PS.SGST_PERCENTAGE), 
             PS.IGST_PERCENTAGE = ISNULL(UPS.IGST_PERCENTAGE,PS.IGST_PERCENTAGE), 
             PS.IsActive = ISNULL(UPS.IsActive,PS.IsActive),
			 PS.UpdatedDate = GETUTCDATE(),
			 ps.UpdatedBy = @login_id
WHEN NOT matched THEN 
  INSERT (  CGST_PERCENTAGE 
      , SGST_PERCENTAGE 
      , IGST_PERCENTAGE  ,
           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID
		   ) 
  VALUES ( UPS.CGST_PERCENTAGE 
      ,  UPS.SGST_PERCENTAGE 
      ,  UPS.IGST_PERCENTAGE , 
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