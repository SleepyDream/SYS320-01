function gatherClasses(){
    $page = Invoke-WebRequest -TimeoutSec 2 http://10.0.17.11/Courses.html

    # Get all the tr elements of the HTML document
    $trs=$page.ParsedHtml.body.getElementsByTagName("tr")

    # Empty array to hold results
    $FullTable = @()
    for ($i=0; $i -lt $trs.length; $i++){
        # Get every td element in the current tr element
        $tds = $trs[$i].getElementsByTagName("td")

        $Times = $tds[5].innerText.Split("-")

        $FullTable += [PSCustomObject]@{
            "Class Code" = $tds[0].innerText;
            "Title"      = $tds[1].innerText;
            "Days"       = $tds[4].innerText;
            "Time Start" = $Times[0];
            "Time End"   = $Times[1];
            "Instructor" = $tds[6].innerText;
            "Location"   = $tds[9].innerText;
        }
}
# A function that returns the full table but with the days translated to their full names
function daysTranslator($FullTable){
    for($i=0; $i -lt $FullTable.length; $i++){
        $Days = @()

        if($FullTable[$i].Days -ilike "*M*"){
            $Days += "Monday"
        }
        # If you see "T" followed by T,W, or F -> Tuesday
        if($FullTable[$i].Days -ilike "*T[WF]*"){
            $Days += "Tuesday"
        }
        # If you see "W"  -> Wednesday
        if($FullTable[$i].Days -ilike "*W*"){
            $Days += "Wednesday"
        }
        # If you see "TH" -> Thursday
        if($FullTable[$i].Days -ilike "*TH*"){
            $Days += "Thursday"
        }
        # If you see "F"  -> Friday
        if($FullTable[$i].Days -ilike "*F*"){
            $Days += "Friday"
        }
        # Make the switch
        $FullTable[$i].Days = $Days
    }
    return $FullTable
}
daysTranslator $FullTable
return $FullTable
}