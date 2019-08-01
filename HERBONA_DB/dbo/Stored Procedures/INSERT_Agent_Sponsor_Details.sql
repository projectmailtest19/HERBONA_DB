CREATE procedure [dbo].[INSERT_Agent_Sponsor_Details]
@Contact_id		int=null,
@Sponsor_Contact_Id bigint=null,
@Placed_Contact_Id bigint=null,
@Placed_Team nvarchar(10),

@MODE			varchar(10)=null,
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@Login_user_ID  int=null
AS
BEGIN
	SET NOCOUNT ON;

	 BEGIN try 
          BEGIN TRANSACTION 


declare @MaxChildNode hierarchyid
 declare @rank_id int

IF( @MODE = 'INSERT' ) 
  BEGIN 


  if exists(select * from Agent_Sponsor_Details where Placed_Contact_Id = @Placed_Contact_Id and Placed_Team = @Placed_Team)
  begin

    SELECT 0 as ID,'Placed Member already has Enterpreneur on the Placed Team' AS CustomMessage, 
                 '2'  AS CustomErrorState

	goto Last_row;

  end

   


  Declare @MemberID nvarchar(max)
  set  @MemberID = CAST(round(RAND()*1000000000,0) AS BIGINT)

      ------------------------------ Contact table insert------------------------------------   
      INSERT INTO Agent_Sponsor_Details 
                  (Contact_id, Placed_Team, IsActive, CreatedDate, CreatedBy, Company_ID, Branch_ID, MemberID, Placed_Contact_Id, Sponsor_Contact_Id) 
      VALUES      (@Contact_id, @Placed_Team, 1, Getdate(), @Login_user_ID, @Company_ID, @Branch_ID ,@MemberID ,@Placed_Contact_Id,@Sponsor_Contact_Id) 


        IF (@Placed_Team = 'L')
        BEGIN
          SELECT
            @MaxChildNode = CAST((AdvisorHierarchyNode.ToString() + '1/') AS hierarchyid)
          FROM Organisation
          WHERE ASSID = @Placed_Contact_Id
        END

        ELSE
        BEGIN
          SELECT
            @MaxChildNode = CAST((AdvisorHierarchyNode.ToString() + '2/') AS hierarchyid)
          FROM Organisation
          WHERE ASSID = @Placed_Contact_Id
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


      -------------------------------End Contact table insert------------------------------------   
    
      SELECT @@IDENTITY                      AS ID, 
             'Agent Sponsor Details Successfully Inserted' AS CustomMessage, 
             '0'                             AS CustomErrorState 

  ---------------------------------End Success message for insert-------------------------------------------------- 
  END 

IF(@MODE = 'UPDATE' ) 
  BEGIN 

      ------------------------------ Contact table update------------------------------------   
      UPDATE Agent_Sponsor_Details 
      SET   
	  --Placed_Team = @Placed_Team,  
	  updateddate = Getdate(), 
      updatedby = @Login_user_ID
	  --Placed_Contact_Id = Placed_Contact_Id, 
	  --Sponsor_Contact_Id  = @Sponsor_Contact_Id  
	
      WHERE  [Contact_id] = @Contact_ID 


	  if not exists(select * from [Agent_Rank_Details] 
	       where contact_id = @Contact_id and Company_ID = @Company_ID and Branch_ID = @Branch_ID)
	  begin	     

		  select top 1 @rank_id = [ID] from  [RANK_REWARD]
		  where name ='HBO'
          order by id

		  insert into [Agent_Rank_Details](Contact_id, Rank_Id, CreatedDate, Company_ID, Branch_ID)
		  values(@Contact_id,@rank_id,getutcdate(), @Company_ID, 
                   @Branch_ID)


	  end


   
      ---------------------------------Success message for update-------------------------------------------------- 
      SELECT id                            AS ID, 
             'Agent Sponsor Details Successfully Updated' AS CustomMessage, 
             '0'                            AS CustomErrorState from Agent_Sponsor_Details where [Contact_id] = @Contact_ID 
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

          SELECT 0 as ID,@sql AS CustomMessage, 
                 '1'  AS CustomErrorState
---------------------------------End Error Message--------------------------------------------------
          ROLLBACK 
		  END catch

END