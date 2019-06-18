CREATE procedure [dbo].[INSERT_BRANCH_DETAILS]
@ID				nvarchar(max)=null,
@Name	nvarchar(max)=null, 
@Company_ID		bigint=null, 
@HODName nvarchar(max)=null, 
@MobileNo		nvarchar(50) = null, 
@PhoneNo		nvarchar(50)=null, 
@Email			nvarchar(max)=null, 
@Password		nvarchar(max)=null, 
@Country		bigint=null, 
@State			bigint=null, 
@City			nvarchar(max)=null, 
@Address		nvarchar(max)=null, 
@LogoPath		nvarchar(max)=null,
@MODE			varchar(10)=null,
@Login_user_ID  nvarchar(max)=null

AS
BEGIN
	SET NOCOUNT ON;
	 BEGIN try 
          BEGIN TRANSACTION 

  DECLARE @Branch_ID    INT, 
        @encryptPsswd NVARCHAR(max), 
        @Contact_ID   INT, 
        @address_ID   INT, 
        @role_ID      INT 

---------------Encrypt password--------------------------------------- 
SELECT @encryptPsswd = master.dbo.Fn_varbintohexstr(Hashbytes('MD5', @Password)) 

--SELECT @encryptPsswd = EncryptByPassPhrase('PEPE', @Password ) 
---------------End Encrypt password--------------------------------------- 
IF( @MODE = 'INSERT' ) 
  BEGIN 
      ------------------------------------validation for insert------------------------------------------- 
      IF EXISTS (SELECT NAME 
                 FROM   branch 
                 WHERE  NAME = @Name 
                        AND company_id = @Company_ID 
                        AND isactive = 1) 
        BEGIN 
            SELECT 'Branch Name Already Exists' AS CustomMessage, 
                   '2'                          AS CustomErrorState 

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
      --------------------------------Branch table Insert--------------------------------            
      INSERT INTO [branch] 
                  (NAME, 
                   hodname, 
                   logopath, 
                   company_id, 
                   contact_id, 
                   isactive, 
                   createddate, 
                   createdby) 
      VALUES     (@Name, 
                  @HODName, 
                  @LogoPath, 
                  @Company_ID, 
                  NULL, 
                  1, 
                  Getdate(), 
                  @Login_user_ID) 

      SET @Branch_ID =@@IDENTITY 

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
				   IsAgent) 
      VALUES      (@Name, 
                   NULL, 
                   @MobileNo, 
                   @PhoneNo, 
                   @Email, 
                   @encryptPsswd, 
                   NULL, 
                   1, 
                   Getdate(), 
                   @Login_user_ID, 
                   @Company_ID, 
                   @Branch_ID,
				   0) 

      SET @Contact_ID=@@IDENTITY 

      UPDATE [branch] 
      SET    contact_id = @Contact_ID 
      WHERE  id = @Branch_ID 

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

      SET @address_ID=@@IDENTITY 

      --------------------------------ADDRESS table Insert--------------------------------  
      --------------------------------ROLE table Insert--------------------------------  
      INSERT INTO role 
                  (NAME, 
                   short_name, 
                   description, 
                   isactive, 
                   createddate, 
                   createdby, 
                   company_id, 
                   branch_id) 
      VALUES      ('BRANCH ADMIN', 
                   'BA', 
                   NULL, 
                   1, 
                   Getdate(), 
                   @Login_user_ID, 
                   @Company_ID, 
                   @Branch_ID) 

      SET @role_ID = @@IDENTITY 

      UPDATE contact 
      SET    roleid = @role_ID 
      WHERE  id = @Contact_ID 

      --------------------------------ROLE table Insert--------------------------------  
      --------------------------------Role Permission table Insert--------------------------------   
      INSERT INTO [role_permission] 
                  ([menuid], 
                   [roleid], 
                   [b_add], 
                   [b_edit], 
                   [b_delete], 
                   [b_view], 
                   [b_payment], 
                   [prient], 
                   [status], 
                   [company_id], 
                   [branch_id]) 
      SELECT [menuid], 
             @Role_ID, 
             [b_add], 
             [b_edit], 
             [b_delete], 
             [b_view], 
             [b_payment], 
             [prient], 
             [status], 
             @COMPANY_ID, 
             @BRANCH_ID 
      FROM   [role_permission] 
      WHERE  roleid = 3 

      --------------------------------End Role Permission table Insert--------------------------------   
      INSERT INTO role 
                  (NAME, 
                   short_name, 
                   description, 
                   isactive, 
                   createddate, 
                   createdby, 
                   company_id, 
                   branch_id) 
      VALUES      ('USER', 
                   'UG', 
                   NULL, 
                   1, 
                   Getdate(), 
                   @Login_user_ID, 
                   @Company_ID, 
                   @Branch_ID) 

      INSERT INTO role 
                  (NAME, 
                   short_name, 
                   description, 
                   isactive, 
                   createddate, 
                   createdby, 
                   company_id, 
                   branch_id) 
      VALUES      ('AGENT', 
                   'AG', 
                   NULL, 
                   1, 
                   Getdate(), 
                   @Login_user_ID, 
                   @Company_ID, 
                   @Branch_ID) 

      ---------------------------------Success message for insert-------------------------------------------------- 
      SELECT @Branch_ID                       AS ID, 
             'Location Successfully Inserted' AS CustomMessage, 
             '0'                              AS CustomErrorState 
  ---------------------------------End Success message for insert-------------------------------------------------- 
  END 

IF( @ID IS NOT NULL 
    AND @MODE = 'UPDATE' ) 
  BEGIN 
      ------------------------------------validation for update------------------------------------------- 
      IF EXISTS (SELECT NAME 
                 FROM   branch 
                 WHERE  NAME = @Name 
                        AND id != @ID 
                        AND company_id = @Company_ID 
                        AND isactive = 1) 
        BEGIN 
            SELECT 'Branch Name Already Exists' AS CustomMessage, 
                   '2'                          AS CustomErrorState 

            GOTO last_row; 
        END 

      IF EXISTS (SELECT email 
                 FROM   contact 
                 WHERE  email = @Email 
                        AND id != (SELECT contact_id 
                                   FROM   branch 
                                   WHERE  id = @ID) 
                        AND isactive = 1) 
        BEGIN 
            SELECT 'Email ID already exists..!' AS CustomMessage, 
                   '2'                          AS CustomErrorState 

            GOTO last_row; 
        END 

      ----------------------------------End validation for upfdate--------------------------------------------- 
      --------------------------------branch table update-------------------------------- 
      UPDATE [branch] 
      SET    [name] = @Name, 
             [hodname] = @HODName, 
             logopath = Isnull(@LogoPath, logopath), 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  id = @ID 

      SELECT @Contact_ID = contact_id 
      FROM   [branch] 
      WHERE  id = @ID 

      --------------------------------End branch table update-------------------------------- 
      ------------------------------ Contact table update------------------------------------  
      UPDATE contact 
      SET    NAME = @Name, 
             mobileno = @MobileNo, 
             phoneno = @PhoneNo, 
             email = @Email, 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  id = @Contact_ID 

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
      WHERE  Contact_ID = @Contact_ID 
             AND is_default = 1 

      ---------------------------------Success message for update-------------------------------------------------- 
      SELECT @ID                             AS ID, 
             'Location Successfully Updated' AS CustomMessage, 
             '0'                             AS CustomErrorState 
  ---------------------------------End Success message for update-------------------------------------------------- 
  END 

IF( @ID IS NOT NULL 
    AND @MODE = 'DELETE' ) 
  BEGIN 
      --------------------------------Branch Table delete---------------------------------------------------- 
      UPDATE [branch] 
      SET    isactive = 0, 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  id = @ID 

      --------------------------------Branch Table delete---------------------------------------------------- 
      --------------------------------Contact Table delete---------------------------------------------------- 
      UPDATE contact 
      SET    isactive = 0, 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  id IN (SELECT contact_id 
                    FROM   branch 
                    WHERE  id = @ID) 

      --------------------------------End Contact Table delete---------------------------------------------------- 
      ---------------------------------Success message for delete-------------------------------------------------- 
      SELECT @ID                             AS ID, 
             'Location Successfully Deleted' AS CustomMessage, 
             '0'                             AS CustomErrorState 
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
---------------------------------End error message--------------------------------------------------
          ROLLBACK 
		  END catch 

END