# $regex = [regex] "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"

function Get-Logs($page, $httpcode, $browser) { 
$logs = Get-Content C:\xampp\apache\logs\access.log | Select-String -Pattern "Get /$page" | Select-String -Pattern $httpcode | Select-String -Pattern $browser

$regex = [regex] "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"

$ipsunorganized = $regex.Matches($logs)

$ips = @()
for($i=0; $i -lt $ipsunorganized.Count; $i++) {
    $ips += [pscustomobject]@{ "IP" = $ipsunorganized[$i].Value; }
    }
$ipsoften = $ips | Where-Object {$_.IP -ilike "10.*" }
$counts = $ipsoften | Group IP
$counts | Select-Object Count, Name
}
