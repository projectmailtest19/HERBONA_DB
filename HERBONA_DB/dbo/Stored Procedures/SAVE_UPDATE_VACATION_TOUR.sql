CREATE PROCEDURE  [dbo].[SAVE_UPDATE_VACATION_TOUR]
@ID   bigint = NULL,
@TOUR_NAME   nvarchar (max) = NULL,
@LEFT_POINT   int  = NULL,
@LEFT_POINT_DETAIL   nvarchar (max) = NULL,
@RIGHT_POINT   int =  NULL,
@RIGHT_POINT_DETAIL   nvarchar (max) = NULL,
 
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

MERGE [VACATION_TOUR] AS PS 
using (SELECT 
@ID  AS ID,
@TOUR_NAME  AS TOUR_NAME,
@LEFT_POINT   AS LEFT_POINT,
@LEFT_POINT_DETAIL  AS LEFT_POINT_DETAIL,
@RIGHT_POINT  AS RIGHT_POINT,
@RIGHT_POINT_DETAIL AS RIGHT_POINT_DETAIL,
@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID
) AS UPS
ON ups.ID = PS.ID 
WHEN matched THEN 
  UPDATE SET PS.TOUR_NAME = ISNULL(UPS.TOUR_NAME,PS.TOUR_NAME),
             PS.LEFT_POINT = ISNULL(UPS.LEFT_POINT,PS.LEFT_POINT), 
             PS.LEFT_POINT_DETAIL = ISNULL(UPS.LEFT_POINT_DETAIL,PS.LEFT_POINT_DETAIL), 
			 PS.RIGHT_POINT = ISNULL(UPS.RIGHT_POINT,PS.RIGHT_POINT), 
			 PS.RIGHT_POINT_DETAIL = ISNULL(UPS.RIGHT_POINT_DETAIL,PS.RIGHT_POINT_DETAIL), 

             PS.IsActive = ISNULL(UPS.IsActive,PS.IsActive),
			 PS.UpdatedDate = GETUTCDATE(),
			 ps.UpdatedBy = @login_id
WHEN NOT matched THEN 
  INSERT (    TOUR_NAME 
      , LEFT_POINT 
      , LEFT_POINT_DETAIL 
      , RIGHT_POINT 
      , RIGHT_POINT_DETAIL ,
           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID
		   ) 
  VALUES ( UPS.TOUR_NAME 
      ,  UPS.LEFT_POINT 
      ,  UPS.LEFT_POINT_DETAIL 
	  ,  UPS.RIGHT_POINT
	  ,  UPS.RIGHT_POINT_DETAIL,
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