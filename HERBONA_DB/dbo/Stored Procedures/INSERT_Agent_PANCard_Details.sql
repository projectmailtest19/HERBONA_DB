create procedure [dbo].[INSERT_Agent_PANCard_Details]
@Contact_id		int=null,
@PANCard_URL	nvarchar(max)=null, 
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
      INSERT INTO [Agent_PANCard_Details] 
                  ([Contact_id]
      ,PANCard_URL
      ,[IsActive]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[Company_ID]
      ,[Branch_ID]) 
      VALUES      (@Contact_id, 
                   @PANCard_URL, 
                   1, 
                   Getdate(), 
                   @Login_user_ID, 
                   @Company_ID, 
                   @Branch_ID) 

      -------------------------------End Contact table insert------------------------------------   
    
      SELECT @@IDENTITY                      AS ID, 
             'PAN Card Successfully Uploaded' AS CustomMessage, 
             '0'                             AS CustomErrorState 

  ---------------------------------End Success message for insert-------------------------------------------------- 
  END 

IF(@MODE = 'UPDATE' ) 
  BEGIN 

      ------------------------------ Contact table update------------------------------------   
      UPDATE [Agent_PANCard_Details] 
      SET    PANCard_URL = @PANCard_URL, 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  [Contact_id] = @Contact_ID 

   
      ---------------------------------Success message for update-------------------------------------------------- 
      SELECT id                            AS ID, 
             'PAN Card Successfully Uploaded' AS CustomMessage, 
             '0'                            AS CustomErrorState from [Agent_PANCard_Details] where [Contact_id] = @Contact_ID 
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