# Get script details
$PSScriptPath = $MyInvocation.MyCommand.Definition
$PSScriptName = (Get-Item -Path $PSScriptPath).BaseName

# Set log file path
$LogPath = "$env:SystemRoot\Logs\PSScripts"
If (-not(Test-Path -Path $LogPath)) { New-Item -Path $LogPath -ItemType Directory }
$LogFilePath = Join-Path -Path $LogPath -ChildPath "$PSScriptName.log"

# Start PS transcript
Start-Transcript -Path $LogFilePath -Append -Force

# Set application name list
$AppNameList = @(
'Clipchamp.Clipchamp',
'Microsoft.GamingApp',
'Microsoft.MicrosoftSolitaireCollection',
'Microsoft.People',
'MicrosoftTeams',
'microsoft.windowscommunicationsapps',
'Microsoft.XboxIdentityProvider',  
'Microsoft.XboxGameCallableUI', 
'Microsoft.XboxSpeechToTextOverlay',
'Microsoft.XboxGamingOverlay',
'Microsoft.XboxGameOverlay',    
'Microsoft.Xbox.TCUI',
'Microsoft.ZuneMusic',
'Microsoft.ZuneVideo')

# Get relevant Provisioned App Packages
$AppPackageList = Get-ProvisionedAppPackage -Online | Where { $AppNameList -contains $_.DisplayName }

# Process each Provisioned App Packages
ForEach ($AppPackage in $AppPackageList) {

    Write-Host "Removing Provisioned App Package [$($AppPackage.DisplayName)]"
    Remove-AppPackage -Package $AppPackage -AllUsers -ErrorAction SilentlyContinue
    Remove-ProvisionedAppPackage -Online -PackageName $AppPackage.PackageName -AllUsers -ErrorAction SilentlyContinue
}

# Stop PS transcript
Stop-Transcript

# Exit with success code
Exit 0
