CREATE TABLE [dbo].[Agent_Bank_Details] (
    [id]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [Contact_id]          INT            NULL,
    [Account_Holder_Name] NVARCHAR (MAX) NULL,
    [Account_Number]      NVARCHAR (MAX) NULL,
    [Bank_Name]           NVARCHAR (MAX) NULL,
    [Account_Type]        NVARCHAR (MAX) NULL,
    [IFSC_Code]           NVARCHAR (MAX) NULL,
    [Branch_Name]         NVARCHAR (MAX) NULL,
    [Pan_No]              NVARCHAR (MAX) NULL,
    [IsActive]            BIT            NULL,
    [CreatedDate]         DATETIME       NULL,
    [CreatedBy]           INT            NULL,
    [UpdatedDate]         DATETIME       NULL,
    [UpdatedBy]           INT            NULL,
    [Company_ID]          BIGINT         NULL,
    [Branch_ID]           BIGINT         NULL
);

