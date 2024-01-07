<#

.Description  
This Module provides many of the basic aliases & functions I may expect in any PowerShell session.

.Example  
...

.Notes  
First Module every ahoy!!
- https://learn.microsoft.com/en-us/powershell/scripting/developer/module/writing-a-windows-powershell-module?view=powershell-7.2
- https://learn.microsoft.com/en-us/powershell/scripting/developer/help/writing-help-for-windows-powershell-scripts-and-functions?view=powershell-7.2
- https://learn.microsoft.com/en-us/powershell/scripting/developer/help/comment-based-help-keywords?view=powershell-7.2

#>


########## pwsh
function showPath { $env:PATH -replace ';', "`n" }
function showModPath { $env:PSModulePath -replace ';', "`n" }
function showHist { bat -l ps1 (Get-PSReadlineOption).HistorySavePath }
function showEnv { Get-ChildItem Env: | ForEach-Object { $_.Name } }

function showTLDR { ls $env:LOCALAPPDATA\tealdeer\tealdeer\tldr-pages\pages\windows | bat -l log }
function symlink ($source, $link) { New-Item -ItemType SymbolicLink -Target $source -Path $link }


########## file mgmt
function props ($file) { Get-Item $file -Force | Format-List * }
function touch ($file) { $path = Join-Path -Path $PWD -ChildPath $file; New-Item -Path $path -ItemType File }
function filePermissions ($file) { (Get-ACL $file).Access | Format-Table -AutoSize }
function findExtension ($extension) { Get-Childitem -Path $($PWD) -File -Recurse -ErrorAction SilentlyContinue | where {($_.Name -like "*.$extension")} }
function findFilez { Get-Childitem -Path $($PWD) -File -Recurse -ErrorAction SilentlyContinue | where {($_.Name -like "*.txt" -or $_.Name -like "*.py" -or $_.Name -like "*.ps1" -or $_.Name -like "*.md" -or $_.Name -like "*.csv")} }


########## cli tools: bat cheat eza git 
function ghb ($command) { Get-Help $command -Full | bat -l $((@("man","ps1") | Get-Random)) --theme Nord }
function cheet ($sheet) { cheat $sheet | bat -p -l sh }

function ezz { eza --icons }
function ezad { eza --icons -la -ShiI .git --no-user --octal-permissions --git }
function ezatal ($level) { eza --icons -laI .git --no-user --no-permissions --no-filesize --git -TL $level }

function gst { git status }
function ga ($file) { git add $file }
function glol { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" }
function glols { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat }


########## misc.
function pkill ($proc) { Stop-Process -Name "$proc" }
function rawSite ($link) { Invoke-WebRequest -Uri "$link" -Method GET | fl RawContent }
# function whichDef ($command) { (Get-Command -Name $command).Definition }
# function whichInf ($command) { Get-Command -Name $command -ShowCommandInfo }


function nek { neko -scale 1 -speed 3 & }

function ff {         # pip install fortune; .\dotfiles\windows\scripts\fortunes_curl.ps1
  $fortune_file = Get-ChildItem -Path "$env:HOMEPATH\dotfiles\docs\fortunes" | Get-Random
  Write-Host "[$($fortune_file.Name)]"
  fortune $fortune_file.FullName
}
