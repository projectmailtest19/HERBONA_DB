 CREATE PROCEDURE [dbo].[GET_ITEM_CATEGORY]
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
      ,[CODE]
      ,[ImageURL]
      ,[IsActive]
  FROM [ITEM_CATEGORY]
  WHERE [Company_ID] = @Company_ID
  AND [Branch_ID] = @Branch_ID 
  AND (@IsActive IS NULL OR [IsActive] = @IsActive)
     
END