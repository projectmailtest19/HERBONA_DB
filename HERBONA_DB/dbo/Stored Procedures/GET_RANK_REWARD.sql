 CREATE PROCEDURE [dbo].[GET_RANK_REWARD]
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
      ,[START]
      ,[LEFT_SIDE]
      ,[RIGHT_SIDE]
      ,[REWARDS_DETAIL]
      ,[IsActive]
  FROM [RANK_REWARD]
  WHERE [Company_ID] = @Company_ID
  AND [Branch_ID] = @Branch_ID 
  AND (@IsActive IS NULL OR [IsActive] = @IsActive)
     
END