New-Item -Path "C:\Users\$localUsername\Documents" -Name 'virus' -ItemType "directory"

$localUsername = $env:USERNAME

$pullPathBeforeCopy = Get-ChildItem -Path C:\ -Recurse -Filter "pull.ps1"

$pathBeforeCopy = Get-ChildItem -Path C:\Users\$localUsername -Directory -Recurse -Filter "virus"
$pathAfterCopy = "C:\Users\$localUsername\Documents\virus"

Copy-Item -Path $pathBeforeCopy -Destination $pathAfterCopy -Recurse
Copy-Item -Path $pullPathBeforeCopy -Destination $pathAfterCopy\Virus
& "$pathAfterCopy\Virus\pull.ps1"