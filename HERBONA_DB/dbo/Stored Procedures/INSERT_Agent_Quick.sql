-- [INSERT_Agent_Quick] '','','','sa','','','','',    '0000000000','10023','L'
CREATE PROCEDURE [dbo].[INSERT_Agent_Quick]
@Name	        nvarchar(max)=null, 
@DOB		    date = null, 
@MobileNo		nvarchar(50) = null, 
@Email			nvarchar(max)=null,

@country_id		int=null, 
@state_id		int=null, 
@district_id	int=null,
@pincode		nvarchar(100)=null, 

@Sponsor_Member_ID nvarchar(max),
@Placed_ID bigint=null, 
@Team		nvarchar(100)=null
AS
BEGIN
	 
	SET NOCOUNT ON;

	 --BEGIN try 
  --        BEGIN TRANSACTION 

select @Sponsor_Member_ID= Contact_id from [dbo].[Agent_Sponsor_Details] where MemberID=@Sponsor_Member_ID

DECLARE @encryptPsswd NVARCHAR(max), 
        @Contact_ID   INT ,
		@NEW_AUTOPSSWD   NVARCHAR(max),
		@company_id int,
		@branch_id int 


		
select @company_id = company_id, @branch_id = branch_id from contact where id = @Sponsor_Member_ID



set @NEW_AUTOPSSWD='123'
SELECT @encryptPsswd = master.dbo.Fn_varbintohexstr(Hashbytes('MD5', @NEW_AUTOPSSWD)) 

 declare @RoleId bigint

set @RoleId = (select ID from [ROLE] where [Company_ID]=@Company_ID and [Branch_ID]=@Branch_ID and Name='AGENT')


      ------------------------------------validation for insert------------------------------------------- 

      IF EXISTS (SELECT email 
                 FROM   contact 
                 WHERE  email = @Email 
                        AND isactive = 1) 
        BEGIN 
    --        SELECT 0 as ID, 'Email ID already exists..!' AS CustomMessage, 
    --               '2'                          AS CustomErrorState,
				--    '' as Email_ID,
			 --'' as Passward,
			 --'' as Agent_Name 

			 SELECT  'Email ID already exists..!' AS CustomMessage, 
             '2'  AS CustomErrorState,
			  @Sponsor_Member_ID as Account_Number,
			  @Name as Name,
			  @MobileNo as MobileNo,
			  @Email as Email


            GOTO last_row; 
        END 

  if exists(select * from Agent_Sponsor_Details where Placed_Contact_Id = @Placed_ID and Placed_Team = @Team)
  begin

    --SELECT 0 as ID,'Placed Member already has Enterpreneur on the Placed Team' AS CustomMessage, 
    --             '2'  AS CustomErrorState

   	   SELECT  'Placed Member already has Enterpreneur on the Placed Team' AS CustomMessage, 
             '2'  AS CustomErrorState,
			  @Sponsor_Member_ID as Account_Number,
			  @Name as Name,
			  @MobileNo as MobileNo,
			  @Email as Email


	goto Last_row;

  end

      ----------------------------------End validation for insert--------------------------------------------- 
      ------------------------------ Contact table insert------------------------------------   
      INSERT INTO contact 
                  (NAME, 
                   Roleid, 
                   MobileNo, 
                   Email, 
                   Password, 
                   
                   Isactive, 
                   Createddate, 
                  
                   Company_id, 
                   Branch_id,
				   IsAgent,
				   IsAgentActive,
				   
				   DateOfBirth) 
      VALUES      (@Name, 
                   @RoleId, 
                   @MobileNo, 
                   @Email, 
                   @encryptPsswd, 
                
                   1, 
                   Getdate(), 
 
                   @Company_ID, 
                   @Branch_ID,
				   1,
				   1,
 
				   @DOB) 

      SET @Contact_ID=@@IDENTITY 

      -------------------------------End Contact table insert------------------------------------   
      --------------------------------ADDRESS table Insert--------------------------------   
      INSERT INTO address 
                  (name,
				   MobileNo,
                   contact_id, 
                   isactive, 
                   createddate, 
                   company_id, 
                   branch_id, 
                   is_default,
				   country_id,
				   state_id,
				   district_id) 
      VALUES      (@name,
				   @MobileNo,
                   @Contact_ID, 
                   1, 
                   Getdate(),  
                   @Company_ID, 
                   @Branch_ID, 
                   1,
				   @country_id,
				   @state_id,
				   @district_id) 


  ---------------------------------End Success message for insert-------------------------------------------------- 


    ---------------------------------Success WALLET for insert-------------------------------------------------- 
  exec [SAVE_UPDATE_WALLET] 
      @MEMBER_ID = @Contact_ID,       
      @IsActive  = 1,
      @Company_ID = @Company_ID,
      @Branch_ID = @Branch_ID
 
    ---------------------------------End Success WALLET for insert-------------------------------------------------- 


    




  declare @MaxChildNode hierarchyid
 declare @rank_id int
  

  Declare @MemberID nvarchar(max)
  set  @MemberID = CAST(round(RAND()*1000000000,0) AS BIGINT)

      ------------------------------ Contact table insert------------------------------------   
      INSERT INTO Agent_Sponsor_Details 
                  (Contact_id, Placed_Team, IsActive, CreatedDate,   Company_ID, Branch_ID, MemberID, Placed_Contact_Id, Sponsor_Contact_Id) 
      VALUES      (@Contact_id, @Team, 1, Getdate(),   @Company_ID, @Branch_ID ,@MemberID ,@Placed_ID,@Sponsor_Member_ID) 


        IF (@Team = 'L')
        BEGIN
          SELECT
            @MaxChildNode = CAST((AdvisorHierarchyNode.ToString() + '1/') AS hierarchyid)
          FROM Organisation
          WHERE ASSID = @Placed_ID
        END

        ELSE
        BEGIN
          SELECT
            @MaxChildNode = CAST((AdvisorHierarchyNode.ToString() + '2/') AS hierarchyid)
          FROM Organisation
          WHERE ASSID = @Placed_ID
        END


        INSERT Organisation (ASSID, AdvisorHierarchyNode)
          VALUES (@Contact_id, @MaxChildNode)

		  insert TBL_PAIRMASTER (ASSID,PAIR,LEFT_CHILD,RIGHT_CHILD) values (@Contact_id,0,0,0)				


		  exec [pair]

		 

		  select top 1 @rank_id = [ID] from  [RANK_REWARD]
		  where name ='HBO'
          order by id

		  insert into [Agent_Rank_Details](Contact_id, Rank_Id, CreatedDate, Company_ID, Branch_ID)
		  values(@Contact_id,@rank_id,getutcdate(), @Company_ID, 
                   @Branch_ID)







	   SELECT  'Success' AS CustomMessage, 
             '0'  AS CustomErrorState,
			  @Sponsor_Member_ID as Account_Number,
			  @Name as Name,
			  @MobileNo as MobileNo,
			  @Email as Email

	Last_row:

 

--          COMMIT 
--      END try 

--      BEGIN catch 
--          IF @@TRANCOUNT > 0 
--            DECLARE @sql NVARCHAR(max) 
-----------------------------------Error Message--------------------------------------------------
--          SET @sql = 'ErrorNumber : ' 
--                     + CONVERT(VARCHAR, Error_number()) 
--                     + ' , ErrorSeverity : ' 
--                     + CONVERT(VARCHAR, Error_severity()) 
--                     + '      	, ErrorState : ' 
--                     + CONVERT(VARCHAR, Error_state()) 
--                     + ' , ErrorProcedure : ' 
--                     + CONVERT(VARCHAR, Error_procedure()) 
--                     + '  , ErrorLine : ' 
--                     + CONVERT(VARCHAR, Error_line()) 
--                     + ' , ErrorMessage : ' 
--                     + CONVERT(VARCHAR, Error_message()) 
--                     + ' , Mode : "DataBase" ' 

--          SELECT 0 as ID,@sql AS CustomMessage, 
--                 '1'  AS CustomErrorState
-----------------------------------End Error Message--------------------------------------------------
--          ROLLBACK 
--		  END catch

END