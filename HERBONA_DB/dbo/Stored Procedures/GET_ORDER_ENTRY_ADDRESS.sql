CREATE PROCEDURE [dbo].[GET_ORDER_ENTRY_ADDRESS]
@ORDER_ID bigint  = NULL,
@IsActive bit = NULL,
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT
AS
BEGIN
	 
	SET NOCOUNT ON;

SELECT [BILLING_ADDRESS_ID]
      ,[SHIPPING_ADDRESS_ID]     
      ,OE.[IsActive]    

	  ,BA.[name] AS BA_name
      ,BA.[addressline] AS BA_addressline
      ,BA.[city] AS BA_city
      ,BA.[district_id] AS BA_district_id
      ,BA.[state_id] AS BA_state_id
      ,BA.[country_id] AS BA_country_id
      ,BA.[pincode] AS BA_pincode
      ,BA.[MobileNo] AS BA_MobileNo
      ,BA.[PhoneNo] AS BA_PhoneNo
      ,BA.[Email] AS BA_Email
      ,BA.[Contact_id] AS BA_Contact_id

	  ,SA.[name] AS SA_name
      ,SA.[addressline] AS SA_addressline
      ,SA.[city] AS SA_city
      ,SA.[district_id] AS SA_district_id
      ,SA.[state_id] AS SA_state_id
      ,SA.[country_id] AS SA_country_id
      ,SA.[pincode] AS SA_pincode
      ,SA.[MobileNo] AS SA_MobileNo
      ,SA.[PhoneNo] AS SA_PhoneNo
      ,SA.[Email] AS SA_Email
      ,SA.[Contact_id] AS SA_Contact_id

  FROM [ORDER_ENTRY] AS OE

  LEFT JOIN [ADDRESS] AS BA ON OE.[BILLING_ADDRESS_ID] = BA.id
  LEFT JOIN [ADDRESS] AS SA ON OE.[SHIPPING_ADDRESS_ID] = SA.id

  WHERE OE.[Company_ID] = @Company_ID
  AND OE.[Branch_ID] = @Branch_ID 
  AND OE.[IsActive] = @IsActive 
  AND OE.ID = @ORDER_ID

     
END