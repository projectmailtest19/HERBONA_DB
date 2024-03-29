﻿CREATE procedure [dbo].[GetALLSponsor_FreeSide]
@Company_ID   bigint=null,
@Branch_ID    bigint=null
AS
BEGIN
--select * from Contact
	
	SET NOCOUNT ON;

	BEGIN try 
          BEGIN TRANSACTION 

           select ID,Name from [Organisation] as o 
		   inner join Contact as c on c.id = o.ASSID
           where IsActive=1 and Company_ID=@Company_ID and Branch_ID=@Branch_ID  
		   and c.id not in (select Placed_Contact_Id from (
                                 select count(Placed_Contact_Id) as cnt,Placed_Contact_Id from Agent_Sponsor_Details  
                                 group by Placed_Contact_Id   
                              ) as c where c.cnt >= 2
							)
		   
		   order by ID desc

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