-- [GET_MEMBER_WALLET_BALANCE] 7
CREATE PROCEDURE [dbo].[GET_MEMBER_WALLET_BALANCE]
@Order_Details_id bigint 
AS
BEGIN
	 
	SET NOCOUNT ON;

	declare @member_id int 

	select @member_id = member_id from [dbo].[Order_Details]
	where id = @Order_Details_id


	select isnull(sum(case when STATUS_CR_DR = 'CR' then AMOUNT
	            when STATUS_CR_DR = 'DR' then AMOUNT * -1
				end),0) as Wallet_Balance	
	from [dbo].[WALLET] as w
	inner join [WALLET_BALANCE_HISTORY] as wb
	on w.id = wb.wallet_id
	where w.MEMBER_ID = @member_id

END