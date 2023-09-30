########## settings
function sd { Write-Host "supdawg" }
function supdawg { Write-Host "not much wbu" }
Set-PSReadLineOption -Colors @{ Command = 'DarkCyan' }
Invoke-Expression (& { (zoxide init powershell | Out-String) })


########## aliases
Set-Alias gs Get-Service
Set-Alias which Get-Command
Set-Alias opendir Invoke-Item
Set-Alias tldr tealdeer-windows-x86_64-msvc.exe
Set-Alias acli arduino-cli


########## functions
function wup { winget upgrade --all }
function pkill ($proc) { Stop-Process -Name "$proc" }
function symlink ($source, $link) { New-Item -ItemType SymbolicLink -Target $source -Path $link }

function touch ($file) { New-Item -Path (Join-Path -Path $PWD -ChildPath $file) -ItemType File }
function perms ($file) { (Get-ACL $file).Access | Format-Table -AutoSize }
function props ($file) { Get-Item $file -Force | Format-List * }

function showPath { $env:PATH -replace ';', "`n" }
function showModPath { $env:PSModulePath -replace ';', "`n" }
function showEnv { Get-ChildItem Env: | ForEach-Object { $_.Name } }
function showHist { bat -l ps1 (Get-PSReadlineOption).HistorySavePath }

function reloadPath {
  $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","MACHINE") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","USER")
}

function gh ($command) { Get-Help $command -Full | bat -l $((@("man","ps1") | Get-Random)) --theme Nord }
function cheet ($sheet) { cheat $sheet | bat -l $((@("sh", "man","ps1") | Get-Random)) --theme Nord }
function showTLDR { ls $env:LOCALAPPDATA\tealdeer\tealdeer\tldr-pages\pages\windows | bat -l log }

function ezz { eza --icons }
function ezad { eza --icons -la -ShiI .git --no-user --octal-permissions --git }
function ezatal ($level) { eza --icons -laI .git --no-user --no-permissions --no-filesize --git -TL $level }

function gst { git status }
function ga ($file) { git add $file }
function glol { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" }
function glols { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat }

function nek { neko -scale 1 -speed 3 & }
function ff {         # pip install fortune; .\dotfiles\windows\scripts\fortunes_curl.ps1
  $fortune_file = Get-ChildItem -Path "$env:HOMEPATH\dotfiles\docs\fortunes" | Get-Random
  Write-Host "[$($fortune_file.Name)]"; fortune $fortune_file.FullName
}

# function whichDef ($command) { (Get-Command -Name $command).Definition }
# function whichInf ($command) { Get-Command -Name $command -ShowCommandInfo }
# function rawSite ($link) { Invoke-WebRequest -Uri "$link" -Method GET | fl RawContent }
# function mkpsd { New-ModuleManifest -Path C:\Users\MTanaka\Documents\WindowsPowerShell\Modules\quick-recon\quick-recon.psd1 -PassThru }
# function findExtension ($extension) { Get-ChildItem -Path $($PWD) -File -Recurse -ErrorAction SilentlyContinue | where {($_.Name -like "*.$extension")} }
# function findFilez { Get-Childitem -Path $($PWD) -File -Recurse -ErrorAction SilentlyContinue | where {($_.Name -like "*.txt" -or $_.Name -like "*.py" -or $_.Name -like "*.ps1" -or $_.Name -like "*.md" -or $_.Name -like "*.csv")} }

########## env. vars
$env:PAGER = 'less.exe'
$MaximumHistoryCount = 10000
$NVIM = "$env:HOMEPATH\dotfiles\.config\nvim"       # $NVIM = "$env:LOCALAPPDATA\nvim"
$fixThemes =  "$env:HOMEPATH\dotfiles\windows\scripts\omp_NOPE.ps1"
# $ModulesPath = If (Test-Path "$env:HOMEPATH\OneDrive\Documents") { Join-Path $env:HOMEPATH\OneDrive\Documents PowerShell\Modules } Else { Join-Path $env:HOMEPATH\Documents PowerShell\Modules }
$isAdmin = ([System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
  if ($isAdmin) { Write-Host "Running with Administrator privileges" }


########## env. paths
$pathsToAdd = @(
  "$env:LOCALAPPDATA\Microsoft\WinGet\Packages",
  # "$env:LOCALAPPDATA\Microsoft\WinGet\Links",     # https://github.com/ziglang/zig/issues/16670
  "$env:PROGRAMFILES\Neovim\bin",
  "$env:PROGRAMFILES\Wireshark",
  # "$env:LOCALAPPDATA\cheat",                      # if script but using GO atm
  "$env:SYSTEMDRIVE\msys64\mingw64\bin"
)

foreach ($path in $pathsToAdd) {
  if ($env:PATH -notlike "*$path*") {
    $env:PATH += ";$path"
  }
}


########## choco
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


########## oh-my-posh
$random_Theme = ""
$randomThemeCandidates=@(
#  'blueish', 'bubblesextra', 'catppuccin_macchiato', 'craver', 'huvix', 'kali', 'microverse-power', 'negligible',
#  'nu4a', 'pararussel', 'patriksvensson', 'peru', 'poshmon', 'powerlevel10k_lean', 'powerlevel10k_rainbow',
#  'powerline', 'space', 'sorin', 'tiwahu', 'tonybaloney', 'uew', 'wopian' 'xtoys', 'zash'
)

function Set-RandomPoshTheme {
  $themeFiles = Get-ChildItem -Path $env:POSH_THEMES_PATH -Filter '*.omp.json' -File
  if ($themeFiles.Count -eq 0) { Write-Host "No theme files found in '$env:POSH_THEMES_PATH'."; return }

  if ($randomThemeCandidates -and $randomThemeCandidates.Count -gt 0) {
    $global:RANDOM_THEME = $randomThemeCandidates | Get-Random } else {
    $global:RANDOM_THEME = ($themeFiles | Get-Random).Name -replace '\.omp\.json$'
  }

  Write-Host "`n[oh-my-posh] Random theme '$($global:RANDOM_THEME)' loaded"
  oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\$($global:RANDOM_THEME).omp.json" | Invoke-Expression
}

Set-RandomPoshTheme


########## HTB
Import-Module Microsoft.PowerShell.LocalAccounts -UseWindowsPowerShell 3>$null  # https://devblogs.microsoft.com/scripting/understanding-streams-redirection-and-write-host-in-powershell && https://devblogs.microsoft.com/scripting/powertip-suppress-powershell-module-import-warning-messages/
# Import-Module AdminToolbox        # Find-Module -Name AdminToolbox | Install-Module
Import-Module $env:HOMEPATH\dotfiles\windows\Modules\HTB_WinFun

