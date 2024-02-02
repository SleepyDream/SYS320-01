. (Join-Path $PSScriptRoot Event_logging.ps1)

clear

$loginoutTable = getLoginouts(15)
$loginoutTable

$startupTable = getPowerOn(15)
$startupTable

$shutdownTable = getPowerOff(15)
$shutdownTable