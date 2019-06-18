CREATE procedure [dbo].[GetShipping_Address] 
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@Contact_id   bigint=null
AS
BEGIN
--select * from Contact
	
	SET NOCOUNT ON;

	BEGIN try 
          BEGIN TRANSACTION 

	select  addr.[id], addr.name,
				  addr.addressline, 
                   dm.Name as District_Name, 
                   st.Name as State_Name, 
                   cnt.Name as Country_Name, 
                   addr.pincode,  
				   addr.MobileNo,
                   is_default from [ADDRESS] as addr
				   left join COUNTRY_MASTER as cnt on cnt.id = addr.country_id
	left join STATE_MASTER as st on st.id = addr.state_id
	left join DISTRICT_MASTER as dm on dm.id = addr.district_id	
	 where addr.contact_id=@Contact_id and addr.branch_id=@Branch_ID and addr.company_id=@Company_ID and addr.isactive=1
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