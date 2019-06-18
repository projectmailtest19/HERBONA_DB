 CREATE PROCEDURE [dbo].[GET_SHIPPING_METHOD]
@ID bigint  = NULL,
@IsActive bit = NULL,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT=NULL
AS
BEGIN
	 
	SET NOCOUNT ON;

	SELECT [ID]
      ,[NAME]
      ,[CODE]
      
      ,[IsActive]
  FROM [SHIPPING_METHOD]
  WHERE [Company_ID] = @Company_ID
  AND [Branch_ID] = @Branch_ID 
  AND (@IsActive IS NULL OR [IsActive] = @IsActive)
     
END