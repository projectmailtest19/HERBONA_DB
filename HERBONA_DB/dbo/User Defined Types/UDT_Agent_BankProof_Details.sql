CREATE TYPE [dbo].[UDT_Agent_BankProof_Details] AS TABLE (
    [id]              BIGINT         NULL,
    [Contact_id]      INT            NULL,
    [Bank_Proof_Type] NVARCHAR (MAX) NULL,
    [Bank_Proof_URL]  NVARCHAR (MAX) NULL);

