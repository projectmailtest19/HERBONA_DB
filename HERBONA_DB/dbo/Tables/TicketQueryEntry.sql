CREATE TABLE [dbo].[TicketQueryEntry] (
    [id]                        INT             IDENTITY (1, 1) NOT NULL,
    [TicketQueryMasterId]       INT             NULL,
    [TicketQueryReasonMasterId] INT             NULL,
    [TicketQueryStatusMasterId] INT             NULL,
    [TickerNumber]              INT             NULL,
    [TicketDate]                DATETIME        NULL,
    [PayScheduleNo]             INT             NULL,
    [CreditedAmount]            DECIMAL (18, 2) NULL,
    [EstimatedAmount]           DECIMAL (18, 2) NULL,
    [Attatchments]              NVARCHAR (MAX)  NULL,
    [Subject]                   NVARCHAR (MAX)  NULL,
    [IsActive]                  BIT             NULL,
    [CreatedDate]               DATETIME        NULL,
    [CreatedBy]                 INT             NULL,
    [UpdatedDate]               DATETIME        NULL,
    [UpdatedBy]                 INT             NULL,
    [Company_ID]                BIGINT          NULL,
    [Branch_ID]                 BIGINT          NULL,
    [ORDER_NUMBER]              NVARCHAR (MAX)  NULL,
    [Contact_id]                INT             NULL
);

