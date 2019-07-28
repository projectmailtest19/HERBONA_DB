CREATE PROCEDURE [dbo].[TicketView_Get]
@TickerNumber nvarchar(100),
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@Login_user_ID  int=null
AS
BEGIN
	
	SET NOCOUNT ON;

	select  TickerNumber, TicketDate,tqm.name as TicketLabel,tqrm.name as QueryType,tqsm.name as Staus,	
	   tqe.PayScheduleNo, tqe.CreditedAmount, tqe.EstimatedAmount, tqe.Attatchments, tqe.Subject, tqe.ORDER_NUMBER,
	   ans_by.AnsweredBy,assg_to.AssignedTO,assg_to.ActionPendingFrom
	from TicketQueryEntry as tqe 
	left join TicketQueryMaster as tqm on tqe.TicketQueryMasterId = tqm.id
	left join TicketQueryReasonMaster as tqrm on tqe.TicketQueryReasonMasterId = tqrm.id
	left join TicketQueryStatusMaster as tqsm on tqe.TicketQueryStatusMasterId = tqsm.id
	left join 
	(
	    select TicketQueryEntryId, AnsweredBy from (
	       select  TicketQueryEntryId, AnsweredBy,row_number() over(partition by TicketQueryEntryId order by id desc) as rn from TicketQueryEntryDetails 
	       where Company_ID = @Company_ID
	       and  Branch_ID = @Branch_ID 
	        and IsActive = '1'
		) as a where rn=2
	) as ans_by on ans_by.TicketQueryEntryId = tqe.id
	left join 
	(
	  select TicketQueryEntryId, AssignedTO, ActionPendingFrom from (
	      select  TicketQueryEntryId, AssignedTO, ActionPendingFrom,row_number() over(partition by TicketQueryEntryId order by id desc) as rn from TicketQueryEntryDetails 
	      where Company_ID = @Company_ID
	      and  Branch_ID = @Branch_ID 
	      and IsActive = '1'
		) as b where rn=1
	) as assg_to on assg_to.TicketQueryEntryId = tqe.id
	left join TicketQueryEntryDetails as tqed on tqed.TicketQueryEntryId = tqe.id
	where tqe.Company_ID = @Company_ID
	and tqe.Branch_ID = @Branch_ID 
	and tqe.IsActive = '1'	
	and TickerNumber = @TickerNumber
	 
	 select comments,
	 case when AssignedTO = @Login_user_ID then '#F4F6F6'
	 else '#FDEBD0' end as Colour
	 from TicketQueryEntry as tqe 
	 left join TicketQueryEntryDetails as tqed on tqed.TicketQueryEntryId = tqe.id
	 where tqe.Company_ID = @Company_ID
	 and tqe.Branch_ID = @Branch_ID 
	 and tqe.IsActive = '1'	
	 and TickerNumber = @TickerNumber 
	 order by tqed.id 
  
END