
create PROCEDURE [dbo].[TicketQueryReasonMaster_Insert] 
( 
         @ID				int   = null             
		,@TicketID			int
		,@name				nvarchar(1024)
		,@PayScheduleNo		bit
		,@CreditedAmount	bit
		,@EstimatedAmount	bit
		,@Comments			bit
		,@orderid			bit
		,@Attatchments		bit
		,@subject			bit
		,@IsActive			bit 
		,@Company_ID		bigint
		,@Branch_ID			bigint
)
AS 
BEGIN
  BEGIN TRY 
    IF(@ID IS NULL)
	BEGIN
	    INSERT [dbo].[TicketQueryReasonMaster] 
        ( 
			   [TicketQueryMasterId]
			 , [name]
			 , [PayScheduleNo]
			 , [CreditedAmount]
			 , [EstimatedAmount]
			 , [Comments]
			 , [orderid]
			 , [Attatchments]
			 , [subject]
			 , [IsActive]
			 , [CreatedDate] 
			 , [Company_ID]
			 , [Branch_ID]
	    ) 
	     VALUES( @TicketID,@name,@PayScheduleNo ,@CreditedAmount,@EstimatedAmount,@Comments,@orderid ,@Attatchments,@subject,@IsActive,GETDATE(),@Company_ID,@Branch_ID)
	 END
	 ELSE
	 BEGIN
	     UPDATE [dbo].[TicketQueryReasonMaster] 
         SET
			   [TicketQueryMasterId] = @TicketID
			 , [name] =@name
			 , [PayScheduleNo] = @PayScheduleNo
			 , [CreditedAmount] = @CreditedAmount
			 , [EstimatedAmount] = @EstimatedAmount
			 , [Comments] = @Comments
			 , [orderid] = @orderid
			 , [Attatchments] = @Attatchments
			 , [subject] = @subject
			 , [IsActive] = @IsActive  
			 , [UpdatedDate] = GETDATE() 
		  WHERE
			   ID = @ID AND [Company_ID] = @Company_ID AND  [Branch_ID] = @Branch_ID
	    
	 END	
	 SELECT 'Sucess' AS SQL_Message, 0 AS ERROR
  END TRY
  BEGIN CATCH 
    SELECT ERROR_MESSAGE() AS SQL_Message, 1 AS ERROR
  END CATCH
END