CREATE TABLE [dbo].[TicketQueryEntryDetails] (
    [id]                 INT            IDENTITY (1, 1) NOT NULL,
    [TicketQueryEntryId] INT            NULL,
    [AssignedTO]         INT            NULL,
    [AnsweredBy]         INT            NULL,
    [ActionPendingFrom]  INT            NULL,
    [Comments]           NVARCHAR (MAX) NULL,
    [IsActive]           BIT            NULL,
    [CreatedDate]        DATETIME       NULL,
    [CreatedBy]          INT            NULL,
    [UpdatedDate]        DATETIME       NULL,
    [UpdatedBy]          INT            NULL,
    [Company_ID]         BIGINT         NULL,
    [Branch_ID]          BIGINT         NULL
);

