CREATE TABLE [dbo].[WALLET] (
    [ID]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [MEMBER_ID]     BIGINT         NULL,
    [WALLET_NUMBER] NVARCHAR (MAX) NULL,
    [IsActive]      BIT            NULL,
    [CreatedDate]   DATETIME       NULL,
    [CreatedBy]     INT            NULL,
    [UpdatedDate]   DATETIME       NULL,
    [UpdatedBy]     INT            NULL,
    [Company_ID]    BIGINT         NULL,
    [Branch_ID]     BIGINT         NULL
);

