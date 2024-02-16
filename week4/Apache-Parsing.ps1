function ApacheLogs1() {
$logsnotformatted = Get-Content C:\xampp\apache\logs\access.log
$tablerecords = @()

for($i=0; $i -lt $logsnotformatted.Count; $i++) {
$words = $logsnotformatted[$i] -split(" ");

$tablerecords += [pscustomobject]@{ "IP" = $words[0];
                                    "Time" = $words[3].Trim('[');
                                    "Method" = $words[5].Trim('"');
                                    "Page" = $words[6];
                                    "Protocol" = $words[7].Trim('"');;
                                    "Responce" = $words[8];
                                    "Referer" = $words[10];
                                    "Client" = $words[11..($words.Length-1)]; }
}
return $tablerecords | Where-Object { $_.IP -ilike "10.*" }
}
$tablerecords = ApacheLogs1
$tablerecords | Format-Table -AutoSize -Wrap