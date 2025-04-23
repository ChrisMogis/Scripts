# Install_LanguagePack_en-US.ps1

<#
.DESCRIPTION
# This script installs the en-US language pack on a Windows 11 machine via Microsoft Intune.

.NOTES
    Version       : 1.0.0
    Author        : Christopher Mogis
    Creation Date : 23/04/2025
#>

# Define the language pack to install
$Language = "en-US"

# Check if the language is already installed
$InstalledLanguages = Get-InstalledLanguage -ErrorAction SilentlyContinue
if ($InstalledLanguages.LanguageTag -contains $Language) {
    Write-Host "The language pack '$Language' is already installed."
    exit 0
}

# Add the language pack
Write-Host "Installing the language pack '$Language'..."
try {
    # Simulate installation with a progress bar
    for ($i = 1; $i -le 100; $i++) {
        Write-Progress -Activity "Installing Language Pack" -Status "Progress: $i%" -PercentComplete $i
        Start-Sleep -Milliseconds 50  # Simulate work
    }
    # Actual installation commands (uncomment in production)
    Install-Language -Language en-US -ErrorAction Stop
    Add-WinUILanguagePack -Language $Language -ErrorAction Stop
    Set-WinUILanguageOverride -Language $Language
    Set-WinUserLanguageList -LanguageList $Language -Force
    Set-WinSystemLocale -SystemLocale $Language
    Set-Culture -CultureInfo $Language
    Write-Host "The language pack '$Language' has been installed successfully."
} catch {
    Write-Error "Failed to install the language pack '$Language'. Error: $_"
    exit 1
}

# Propose a restart to the user
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show(
    "The language changes require a restart to take effect. Please save your work and restart the computer at your earliest convenience.",
    "Restart Required",
    [System.Windows.MessageBoxButton]::OK,
    [System.Windows.MessageBoxImage]::Information
)

# Propose a restart to the user with a "Restart" button
Add-Type -AssemblyName PresentationFramework
$Result = [System.Windows.MessageBox]::Show(
    "The language changes require a restart to take effect. Would you like to restart now?",
    "Restart Required",
    [System.Windows.MessageBoxButton]::YesNo,
    [System.Windows.MessageBoxImage]::Question
)

if ($Result -eq [System.Windows.MessageBoxResult]::Yes) {
    Write-Host "Restarting the computer..."
    Restart-Computer -Force
} else {
    Write-Host "The user chose not to restart the computer at this time."
}
