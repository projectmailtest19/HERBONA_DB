CREATE procedure [dbo].[INSERT_COMPANY_DETAILS]
@ID				bigint=null,
@CompanyName	nvarchar(max)=null, 
@CEOName		nvarchar(max)=null, 
@MobileNo       nvarchar(50)=null, 
@PhoneNo		nvarchar(50)=null, 
@Email			nvarchar(max)=null, 
@Password		nvarchar(max)=null, 
@Country		bigint=null, 
@State			bigint=null, 
@City			nvarchar(max)=null, 
@CompanyType	nvarchar(max)=null, 
@Address		nvarchar(max)=null, 
@WebsiteUrl		nvarchar(max)=null, 
@LogoPath		nvarchar(max)=null,
@MODE			varchar(10)=null,
@Login_user_ID  bigint=null,

@CIN nvarchar(max)=null,
@PAN nvarchar(max)=null,
@GST_NUMBER nvarchar(max)=null

AS
BEGIN
	
	

	SET NOCOUNT ON; 

	 BEGIN try 
          BEGIN TRANSACTION 

DECLARE @Company_ID   INT, 
        @encryptPsswd NVARCHAR(max), 
        @Contact_ID   INT, 
        @address_ID   INT, 
        @role_ID      INT 

---------------Encrypt password--------------------------------------- 
SELECT @encryptPsswd = master.dbo.Fn_varbintohexstr(Hashbytes('MD5', @Password)) 

---SELECT @encryptPsswd = EncryptByPassPhrase('PEPE', @Password ) 
---------------End Encrypt password--------------------------------------- 
IF( @MODE = 'INSERT' ) 
  BEGIN 
      ------------------------------------validation for insert------------------------------------------- 
      IF EXISTS (SELECT companyname 
                 FROM   company 
                 WHERE  companyname = @CompanyName 
                        AND isactive = 1) 
        BEGIN 
            SELECT 'Company Name Already Exists' AS CustomMessage, 
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
      --------------------------------Company table Insert--------------------------------            
      INSERT INTO company 
                  (companyname, 
                   ceoname, 
                   websiteurl, 
                   logopath, 
                   contact_id, 
                   isactive, 
                   createddate, 
                   createdby, 
                   companytype,
				   CIN,
                   PAN,
                   GST_NUMBER) 
      VALUES     (@CompanyName, 
                  @CEOName, 
                  @WebsiteUrl, 
                  @LogoPath, 
                  NULL, 
                  1, 
                  Getdate(), 
                  @Login_user_ID, 
                  @CompanyType,
				  @CIN,
                  @PAN,
                  @GST_NUMBER) 

      SET @Company_ID =@@IDENTITY 

      --------------------------------End Company table Insert----------------------------- 
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
      VALUES     (@CompanyName, 
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
                  NULL,
				  0) 

      SET @Contact_ID=@@IDENTITY 

      UPDATE company 
      SET    contact_id = @Contact_ID 
      WHERE  id = @Company_ID 

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
      VALUES     (@CompanyName, 
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
                  NULL, 
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
                   company_id) 
      VALUES     ('COMPANY ADMIN', 
                  'CA', 
                  NULL, 
                  1, 
                  Getdate(), 
                  @Login_user_ID, 
                  @Company_ID) 

      SET @role_ID = @@IDENTITY 

      UPDATE contact 
      SET    roleid = @role_ID 
      WHERE  id = @Contact_ID 

      --------------------------------ROLE table Insert-------------------------------- 
      ---------------------------------Success message for insert-------------------------------------------------- 
      SELECT @Company_ID                     AS ID, 
             'Company Successfully Inserted' AS CustomMessage, 
             '0'                             AS CustomErrorState 
  ---------------------------------End Success message for insert-------------------------------------------------- 
  END 

IF( @ID IS NOT NULL 
    AND @MODE = 'UPDATE' ) 
  BEGIN 
      ------------------------------------validation for update------------------------------------------- 
      IF EXISTS (SELECT companyname 
                 FROM   company 
                 WHERE  companyname = @CompanyName 
                        AND id != @ID 
                        AND isactive = 1) 
        BEGIN 
            SELECT 'Company Name Already Exists' AS CustomMess, 
                   '2'                           AS CustomErrorState 

            GOTO last_row; 
        END 

      IF EXISTS (SELECT email 
                 FROM   contact 
                 WHERE  email = @Email 
                        AND id != (SELECT contact_id 
                                   FROM   company 
                                   WHERE  id = @ID) 
                        AND isactive = 1) 
        BEGIN 
            SELECT 'Email ID already exists..!' AS CustomMessage, 
                   '2'                          AS CustomErrorState 

            GOTO last_row; 
        END 

      ----------------------------------End validation for update--------------------------------------------- 
      --------------------------------Company table update-------------------------------- 
      UPDATE company 
      SET    companyname = @CompanyName, 
             ceoname = @CEOName, 
             websiteurl = @WebsiteUrl, 
             logopath = Isnull(@LogoPath, logopath), 
             companytype = @CompanyType, 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID,
			 CIN = @CIN,
             GST_NUMBER = @GST_NUMBER
      WHERE  id = @ID 

      SELECT @Contact_ID = contact_id 
      FROM   company 
      WHERE  id = @ID 

      --------------------------------End Company table update-------------------------------- 
      ------------------------------ Contact table update------------------------------------ 
      UPDATE contact 
      SET    NAME = @CompanyName, 
             mobileno = @MobileNo, 
             phoneno = @PhoneNo, 
             email = @Email, 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  id = @Contact_ID 

      ------------------------------ End Contact table update------------------------------------ 
      UPDATE address 
      SET    NAME = @CompanyName, 
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
      SELECT @ID                            AS ID, 
             'Company Successfully Updated' AS CustomMessage, 
             '0'                            AS CustomErrorState 
  ---------------------------------End Success message for update-------------------------------------------------- 
  END 

IF( @ID IS NOT NULL 
    AND @MODE = 'DELETE' ) 
  BEGIN 
      --------------------------------Company Table delete---------------------------------------------------- 
      UPDATE company 
      SET    isactive = 0, 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  id = @ID 

      --------------------------------End Company Table delete---------------------------------------------------- 
      --------------------------------Contact Table delete---------------------------------------------------- 
      UPDATE contact 
      SET    isactive = 0, 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  id IN (SELECT contact_id 
                    FROM   company 
                    WHERE  id = @ID) 

      --------------------------------End Company Table delete---------------------------------------------------- 
      ---------------------------------Success message for delete-------------------------------------------------- 
      SELECT @ID                            AS ID, 
             'Company Successfully Deleted' AS CustomMessage, 
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
---------------------------------End error message--------------------------------------------------
          ROLLBACK 
      END catch 
  END