CREATE procedure [dbo].[INSERT_Order_Details]
@Member_Id     bigint=null, 
@Order_ID	    bigint=null,  
@Address_ID		 bigint=null, 
@ShippingMethod_ID		 bigint=null, 
@Company_ID     bigint=null,
@Branch_ID      bigint=null,
@Login_user_ID  nvarchar(max)=null
AS
BEGIN
	SET NOCOUNT ON;

	 BEGIN try 
          BEGIN TRANSACTION 

      --------------------------------ADDRESS table Insert--------------------------------   
      INSERT INTO [Order_Details] 
                  ([Member_Id]
      ,[Order_ID]
      ,[Address_ID]
      ,[ShippingMethod_ID]
       ,[IsActive]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[Company_ID]
      ,[Branch_ID]) 
      VALUES      (@Member_Id,
	               @Order_ID,
				   @Address_ID,
				   @ShippingMethod_ID,  
                   1, 
                   Getdate(), 
                   @Login_user_ID, 
                   @Company_ID, 
                   @Branch_ID) 

      ---------------------------------Success message for insert-------------------------------------------------- 
      SELECT @@IDENTITY                      AS ID, 
             'Data Successfully Inserted' AS CustomMessage, 
             '0'                             AS CustomErrorState

  ---------------------------------End Success message for insert-------------------------------------------------- 


 

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
                 '1'  AS CustomErrorState ,
				  '' as Email_ID,
			 '' as Passward,
			 '' as Agent_Name
---------------------------------End Error Message--------------------------------------------------
          ROLLBACK 
		  END catch

END