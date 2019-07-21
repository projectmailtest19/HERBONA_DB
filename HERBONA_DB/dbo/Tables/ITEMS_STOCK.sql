CREATE TABLE [dbo].[ITEMS_STOCK] (
    [ID]          BIGINT           IDENTITY (1, 1) NOT NULL,
    [ITEM_ID]     BIGINT           NULL,
    [QUANTITY]    DECIMAL (18, 2) NULL,
    [NOTES]       NVARCHAR (MAX)   NULL,
    [IsActive]    BIT              NULL,
    [CreatedDate] DATETIME         NULL,
    [CreatedBy]   INT              NULL,
    [UpdatedDate] DATETIME         NULL,
    [UpdatedBy]   INT              NULL,
    [Company_ID]  BIGINT           NULL,
    [Branch_ID]   BIGINT           NULL
);

