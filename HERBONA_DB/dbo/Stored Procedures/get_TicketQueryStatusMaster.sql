 
CREATE PROCEDURE [dbo].[get_TicketQueryStatusMaster]
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@login_id     bigint=null,
@ID INT = NULL
AS
BEGIN
	 
	SET NOCOUNT ON;

   
select id, name,IsActive 
from TicketQueryStatusMaster
where Company_ID = @Company_ID
and Branch_ID = @Branch_ID 
and IsActive = '1'
AND (@ID IS NULL OR id = @ID)


END