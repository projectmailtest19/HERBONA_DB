 
CREATE PROCEDURE get_TicketQueryMaster
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@login_id     bigint=null
AS
BEGIN
	 
	SET NOCOUNT ON;

   
select id, name 
from TicketQueryMaster
where Company_ID = @Company_ID
and Branch_ID = @Branch_ID 
and IsActive = '1'


END