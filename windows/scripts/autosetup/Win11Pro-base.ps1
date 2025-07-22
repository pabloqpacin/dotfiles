
Write-Host "`n------####################################################################------"
Write-Host "#########~~~~~{       Win11Pro-base v0.1.2  by @pabloqpacin      }~~~~~#########"
Write-Host "------####################################################################------`n"

########## NOTES
# - This script should be run after tweaking WinGet and installing PowerShell v7
# - Github SSH authentication isn't meant for VMs

<#
  - curl https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/windows/scripts/autosetup/Win11Pro-base.ps1 --output self.ps1
  - .\self.ps1
  - rm self.ps1
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
};  $userInput = $null


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
    $userInput = $null

    reloadPath

do { $userInput = Read-Host "Have you authenticated to Github via SSH? (Y/N)" }
    while ($userInput -ne "Y" -and $userInput -ne "N")

if ($userInput -eq "Y") {
    Write-Host "Cloning dotfiles via SSH. Proper way."
    git clone git@github.com:pabloqpacin/dotfiles.git "$env:HOMEPATH\dotfiles"
} else {
    Write-Host "Cloning dotfiles via HTTPS. You won't be able to push changes."
    git clone https://github.com/pabloqpacin/dotfiles.git "$env:HOMEPATH\dotfiles"
};  $userInput = $null

New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.gitconfig" -Path "$env:HOMEPATH\.gitconfig"

# TODO: OneDrive CHECK
if (-not (Test-Path -Path $env:HOMEPATH\Documents\PowerShell -PathType Container)) {
    New-Item -Path $env:HOMEPATH\Documents\PowerShell -ItemType Directory }     # https://www.faqforge.com/powershell/create-directory-with-powershell
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\windows\Microsoft.PowerShell_profile.ps1" -Path "$env:HOMEPATH\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"


########## Custom Shell Environment
winget install jftuga.less sharkdp.bat clement.bottom `
               dandavison.delta eza-community.eza fzf `
               golang.go gitui gokcehan.lf `
               'ripgrep gnu' tldr zoxide `
               insecure.nmap
               # gnuwin32.findutils sharkdp.fd          # need fix nvim.telescope

    reloadPath

go install github.com/cheat/cheat/cmd/cheat@latest
    # cheat -y; cat $env:HOMEPATH\dotfiles\.config\cheat\conf.yaml; nvim $env:APPDATA\cheat\conf.yaml

zoxide add dotfiles
# tealdeer-windows-x86_64-msvc.exe --update     # Error: invalid peer certificate: UnknownIssuer
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\bat" -Path "$env:APPDATA\bat"
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\gitui" -Path "$env:APPDATA\gitui"
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\bottom" -Path "$env:APPDATA\bottom"

do { $userInput = Read-Host "`nAlmost there. Install 'FiraCode Nerd Font'? (Y/N)" }
    while ($userInput -ne "Y" -and $userInput -ne "N")
if ($userInput -eq "Y") { cd $env:HOMEPATH; .\dotfiles\windows\scripts\setup\nerdfont-helper.ps1 }
    $userInput = $null


do { $userInput = Read-Host "`nLast thing. Set up Neovim? (Y/N)" }
    while ($userInput -ne "Y" -and $userInput -ne "N")

if ($userInput -eq "Y") {
    Start-Process -FilePath "pwsh" -ArgumentList "$env:HOMEPATH\dotfiles\windows\scripts\setup\neovim-winget.ps1" -Wait
} else { Write-Host "You can find the Neovim setup script at '$env:HOMEPATH\dotfiles\windows\scripts\setup\neovim-winget.ps1'." }


########## Wrap-up
    reloadPath
    . $PROFILE

$endTime = Get-Date
$elapsedTimeMinutes = [math]::Round(($endTime - $startTime).TotalMinutes, 2)
Write-Host "Script execution time: $elapsedTimeMinutes minutes"

########## NOTES
# - TODO: Terminal settings, cheat, [lf](https://pkg.go.dev/github.com/gokcehan/lf)     # ...
