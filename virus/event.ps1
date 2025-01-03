$currentPID = $PID
$duplicateProcess = Get-Process -Name "powershell" | Where-Object { $_.Id -ne $currentPID -and $_.CommandLine -match $MyInvocation.MyCommand.Path }

if ($duplicateProcess.Count -gt 1) {
    Write-Output "Triplicate found. Terminating new process..."
    exit 1
}




$folder = "C:\Users\$env:USERNAME\AppData\Local\Temp\"
$filter = "*.LOG"
#$currentProcessName = (Get-Process -Id (Get-Process -Name "powershell" | Select-Object -ExpandProperty Id)).Name
$duplicateProcess = Get-Process | Where-Object {
    $_.Name -eq $currentProcessName -and $_.Id -ne (Get-Process -Name "powershell" | Select-Object -ExpandProperty Id)
}
$Watcher = New-Object IO.FileSystemWatcher $folder, $filter -Property @{ 
    IncludeSubdirectories = $false
    NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
}
$onCreated = Register-ObjectEvent $Watcher -EventName Created -SourceIdentifier FileCreated -Action {
   $path = $Event.SourceEventArgs.FullPath
   $name = $Event.SourceEventArgs.Name
   $changeType = $Event.SourceEventArgs.ChangeType
   $timeStamp = $Event.TimeGenerated
   Write-Host "The file '$name' was $changeType at $timeStamp"
   Write-Host $path
   #Move-Item $path -Destination $destination -Force -Verbose
}

Function Register-Watcher {
    param ($folder)
    $filter = "*.*" #all files
    $watcher = New-Object IO.FileSystemWatcher $folder, $filter -Property @{ 
        IncludeSubdirectories = $false
        EnableRaisingEvents = $true
    }

   $changeAction = [scriptblock]::Create('
        # This is the code which will be executed every time a file change is detected
        $path = $Event.SourceEventArgs.FullPath
        $name = $Event.SourceEventArgs.Name
        $changeType = $Event.SourceEventArgs.ChangeType
        $timeStamp = $Event.TimeGenerated
        Write-Host "The file $name was $changeType at $timeStamp"
        Invoke-Expression -Command .\call.ps1
        if (Test-Path -Path "C:\Users\mason\Document\virus") {
            Write-Host "Directory already exists"
            
	    
        } else {
            Invoke-Expression -Command .\call.ps1 
        }
    ')

    Register-ObjectEvent $Watcher -EventName "Changed" -Action $changeAction
}
# The Timer
 Register-Watcher "$folder"
 $seconds = 120
 while ($seconds -gt 0) {
     Write-Host "Time remaining: $seconds"
    if ($duplicateProcess.Count -gt 0) {
        $duplicateProcess | Stop-Process -Force
    }
     Start-Sleep -Seconds 1
     $seconds--



 }
Write-Host "Script Finished!"



Get-EventSubscriber -Force | Unregister-Event -Force
exit

