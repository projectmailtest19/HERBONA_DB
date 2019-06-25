-- [GetAgentIDCardDetails] 1,2,10008
CREATE procedure [dbo].[GetAgentIDCardDetails]
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@ID           bigint=null
AS
BEGIN
--select * from Contact
	
	SET NOCOUNT ON;

	BEGIN try 
          BEGIN TRANSACTION 

	select c.ID, c.Name,ABD.Account_Number,c.ImageURL,CM.NAME as Countey_Name, SM.NAME as State_Name,DM.NAME as District_Name,ABD.[Pan_No],CONVERT(VARCHAR(10),DATEADD(year,2,c.[CreatedDate]),103) as Valid_Upto
	from Contact c
	inner join ADDRESS as addr on addr.Contact_Id = c.ID
	inner join Agent_Bank_Details as ABD on ABD.[Contact_id]=c.ID
	inner join Country_Master as CM on CM.ID=addr.country_id
	inner join State_Master as Sm on Sm.ID=addr.state_id
	inner join District_Master as DM on Dm.Id=addr.district_id
	where c.IsActive=1 and c.Company_ID=@Company_ID and c.Branch_ID=@Branch_ID
	and addr.is_default = 1 and c.IsAgent=1 and c.ID=isnull(nullif(@ID,''),c.ID) order by c.ID desc
	
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