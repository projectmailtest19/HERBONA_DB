CREATE PROCEDURE [dbo].[GET_ORDER_ENTRY]
@ID bigint  = NULL,
@IsActive bit = 1,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT,
@MEMEBER_ID BIGINT = NULL,
@ORDER_NUMBER nvarchar(max) = null,	
@FROM_ORDER_DATE DATE = NULL,
@TO_ORDER_DATE DATE = NULL
AS
BEGIN
	 
	SET NOCOUNT ON;

SELECT oe.[ID]
      ,MemberID as [MEMEBER_ID]
	  ,ab.Account_Number
      ,oe.[ORDER_DATE]
	  ,oe.ORDER_NUMBER
      ,oe.[INVOICE_DATE]
      ,oe.[INVOICE_NUMBER]
	  ,oe.PAYMENT_STATUS
	  ,ModeOfPayment
      ,oe.[TOTAL_SVP]
      ,oe.[TOTAL_AMOUNT]
      ,oe.[ORDER_TYPE]      
      ,oe.[IsActive]    
	  ,c.Name as [MEMEBER_NAME]
  FROM [ORDER_ENTRY] as oe
  inner join CONTACT as c 
  on c.id = oe.[MEMEBER_ID]
  left join [Agent_Sponsor_Details] as a 
  on c.id = a.Contact_id
  left join [Agent_Bank_Details] as ab
  on c.id = ab.Contact_id
  left join 
  (

SELECT ORDER_ID,ModeOfPayment=STUFF  
(  
     (  
       SELECT DISTINCT ', ' + CAST(p.name AS VARCHAR(MAX))  
       FROM [ORDER_ENTRY_PAYMENT] as t2
	   left join [PAYMENT_MODE] as p
	   on t2.MODE_OF_PAYMENT = p.id    
       WHERE t2.ORDER_ID = t1.ORDER_ID   
       FOR XML PATH('')  
     ),1,1,''  
)  
FROM [ORDER_ENTRY_PAYMENT] as t1
	 left join [PAYMENT_MODE] as p
	 on t1.MODE_OF_PAYMENT = p.id  
GROUP BY ORDER_ID  
  
  ) as m on m.ORDER_ID = oe.id
  WHERE oe.[Company_ID] = @Company_ID
  AND oe.[Branch_ID] = @Branch_ID 
  AND oe.[IsActive] = @IsActive
  AND (@MEMEBER_ID is null or oe.MEMEBER_ID = @MEMEBER_ID)
  AND (@ORDER_NUMBER IS NULL OR oe.ORDER_NUMBER = @ORDER_NUMBER)
  AND (@FROM_ORDER_DATE IS NULL OR convert(date,oe.[ORDER_DATE]) >= @FROM_ORDER_DATE)
  AND (@TO_ORDER_DATE IS NULL OR convert(date,oe.[ORDER_DATE]) <= @TO_ORDER_DATE)
  order by oe.[ORDER_DATE] desc


     
END