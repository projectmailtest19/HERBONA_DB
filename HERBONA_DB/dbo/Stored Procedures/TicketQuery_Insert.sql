CREATE PROCEDURE TicketQuery_Insert
@TicketQueryMasterId int = NULL,
@TicketQueryReasonMasterId int = NULL,
@Contact_id int = NULL,
@PayScheduleNo int = NULL,
@CreditedAmount decimal(18, 2) = NULL,
@EstimatedAmount decimal(18, 2) = NULL,
@ORDER_NUMBER nvarchar(max) = NULL,
@Attatchments nvarchar(max) = NULL,
@Subject nvarchar(max) = NULL,
@Comments nvarchar(max) = NULL,
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@Login_user_ID  int=null
AS
BEGIN

	SET NOCOUNT ON;

	declare @TicketQueryStatusMasterId int = NULL,
	        @TickerNumber int = NULL,
			@TicketQueryEntryId int,
			@AssignedTO int = NULL 


	select @TicketQueryStatusMasterId = id from TicketQueryStatusMaster where name = 'Active'
	
    select @AssignedTO = Contact_Id from branch where id = @Branch_ID


	insert into TicketQueryEntry (TicketQueryMasterId, TicketQueryReasonMasterId, TicketQueryStatusMasterId, Contact_id, TickerNumber, TicketDate, PayScheduleNo, CreditedAmount, EstimatedAmount,ORDER_NUMBER, Attatchments, Subject, IsActive,
	 CreatedDate, CreatedBy,Company_ID, Branch_ID)
	values(@TicketQueryMasterId,@TicketQueryReasonMasterId,@TicketQueryStatusMasterId,@Contact_id,null,getutcdate(),@PayScheduleNo,@CreditedAmount,@EstimatedAmount,@ORDER_NUMBER,@Attatchments,@Subject,'1',
	 getutcdate(),@Login_user_ID,@Company_ID,@Branch_ID)

    set @TicketQueryEntryId = @@identity

	update TicketQueryEntry set TickerNumber = @TicketQueryEntryId where id = @TicketQueryEntryId 


	insert into TicketQueryEntryDetails (TicketQueryEntryId, AssignedTO, AnsweredBy, ActionPendingFrom, Comments, IsActive, CreatedDate, CreatedBy, Company_ID, Branch_ID)
	values(@TicketQueryEntryId,@AssignedTO,null,@AssignedTO,@Comments,'1',getutcdate(),@Login_user_ID,@Company_ID,@Branch_ID)




   
END