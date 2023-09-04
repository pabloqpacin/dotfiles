########## NOTES
# - This script should be run after tweaking WinGet and installing PowerShell v7
# - Github SSH authentication isn't meant for VMs
# - TODO: Terminal settings, cheat

<#
  - curl https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/windows/scripts/SW_install-symlink.ps1 --output self.ps1
  - .\self.ps1
#>


########## Script variables & functions
$isAdmin = ([System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)

function reloadPath {
  $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","MACHINE") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","USER")
}

$startTime = Get-Date


########## PWSH check, exit otherwise
if (!(Get-Command -Name "pwsh.exe" -ErrorAction SilentlyContinue)) {
    Write-Host "'pwsh.exe' not found. Downloading PowerShell 7. If slow, run and tweak 'winget settings'."
    winget install Microsoft.PowerShell
    Write-Host "Terminating script. Run it again from PowerShell 7, i.e. 'pwsh.exe'."
    exit 0
} elseif (!($PSVersionTable.PSVersion.Major -eq 7)) {
    Write-Host "Please run the script with PowerShell v.7, i.e. 'pwsh.exe'."
    exit 0
} elseif (!($isAdmin)) {
    do { $userInput = Read-Host "
Non-admin session detected. Consider running PWSH as admin to avoid confirmation prompts
and to ensure symlinks are applied and fonts are installed. Continue? (Y/N)" }
        while ($userInput -ne "Y" -and $userInput -ne "N")
    if ($userInput -eq "N") { exit 0 }
}


########## Basics and dotfiles repo + symlink .gitconfig & $PROFILE
winget upgrade --all
winget install Microsoft.VCRedist.2015+.x64
winget install JanDeDobbeleer.OhMyPosh
winget install Brave.Brave
winget install Git.Git

do { $userInput = Read-Host "Do you want to install 'VSCode', 'VSCodium', 'both' or 'neither'?" }
    while ($userInput -ne "vscode" -and $userInput -ne "vscodium" -and $userInput -ne "both" -and $userInput -ne "neither")

if ($userInput -eq "vscode") { winget install Microsoft.VisualStudioCode --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders"' }
    elseif ($userInput -eq "vscodium") { winget install VSCodium }
    elseif ($userInput -eq "both") { winget install VSCodium; winget install Microsoft.VisualStudioCode --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders"' }

    reloadPath

do { $userInput = Read-Host "Have you authenticated to Github via SSH? (Y/N)" }
    while ($userInput -ne "Y" -and $userInput -ne "N")

if ($userInput -eq "Y") {
    Write-Host "Cloning dotfiles via SSH. Proper way."
    git clone git@github.com:pabloqpacin/dotfiles.git "$env:HOMEPATH\dotfiles"
} else {
    Write-Host "Cloning dotfiles via HTTPS. You won't be able to push changes."
    git clone https://github.com/pabloqpacin/dotfiles.git "$env:HOMEPATH\dotfiles"
}

New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.gitconfig" -Path "$env:HOMEPATH\.gitconfig"

if (-not (Test-Path -Path $env:HOMEPATH\Documents\PowerShell -PathType Container)) {
    New-Item -Path $env:HOMEPATH\Documents\PowerShell -ItemType Directory }     # https://www.faqforge.com/powershell/create-directory-with-powershell
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\windows\Microsoft.PowerShell_profile.ps1" -Path "$env:HOMEPATH\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"


########## Custom Shell Environment
winget install jftuga.less sharkdp.bat clement.bottom dandavison.delta fzf gitui 'ripgrep gnu' tldr zoxide

    reloadPath

zoxide add dotfiles
# tealdeer-windows-x86_64-msvc.exe --update     # Error: invalid peer certificate: UnknownIssuer
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\bat" -Path "$env:APPDATA\bat"
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\gitui" -Path "$env:APPDATA\gitui"
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\bottom" -Path "$env:APPDATA\bottom"

Write-Host "Almost there. Installing Golang, then installing 'lf' and 'cheat'. Terminal might get cluttery."
cd $env:HOMEPATH; .\dotfiles\windows\scripts\golang_install.ps1

    reloadPath

$env:CGO_ENABLED = '0'
go install -ldflags="-s -w" github.com/gokcehan/lf@latest

go install github.com/cheat/cheat/cmd/cheat@latest
# cat $env:HOMEPATH\dotfiles\.config\cheat\conf.yaml; nvim $env:APPDATA\cheat\conf.yaml

Write-Host "Installing 'FiraCode Nerd Font'"
cd $env:HOMEPATH; .\dotfiles\windows\scripts\nerdfont_install.ps1


########## Neovim
# winget install Neovim.Neovim.Nightly        # "Installer hash does not match"
    # ... WIP


########## Wrap-up
    reloadPath
    . $PROFILE

$endTime = Get-Date
$elapsedTimeMinutes = [math]::Round(($endTime - $startTime).TotalMinutes, 2)
Write-Host "Script execution time: $elapsedTimeMinutes minutes"