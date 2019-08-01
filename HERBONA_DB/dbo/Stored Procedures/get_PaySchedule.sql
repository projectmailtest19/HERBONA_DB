 
CREATE PROCEDURE get_PaySchedule
@Company_ID   bigint=null,
@Branch_ID    bigint=null,
@login_id     bigint=null
AS
BEGIN
	 
	SET NOCOUNT ON;

   
select p.id,convert(varchar,p.PayScheduleWeek) +' ('+s.session_name+')' as PaySchedule  from PaySchedule as p 
inner join Session as s 
on p.session_id = s.id


END