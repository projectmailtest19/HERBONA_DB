
CREATE PROCEDURE [dbo].[Get_Rank_History]
@company_id int = null,
@branch_id int = null,
@login_id int = null	
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT '1' as Sno,
	     MemberID as [MEMEBER_ID],
         c.[Name],
	     c.[CreatedDate] as Registration_Date,
	     rr.NAME as   Designation,
		 r.CreatedDate as Designation_Date
  FROM [CONTACT] as c
  left join [Agent_Sponsor_Details] as a 
  on c.id = a.Contact_id
  left join 
  (
  select top 1 contact_id,CreatedDate,rank_id from  [Agent_Rank_Details]
  order by CreatedDate desc
  ) as r
  on c.id = r.contact_id
  left join RANK_REWARD as rr 
  on rr.id = r.rank_id
  where c.id = @login_id 
  order by c.[CreatedDate] 

		   
END