function IOCList() {
$page = Invoke-WebRequest -TimeoutSec 2 http://10.0.17.5/IOC.html

    # Get all the tr elements of the HTML document
    $trs=$page.ParsedHtml.body.getElementsByTagName("tr")

    # Empty array to hold results
    $FullTable = @()
    for ($i=0; $i -lt $trs.length; $i++){
        # Get every td element in the current tr element
        $tds = $trs[$i].getElementsByTagName("td")

        $FullTable += [PSCustomObject]@{
            "Pattern" = $tds[0].innerText;
            "Explanation" = $tds[1].innerText;
        }
}
return $FullTable
}