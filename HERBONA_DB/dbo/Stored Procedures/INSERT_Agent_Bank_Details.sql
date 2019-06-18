CREATE procedure [dbo].[INSERT_Agent_Bank_Details]
@Contact_id		int=null,
@Account_Holder_Name	        nvarchar(max)=null, 
@Account_Number		    nvarchar(max) = null, 
@Bank_Name		nvarchar(max) = null, 
@Account_Type			nvarchar(max)=null,
@IFSC_Code       nvarchar(max)=null,
@Branch_Name	nvarchar(max)=null, 
@Pan_No	nvarchar(max)=null, 
@MODE			varchar(10)=null,
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@Login_user_ID  int=null
AS
BEGIN
	SET NOCOUNT ON;

	 BEGIN try 
          BEGIN TRANSACTION 

IF( @MODE = 'INSERT' ) 
  BEGIN 

      ------------------------------ Contact table insert------------------------------------   
      INSERT INTO Agent_Bank_Details 
                  ([Contact_id]
      ,[Account_Holder_Name]
      ,[Account_Number]
      ,[Bank_Name]
      ,[Account_Type]
      ,[IFSC_Code]
      ,[Branch_Name]
      ,[Pan_No]
      ,[IsActive]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[Company_ID]
      ,[Branch_ID]) 
      VALUES      (@Contact_id, 
                   @Account_Holder_Name, 
                   @Account_Number, 
				   @Bank_Name,
                   @Account_Type, 
                   @IFSC_Code, 
                   @Branch_Name, 
				   @Pan_No,
                   1, 
                   Getdate(), 
                   @Login_user_ID, 
                   @Company_ID, 
                   @Branch_ID) 

      -------------------------------End Contact table insert------------------------------------   
    
      SELECT @@IDENTITY                      AS ID, 
             'Agent Bank Details Successfully Inserted' AS CustomMessage, 
             '0'                             AS CustomErrorState 

  ---------------------------------End Success message for insert-------------------------------------------------- 
  END 

IF(@MODE = 'UPDATE' ) 
  BEGIN 

      ------------------------------ Contact table update------------------------------------   
      UPDATE Agent_Bank_Details 
      SET    [Account_Holder_Name] = @Account_Holder_Name, 
             [Account_Number] = @Account_Number, 
             [Bank_Name] = @Account_Type,
			 [Account_Type] =@Account_Type,
			  [IFSC_Code] =@IFSC_Code,
			   [Branch_Name] =@Branch_Name,
			    [Pan_No] =@Pan_No,
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  [Contact_id] = @Contact_ID 

   
      ---------------------------------Success message for update-------------------------------------------------- 
      SELECT id                            AS ID, 
             'Agent Bank Details Successfully Updated' AS CustomMessage, 
             '0'                            AS CustomErrorState from Agent_Bank_Details where [Contact_id] = @Contact_ID 
  ---------------------------------End Success message for update-------------------------------------------------- 
  END 

	Last_row:

          COMMIT 
      END try 

      BEGIN catch 
          IF @@TRANCOUNT > 0 
            DECLARE @sql NVARCHAR(max) 
---------------------------------Error Message--------------------------------------------------
          SET @sql = 'ErrorNumber : ' 
                     + CONVERT(VARCHAR, Error_number()) 
                     + ' , ErrorSeverity : ' 
                     + CONVERT(VARCHAR, Error_severity()) 
                     + '      	, ErrorState : ' 
                     + CONVERT(VARCHAR, Error_state()) 
                     + ' , ErrorProcedure : ' 
                     + CONVERT(VARCHAR, Error_procedure()) 
                     + '  , ErrorLine : ' 
                     + CONVERT(VARCHAR, Error_line()) 
                     + ' , ErrorMessage : ' 
                     + CONVERT(VARCHAR, Error_message()) 
                     + ' , Mode : "DataBase" ' 

          SELECT 0 as ID, @sql AS CustomMessage, 
                 '1'  AS CustomErrorState
---------------------------------End Error Message--------------------------------------------------
          ROLLBACK 
		  END catch

END