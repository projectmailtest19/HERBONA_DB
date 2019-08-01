
CREATE PROCEDURE [dbo].[Get_MyDirects]
@company_id int = null,
@branch_id int = null,
@login_id int = null	
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT MemberID as MemberID,
       [Name],
	   c.[CreatedDate] as RegistrationDate,
	   [Placed_Team] as Position          
  FROM [CONTACT] as c
  left join [Agent_Sponsor_Details] as a 
  on c.id = a.Contact_id
  where Sponsor_Contact_Id = @login_id   or Placed_Contact_Id = @login_id 
  order by c.[CreatedDate] 
   
END