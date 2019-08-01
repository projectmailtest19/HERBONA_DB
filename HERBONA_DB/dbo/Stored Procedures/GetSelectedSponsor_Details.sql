CREATE procedure [dbo].[GetSelectedSponsor_Details]
@id   bigint=null
AS
BEGIN
--select * from Contact
	
	SET NOCOUNT ON;

	BEGIN try 
          BEGIN TRANSACTION 

	  select  c.MobileNo,c.Name,s.MemberID
      from CONTACT as c  
	  inner join Agent_Sponsor_Details as s on s.Contact_id=c.ID
	  where c.[IsActive]=1 and c.[ID]=@id
	
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