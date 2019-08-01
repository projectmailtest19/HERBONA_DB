CREATE PROCEDURE get_TicketQueryReasonMaster
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@login_id     bigint=null,
@TicketQueryMasterId int
AS
BEGIN
	 
	SET NOCOUNT ON;

   
select id, name, PayScheduleNo, CreditedAmount, EstimatedAmount, Comments, orderid, Attatchments, subject
from TicketQueryReasonMaster
where Company_ID = @Company_ID
and Branch_ID = @Branch_ID 
and IsActive = '1'
and TicketQueryMasterId = @TicketQueryMasterId


END