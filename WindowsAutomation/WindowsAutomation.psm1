<#
.Synopsis
Creates a new local user
#>
function New-User
{
    param(  [string]$Name = $(throw 'Muse provide a username'),
            [string]$Password = $(throw 'Muse provide a password')
    ) 
    
    $hostname = hostname   
    $computer = [adsi] "WinNT://$hostname"  
    
    foreach ($user in $computer.psbase.children)
	{
		if ($user.Name -eq $Name)
		{
			Write-Host $user.Name "already exist."
			Return
		}
    }
    
    $userObj = $computer.Create("User", $Name)   
    
    $userObj.Put("description", "$Name")
	$userObj.SetInfo()
	$userObj.SetPassword($Password)
	$userObj.SetInfo()
	$userObj.psbase.invokeset("AccountDisabled", "False")
	$userObj.SetInfo()
}

<#
.Synopsis
Adds a user to a local user group
#>
function Add-UserToGroup
{
    param(  [string]$Username = $(throw "Must provide the user name"),
            [string]$Group = $(throw "Must provide the group name")
    )
    
    $computer = $env:computername
    $groupObj = [ADSI]"WinNT://$computer/$Group,group"
    
    # Check if the user is already part of the group
    $found = $false
    foreach ($existingUser in $groupObj.Members())
    {
        $name = $existingUser.GetType().InvokeMember('Name', 'GetProperty', $null, $existingUser, $null)
        if ($name -eq $Username)
        {
            $found = $true
        }
    }    

    if (!$found)
    {
        $groupObj.Add("WinNT://$Username")
    }
}


<#
.Synopsis
Gives a user permissions on a given folder
#>
function Add-FolderPermissions
{
    param(  $Path = $(throw "Must provide the folder path"),
            $Username = $(throw "Must provide the user name"),
            $Permission = $(throw "Must provide the permission, ex: Read"),
            $Modifier = $(throw "Must provide the modifier, ex: Allow")
    )
    
    $acl = Get-Acl $Path
    $fullPermission = $Username,$Permission,$Modifier
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $fullPermission
    $acl.SetAccessRule($accessRule)
    Set-Acl $folder $acl
}
