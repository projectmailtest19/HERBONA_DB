CREATE procedure [dbo].[CU_PERMISSION]
(
@ID VARCHAR(20) = null,
@MenuID VARCHAR(20),
@RoleID VARCHAR(20),
@B_Add VARCHAR(20),
@B_Edit VARCHAR(20),
@B_Delete VARCHAR(20),
@B_View VARCHAR(20),
@B_Payment VARCHAR(20),
@BRANCH_ID bigint  =null,
@COMPANY_ID bigint =null
)
AS
BEGIN

SET NOCOUNT ON;

	 BEGIN try 
          BEGIN TRANSACTION 

            DELETE FROM ROLE_PERMISSION WHERE	MenuID = @MenuID AND RoleID = @RoleID AND Branch_Id=@BRANCH_ID AND Company_Id=@COMPANY_ID 
			INSERT INTO ROLE_PERMISSION(MenuID,
											RoleID,
											B_Add,
											B_Edit,
											B_Delete,
											B_View,
											B_Payment,
											Company_Id,
											Branch_Id)
									VALUES (@MenuID,
											@RoleID,
											@B_Add,
											@B_Edit,
											@B_Delete,
											@B_View,
											@B_Payment,
											@Company_Id,
											@Branch_Id)
											

					 SELECT @@IDENTITY                   AS ID, 
                       'Successfully Updated' AS CustomMessage, 
                       '0'                          AS CustomErrorState 


	COMMIT 
      END try 

      BEGIN catch 
          IF @@TRANCOUNT > 0 
            DECLARE @sql NVARCHAR(max) 

          SET @sql = 'ErrorNumber : ' 
                     + CONVERT(VARCHAR, Error_number()) 
                     + ' , ErrorSeverity : ' 
                     + CONVERT(VARCHAR, Error_severity()) 
                     + '      	, ErrorState : ' 
                     + CONVERT(VARCHAR, Error_state()) 
                     + ' , ErrorProcedure : ' 
                     + CONVERT(VARCHAR, Error_procedure()) 
                     + '  , ErrorLine : ' 
                     + CONVERT(VARCHAR, Error_line()) 
                     + ' , ErrorMessage : ' 
                     + CONVERT(VARCHAR, Error_message()) 
                     + ' , Mode : "DataBase" ' 

          SELECT @sql AS CustomMessage, 
                 '1'  AS CustomErrorState 

          ROLLBACK 
		  END catch

   

END