$stoppedServices = Get-Service | Where-Object { $_.Status -eq 'Stopped' }

$sortedServices = $stoppedServices | Sort-Object -Property Name

$sortedServices | Export-Csv -Path 'C:\Users\champuser\SYS320-01\week2\output.csv' -NoTypeInformation