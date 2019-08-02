CREATE PROCEDURE  [dbo].[SAVE_UPDATE_WALLET]
@ID   bigint  = NULL,
@MEMBER_ID   bigint = NULL,
 
@IsActive bit = NULL,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT=null	 
AS
BEGIN
	 
	SET NOCOUNT ON;

declare @WALLET_NUMBER   nvarchar (max) = NULL
declare @random varchar(50)

set @random = newid()

select @WALLET_NUMBER = substring(@random,1, 16)


DECLARE @OUTPUT_TABLE TABLE 
( 
  ID INT 
) 

MERGE WALLET AS PS 
using (SELECT 
@ID  AS ID,
@MEMBER_ID AS MEMBER_ID,
@WALLET_NUMBER AS WALLET_NUMBER,
 

@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID
) AS UPS
ON ups.ID = PS.ID 
WHEN matched THEN 
  UPDATE SET PS.MEMBER_ID = ISNULL(UPS.MEMBER_ID,PS.MEMBER_ID), 
  PS.WALLET_NUMBER = ISNULL(UPS.WALLET_NUMBER,PS.WALLET_NUMBER), 

             PS.IsActive = ISNULL(UPS.IsActive,PS.IsActive),
			 PS.UpdatedDate = GETUTCDATE(),
			 ps.UpdatedBy = @login_id
WHEN NOT matched THEN 
  INSERT (    MEMBER_ID 
      , WALLET_NUMBER ,
           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID
		   ) 
  VALUES ( UPS. MEMBER_ID ,
  UPS. WALLET_NUMBER ,
           UPS.IsActive, 
           GETUTCDATE(), 
           @login_id, 
           UPS.Company_ID, 
           UPS.Branch_ID) 
output inserted.id 
INTO @OUTPUT_TABLE; 
 
   
END