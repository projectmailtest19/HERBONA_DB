-- get_Bonus_Wallet_Summary 1,2,null
CREATE PROCEDURE get_Bonus_Wallet_Summary
@Company_ID bigint,
@Branch_ID bigint,
@login_id BIGINT,
@FROM_DATE DATE = NULL,
@TO_DATE DATE = NULL
AS
BEGIN
	
	SET NOCOUNT ON;


;WITH tempDebitCredit AS (
select   row_number() over(order by DATE desc) as id,DATE as Transaction_Date,PayShedule,
case when STATUS_CR_DR = 'CR' then isnull(AMOUNT,0) else 0 end as Credited_Amount,
case when STATUS_CR_DR = 'DR' then isnull(AMOUNT,0) else 0 end as Debited_Amount,
(case when STATUS_CR_DR = 'CR' then isnull(AMOUNT,0) else 0 end)-(case when STATUS_CR_DR = 'DR' then isnull(AMOUNT,0) else 0 end) as Balance,
wpt.NAME as Type,DETAILS as Narration from WALLET_BALANCE_HISTORY as wbh
left join WALLET_PAYMENT_TYPE as wpt on wbh.WALLET_PAYMENT_TYPE_ID = wpt.id
where wbh.IsActive = 1
and wpt.NAME in ('FTB Bonus')
and wbh.[Company_ID] = @Company_ID
and wbh.[Branch_ID] = @Branch_ID 
AND (@FROM_DATE IS NULL OR convert(date,wbh.DATE) >= @FROM_DATE)
AND (@TO_DATE IS NULL OR convert(date,wbh.DATE) <= @TO_DATE)
)
SELECT a.Transaction_Date,a.PayShedule,a.Credited_Amount,a.Debited_Amount,SUM(b.Balance) as Balance,a.Type,a.Narration  
FROM   tempDebitCredit a,
       tempDebitCredit b
WHERE b.id >= a.id
GROUP BY a.id,a.Transaction_Date,a.PayShedule,a.Credited_Amount,a.Debited_Amount,a.Type,a.Narration

   
END