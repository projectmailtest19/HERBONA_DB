 CREATE PROCEDURE [dbo].[GET_VACATION_TOUR]
@ID bigint  = NULL,
@IsActive bit = NULL,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT	
AS
BEGIN
	 
	SET NOCOUNT ON;

	SELECT [ID]
      ,[TOUR_NAME]
      ,[LEFT_POINT]
      ,[LEFT_POINT_DETAIL]
      ,[RIGHT_POINT]
      ,[RIGHT_POINT_DETAIL]
      ,[IsActive]
  FROM [VACATION_TOUR]
  WHERE [Company_ID] = @Company_ID
  AND [Branch_ID] = @Branch_ID 
  AND (@IsActive is null or [IsActive] = @IsActive)
     
END