-- [GetAgentPersonalDetails] 1,2
CREATE procedure [dbo].[GetAgentPersonalDetails]
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@ID           bigint=null
AS
BEGIN
--select * from Contact
	
	SET NOCOUNT ON;

	BEGIN try 
          BEGIN TRANSACTION 

	select c.ID, c.Name, c.MobileNo, c.Email, c.Gender,c.ImageURL,addr.country_id, addr.state_id,addr.district_id,
     addr.addressline as Address,addr.pincode,   c.IsAgentActive 
	from Contact c
	inner join ADDRESS as addr on addr.Contact_Id = c.ID	
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