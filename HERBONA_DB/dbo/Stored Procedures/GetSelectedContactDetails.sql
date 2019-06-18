CREATE procedure [dbo].[GetSelectedContactDetails] 
@ID int = null
AS
BEGIN
	
	SET NOCOUNT ON;

	 BEGIN try 
          BEGIN TRANSACTION 

	select c.ID, c.Name, RoleId, c.MobileNo, c.PhoneNo, c.Email, Password,cnt.id as  Country, 
	st.id as State , City, addr.addressline as  Address, c.IsActive,ImageURL as LogoPath from Contact as c
	left join ADDRESS as addr on addr.Contact_Id = c.ID
	left join COUNTRY_MASTER as cnt on cnt.id = addr.country_id
	left join STATE_MASTER as st on st.id = addr.state_id
	left join DISTRICT_MASTER as dm on dm.id = addr.district_id	
	inner join ROLE as r on r.ID = c.RoleId
	where c.ID = @ID
	
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