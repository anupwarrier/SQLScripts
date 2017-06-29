select distinct rateplanlevelcostpricelogseqnbr from rateplanlevelcostprice

select distinct logseqnbr from rateplaninventory

select distinct roomtypeinventorylogseqnbr from roomtypeinventory

select distinct rateplanlevelrestrictionlogseqnbr from rateplanlevelrestriction


BEGIN TRAN
UPDATE rateplanlevelrestriction
SET rateplanlevelrestrictionlogseqnbr = 300
WHERE rateplanlevelrestrictionlogseqnbr >300;

COMMIT TRAN
--ROLLBACK TRAN


TRUNCATE TABLE rateplanlevelcostpricelog;
TRUNCATE TABLE rateplaninventoryLog;
TRUNCATE TABLE roomtypeinventorylog;
TRUNCATE TABLE rateplanlevelrestrictionLog;