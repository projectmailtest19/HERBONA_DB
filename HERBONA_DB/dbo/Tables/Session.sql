CREATE TABLE [dbo].[Session] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [Session_Name] NVARCHAR (100) NULL,
    [from_date]    DATE           NULL,
    [to_date]      DATE           NULL
);

