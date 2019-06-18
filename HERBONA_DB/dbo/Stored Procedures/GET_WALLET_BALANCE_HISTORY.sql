 CREATE PROCEDURE [dbo].[GET_WALLET_BALANCE_HISTORY]
@ID bigint  = NULL,
@IsActive bit = NULL,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT	
AS
BEGIN
	 
	SET NOCOUNT ON;

	SELECT  [ID]
      ,[DATE]
      ,[AMOUNT]
      ,[STATUS_CR_DR]
      ,[DETAILS]
      ,[IsActive]
  FROM [WALLET_BALANCE_HISTORY]
  WHERE [Company_ID] = @Company_ID
  AND [Branch_ID] = @Branch_ID 
  AND [IsActive] = @IsActive
     
END