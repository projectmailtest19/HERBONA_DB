CREATE TABLE [dbo].[Session] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [Session_Name] NVARCHAR (100) NULL,
    [from_date]    DATE           NULL,
    [to_date]      DATE           NULL,
    [IsActive]     BIT            NULL,
    [CreatedDate]  DATETIME       NULL,
    [CreatedBy]    INT            NULL,
    [UpdatedDate]  DATETIME       NULL,
    [UpdatedBy]    INT            NULL,
    [Company_ID]   BIGINT         NULL,
    [Branch_ID]    BIGINT         NULL
);



