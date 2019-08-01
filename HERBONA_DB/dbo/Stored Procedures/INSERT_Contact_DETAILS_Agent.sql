CREATE procedure [dbo].[INSERT_Contact_DETAILS_Agent]
@ID				bigint=null,
@Name	        nvarchar(max)=null, 
@Gender		    nvarchar(100) = null, 
@MobileNo		nvarchar(50) = null, 
@Email			nvarchar(max)=null,
@ImageURL       nvarchar(max)=null,

@country_id		int=null, 
@state_id		int=null, 
@district_id	int=null,
@addressline	nvarchar(max)=null, 
@pincode		nvarchar(100)=null, 
@DateOfBirth varchar(20)=null,
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
        @Contact_ID   INT ,
		 @NEW_AUTOPSSWD   NVARCHAR(max) 

---------------Encrypt password--------------------------------------- 
 --SET @NEW_AUTOPSSWD=(SELECT Cast((Abs(Checksum(Newid()))%10) AS VARCHAR 
 --                                    (1)) 
 --                                    + Char(Ascii('a')+(Abs(Checksum(Newid()))% 
 --                                    25)) 
 --                                    + Char(Ascii('A')+(Abs(Checksum(Newid()))% 
 --                                    25)) 
 --                                    + LEFT(Newid(), 5)) 

 set @NEW_AUTOPSSWD='123'
SELECT @encryptPsswd = master.dbo.Fn_varbintohexstr(Hashbytes('MD5', @NEW_AUTOPSSWD)) 

  declare @RoleId bigint

  set @RoleId = (select ID from [ROLE] where [Company_ID]=@Company_ID and [Branch_ID]=@Branch_ID and Name='AGENT')

--SELECT @encryptPsswd = EncryptByPassPhrase('PEPE', @Password ) 
---------------End Encrypt password--------------------------------------- 
IF( @MODE = 'INSERT' ) 
  BEGIN 
      ------------------------------------validation for insert------------------------------------------- 

      IF EXISTS (SELECT email 
                 FROM   contact 
                 WHERE  email = @Email 
                        AND isactive = 1) 
        BEGIN 
            SELECT 0 as ID, 'Email ID already exists..!' AS CustomMessage, 
                   '2'                          AS CustomErrorState,
				    '' as Email_ID,
			 '' as Passward,
			 '' as Agent_Name 

            GOTO last_row; 
        END 

      ----------------------------------End validation for insert--------------------------------------------- 
      ------------------------------ Contact table insert------------------------------------   
      INSERT INTO contact 
                  (NAME, 
                   Roleid, 
                   MobileNo, 
                   Email, 
                   Password, 
                   Gender, 
                   Isactive, 
                   Createddate, 
                   Createdby, 
                   Company_id, 
                   Branch_id,
				   IsAgent,
				   IsAgentActive,
				   ImageURL,
				   DateOfBirth) 
      VALUES      (@Name, 
                   @RoleId, 
                   @MobileNo, 
                   @Email, 
                   @encryptPsswd, 
                   @Gender, 
                   1, 
                   Getdate(), 
                   @Login_user_ID, 
                   @Company_ID, 
                   @Branch_ID,
				   1,
				   1,
				   @ImageURL,
				   @DateOfBirth) 

      SET @Contact_ID=@@IDENTITY 

      -------------------------------End Contact table insert------------------------------------   
      --------------------------------ADDRESS table Insert--------------------------------   
      INSERT INTO address 
                  (name,
				  addressline, 
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
                   1) 

      ---------------------------------Success message for insert-------------------------------------------------- 
      SELECT @Contact_ID                      AS ID, 
             'Agent Personal Details Successfully Inserted' AS CustomMessage, 
             '0'                             AS CustomErrorState ,
			 @Email as Email_ID,
			 @NEW_AUTOPSSWD as Passward,
			 @Name as Agent_Name

  ---------------------------------End Success message for insert-------------------------------------------------- 


    ---------------------------------Success WALLET for insert-------------------------------------------------- 
  exec [SAVE_UPDATE_WALLET] 
      @MEMBER_ID = @Contact_ID,       
      @IsActive  = 1,
      @Company_ID = @Company_ID,
      @Branch_ID = @Branch_ID,
      @login_id = @Login_user_ID	 
    ---------------------------------End Success WALLET for insert-------------------------------------------------- 


  END 

IF( @ID IS NOT NULL 
    AND @MODE = 'UPDATE' ) 
  BEGIN 
      ------------------------------------validation for Update------------------------------------------- 

      IF EXISTS (SELECT email 
                 FROM   contact 
                 WHERE  email = @Email 
                        AND id != @ID 
                        AND isactive = 1) 
        BEGIN 
            SELECT  0 as ID,'Agent already registered with this email id..!' AS 
                   CustomMessage 
                   , 
                   '2'                                                AS 
                   CustomErrorState ,
				    '' as Email_ID,
			 '' as Passward,
			 '' as Agent_Name

            GOTO last_row; 
        END 

      ----------------------------------End validation for Update--------------------------------------------- 
      ------------------------------ Contact table update------------------------------------   
      UPDATE contact 
      SET    NAME = @Name, 
             mobileno = @MobileNo, 
             email = @Email,
			 ImageURL =@ImageURL,
             updateddate = Getdate(), 
             updatedby = @Login_user_ID,
			 DateOfBirth = @DateOfBirth 
      WHERE  id = @ID 

      ------------------------------ End Contact table update------------------------------------   
      UPDATE address 
      SET   name = @Name, 
             addressline = @addressline, 
             state_id = @state_id, 
             country_id = @country_id, 
             district_id = @district_id, 
             pincode = @pincode, 
			 MobileNo = @MobileNo, 
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  contact_id = @ID 
             AND is_default = 1 and IsActive=1

      ---------------------------------Success message for update-------------------------------------------------- 
      SELECT @ID                            AS ID, 
             'Agent Personal Details Successfully Updated' AS CustomMessage, 
             '0'                            AS CustomErrorState ,
			 '' as Email_ID,
			 '' as Passward,
			 '' as Agent_Name
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
             'Agent Personal Details Successfully Deleted' AS CustomMessage, 
             '0'                            AS CustomErrorState ,
			  '' as Email_ID,
			 '' as Passward,
			 '' as Agent_Name
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

          SELECT 0 as ID, @sql AS CustomMessage, 
                 '1'  AS CustomErrorState ,
				  '' as Email_ID,
			 '' as Passward,
			 '' as Agent_Name
---------------------------------End Error Message--------------------------------------------------
          ROLLBACK 
		  END catch

END