-- GET_MEMBER 1,2
CREATE PROCEDURE GET_MEMBER
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@ID           bigint=null
AS
BEGIN
 
	SET NOCOUNT ON;

   
	select c.ID, c.Name, c.MobileNo, c.Email, c.Gender,c.ImageURL,c.IsAgentActive 
	from Contact c
	where c.IsActive=1 and c.Company_ID=@Company_ID and c.Branch_ID=@Branch_ID
	and c.IsAgent=1 and c.ID=isnull(nullif(@ID,''),c.ID) order by c.ID desc

END