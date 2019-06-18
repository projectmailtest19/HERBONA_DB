CREATE TABLE [dbo].[RANK_REWARD] (
    [ID]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [NAME]           NVARCHAR (MAX) NULL,
    [START]          INT            NULL,
    [LEFT_SIDE]      INT            NULL,
    [RIGHT_SIDE]     INT            NULL,
    [REWARDS_DETAIL] NVARCHAR (MAX) NULL,
    [IsActive]       BIT            NULL,
    [CreatedDate]    DATETIME       NULL,
    [CreatedBy]      INT            NULL,
    [UpdatedDate]    DATETIME       NULL,
    [UpdatedBy]      INT            NULL,
    [Company_ID]     BIGINT         NULL,
    [Branch_ID]      BIGINT         NULL
);

