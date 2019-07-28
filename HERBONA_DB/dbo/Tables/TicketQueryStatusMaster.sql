CREATE TABLE [dbo].[TicketQueryStatusMaster] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [name]        NVARCHAR (255) NULL,
    [IsActive]    BIT            NULL,
    [CreatedDate] DATETIME       NULL,
    [CreatedBy]   INT            NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   INT            NULL,
    [Company_ID]  BIGINT         NULL,
    [Branch_ID]   BIGINT         NULL
);

