CREATE procedure [dbo].[INSERT_Contact_DETAILS]
@ID				nvarchar(max)=null,
@Name	        nvarchar(max)=null, 
@RoleId		    int=null, 
@MobileNo		nvarchar(50) = null, 
@PhoneNo		nvarchar(50)=null, 
@Email			nvarchar(max)=null, 
@Password		nvarchar(max)=null, 
@Country		bigint=null, 
@State			bigint=null, 
@City			nvarchar(max)=null, 
@Type	        nvarchar(max)=null, 
@Address		nvarchar(max)=null, 
@WebsiteUrl		nvarchar(max)=null, 
@LogoPath		nvarchar(max)=null,
@IsStatus       int = 1,
@MODE			varchar(10)=null,
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@Login_user_ID  nvarchar(max)=null
AS
BEGIN
	SET NOCOUNT ON;

	 BEGIN try 
          BEGIN TRANSACTION 

DECLARE @encryptPsswd NVARCHAR(max), 
        @Contact_ID   INT 

---------------Encrypt password--------------------------------------- 
SELECT @encryptPsswd = master.dbo.Fn_varbintohexstr(Hashbytes('MD5', @Password)) 

--SELECT @encryptPsswd = EncryptByPassPhrase('PEPE', @Password ) 
---------------End Encrypt password--------------------------------------- 
IF( @MODE = 'INSERT' ) 
  BEGIN 
      ------------------------------------validation for insert------------------------------------------- 
      IF EXISTS (SELECT NAME 
                 FROM   contact 
                 WHERE  NAME = @Name 
                        AND company_id = @Company_ID 
                        AND branch_id = @Branch_ID 
                        AND isactive = 1) 
        BEGIN 
            SELECT 'Contact Name Already Exists' AS CustomMessage, 
                   '2'                           AS CustomErrorState 

            GOTO last_row; 
        END 

      IF EXISTS (SELECT email 
                 FROM   contact 
                 WHERE  email = @Email 
                        AND isactive = 1) 
        BEGIN 
            SELECT 'Email ID already exists..!' AS CustomMessage, 
                   '2'                          AS CustomErrorState 

            GOTO last_row; 
        END 

      ----------------------------------End validation for insert--------------------------------------------- 
      ------------------------------ Contact table insert------------------------------------   
      INSERT INTO contact 
                  (NAME, 
                   roleid, 
                   mobileno, 
                   phoneno, 
                   email, 
                   password, 
                   gender, 
                   isactive, 
                   createddate, 
                   createdby, 
                   company_id, 
                   branch_id,
				   IsAgent,
				   ImageURL
				   ) 
      VALUES      (@Name, 
                   @roleid, 
                   @MobileNo, 
                   @PhoneNo, 
                   @Email, 
                   @encryptPsswd, 
                   NULL, 
                   @IsStatus, 
                   Getdate(), 
                   @Login_user_ID, 
                   @Company_ID, 
                   @Branch_ID,
				   0,
				   @LogoPath) 

      SET @Contact_ID=@@IDENTITY 

      -------------------------------End Contact table insert------------------------------------   
      --------------------------------ADDRESS table Insert--------------------------------   
      INSERT INTO address 
                  (NAME, 
                   addressline, 
                   city, 
                   district_id, 
                   state_id, 
                   country_id, 
                   pincode, 
                   mobileno, 
                   phoneno, 
                   email, 
                   contact_id, 
                   isactive, 
                   createddate, 
                   createdby, 
                   company_id, 
                   branch_id, 
                   is_default) 
      VALUES      (@Name, 
                   @Address, 
                   @City, 
                   NULL, 
                   @State, 
                   @Country, 
                   NULL, 
                   @MobileNo, 
                   @PhoneNo, 
                   @Email, 
                   @Contact_ID, 
                   1, 
                   Getdate(), 
                   @Login_user_ID, 
                   @Company_ID, 
                   @Branch_ID, 
                   1) 

      ---------------------------------Success message for insert-------------------------------------------------- 
      SELECT @@IDENTITY                      AS ID, 
             'Contact Successfully Inserted' AS CustomMessage, 
             '0'                             AS CustomErrorState 
  ---------------------------------End Success message for insert-------------------------------------------------- 
  END 

IF( @ID IS NOT NULL 
    AND @MODE = 'UPDATE' ) 
  BEGIN 
      ------------------------------------validation for Update------------------------------------------- 
      IF EXISTS (SELECT NAME 
                 FROM   contact 
                 WHERE  NAME = @Name 
                        AND company_id = @Company_ID 
                        AND branch_id = @Branch_ID 
                        AND id != @ID 
                        AND isactive = 1) 
        BEGIN 
            SELECT 'Contact Name Already Exists' AS CustomMessage, 
                   '2'                           AS CustomErrorState 

            GOTO last_row; 
        END 

      IF EXISTS (SELECT email 
                 FROM   contact 
                 WHERE  email = @Email 
                        AND id != @ID 
                        AND isactive = 1) 
        BEGIN 
            SELECT 'Contact already registered with this email id..!' AS 
                   CustomMessage 
                   , 
                   '2'                                                AS 
                   CustomErrorState 

            GOTO last_row; 
        END 

      ----------------------------------End validation for Update--------------------------------------------- 
      ------------------------------ Contact table update------------------------------------   
      UPDATE contact 
      SET    NAME = @Name, 
             mobileno = @MobileNo, 
             phoneno = @PhoneNo, 
             email = @Email, 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID, 
			 isactive = @IsStatus,
			 ImageURL = @LogoPath
      WHERE  id = @ID 

      ------------------------------ End Contact table update------------------------------------   
      UPDATE address 
      SET    NAME = @Name, 
             addressline = @Address, 
             city = @City, 
             state_id = @State, 
             country_id = @Country, 
             mobileno = @MobileNo, 
             phoneno = @PhoneNo, 
             email = @Email, 
             district_id = NULL, 
             pincode = NULL, 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  contact_id = @ID 
             AND is_default = 1 

      ---------------------------------Success message for update-------------------------------------------------- 
      SELECT @ID                            AS ID, 
             'Contact Successfully Updated' AS CustomMessage, 
             '0'                            AS CustomErrorState 
  ---------------------------------End Success message for update-------------------------------------------------- 
  END 

IF( @ID IS NOT NULL 
    AND @MODE = 'DELETE' ) 
  BEGIN 
      --------------------------------Contact Table delete---------------------------------------------------- 
      UPDATE contact 
      SET    isactive = 0, 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  id = @ID 

      --------------------------------End Contact Table delete---------------------------------------------------- 
      ---------------------------------Success message for delete-------------------------------------------------- 
      SELECT @ID                            AS ID, 
             'Contact Successfully Deleted' AS CustomMessage, 
             '0'                            AS CustomErrorState 
  ---------------------------------End Success message for delete-------------------------------------------------- 
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

          SELECT @sql AS CustomMessage, 
                 '1'  AS CustomErrorState 
---------------------------------End Error Message--------------------------------------------------
          ROLLBACK 
		  END catch

END