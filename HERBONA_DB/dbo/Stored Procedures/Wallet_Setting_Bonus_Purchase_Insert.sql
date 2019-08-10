create PROCEDURE [dbo].[Wallet_Setting_Bonus_Purchase_Insert]
(
   @ID			INT = NULL,
   @Name        NVARCHAR(256) = NUll,
   @WALLET_PAYMENT_TYPE_ID        NVARCHAR(1024) = NUll,
   @Company_ID	bigint  = NULL,
   @Branch_ID	bigint  = NULL
)
AS 
BEGIN
 BEGIN TRY 
     IF(@ID IS NULL)
	 BEGIN
		 INSERT INTO Wallet_Setting_Bonus_Purchase
		 (name,WALLET_PAYMENT_TYPE_ID,	IsActive	,CreatedDate,	CreatedBy,Company_ID,	Branch_ID)
		 VALUES
		 (@Name, @WALLET_PAYMENT_TYPE_ID,	1,	GETDATE(),	NULL,@Company_ID,	@Branch_ID)
    END
	ELSE
	BEGIN
	   UPDATE Wallet_Setting_Bonus_Purchase 
	     SET 
		 name  = @Name,
		 WALLET_PAYMENT_TYPE_ID = @WALLET_PAYMENT_TYPE_ID,
		 UpdatedDate = GETDATE()
	  WHERE ID=@ID AND [Company_ID] = @Company_ID AND  [Branch_ID] = @Branch_ID
	END
    SELECT 'Sucess' AS SQL_Message, 0 AS ERROR
  END TRY
  BEGIN CATCH 
    SELECT ERROR_MESSAGE() AS SQL_Message, 1 AS ERROR
  END CATCH		
END