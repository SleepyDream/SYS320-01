. (Join-Path $PSScriptRoot IOC-Scrape.ps1)
. (Join-Path $PSScriptRoot Access_Apache.ps1)

Clear-Host

# Get the IOC list
$IOCList = IOCList
 # Get the Apache logs
$ApacheLogs = getLogs

# Compare the logs to the IOC list and display logs that match
foreach ($log in $ApacheLogs) {
    foreach ($ioc in $IOCList) {
        if ($log.Page -match $ioc.Pattern) {
            $IOCLogs += [PSCustomObject]@{
                "IP" = $log.IP;
                "Time" = $log.Time;
                "Method" = $log.Method;
                "Page" = $log.Page;
                "Protocol" = $log.Protocol;
                "Responce" = $log.Responce;
                "Referer" = $log.Referer;
            }
    }
}
}
$IOCLogs





