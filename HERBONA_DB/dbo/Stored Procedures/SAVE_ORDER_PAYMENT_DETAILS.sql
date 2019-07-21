 
CREATE PROCEDURE [dbo].[SAVE_ORDER_PAYMENT_DETAILS]
@Order_Details_id bigint,
@UDT_ORDER_PAYMENT_DETAILS UDT_ORDER_PAYMENT_DETAILS READONLY
AS
BEGIN
	 
	SET NOCOUNT ON;

	declare @INVOICE_DATE datetime,
	        @INVOICE_NUMBER nvarchar(50),
			@Order_ID int,
			@MEMBER_ID int,
			@WALLET_ID int,
			@Company_ID int,
			@Branch_ID int,
			@ORDER_ENTRY_PAYMENT_ID int,
			@WALLET_PAYMENT_TYPE_ID int,
			@WALLET_AMOUNT decimal(18,2),
			@ORDER_NUMBER nvarchar(max)

	set @INVOICE_DATE = getutcdate()
    set @INVOICE_NUMBER = 'INV'+convert(varchar,CAST(round(RAND()*1000000000000000,0) AS bigint))


	select @Order_ID = Order_ID,
	       @MEMBER_ID = Member_Id,
		   @Company_ID = Company_ID,
		   @Branch_ID = Branch_ID from Order_Details where id = @Order_Details_id


	SELECT @WALLET_ID = [ID]      
    FROM [WALLET]  
    where [MEMBER_ID] = @MEMBER_ID

    select @WALLET_PAYMENT_TYPE_ID = id from WALLET_PAYMENT_TYPE 
    where name = 'Wallet Purchase'


	update [ORDER_ENTRY] set [INVOICE_DATE] = @INVOICE_DATE
      ,[INVOICE_NUMBER] = @INVOICE_NUMBER
	  , [PAYMENT_STATUS] = 'Success'
	where id = @Order_ID

	select @ORDER_NUMBER = ORDER_NUMBER from [ORDER_ENTRY]
	where id = @Order_ID


	insert into [ORDER_ENTRY_PAYMENT](ORDER_ID, AMOUNT, MODE_OF_PAYMENT, PAYMET_DATE, IsActive, CreatedDate, Company_ID, Branch_ID)
	select @Order_ID,AMOUNT,p.id,@INVOICE_DATE,1,@INVOICE_DATE,@Company_ID,@Branch_ID  from @UDT_ORDER_PAYMENT_DETAILS as u
	inner join [PAYMENT_MODE] as p on p.name = u.name 


	select  @ORDER_ENTRY_PAYMENT_ID = o.id,
	        @WALLET_AMOUNT = amount from [ORDER_ENTRY_PAYMENT] as o
	inner join [PAYMENT_MODE] as p on o.MODE_OF_PAYMENT = p.id
	 where ORDER_ID = @Order_ID and p.name = 'Wallet'


	insert into [WALLET_BALANCE_HISTORY] (DATE, AMOUNT, STATUS_CR_DR, DETAILS, IsActive, CreatedDate, Company_ID, Branch_ID, WALLET_ID, ORDER_ENTRY_PAYMENT_ID, WALLET_PAYMENT_TYPE_ID)
	values(@INVOICE_DATE,@WALLET_AMOUNT,'DR','Wallet Purchase for order number: '+@ORDER_NUMBER,1,@INVOICE_DATE,@Company_ID,@Branch_ID,@WALLET_ID,@ORDER_ENTRY_PAYMENT_ID,@WALLET_PAYMENT_TYPE_ID)

	SELECT 1                           AS ID, 
           'Payment Successfully Processed' AS CustomMessage, 
           '0'                            AS CustomErrorState 

END