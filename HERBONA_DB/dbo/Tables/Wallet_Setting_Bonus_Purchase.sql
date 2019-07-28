CREATE TABLE [dbo].[Wallet_Setting_Bonus_Purchase] (
    [id]                     INT            IDENTITY (1, 1) NOT NULL,
    [name]                   NVARCHAR (100) NULL,
    [WALLET_PAYMENT_TYPE_ID] NVARCHAR (100) NULL,
    [IsActive]               BIT            NULL,
    [CreatedDate]            DATETIME       NULL,
    [CreatedBy]              INT            NULL,
    [UpdatedDate]            DATETIME       NULL,
    [UpdatedBy]              INT            NULL,
    [Company_ID]             BIGINT         NULL,
    [Branch_ID]              BIGINT         NULL
);

