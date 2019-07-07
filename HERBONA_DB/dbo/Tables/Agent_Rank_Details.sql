CREATE TABLE [dbo].[Agent_Rank_Details] (
    [id]          BIGINT   IDENTITY (1, 1) NOT NULL,
    [Contact_id]  INT      NULL,
    [Rank_Id]     INT      NULL,
    [CreatedDate] DATETIME NULL,
    [CreatedBy]   INT      NULL,
    [UpdatedDate] DATETIME NULL,
    [UpdatedBy]   INT      NULL,
    [Company_ID]  BIGINT   NULL,
    [Branch_ID]   BIGINT   NULL
);

