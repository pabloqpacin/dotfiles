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

function gh ($command) { Get-Help $command -Full | bat -l $((@("man","ps1") | Get-Random)) --theme Nord }
function props ($file) { Get-Item $file -Force | Format-List * }

function gst { git status }
function ga ($file) { git add $file }
function glol { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" }
function glols { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat }

function showPath { $env:PATH -replace ';', "`n" }
function showEnv { Get-ChildItem Env: | ForEach-Object { $_.Name } }
function showHist { bat -l ps1 (Get-PSReadlineOption).HistorySavePath }
function showTLDR { ls $env:LOCALAPPDATA\tealdeer\tealdeer\tldr-pages\pages\windows | bat -l log }

function reloadPath {
  $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","MACHINE") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","USER")
}

function whichDef ($command) { (Get-Command -Name $command).Definition }
function whichInf ($command) { Get-Command -Name $command -ShowCommandInfo }

function symlink ($source, $link) {
  New-Item -ItemType SymbolicLink -Target $source -Path $link
}   # Admin-only process -- can't edit $link directly

function touch ($file) {
  $path = Join-Path -Path $PWD -ChildPath $file
  New-Item -Path $path -ItemType File
}

function cheet ($sheet) {
  cheat $sheet | bat -p -l sh
}

function ff {         # pip install fortune; .\dotfiles\windows\scripts\fortunes_curl.ps1
  $fortune_file = Get-ChildItem -Path "$env:HOMEPATH\dotfiles\docs\fortunes" | Get-Random
  Write-Host "[$($fortune_file.Name)]"
  fortune $fortune_file.FullName
}

function nek { neko -scale 1 -speed 3 & }


########## env. vars
$NVIM = "$env:HOMEPATH\dotfiles\.config\nvim"       # $NVIM = "$env:LOCALAPPDATA\nvim"
$fixThemes =  "$env:HOMEPATH\dotfiles\windows\scripts\omp_NOPE.ps1"
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
#  'blueish', 'bubblesextra', 'catppuccin_macchiato', 'craver',
#  'huvix', 'kali', 'microverse-power', 'negligible', 'nu4a',
#  'pararussel', 'patriksvensson', 'peru', 'poshmon',
#  'powerlevel10k_lean', 'powerlevel10k_rainbow', 'powerline',
#  'space', 'sorin', 'tiwahu', 'tonybaloney', 'uew', 'wopian' 'xtoys', 'zash'
)

function Set-RandomPoshTheme {
  $themeFiles = Get-ChildItem -Path $env:POSH_THEMES_PATH -Filter '*.omp.json' -File

  if ($themeFiles.Count -eq 0) {
    Write-Host "No theme files found in '$env:POSH_THEMES_PATH'."; return
  }

  if ($randomThemeCandidates -and $randomThemeCandidates.Count -gt 0) {
    $global:RANDOM_THEME = $randomThemeCandidates | Get-Random } else {
    $global:RANDOM_THEME = ($themeFiles | Get-Random).Name -replace '\.omp\.json$'
  }

  Write-Host "`n[oh-my-posh] Random theme '$($global:RANDOM_THEME)' loaded"
  oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\$($global:RANDOM_THEME).omp.json" | Invoke-Expression
}

Set-RandomPoshTheme


<#
- https://gist.github.com/timdeschryver/c78c02750f068a8d8154d9d60b070ffa
- https://github.com/JanDeDobbeleer/oh-my-posh/issues/4156
#>
