CREATE procedure [dbo].[INSERT_Delivery_Address]
@Contact_ID     bigint=null, 
@Name	        nvarchar(max)=null, 
@MobileNo		nvarchar(50) = null,
@country_id		int=null, 
@state_id		int=null, 
@district_id	int=null,
@addressline	nvarchar(max)=null, 
@pincode		nvarchar(100)=null,
@city           nvarchar(max)=null, 
@Company_ID     bigint=null,
@Branch_ID      bigint=null,
@Login_user_ID  nvarchar(max)=null
AS
BEGIN
	SET NOCOUNT ON;

	 BEGIN try 
          BEGIN TRANSACTION 

      --------------------------------ADDRESS table Insert--------------------------------   
      INSERT INTO address 
                  (name,
				  addressline, 
				  city,
                   district_id, 
                   state_id, 
                   country_id, 
                   pincode,  
				   MobileNo,
                   contact_id, 
                   isactive, 
                   createddate, 
                   createdby, 
                   company_id, 
                   branch_id, 
                   is_default) 
      VALUES      (@name,
	               @addressline,
				   @city, 
                   @district_id, 
                   @state_id, 
                   @country_id, 
                   @pincode,  
				   @MobileNo,
                   @Contact_ID, 
                   1, 
                   Getdate(), 
                   @Login_user_ID, 
                   @Company_ID, 
                   @Branch_ID, 
                   0) 

      ---------------------------------Success message for insert-------------------------------------------------- 
      SELECT @Contact_ID                      AS ID, 
             'Address Successfully Inserted' AS CustomMessage, 
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