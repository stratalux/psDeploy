
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
    
    try
    {
        $network = New-Object -ComObject WScript.Network
        $network.MapNetworkDrive("$DriveLetter:", $UncPath)
    }
    catch
    {
        Write-Error ("Could not map the path $UncPath. `n" + $_)
    }
    
    Write-Output "Created new network drive $DriveLetter: = $UncPath"
}

