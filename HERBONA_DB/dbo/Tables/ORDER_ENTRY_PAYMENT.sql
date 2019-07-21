CREATE TABLE [dbo].[ORDER_ENTRY_PAYMENT] (
    [ID]                 BIGINT           IDENTITY (1, 1) NOT NULL,
    [ORDER_ID]           BIGINT           NULL,
    [AMOUNT]             DECIMAL (18, 2) NULL,
    [MODE_OF_PAYMENT]    BIGINT           NULL,
    [PAYMET_DATE]        DATETIME         NULL,
    [CREDIT_CARD_NUMBER] NVARCHAR (255)   NULL,
    [CARD_EXPIRY_DATE]   NVARCHAR (50)    NULL,
    [BANK_NAME]          NVARCHAR (255)   NULL,
    [ACCOUNT_NUMBER]     NVARCHAR (255)   NULL,
    [IsActive]           BIT              NULL,
    [CreatedDate]        DATETIME         NULL,
    [CreatedBy]          INT              NULL,
    [UpdatedDate]        DATETIME         NULL,
    [UpdatedBy]          INT              NULL,
    [Company_ID]         BIGINT           NULL,
    [Branch_ID]          BIGINT           NULL
);



