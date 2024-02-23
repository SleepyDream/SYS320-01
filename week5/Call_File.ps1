# Call the getClasses function from the HTML.ps1 file
. (Join-Path $PSScriptRoot HTML.ps1)

Clear-Host

# Make a list of all instructors that teach at least 1 courses in
# SYS, SEC, NET, FOR, CSI, and DAT
# Sort by name, and make it unique
$ITSInstructors = gatherClasses | Where-Object { ($_."Class Code" -match "SYS*") -or `
                                                ($_."Class Code" -match "SEC*") -or `
                                                ($_."Class Code" -match "NET*") -or `
                                                ($_."Class Code" -match "FOR*") -or `
                                                ($_."Class Code" -match "CSI*") -or `
                                                ($_."Class Code" -match "DAT*") } `
                    | Sort-Object -Property Instructor -Unique `
                    | Select-Object "Instructor" -Unique
# Group all the instructors by the number of classes they are teaching
gatherClasses | Where-Object { $_.Instructor -in $ITSInstructors.Instructor } `
                | Group-Object "Instructor" | Sort-Object Count,Name | Sort-Object Count -Descending
                                                
