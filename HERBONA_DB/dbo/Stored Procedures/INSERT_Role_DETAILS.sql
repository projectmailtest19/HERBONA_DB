CREATE procedure [dbo].[INSERT_Role_DETAILS]
@ID				nvarchar(max)=null,
@Name	        nvarchar(max)=null, 
@Short_Name	   nvarchar(max) = null, 
@Description		nvarchar(max) = null, 
@MODE			varchar(10)=null,
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@Login_user_ID  nvarchar(max)=null
AS
BEGIN
	SET NOCOUNT ON;

	 BEGIN try 
          BEGIN TRANSACTION 

	IF(@MODE = 'INSERT')
	BEGIN

-----------------------------------------validation for insert-------------------------------------------
	 IF EXISTS (SELECT Name FROM Role
					WHERE Name=@Name and  Company_ID=@Company_ID and Branch_ID=@Branch_ID  and IsActive=1)
					BEGIN
					SELECT 'Right Already Exists' AS CustomMessage, 
                       '2'                   AS CustomErrorState 

					   GOTO Last_row;

					END       
----------------------------------End validation for insert---------------------------------------------

--------------------------------Role table Insert--------------------------------	

		INSERT INTO [Role](Name, Short_Name, Description,  IsActive, CreatedDate, CreatedBy,Company_ID,Branch_ID)
		values(@Name,@Short_Name,@Description,1, GETDATE(), @Login_user_ID,@Company_ID,@Branch_ID)
--------------------------------End Role table Insert--------------------------------

-------------------------------- Role permission table Insert--------------------------------

		 insert into [ROLE_PERMISSION] ([MenuID],[RoleID],[B_Add],[B_Edit],[B_Delete],[B_View],[B_Payment],[Prient],[Status],[Company_Id],[Branch_Id])
		 select [MenuID],@ID,[B_Add],[B_Edit],[B_Delete],[B_View],[B_Payment],[Prient],[Status],@COMPANY_ID,@BRANCH_ID from [ROLE_PERMISSION]
		 where RoleID=1

-------------------------------- End Role permission table Insert--------------------------------
---------------------------------Success message for insert--------------------------------------------------
		  SELECT @@IDENTITY                   AS ID, 
                       'Right Successfully Inserted' AS CustomMessage, 
                       '0'                          AS CustomErrorState 

---------------------------------End Success message for insert--------------------------------------------------

	END
	IF(@ID IS not NUll and @MODE= 'UPDATE')
	BEGIN

	-----------------------------------------validation for Dudate-------------------------------------------
	 IF EXISTS (SELECT Name FROM Role
					WHERE Name=@Name and  Company_ID=@Company_ID and Branch_ID=@Branch_ID and ID!=@ID  and IsActive=1)
					BEGIN
					SELECT 'Right Already Exists' AS CustomMessage, 
                       '2'                   AS CustomErrorState 

					   GOTO Last_row;

					END       
----------------------------------End validation for Dpdate---------------------------------------------
--------------------------------Role table update--------------------------------
		UPDATE [Role] SET
			Name = @Name, 
			Short_Name = @Short_Name, 
			Description = @Description,			
			UpdatedDate = GETDATE(), 
			UpdatedBy = @Login_user_ID
			where ID = @ID
--------------------------------End Role table update--------------------------------

---------------------------------Success message for update--------------------------------------------------
			SELECT @ID                   AS ID, 
                       'Right Successfully Updated' AS CustomMessage, 
                       '0'                          AS CustomErrorState 
---------------------------------End Success message for update--------------------------------------------------
	END
	IF(@ID IS not NUll and @MODE= 'DELETE')
	BEGIN

--------------------------------Role table delete--------------------------------
		UPDATE [Role] SET
			IsActive = 0,
			UpdatedDate = GETDATE(), 
			UpdatedBy = @Login_user_ID
			where ID = @ID
--------------------------------End Role table delete--------------------------------

--------------------------------Success Message for delete--------------------------------
			SELECT @ID                   AS ID, 
                       'Right Successfully Deleted' AS CustomMessage, 
                       '0'                          AS CustomErrorState 
--------------------------------End Success Message for delete--------------------------------
	END

	Last_row:

          COMMIT 
      END try 

      BEGIN catch 
          IF @@TRANCOUNT > 0 
            DECLARE @sql NVARCHAR(max) 
---------------------------------Error Message--------------------------------------------------
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
---------------------------------End Error Message--------------------------------------------------
          ROLLBACK 
		  END catch

END