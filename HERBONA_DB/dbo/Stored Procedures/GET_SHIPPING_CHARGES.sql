 CREATE PROCEDURE [dbo].[GET_SHIPPING_CHARGES]
@ID bigint  = NULL,
@IsActive bit = NULL,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT	
AS
BEGIN
	 
	SET NOCOUNT ON;

	SELECT SC.[ID]
      ,SC.[DISTRICT_ID]
      ,SC.[CHARGE_PERCENTAGE]
      ,SC.[CHARGE_AMOUNT]
      ,SC.[IsActive]
	  ,DM.NAME AS DISTRICT_NAME
	  ,country_id
	  ,state_id
  FROM [SHIPPING_CHARGES] AS SC
  INNER JOIN [DISTRICT_MASTER] AS DM
  ON SC.[DISTRICT_ID] = DM.ID
  inner join STATE_MASTER as SM ON DM.STATE_ID = SM.ID
  INNER JOIN COUNTRY_MASTER AS CM ON SM.COUNTRY_ID = CM.ID
  WHERE [Company_ID] = @Company_ID
  AND [Branch_ID] = @Branch_ID 
  AND (@IsActive IS NULL OR [IsActive] = @IsActive)
     
END