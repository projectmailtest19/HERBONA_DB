
CREATE PROCEDURE [dbo].[Get_MyDirects]
@company_id int = null,
@branch_id int = null,
@login_id int = null	
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT [Placed_MemberID] as PBO_Account_No,
       [Name],
	   c.[CreatedDate] as RegistrationDate,
	   [Placed_Team] as Position          
  FROM [CONTACT] as c
  left join [Agent_Sponsor_Details] as a 
  on c.id = a.Contact_id
  where [Sponsor_ID] = @login_id or [SplitSponsor_ID] = @login_id 
  order by c.[CreatedDate] 
   
END