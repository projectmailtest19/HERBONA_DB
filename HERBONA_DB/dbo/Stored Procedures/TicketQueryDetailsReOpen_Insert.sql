CREATE PROCEDURE [dbo].[TicketQueryDetailsReOpen_Insert]
@TickerNumber int = NULL,
@Comments nvarchar(max) = NULL,
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@Login_user_ID  int=null
AS
BEGIN

	SET NOCOUNT ON;

	declare @TicketQueryEntryId int = null,
	        @TicketQueryEntryDetails int = null,
			@AssignedTO int = null,
			@TicketQueryStatusMasterId  int = null

	select @AssignedTO = Contact_Id from branch where id = @Branch_ID


	select @TicketQueryEntryId = id from TicketQueryEntry where TickerNumber = @TickerNumber

		
	select @TicketQueryStatusMasterId = id from TicketQueryStatusMaster where name = 'Active'



	update TicketQueryEntry set TicketQueryStatusMasterId = isnull(@TicketQueryStatusMasterId,TicketQueryStatusMasterId),updateddate=   getdate(),updatedby = @Login_user_ID where id = @TicketQueryEntryId

	--select top 1 @TicketQueryEntryDetails = id  from TicketQueryEntryDetails where TicketQueryEntryId = @TicketQueryEntryId order by 1 desc

	--update TicketQueryEntryDetails set AnsweredBy = @Login_user_ID where id = @TicketQueryEntryDetails
	

	insert into TicketQueryEntryDetails (TicketQueryEntryId, AssignedTO, AnsweredBy, ActionPendingFrom, Comments, IsActive, CreatedDate, CreatedBy, Company_ID, Branch_ID)
	values(@TicketQueryEntryId,@AssignedTO,null,@AssignedTO,@Comments,'1',getutcdate(),@Login_user_ID,@Company_ID,@Branch_ID)

	   
END