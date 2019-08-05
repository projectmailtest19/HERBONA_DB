CREATE PROCEDURE  [dbo].[SAVE_UPDATE_Session]
@ID   bigint  = NULL,
@Session_Name   nvarchar (max) = NULL,
@from_date DATE,
@to_date DATE,
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

MERGE Session AS PS 
using (SELECT 
@ID   AS ID,
@Session_Name  AS Session_Name,
@from_date AS from_date,
@to_date AS to_date,

@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID
) AS UPS
ON ups.ID = PS.ID 
WHEN matched THEN 
  UPDATE SET PS.Session_Name = ISNULL(UPS.Session_Name,PS.Session_Name), 
             PS.from_date = ISNULL(UPS.from_date,PS.from_date), 
             PS.to_date = ISNULL(UPS.to_date,PS.to_date), 

             PS.IsActive = ISNULL(UPS.IsActive,PS.IsActive),
			 PS.UpdatedDate = GETUTCDATE(),
			 ps.UpdatedBy = @login_id
WHEN NOT matched THEN 
  INSERT ( Session_Name,
           from_date,
		   to_date,
           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID
		   ) 
  VALUES ( UPS. Session_Name,
           ups.from_date,
		   UPS.to_date,
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