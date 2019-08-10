create PROCEDURE [dbo].[WALLET_PAYMENT_TYPE_Select]    
(  
   --@ID   INT = NULL,  
   @Company_ID bigint  = NULL,  
   @Branch_ID bigint  = NULL  
)  
AS   
BEGIN  
     SELECT   
  *   
  FROM   
  WALLET_PAYMENT_TYPE   
 WHERE   
      Branch_ID=ISNULL(@Branch_ID,Branch_ID) AND Company_ID=ISNULL(@Company_ID,Company_ID) AND IsActive=1  
    
END