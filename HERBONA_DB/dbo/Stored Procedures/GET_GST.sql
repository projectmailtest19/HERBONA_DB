 CREATE PROCEDURE [dbo].[GET_GST]
@ID bigint  = NULL,
@IsActive bit = NULL,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT = null	
AS
BEGIN
	 
	SET NOCOUNT ON;

	SELECT [ID]
      ,[CGST_PERCENTAGE]
      ,[SGST_PERCENTAGE]
      ,[IGST_PERCENTAGE]
      ,[IsActive]
  FROM [GST]
  WHERE [Company_ID] = @Company_ID
  AND [Branch_ID] = @Branch_ID 
  AND (@IsActive is null or [IsActive] = @IsActive)
     
END