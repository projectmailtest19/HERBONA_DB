 CREATE PROCEDURE [dbo].[GET_WALLET]
@ID bigint  = NULL,
@IsActive bit = NULL,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT	
AS
BEGIN
	 
	SET NOCOUNT ON;

	SELECT  w.[ID]
      ,w.[MEMBER_ID]
      ,w.[WALLET_NUMBER]
      ,w.[IsActive]
	  ,c.Name as MEMBER_NAME
  FROM [WALLET] as w 
  inner join CONTACT as c on w.MEMBER_ID = c.id
  WHERE w.[Company_ID] = @Company_ID
  AND w.[Branch_ID] = @Branch_ID 
  AND (@IsActive IS NULL OR w.[IsActive] = @IsActive)
     
END