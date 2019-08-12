
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
	   case when [Placed_Team] = 'L' then 'Team - A'
	        when [Placed_Team] = 'R' then 'Team - B' end  as Position,
	   case when IsItemOrdered = 0 or IsItemOrdered is null then 'R'
	        when IsItemOrdered = 1 then 'A'
			when IsItemOrdered = 2 then 'DA'
	   end as Status          
  FROM [CONTACT] as c
  left join [Agent_Sponsor_Details] as a 
  on c.id = a.Contact_id
  where Sponsor_Contact_Id = @login_id   or Placed_Contact_Id = @login_id 
  order by c.[CreatedDate] 
   
END