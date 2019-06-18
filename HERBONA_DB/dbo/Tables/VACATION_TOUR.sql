CREATE TABLE [dbo].[VACATION_TOUR] (
    [ID]                 BIGINT         IDENTITY (1, 1) NOT NULL,
    [TOUR_NAME]          NVARCHAR (MAX) NULL,
    [LEFT_POINT]         INT            NULL,
    [LEFT_POINT_DETAIL]  NVARCHAR (MAX) NULL,
    [RIGHT_POINT]        INT            NULL,
    [RIGHT_POINT_DETAIL] NVARCHAR (MAX) NULL,
    [IsActive]           BIT            NULL,
    [CreatedDate]        DATETIME       NULL,
    [CreatedBy]          INT            NULL,
    [UpdatedDate]        DATETIME       NULL,
    [UpdatedBy]          INT            NULL,
    [Company_ID]         BIGINT         NULL,
    [Branch_ID]          BIGINT         NULL
);

