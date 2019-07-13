CREATE TABLE [dbo].[WALLET_BALANCE_HISTORY] (
    [ID]                     BIGINT           IDENTITY (1, 1) NOT NULL,
    [DATE]                   DATETIME         NULL,
    [AMOUNT]                 DECIMAL (25, 13) NULL,
    [STATUS_CR_DR]           NVARCHAR (10)    NULL,
    [DETAILS]                NVARCHAR (MAX)   NULL,
    [IsActive]               BIT              NULL,
    [CreatedDate]            DATETIME         NULL,
    [CreatedBy]              INT              NULL,
    [UpdatedDate]            DATETIME         NULL,
    [UpdatedBy]              INT              NULL,
    [Company_ID]             BIGINT           NULL,
    [Branch_ID]              BIGINT           NULL,
    [WALLET_ID]              INT              NULL,
    [ORDER_ENTRY_PAYMENT_ID] INT              NULL,
    [WALLET_PAYMENT_TYPE_ID] INT              NULL
);



