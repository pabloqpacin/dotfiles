########## NOTES
# - This script should be run after tweaking WinGet and installing PowerShell v7
# - Github SSH authentication isn't meant for VMs
# - TODO: Nerdfont


########## Script variables & functions
function reloadPath {
  $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","MACHINE") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","USER")
}


########## PWSH check, exit otherwise
if (!(Get-Command -Name "pwsh.exe" -ErrorAction SilentlyContinue)) {
    Write-Host "'pwsh.exe' not found. Downloading PowerShell 7. If slow, run and tweak 'winget settings'."
    winget install Microsoft.PowerShell
    Write-Host "Terminating script. Run it again from PowerShell 7, i.e. 'pwsh.exe'."
    exit 0
} elseif (!($PSVersionTable.PSVersion.Major -eq 7)) {
    Write-Host "Please run the script with PowerShell v.7, i.e. 'pwsh.exe'."
    exit 0
}


########## Basics and dotfiles repo + symlink .gitconfig & $PROFILE
winget upgrade --All
winget install Microsoft.VCRedist.2015+.x64
winget install JanDeDobbeleer.OhMyPosh
winget install Brave.Brave
winget install Git.Git

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

New-Item "$env:HOMEPATH\Documents\PowerShell" -ItemType Directory       # https://www.faqforge.com/powershell/create-directory-with-powershell/
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\windows\Microsoft.PowerShell_profile.ps1" -Path "$env:HOMEPATH\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"



########## Custom Shell Environment
winget install jftuga.less sharkdp.bat clement.bottom dandavison.delta fzf gitui 'ripgrep gnu' tldr zoxide

    reloadPath

tldr --update
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\bat" -Path "$env:APPDATA\bat"
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\gitui" -Path "$env:APPDATA\gitui"
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\bottom" -Path "$env:APPDATA\bottom"

cd $env:HOMEPATH; .\dotfiles\windows\scripts\golang_install.ps1

    reloadPath

$env:CGO_ENABLED = '0'
go install -ldflags="-s -w" github.com/gokcehan/lf@latest

go install github.com/cheat/cheat/cmd/cheat@latest
# cat $env:HOMEPATH\dotfiles\.config\cheat\conf.yaml; nvim $env:APPDATA\cheat\conf.yaml

cd $env:HOMEPATH; .\dotfiles\windows\scripts\nerdfont_install.ps1


########## Neovim
winget install Neovim.Neovim.Nightly
    # ... WIP


########## Wrap-up
    reloadPath
    . $PROFILE
