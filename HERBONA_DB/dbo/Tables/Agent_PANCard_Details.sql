CREATE TABLE [dbo].[Agent_PANCard_Details] (
    [id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Contact_id]  INT            NULL,
    [PANCard_URL] NVARCHAR (MAX) NULL,
    [IsActive]    BIT            NULL,
    [CreatedDate] DATETIME       NULL,
    [CreatedBy]   INT            NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   INT            NULL,
    [Company_ID]  BIGINT         NULL,
    [Branch_ID]   BIGINT         NULL
);

