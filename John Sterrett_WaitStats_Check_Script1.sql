/*
Could use Azure Automation, Azure Functions, App Service Web Jobs
*/
DECLARE @EndTime datetime, @WaitSeconds int
SELECT @EndTime = DATEADD(MINUTE, 300, getdate()),
       @WaitSeconds = 60
 
EXEC Waits.GetWaitStats
    @WaitTimeSec = @WaitSeconds,
    @StopTime = @EndTime

--TRUNCATE TABLE Waits.WaitStats
