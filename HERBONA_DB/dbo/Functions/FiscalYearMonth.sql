CREATE FUNCTION FiscalYearMonth
(
    @DAT datetime

)
RETURNS int
AS
BEGIN

    DECLARE @TAXY as int;
    DECLARE @R as int;

    SET @TAXY = YEAR(dateadd(month,-3,@dat));
    DECLARE @TDAT as  varchar(8) 

    SET @TDAT = CAST(@TAXY AS varchar(4)) + '0401';

    SELECT @R = datediff(day,  DATEADD(day , (8 - DATEPART(DW,@TDAT)) % 7,@TDAT), dateadd(day,14,@DAT)) / 7;

    RETURN @R;

END