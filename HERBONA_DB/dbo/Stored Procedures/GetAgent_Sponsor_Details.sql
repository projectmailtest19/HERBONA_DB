-- [GetAgent_Sponsor_Details] 1
CREATE procedure [dbo].[GetAgent_Sponsor_Details]
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@Contact_id   bigint=null
AS
BEGIN
--select * from Contact
	
	SET NOCOUNT ON;

	BEGIN try 
          BEGIN TRANSACTION 

	select  [id]
      ,[Contact_id]
      ,Sponsor_Contact_Id      
      ,MemberID
      ,[Placed_Team]
	  ,Placed_Contact_Id from Agent_Sponsor_Details where [IsActive]=1 and [Contact_id]=@Contact_id and [Company_ID]=@Company_ID and [Branch_ID]=@Branch_ID
	
          COMMIT 
      END try 

      BEGIN catch 
          IF @@TRANCOUNT > 0 
            DECLARE @sql NVARCHAR(max) 

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

          ROLLBACK 
		  END catch

END