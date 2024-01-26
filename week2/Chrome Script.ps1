$chromeProcess = Get-Process -Name chrome -ErrorAction SilentlyContinue

if ($chromeProcess) {
    echo "Closing Chrome"
    $chromeProcess | ForEach-Object { $_.CloseMainWindow() | Out-Null }
    $chromeProcess | ForEach-Object { $_.WaitForExit(5000) | Out-Null }
}else{
    echo "Opening Chrome"
    Start-Process "chrome.exe" -ArgumentList "https://www.champlain.edu"
}