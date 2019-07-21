CREATE TABLE [dbo].[ORDER_ENTRY_ITEMS] (
    [ID]                  BIGINT           IDENTITY (1, 1) NOT NULL,
    [ORDER_ID]            BIGINT           NULL,
    [ITEM_ID]             BIGINT           NULL,
    [QUANTITY]            DECIMAL (18, 2) NULL,
    [CATEGORY_ID]         BIGINT           NULL,
    [PBO_PRICE]           DECIMAL (18, 2) NULL,
    [PRODUCT_SVP]         DECIMAL (18, 2) NULL,
    [DISCOUNT_PERCENTAGE] DECIMAL (18, 2) NULL,
    [DISCOUNT_AMOUNT]     DECIMAL (18, 2) NULL,
    [GST_ID]              BIGINT           NULL,
    [MRP]                 DECIMAL (18, 2) NULL,
    [SALE_PRICE]          DECIMAL (18, 2) NULL,
    [IsActive]            BIT              NULL,
    [CreatedDate]         DATETIME         NULL,
    [CreatedBy]           INT              NULL,
    [UpdatedDate]         DATETIME         NULL,
    [UpdatedBy]           INT              NULL,
    [Company_ID]          BIGINT           NULL,
    [Branch_ID]           BIGINT           NULL
);

