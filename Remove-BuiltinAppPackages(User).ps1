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

# Process each application
ForEach ($AppName in $AppNameList) {

    # Get App Package
    $AppPackage = Get-AppPackage -Name $AppName -ErrorAction SilentlyContinue

    # Remove App Package
    If ($AppPackage) { 

        Write-Host "Removing App Package [$AppName]"
        Remove-AppPackage -Package $AppPackage -ErrorAction SilentlyContinue 
    }
}

# Stop PS transcript
Stop-Transcript

# Exit with success code
Exit 0