
create PROCEDURE [dbo].[TicketQueryMaster_Select]
(
   @ID			INT = NULL,
   @Company_ID	bigint  = NULL,
   @Branch_ID	bigint  = NULL
)
AS 
BEGIN
     SELECT 
		* 
	 FROM 
		TicketQueryMaster 
	WHERE 
	    ID = ISNULL(@ID,ID) AND Branch_ID=ISNULL(@ID,Branch_ID) AND Company_ID=ISNULL(@ID,Company_ID) AND IsActive=1
		
END