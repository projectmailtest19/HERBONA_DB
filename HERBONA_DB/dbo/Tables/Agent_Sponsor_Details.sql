CREATE TABLE [dbo].[Agent_Sponsor_Details] (
    [id]                 BIGINT         IDENTITY (1, 1) NOT NULL,
    [Contact_id]         INT            NULL,
    [Placed_Team]        NVARCHAR (MAX) NULL,
    [IsActive]           BIT            NULL,
    [CreatedDate]        DATETIME       NULL,
    [CreatedBy]          INT            NULL,
    [UpdatedDate]        DATETIME       NULL,
    [UpdatedBy]          INT            NULL,
    [Company_ID]         BIGINT         NULL,
    [Branch_ID]          BIGINT         NULL,
    [MemberID]           NVARCHAR (100) NULL,
    [Placed_Contact_Id]  INT            NULL,
    [Sponsor_Contact_Id] INT            NULL
);



