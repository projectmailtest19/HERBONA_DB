
CREATE PROCEDURE [dbo].[Get_MyDirects]
@company_id int = null,
@branch_id int = null,
@login_id int = null	
AS
BEGIN
	
	SET NOCOUNT ON;


	select '8808904983' as PBO_Account_No,
	       'Maniram sharma' as Name,
		   '02/06/2018' as DOA,
		   'Team-A' as Position
   
END