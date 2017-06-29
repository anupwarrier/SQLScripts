
DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate = DATEADD(hh, -24, getdate()), @EndDate = GETDATE()

SELECT WaitType, SUM(Wait_S) Wait_S, SUM(Resource_S) Resource_S, SUM(Signal_S) Signal_S, SUM(WaitCount) WaitCount,
AvgWait_S = SUM(Wait_S)/SUM(WaitCount), AvgResource_S = SUM(Resource_S)/SUM(WaitCount)
from Waits.WaitStats
WHERE wait_S > 1 
AND CaptureDate > @StartDate AND CaptureDate < @EndDate
GROUP BY WaitType
ORDER BY Wait_S desc

select WaitType, Wait_S, Resource_S, Signal_S, WaitCount, Avg_Wait_S, Avg_Resource_S, Avg_Signal_S, CaptureDate 
from Waits.WaitStats
WHERE wait_S > 1 
ORDER BY CaptureDate desc, Wait_S desc 
 