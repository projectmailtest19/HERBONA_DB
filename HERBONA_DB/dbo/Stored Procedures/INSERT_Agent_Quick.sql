 
CREATE PROCEDURE [dbo].[INSERT_Agent_Quick]
@Name	        nvarchar(max)=null, 
@DOB		    date = null, 
@MobileNo		nvarchar(50) = null, 
@Email			nvarchar(max)=null,

@country_id		int=null, 
@state_id		int=null, 
@district_id	int=null,
@pincode		nvarchar(100)=null, 

@Sponsor_Member_ID nvarchar(max),
@Placed_ID bigint=null, 
@Team		nvarchar(100)=null
AS
BEGIN
	 
	SET NOCOUNT ON;


	   SELECT  'Success' AS CustomMessage, 
             '0'  AS CustomErrorState,
			  @Sponsor_Member_ID as Account_Number,
			  @Name as Name,
			  @MobileNo as MobileNo,
			  @Email as Email



     


END