function getLoginouts($days){

$loginoutslogs = Get-EventLog system -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$days)

$loginoutsTable = @()
for($i=0; $i -lt $loginoutslogs.Count; $i++) {
    $event = ""
    if($loginoutslogs[$i].EventID -eq 7001) {$event = "Logon"}
    if($loginoutslogs[$i].EventID -eq 7002) {$event = "Logoff"}

    $userPID = New-Object System.Security.Principal.SecurityIdentifier($loginoutslogs[$i].ReplacementStrings[1])
    $user = $userPID.Translate([System.Security.Principal.NTAccount])

    $loginoutsTable += [PSCustomObject]@{
    "Time" = $loginoutslogs[$i].TimeGenerated;
    "ID" = $loginoutslogs[$i].EventID;
    "Event"  = $event
    "User" = $user.Value
    }
}
return $loginoutsTable
}


function getPowerOn($days){

$poweronlogs = Get-EventLog system -After (Get-Date).AddDays(-$days) | Where-Object{$_.EventID -eq "6005"}

$poweronTable = @()
for($i=0; $i -lt $poweronlogs.Count; $i++) {
    $poweronTable += [PSCustomObject]@{
    "Time" = $poweronlogs[$i].TimeGenerated;
    "ID" = $poweronlogs[$i].EventID; 
    "Event" = "Startup"  
    "User" = "System"; 
    }
}
return $poweronTable

}


function getPowerOff($days){

$powerofflogs = Get-EventLog system -After (Get-Date).AddDays(-$days) | Where-Object{$_.EventID -eq "6006"}

$poweroffTable = @()
for($i=0; $i -lt $powerofflogs.Count; $i++) {
    $poweroffTable += [PSCustomObject]@{
    "Time" = $powerofflogs[$i].TimeGenerated;
    "ID" = $powerofflogs[$i].EventID; 
    "Event" = "Shutdown"  
    "User" = "System"; 
    }
}
return $poweroffTable

}
