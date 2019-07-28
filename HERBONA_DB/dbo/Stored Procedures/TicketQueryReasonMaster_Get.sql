 
CREATE PROCEDURE [dbo].[TicketQueryReasonMaster_Get] 
@TicketQueryMasterId int,
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@Login_user_ID  int=null
AS
BEGIN

	SET NOCOUNT ON;


	select id, name, PayScheduleNo, CreditedAmount, EstimatedAmount, Comments, orderid, Attatchments, subject from TicketQueryReasonMaster
    where Company_ID = @Company_ID and Branch_ID = @Branch_ID
	and TicketQueryMasterId = @TicketQueryMasterId
	and IsActive = 1

END