CREATE TABLE [dbo].[Agent_BankProof_Details] (
    [id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [Contact_id]      INT            NULL,
    [Bank_Proof_Type] NVARCHAR (MAX) NULL,
    [Bank_Proof_URL]  NVARCHAR (MAX) NULL,
    [IsActive]        BIT            NULL,
    [CreatedDate]     DATETIME       NULL,
    [CreatedBy]       INT            NULL,
    [UpdatedDate]     DATETIME       NULL,
    [UpdatedBy]       INT            NULL,
    [Company_ID]      BIGINT         NULL,
    [Branch_ID]       BIGINT         NULL
);

