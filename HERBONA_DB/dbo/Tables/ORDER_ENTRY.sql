CREATE TABLE [dbo].[ORDER_ENTRY] (
    [ID]                  BIGINT           IDENTITY (1, 1) NOT NULL,
    [MEMEBER_ID]          BIGINT           NULL,
    [ORDER_DATE]          DATETIME         NULL,
    [INVOICE_DATE]        DATETIME         NULL,
    [INVOICE_NUMBER]      NVARCHAR (255)   NULL,
    [TOTAL_SVP]           DECIMAL (25, 13) NULL,
    [TOTAL_AMOUNT]        DECIMAL (25, 13) NULL,
    [ORDER_TYPE]          NVARCHAR (50)    NULL,
    [PAYMENT_STATUS]      NVARCHAR (50)    NULL,
    [BILLING_ADDRESS_ID]  BIGINT           NULL,
    [SHIPPING_ADDRESS_ID] BIGINT           NULL,
    [IsActive]            BIT              NULL,
    [CreatedDate]         DATETIME         NULL,
    [CreatedBy]           INT              NULL,
    [UpdatedDate]         DATETIME         NULL,
    [UpdatedBy]           INT              NULL,
    [Company_ID]          BIGINT           NULL,
    [Branch_ID]           BIGINT           NULL,
    [ORDER_NUMBER]        NVARCHAR (MAX)   NULL
);

