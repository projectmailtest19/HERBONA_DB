-- [Wallet_Setting_Bonus_Purchase_Select] 1,1,2
create PROCEDURE [dbo].[Wallet_Setting_Bonus_Purchase_Select]
(
   @ID			INT = NULL,
   @Company_ID	bigint  = NULL,
   @Branch_ID	bigint  = NULL
)
AS 
BEGIN
     SELECT 
		* , 
		WALLET_PAYMENT_TYPE_NAME = STUFF(
             (SELECT ',' + name 
              FROM [WALLET_PAYMENT_TYPE] t1 
			  WHERE ID IN (SELECT * FROM [dbo].[fnSplitString]([Wallet_Setting_Bonus_Purchase].WALLET_PAYMENT_TYPE_ID,','))
              FOR XML PATH (''))
             , 1, 1, '')  
	 FROM 
		[Wallet_Setting_Bonus_Purchase] 
	WHERE 
	    ID = ISNULL(@ID,ID) AND Branch_ID=ISNULL(@Branch_ID,Branch_ID) AND Company_ID=ISNULL(@Company_ID,Company_ID) AND IsActive=1
		
END