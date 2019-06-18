CREATE TABLE [dbo].[ITEM_DETAILS] (
    [ID]                  BIGINT           IDENTITY (1, 1) NOT NULL,
    [CATEGORY_ID]         BIGINT           NULL,
    [NAME]                NVARCHAR (255)   NULL,
    [PBO_PRICE]           DECIMAL (25, 13) NULL,
    [PRODUCT_SVP]         DECIMAL (25, 13) NULL,
    [DISCOUNT_PERCENTAGE] DECIMAL (25, 13) NULL,
    [DISCOUNT_AMOUNT]     DECIMAL (25, 13) NULL,
    [CODE]                NVARCHAR (50)    NULL,
    [GST_ID]              BIGINT           NULL,
    [MRP]                 DECIMAL (25, 13) NULL,
    [SALE_PRICE]          DECIMAL (25, 13) NULL,
    [ImageURL]            NVARCHAR (MAX)   NULL,
    [IsActive]            BIT              NULL,
    [CreatedDate]         DATETIME         NULL,
    [CreatedBy]           INT              NULL,
    [UpdatedDate]         DATETIME         NULL,
    [UpdatedBy]           INT              NULL,
    [Company_ID]          BIGINT           NULL,
    [Branch_ID]           BIGINT           NULL
);

