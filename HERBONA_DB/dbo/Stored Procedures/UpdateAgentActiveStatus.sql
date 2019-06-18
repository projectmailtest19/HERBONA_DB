CREATE procedure [dbo].[UpdateAgentActiveStatus]
@ID           bigint 

AS
BEGIN
--select * from Contact
	
	SET NOCOUNT ON;

	BEGIN try 
          BEGIN TRANSACTION 
declare @AgentActiveStatus bit
	set @AgentActiveStatus=( select IsAgentActive 
	from Contact
	where ID=@ID)

	if (@AgentActiveStatus=1)
	begin
	update CONTACT set IsAgentActive=0 where  ID=@ID
	end
	else
	begin
	update CONTACT set IsAgentActive=1 where  ID=@ID
	end

	SELECT @ID AS ID,'Status Successfully Updated' AS CustomMessage,'0' AS CustomErrorState
	
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