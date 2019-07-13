 
CREATE PROCEDURE [dbo].[SAVE_ORDER_PAYMENT_DETAILS]
@Order_Details_id bigint,
@UDT_ORDER_PAYMENT_DETAILS UDT_ORDER_PAYMENT_DETAILS READONLY
AS
BEGIN
	 
	SET NOCOUNT ON;

	  SELECT 1                           AS ID, 
             'Payment Successfully Processed' AS CustomMessage, 
             '0'                            AS CustomErrorState 

END