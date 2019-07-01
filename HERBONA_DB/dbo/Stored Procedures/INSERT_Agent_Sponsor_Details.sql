CREATE procedure [dbo].[INSERT_Agent_Sponsor_Details]
@Contact_id		int=null,
@Sponsor_ID bigint=null,
@Placed_Name       nvarchar(max)=null,
@SplitSponsor_ID bigint=null, 
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


IF( @MODE = 'INSERT' ) 
  BEGIN 
  Declare @Placed_MemberID nvarchar(max), @Placed_Team nvarchar(max)
  set  @Placed_MemberID = CAST(round(RAND()*10000000000000000,0) AS BIGINT)

  if not exists(select * from Agent_Sponsor_Details where [Sponsor_ID] = @Sponsor_ID)
  begin 

  set @Placed_Team = 'L'

  end
  else
  begin

  set @Placed_Team = 'R'

  end


      ------------------------------ Contact table insert------------------------------------   
      INSERT INTO Agent_Sponsor_Details 
                  ([Contact_id]
      ,[Sponsor_ID]
      ,[Placed_Name]
      ,[Placed_MemberID]
      ,[Placed_Team]
	  ,[SplitSponsor_ID]
      ,[IsActive]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[Company_ID]
      ,[Branch_ID]) 
      VALUES      (@Contact_id, 
                   @Sponsor_ID, 
                   @Placed_Name, 
                   @Placed_MemberID, 
				   @Placed_Team,
				   @SplitSponsor_ID,
                   1, 
                   Getdate(), 
                   @Login_user_ID, 
                   @Company_ID, 
                   @Branch_ID) 


        IF (@Placed_Team = 'L')
        BEGIN
          SELECT
            @MaxChildNode = CAST((AdvisorHierarchyNode.ToString() + '1/') AS hierarchyid)
          FROM Organisation
          WHERE ASSID = @Sponsor_ID
        END

        ELSE
        BEGIN
          SELECT
            @MaxChildNode = CAST((AdvisorHierarchyNode.ToString() + '2/') AS hierarchyid)
          FROM Organisation
          WHERE ASSID = @Sponsor_ID
        END


        INSERT Organisation (ASSID, AdvisorHierarchyNode)
          VALUES (@Contact_id, @MaxChildNode)

		  insert TBL_PAIRMASTER (ASSID,PAIR,LEFT_CHILD,RIGHT_CHILD) values (@Contact_id,0,0,0)				


		  exec [pair]


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
      SET    [Sponsor_ID] = @Sponsor_ID, 
			 [Placed_Name] =@Placed_Name,
			 --[Placed_MemberID] =@Placed_MemberID,
			 --[Placed_Team] =@Placed_Team,
			 [SplitSponsor_ID]=@SplitSponsor_ID,
             updateddate = Getdate(), 
             updatedby = @Login_user_ID 
      WHERE  [Contact_id] = @Contact_ID 

   
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