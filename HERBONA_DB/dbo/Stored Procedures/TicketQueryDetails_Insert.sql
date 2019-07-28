CREATE PROCEDURE [dbo].[TicketQueryDetails_Insert]
@TicketQueryStatusMasterId int = NULL,
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
			@AssignedTO int = null

	select @AssignedTO = Contact_Id from branch where id = @Branch_ID


	select @TicketQueryEntryId = id from TicketQueryEntry where TickerNumber = @TickerNumber

	if(@Login_user_ID = @AssignedTO)
	begin

	  select @AssignedTO = Contact_id from TicketQueryEntry where id = @TicketQueryEntryId

	end
	

	update TicketQueryEntry set TicketQueryStatusMasterId = isnull(@TicketQueryStatusMasterId,TicketQueryStatusMasterId),updateddate=   getdate(),updatedby = @Login_user_ID where id = @TicketQueryEntryId

	select top 1 @TicketQueryEntryDetails = id  from TicketQueryEntryDetails where TicketQueryEntryId = @TicketQueryEntryId order by 1 desc

	update TicketQueryEntryDetails set AnsweredBy = @Login_user_ID where id = @TicketQueryEntryDetails


	if exists(select * from TicketQueryStatusMaster where id = @TicketQueryStatusMasterId and name = 'Resolved')
	begin

		insert into TicketQueryEntryDetails (TicketQueryEntryId, AssignedTO, AnsweredBy, ActionPendingFrom, Comments, IsActive, CreatedDate, CreatedBy, Company_ID, Branch_ID)
	    values(@TicketQueryEntryId,@AssignedTO,null,null,@Comments,'1',getutcdate(),@Login_user_ID,@Company_ID,@Branch_ID)

	end
	else
	begin

		insert into TicketQueryEntryDetails (TicketQueryEntryId, AssignedTO, AnsweredBy, ActionPendingFrom, Comments, IsActive, CreatedDate, CreatedBy, Company_ID, Branch_ID)
	    values(@TicketQueryEntryId,@AssignedTO,null,@AssignedTO,@Comments,'1',getutcdate(),@Login_user_ID,@Company_ID,@Branch_ID)

	end






   
END