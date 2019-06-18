CREATE TABLE [dbo].[ORDER_ENTRY_ITEMS] (
    [ID]                  BIGINT           IDENTITY (1, 1) NOT NULL,
    [ORDER_ID]            BIGINT           NULL,
    [ITEM_ID]             BIGINT           NULL,
    [QUANTITY]            DECIMAL (25, 13) NULL,
    [CATEGORY_ID]         BIGINT           NULL,
    [PBO_PRICE]           DECIMAL (25, 13) NULL,
    [PRODUCT_SVP]         DECIMAL (25, 13) NULL,
    [DISCOUNT_PERCENTAGE] DECIMAL (25, 13) NULL,
    [DISCOUNT_AMOUNT]     DECIMAL (25, 13) NULL,
    [GST_ID]              BIGINT           NULL,
    [MRP]                 DECIMAL (25, 13) NULL,
    [SALE_PRICE]          DECIMAL (25, 13) NULL,
    [IsActive]            BIT              NULL,
    [CreatedDate]         DATETIME         NULL,
    [CreatedBy]           INT              NULL,
    [UpdatedDate]         DATETIME         NULL,
    [UpdatedBy]           INT              NULL,
    [Company_ID]          BIGINT           NULL,
    [Branch_ID]           BIGINT           NULL
);

