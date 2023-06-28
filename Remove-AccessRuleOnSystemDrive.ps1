# Get script details
$PSScriptPath = $MyInvocation.MyCommand.Definition
$PSScriptName = (Get-Item -Path $PSScriptPath).BaseName

# Set log file path
$LogPath = "$env:SystemRoot\Logs\PSScripts"
If (-not(Test-Path -Path $LogPath)) { New-Item -Path $LogPath -ItemType Directory }
$LogFilePath = Join-Path -Path $LogPath -ChildPath "$PSScriptName.log"

# Start PS transcript
Start-Transcript -Path $LogFilePath -Append -Force

# Set Path and Identity
$Path = "$env:SystemDrive\"
$Identity = "NT AUTHORITY\Authenticated Users"

# Get folder item
$Folder = Get-Item -Path $Path

# Get ACL for folder item
$Acl = $Folder.GetAccessControl()

# Filter Access Control Entry by Identity
$AceList = $Acl.Access | Where { $_.IdentityReference -eq $Identity }

# Write host message
$Message = "Removing the following Access Control Entry for identity [$Identity] for path [$Path]:"
$Message += $($AceList | Format-List | Out-String)
Write-Host $Message

# Process each Access Control Entry
ForEach ($Ace in $AceList) {
    
    # Remove ccess Control Entry
    $Acl.RemoveAccessRule($Ace)
}

# Write host message
$Message = "Setting the new Access Control List as follows for path [$Path]:"
$Message += $($Acl.Access | Format-List | Out-String)
Write-Host $Message

# Set Access Control List 
$Folder.SetAccessControl($Acl)

# Stop PS transcript
Stop-Transcript

# Exit with success code
Exit 0
