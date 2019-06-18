CREATE procedure [dbo].[INSERT_Agent_AddressProof_Details]
@UDT_Agent_AddressProof_Details UDT_Agent_AddressProof_Details READONLY,
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@Login_user_ID  int=null,
@Contact_id int=null
AS
BEGIN
	SET NOCOUNT ON;

	 BEGIN try 
          BEGIN TRANSACTION 

MERGE Agent_AddressProof_Details AS T
USING (
SELECT [id],
	   [Contact_id],
	   [Address_Proof_Type],
	   [Address_Proof_URL] 
  FROM @UDT_Agent_AddressProof_Details
) AS S
ON T.id=S.id and T.[Contact_id]=S.[Contact_id]
WHEN NOT MATCHED BY TARGET
    THEN INSERT(
	   [Contact_id],
	   [Address_Proof_Type],
	   [Address_Proof_URL],
	   [CreatedDate],
	   [CreatedBy],	  
	   [isActive],
	   [Branch_ID],
	   [Company_ID]
	   )
	    VALUES(
	   S.[Contact_id]      
      ,S.[Address_Proof_Type]
	  ,S.[Address_Proof_URL]
	  ,GetDate()
      ,@Login_user_ID 
	  ,1  
      ,@Branch_ID
      ,@Company_ID
     )
WHEN MATCHED THEN 
     UPDATE SET
	   T.[Contact_id]=S.[Contact_id]     
      ,T.[Address_Proof_Type]=S.[Address_Proof_Type]  
	  ,T.[Address_Proof_URL]=S.[Address_Proof_URL]  
	  ,T.[UpdatedDate]=GetDate()   
      ,T.[UpdatedBy]=@Login_user_ID 
	     
WHEN NOT MATCHED BY SOURCE and T.[Branch_ID]=@Branch_ID and  T.[Company_ID]=@Company_ID and T.[Contact_id]=@Contact_id THEN
    UPDATE SET
	   T.[isActive]=0   
	   ,T.[UpdatedDate]=GetDate()   
      ,T.[UpdatedBy]=@Login_user_ID 
     ;
	 select 'success' as CustomMessage,'0' as CustomErrorState
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