CREATE TABLE [dbo].[Organisation] (
    [ASSID]                 INT                 NOT NULL,
    [AdvisorHierarchyNode]  [sys].[hierarchyid] NOT NULL,
    [AdvisorHierarchyLevel] AS                  ([AdvisorHierarchyNode].[GetLevel]()) PERSISTED,
    CONSTRAINT [PK_Organisation] PRIMARY KEY CLUSTERED ([ASSID] ASC)
);

