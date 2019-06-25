CREATE TABLE [dbo].[Order_Details] (
    [ID]                BIGINT   IDENTITY (1, 1) NOT NULL,
    [Member_Id]         BIGINT   NULL,
    [Order_ID]          BIGINT   NULL,
    [Address_ID]        BIGINT   NULL,
    [ShippingMethod_ID] BIGINT   NULL,
    [IsActive]          BIT      NULL,
    [CreatedDate]       DATETIME NULL,
    [CreatedBy]         INT      NULL,
    [UpdatedDate]       DATETIME NULL,
    [UpdatedBy]         INT      NULL,
    [Company_ID]        BIGINT   NULL,
    [Branch_ID]         BIGINT   NULL
);

