$callPathBeforeCopy = Get-ChildItem -Path C:\Users\$localUsername -Recurse -Filter "call.ps1"
$callMoveDir = "C:\Users\$localUsername\Documents\virus\Virus\call.ps1"

Copy-Item -Path $callPathBeforeCopy -Destination $callMoveDir