 CREATE PROCEDURE [dbo].[GET_PAYMENT_MODE]
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
  FROM [PAYMENT_MODE]
  WHERE [Company_ID] = @Company_ID
  AND [Branch_ID] = @Branch_ID 
  AND (@IsActive IS NULL OR [IsActive] = @IsActive)
     
END