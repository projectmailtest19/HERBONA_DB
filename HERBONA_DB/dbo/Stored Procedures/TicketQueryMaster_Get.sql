 
CREATE PROCEDURE [dbo].[TicketQueryMaster_Get] 
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@Login_user_ID  int=null
AS
BEGIN

	SET NOCOUNT ON;


	select id,name from TicketQueryMaster
    where Company_ID = @Company_ID and Branch_ID = @Branch_ID

END