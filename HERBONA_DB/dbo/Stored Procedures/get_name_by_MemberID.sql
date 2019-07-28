-- get_name_by_MemberID 7852136495
CREATE PROCEDURE [dbo].[get_name_by_MemberID] 
	@Placed_MemberID nvarchar(max) 
AS
BEGIN
	 
	SET NOCOUNT ON;

    select c.name,c.Company_ID,c.Branch_ID from [dbo].[Agent_Sponsor_Details] as asd 
    inner join contact as c on asd.contact_id = c.id
    where Placed_MemberID = @Placed_MemberID


END