 
CREATE PROCEDURE [dbo].[SAVE_ORDER_PAYMENT_DETAILS]
@Order_Details_id bigint,
@UDT_ORDER_PAYMENT_DETAILS UDT_ORDER_PAYMENT_DETAILS READONLY
AS
BEGIN
	 
	SET NOCOUNT ON;

	select * into AA from @UDT_ORDER_PAYMENT_DETAILS

	  SELECT 1                           AS ID, 
             'Payment Successfully Processed' AS CustomMessage, 
             '0'                            AS CustomErrorState 

END