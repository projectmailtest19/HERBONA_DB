CREATE TABLE [dbo].[TBL_BUSINESSMASTER] (
    [TRANS_NO]  INT             NOT NULL,
    [ASSID]     INT             NOT NULL,
    [FOR_ID]    INT             NULL,
    [AMOUNT]    DECIMAL (18, 2) NOT NULL,
    [BUSS_TYPE] NVARCHAR (10)   NOT NULL,
    [STATUS]    NVARCHAR (10)   NOT NULL,
    [DATE]      DATE            NULL,
    [PAYMENTID] INT             NULL
);

