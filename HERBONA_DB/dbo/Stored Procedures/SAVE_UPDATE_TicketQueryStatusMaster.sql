CREATE PROCEDURE  [dbo].[SAVE_UPDATE_TicketQueryStatusMaster]
@ID   bigint  = NULL,
@NAME   nvarchar (max) = NULL,
 
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

MERGE TicketQueryStatusMaster AS PS 
using (SELECT 
@ID   AS ID,
@NAME  AS NAME,
 

@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID
) AS UPS
ON ups.ID = PS.ID 
WHEN matched THEN 
  UPDATE SET PS.NAME = ISNULL(UPS.NAME,PS.NAME), 

             PS.IsActive = ISNULL(UPS.IsActive,PS.IsActive),
			 PS.UpdatedDate = GETUTCDATE(),
			 ps.UpdatedBy = @login_id
WHEN NOT matched THEN 
  INSERT (   NAME  ,
           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID
		   ) 
  VALUES ( UPS. NAME ,
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