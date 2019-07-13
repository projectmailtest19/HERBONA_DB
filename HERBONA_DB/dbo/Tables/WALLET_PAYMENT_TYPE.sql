CREATE TABLE [dbo].[WALLET_PAYMENT_TYPE] (
    [ID]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [NAME]        NVARCHAR (MAX) NULL,
    [IsActive]    BIT            NULL,
    [CreatedDate] DATETIME       NULL,
    [CreatedBy]   INT            NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   INT            NULL,
    [Company_ID]  BIGINT         NULL,
    [Branch_ID]   BIGINT         NULL
);

