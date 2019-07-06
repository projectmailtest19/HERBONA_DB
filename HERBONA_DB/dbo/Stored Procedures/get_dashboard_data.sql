
CREATE PROCEDURE get_dashboard_data
@company_id int = null,
@branch_id int = null,
@login_id int = null	
AS
BEGIN
	
	SET NOCOUNT ON;


	select '13500' as personal_purchase_invoice,
	       '2018-11-27' as next_due_date_repurchase,
		   '100' as current_payschedule_purchase,
		   '4000' as total_ftb,
		   '4000' as total_tlb,
		   '800' as total_dplx,
		   '200' as total_rab,
		   '226.94' as car_travel_fund,
		   '500.26' as house_fund,
		   '125.22' as leadership_bonus,
		   '456.25' as elite_ranking_bonus,
		   '10500' as retail_profit,
		   'STAR' as current_rank_tittle,
		   '12' as no_of_directs
   
END