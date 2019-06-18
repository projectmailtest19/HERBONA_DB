CREATE TABLE [dbo].[GST] (
    [ID]              BIGINT           IDENTITY (1, 1) NOT NULL,
    [CGST_PERCENTAGE] DECIMAL (25, 13) NULL,
    [SGST_PERCENTAGE] DECIMAL (25, 13) NULL,
    [IGST_PERCENTAGE] DECIMAL (25, 13) NULL,
    [IsActive]        BIT              NULL,
    [CreatedDate]     DATETIME         NULL,
    [CreatedBy]       INT              NULL,
    [UpdatedDate]     DATETIME         NULL,
    [UpdatedBy]       INT              NULL,
    [Company_ID]      BIGINT           NULL,
    [Branch_ID]       BIGINT           NULL
);

