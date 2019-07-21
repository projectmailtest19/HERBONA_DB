CREATE TABLE [dbo].[SHIPPING_CHARGES] (
    [ID]                BIGINT           IDENTITY (1, 1) NOT NULL,
    [DISTRICT_ID]       BIGINT           NULL,
    [CHARGE_PERCENTAGE] DECIMAL (18, 2) NULL,
    [CHARGE_AMOUNT]     DECIMAL (18, 2) NULL,
    [IsActive]          BIT              NULL,
    [CreatedDate]       DATETIME         NULL,
    [CreatedBy]         INT              NULL,
    [UpdatedDate]       DATETIME         NULL,
    [UpdatedBy]         INT              NULL,
    [Company_ID]        BIGINT           NULL,
    [Branch_ID]         BIGINT           NULL
);

