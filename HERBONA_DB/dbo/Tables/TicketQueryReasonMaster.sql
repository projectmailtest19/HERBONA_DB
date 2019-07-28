CREATE TABLE [dbo].[TicketQueryReasonMaster] (
    [id]                  INT            IDENTITY (1, 1) NOT NULL,
    [TicketQueryMasterId] INT            NULL,
    [name]                NVARCHAR (255) NULL,
    [PayScheduleNo]       BIT            NULL,
    [CreditedAmount]      BIT            NULL,
    [EstimatedAmount]     BIT            NULL,
    [Comments]            BIT            NULL,
    [orderid]             BIT            NULL,
    [Attatchments]        BIT            NULL,
    [subject]             BIT            NULL,
    [IsActive]            BIT            NULL,
    [CreatedDate]         DATETIME       NULL,
    [CreatedBy]           INT            NULL,
    [UpdatedDate]         DATETIME       NULL,
    [UpdatedBy]           INT            NULL,
    [Company_ID]          BIGINT         NULL,
    [Branch_ID]           BIGINT         NULL
);

