CREATE TYPE [dbo].[UDT_Agent_AddressProof_Details] AS TABLE (
    [id]                 BIGINT         NULL,
    [Contact_id]         INT            NULL,
    [Address_Proof_Type] NVARCHAR (MAX) NULL,
    [Address_Proof_URL]  NVARCHAR (MAX) NULL);

