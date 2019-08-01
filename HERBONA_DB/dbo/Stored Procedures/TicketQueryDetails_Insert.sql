CREATE PROCEDURE [dbo].[TicketQueryDetails_Insert]
@TicketQueryStatusMasterId int = NULL,
@TickerNumber int = NULL,
@Comments nvarchar(max) = NULL,
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@login_id  int=null
AS
BEGIN

	SET NOCOUNT ON;

	declare @TicketQueryEntryId int = null,
	        @TicketQueryEntryDetails int = null,
			@AssignedTO int = null

	select @AssignedTO = Contact_Id from branch where id = @Branch_ID


	select @TicketQueryEntryId = id from TicketQueryEntry where TickerNumber = @TickerNumber

	if(@login_id = @AssignedTO)
	begin

	  select @AssignedTO = Contact_id from TicketQueryEntry where id = @TicketQueryEntryId

	end
	

	update TicketQueryEntry set TicketQueryStatusMasterId = isnull(@TicketQueryStatusMasterId,TicketQueryStatusMasterId),updateddate=   getdate(),updatedby = @login_id where id = @TicketQueryEntryId

	select top 1 @TicketQueryEntryDetails = id  from TicketQueryEntryDetails where TicketQueryEntryId = @TicketQueryEntryId order by 1 desc

	update TicketQueryEntryDetails set AnsweredBy = @login_id where id = @TicketQueryEntryDetails


	if exists(select * from TicketQueryStatusMaster where id = @TicketQueryStatusMasterId and name = 'Resolved')
	begin

		insert into TicketQueryEntryDetails (TicketQueryEntryId, AssignedTO, AnsweredBy, ActionPendingFrom, Comments, IsActive, CreatedDate, CreatedBy, Company_ID, Branch_ID)
	    values(@TicketQueryEntryId,@AssignedTO,null,null,@Comments,'1',getutcdate(),@login_id,@Company_ID,@Branch_ID)

	end
	else
	begin

		insert into TicketQueryEntryDetails (TicketQueryEntryId, AssignedTO, AnsweredBy, ActionPendingFrom, Comments, IsActive, CreatedDate, CreatedBy, Company_ID, Branch_ID)
	    values(@TicketQueryEntryId,@AssignedTO,null,@AssignedTO,@Comments,'1',getutcdate(),@login_id,@Company_ID,@Branch_ID)

	end



		select  '0' as CustomErrorState,'sucess' as CustomMessage  


   
END