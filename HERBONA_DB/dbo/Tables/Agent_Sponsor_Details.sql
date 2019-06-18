CREATE TABLE [dbo].[Agent_Sponsor_Details] (
    [id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [Contact_id]      INT            NULL,
    [Sponsor_ID]      BIGINT         NULL,
    [Placed_Name]     NVARCHAR (MAX) NULL,
    [Placed_MemberID] NVARCHAR (MAX) NULL,
    [Placed_Team]     NVARCHAR (MAX) NULL,
    [SplitSponsor_ID] BIGINT         NULL,
    [IsActive]        BIT            NULL,
    [CreatedDate]     DATETIME       NULL,
    [CreatedBy]       INT            NULL,
    [UpdatedDate]     DATETIME       NULL,
    [UpdatedBy]       INT            NULL,
    [Company_ID]      BIGINT         NULL,
    [Branch_ID]       BIGINT         NULL
);

