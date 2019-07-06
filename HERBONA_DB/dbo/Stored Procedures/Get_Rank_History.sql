
CREATE PROCEDURE [dbo].[Get_Rank_History]
@company_id int = null,
@branch_id int = null,
@login_id int = null	
AS
BEGIN
	
	SET NOCOUNT ON;


	select '1' as Sno,
	       '8167392885' as Account_No,
		   'Maniram sharma' as Name,
		   '5/12/2017 7:08:14 PM' as Registration_Date,
		   'eGOLD' as Designation,
		   '5/15/2017 4:07:31 PM' as Designation_Date
		   
END