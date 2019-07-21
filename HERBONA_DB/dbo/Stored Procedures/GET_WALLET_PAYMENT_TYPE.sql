 CREATE PROCEDURE [dbo].[GET_WALLET_PAYMENT_TYPE]
@ID bigint  = NULL,
@IsActive bit = NULL,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT	
AS
BEGIN
	 
	SET NOCOUNT ON;

	SELECT [ID]
      ,[NAME]
      ,[IsActive]
  FROM [WALLET_PAYMENT_TYPE]
  WHERE [Company_ID] = @Company_ID
  AND [Branch_ID] = @Branch_ID 
  AND (@IsActive IS NULL OR [IsActive] = @IsActive)
     
END