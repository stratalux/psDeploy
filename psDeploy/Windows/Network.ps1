
<#
.Synopsis
Creates a new network drive
#>
function New-NetworkDrive
{
    param
    (
        $UncPath = $(throw "You must specify a UNC path to mount"),
        $DriveLetter = $(throw "You must specify a drive letter")
    )
    
    $network = New-Object -ComObject WScript.Network
    $network.MapNetworkDrive("$DriveLetter:", $UncPath)
    
    Write-Output "Created new network drive $DriveLetter: = $UncPath"
}

