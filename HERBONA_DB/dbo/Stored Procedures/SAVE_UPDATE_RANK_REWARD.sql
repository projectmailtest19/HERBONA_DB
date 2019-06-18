CREATE PROCEDURE  [dbo].[SAVE_UPDATE_RANK_REWARD]
@ID   bigint  = NULL,
@NAME   nvarchar (max) = NULL,
@START   int =  NULL,
@LEFT_SIDE   int = NULL,
@RIGHT_SIDE   int =  NULL,
@REWARDS_DETAIL   nvarchar (max) = NULL,
 
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

MERGE RANK_REWARD AS PS 
using (SELECT 
@ID  AS ID,
@NAME   AS NAME,
@START  AS START,
@LEFT_SIDE AS LEFT_SIDE,
@RIGHT_SIDE AS RIGHT_SIDE,
@REWARDS_DETAIL AS REWARDS_DETAIL,

@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID
) AS UPS
ON ups.ID = PS.ID 
WHEN matched THEN 
  UPDATE SET PS.NAME = ISNULL(UPS.NAME,PS.NAME),
             PS.START = ISNULL(UPS.START,PS.START), 
             PS.LEFT_SIDE = ISNULL(UPS.LEFT_SIDE,PS.LEFT_SIDE), 
			 PS.RIGHT_SIDE = ISNULL(UPS.RIGHT_SIDE,PS.RIGHT_SIDE), 
			 PS.REWARDS_DETAIL = ISNULL(UPS.REWARDS_DETAIL,PS.REWARDS_DETAIL), 

             PS.IsActive = ISNULL(UPS.IsActive,PS.IsActive),
			 PS.UpdatedDate = GETUTCDATE(),
			 ps.UpdatedBy = @login_id
WHEN NOT matched THEN 
  INSERT (  NAME 
      , START 
      , LEFT_SIDE 
      , RIGHT_SIDE 
      , REWARDS_DETAIL ,
           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID
		   ) 
  VALUES ( UPS.NAME 
      ,  UPS.START 
      ,  UPS.LEFT_SIDE 
	  ,  UPS.RIGHT_SIDE
	  ,  UPS.REWARDS_DETAIL,
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