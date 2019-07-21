CREATE PROCEDURE  dbo.SAVE_UPDATE_WALLET_BALANCE_HISTORY
@ID   bigint  = NULL,
@DATE   datetime = NULL,
@AMOUNT   decimal (18, 2) = NULL,
@STATUS_CR_DR   nvarchar (10) = NULL,
@DETAILS   nvarchar (max) = NULL,
 
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

MERGE WALLET_BALANCE_HISTORY AS PS 
using (SELECT 
@ID AS ID,
@DATE AS DATE,
@AMOUNT  AS AMOUNT,
@STATUS_CR_DR  AS STATUS_CR_DR,
@DETAILS  AS DETAILS,
 

@IsActive AS IsActive,
@Company_ID AS Company_ID,
@Branch_ID AS Branch_ID
) AS UPS
ON ups.ID = PS.ID 
WHEN matched THEN 
  UPDATE SET PS.DATE = ISNULL(UPS.DATE,PS.DATE), 
  PS.AMOUNT = ISNULL(UPS.AMOUNT,PS.AMOUNT), 
   PS.STATUS_CR_DR = ISNULL(UPS.STATUS_CR_DR,PS.STATUS_CR_DR), 
    PS.DETAILS = ISNULL(UPS.DETAILS,PS.DETAILS), 

             PS.IsActive = ISNULL(UPS.IsActive,PS.IsActive),
			 PS.UpdatedDate = GETUTCDATE(),
			 ps.UpdatedBy = @login_id
WHEN NOT matched THEN 
  INSERT (   DATE 
      , AMOUNT 
      , STATUS_CR_DR 
      , DETAILS ,
           IsActive,
		   CreatedDate,
		   CreatedBy,
		   Company_ID,
		   Branch_ID
		   ) 
  VALUES ( UPS. DATE 
      ,UPS. AMOUNT 
      ,UPS. STATUS_CR_DR 
      ,UPS. DETAILS ,
           UPS.IsActive, 
           GETUTCDATE(), 
           @login_id, 
           UPS.Company_ID, 
           UPS.Branch_ID) 
output inserted.id 
INTO @OUTPUT_TABLE; 


select ID 
from @OUTPUT_TABLE

   
END