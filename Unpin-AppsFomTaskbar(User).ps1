# Get script details
$PSScriptPath = $MyInvocation.MyCommand.Definition
$PSScriptName = (Get-Item -Path $PSScriptPath).BaseName

# Set log file path
$LogPath = "$env:SystemRoot\Logs\PSScripts"
If (-not(Test-Path -Path $LogPath)) { New-Item -Path $LogPath -ItemType Directory }
$LogFilePath = Join-Path -Path $LogPath -ChildPath "$PSScriptName.log"

# Start PS transcript
Start-Transcript -Path $LogFilePath -Append -Force

# Set search string
$SearchString = "*Store*"

# Get shell applications
$Shell_Apps = ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items())

# Get shell applications that match search string
$AppList = $Shell_Apps | Where { $_.Name -like $SearchString  }

# Write host message
$Message = "The following shell applications matched the searchstring [$SearchString]:"
$Message += $($AppList | Format-List | Out-String)
Write-Host $Message

# Process each shell application
ForEach ($App in $AppList) {

    # Write host message
    Write-Host "Unpinning shell application [$($App.Name)] from the taskbar"
    
    # Unpin shell application from taskbar
    ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $App.Name}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}
}

# Stop PS transcript
Stop-Transcript

# Exit with success code
Exit 0