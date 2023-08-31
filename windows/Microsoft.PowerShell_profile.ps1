########## settings
function sd { Write-Host "supdawg" }
Set-PSReadLineOption -Colors @{ Command = 'DarkCyan' }
Invoke-Expression (& { (zoxide init powershell | Out-String) })


########## aliases
Set-Alias which Get-Command
Set-Alias opendir Invoke-Item
Set-Alias tldr tealdeer-windows-x86_64-msvc.exe


########## functions
function gh ($command) { Get-Help $command -Full | bat - l man --theme Nord }
function file ($file) { Get-Item $file | Format-List * }

function gst { git status }
function ga ($file) { git add $file }
function glol { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" }
function glols { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat }

function showPath { $env:PATH -replace ';', "`n" }
function showEnv { Get-ChildItem Env: | ForEach-Object { $_.Name } }
function showHist { bat -l ps1 (Get-PSReadlineOption).HistorySavePath }
function showTLDR { ls $env:LocalAppData\tealdeer\tealdeer\tldr-pages\pages\windows | bat -l log }

function whichInfo ($command) { Get-Command -Name $command -ShowCommandInfo }
function whichDef ($command) { (Get-Command -Name $command).Definition }    # mkdir

function symlink ($source, $link) {
    New-Item -ItemType SymbolicLink -Target $source -Path $link
}   # Admin-only process -- can't edit $link directly

function touch ($file) {
    $path = Join-Path -Path $PWD -ChildPath $file
    New-Item -Path $path -ItemType File
}

function lsr {
    Get-ChildItem -Recurse | Sort-Object FullName | ForEach-Object {
        Write-Host (" " * ($_.FullName.Split("\").Length - 1) * 4) + $_.Name
    }
}


########## env. vars
$NVIM = "$env:HOMEPATH\dotfiles\.config\nvim"   # $NVIM = "$env:LocalAppData\nvim"
$isAdmin = ([System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    if ($isAdmin) { Write-Host "Running with Administrator privileges" }


########## env. paths
$pathsToAdd = @(
    "$env:LocalAppData\Microsoft\WinGet\Packages",
    "$env:ProgramFiles\Neovim\bin"
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
