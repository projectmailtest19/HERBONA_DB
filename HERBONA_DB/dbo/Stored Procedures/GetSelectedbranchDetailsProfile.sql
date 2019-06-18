CREATE procedure [dbo].[GetSelectedbranchDetailsProfile] 
@ID int = null
AS
BEGIN
	
	SET NOCOUNT ON;
	
	 BEGIN try 
          BEGIN TRANSACTION 

	select c.ID, c.[Name], c.[Company_ID], [HODName],MobileNo, PhoneNo, Email,cnt.ID as  Country, 
	st.ID as State, City,addr.addressline as  Address, LogoPath, c.IsActive,c.Contact_ID from [branch]  as c
	left join ADDRESS as addr on addr.Contact_Id = c.Contact_Id
	left join COUNTRY_MASTER as cnt on cnt.id = addr.country_id
	left join STATE_MASTER as st on st.id = addr.state_id
	left join DISTRICT_MASTER as dm on dm.id = addr.district_id
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