--- [TicketQueryReasonMaster_Select] 2 , 6 , 1 , 2
create PROCEDURE [dbo].[TicketQueryReasonMaster_Select] 
(
   @TicketID	INT = NULL,
   @ID			INT = NULL,
   @Company_ID	bigint  = NULL,
   @Branch_ID	bigint  = NULL
)
AS 
BEGIN
  
    IF(@TicketID IS NOT NULL)
	BEGIN
		 SELECT 
			* 
		 FROM 
			TicketQueryReasonMaster 
		 WHERE 
		    ID = ISNULL(@ID,ID) AND TicketQueryMasterId = ISNULL(@TicketID,TicketQueryMasterId) AND Branch_ID=ISNULL(@Branch_ID,Branch_ID) AND Company_ID=ISNULL(@Company_ID,Company_ID)
	 END
	 ELSE
	 BEGIN
	      SELECT 
			* 
		 FROM 
			TicketQueryReasonMaster 
		 WHERE 
		    ID = ISNULL(@ID,ID) --AND Branch_ID=ISNULL(@ID,Branch_ID) AND Company_ID=ISNULL(@ID,Company_ID)
	 END	
END