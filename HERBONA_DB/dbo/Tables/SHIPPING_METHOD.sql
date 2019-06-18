CREATE TABLE [dbo].[SHIPPING_METHOD] (
    [ID]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [NAME]        NVARCHAR (255) NULL,
    [CODE]        NVARCHAR (50)  NULL,
    [IsActive]    BIT            NULL,
    [CreatedDate] DATETIME       NULL,
    [CreatedBy]   INT            NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   INT            NULL,
    [Company_ID]  BIGINT         NULL,
    [Branch_ID]   BIGINT         NULL
);

