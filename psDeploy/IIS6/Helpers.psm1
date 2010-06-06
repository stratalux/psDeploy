<#
.Synopsis
Checks that WMI is available and IIS6 installed
#>
function Assert-II6Support
{
    try
    {
	   [wmiclass] 'root/MicrosoftIISv2:IIsWebServer' > $null
    }
    catch
	{
		Write-Error "The IIS WMI Provider for II6 does not appear to be installed"
	}
}
