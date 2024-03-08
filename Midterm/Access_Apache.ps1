function getLogs(){
$rawlogs = Get-Content C:\Users\champuser\SYS320-01\Midterm\access.log
$tablerecords = @()

for($i=0; $i -lt $rawlogs.Count; $i++) {
$words = $rawlogs[$i] -split(" ");

$tablerecords += [pscustomobject]@{ "IP" = $words[0];
                                    "Time" = $words[3].Trim('[');
                                    "Method" = $words[5].Trim('"');
                                    "Page" = $words[6];
                                    "Protocol" = $words[7].Trim('"');;
                                    "Responce" = $words[8];
                                    "Referer" = $words[10];
    }
}
return $tablerecords
}

getLogs
