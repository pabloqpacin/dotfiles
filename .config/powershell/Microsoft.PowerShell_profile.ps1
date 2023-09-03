########## settings
function sd { Write-Host "supdawg" }
Set-PSReadLineOption -Colors @{ Command = 'DarkCyan' }
Invoke-Expression (& { (zoxide init powershell | Out-String) })


########## aliases
Set-Alias which Get-Command
Set-Alias opendir Invoke-Item


########## functions
function la { ls -all }

function gh ($command) { Get-Help $command -Full | bat -l $((@("man","ps1") | Get-Random)) --theme Nord }
function props ($file) { Get-Item $file -Force | Format-List * }

function showPath { $env:PATH -replace ':', "`n" }
function showEnv { Get-ChildItem Env: | ForEach-Object { $_.Name } }
function showHist { bat -l ps1 (Get-PSReadlineOption).HistorySavePath }

function whichDef ($command) { (Get-Command -Name $command).Definition }
function whichInf ($command) { Get-Command -Name $command -ShowCommandInfo }


########## oh-my-posh
$posh_themes_path = "$env:HOME/.cache/oh-my-posh/themes"
$randomTheme = ""
$randomThemeCandidates=@()

function Set-RandomPoshTheme {
  $themeFiles = Get-ChildItem -Path $posh_themes_path -Filter '*.omp.json' -File

  if ($themeFiles.Count -eq 0) {
    Write-Host "No theme files found in '$posh_themes_path'."; return
  }

  if ($randomThemeCandidates -and $randomThemeCandidates.Count -gt 0) {
    $global:randomTheme = $randomThemeCandidates | Get-Random } else {
    $global:randomTheme = ($themeFiles | Get-Random).Name -replace '\.omp\.json$'
  }

  Write-Host "`n[oh-my-posh] Random theme '$randomTheme' loaded"
  oh-my-posh init pwsh --config "$posh_themes_path/$randomTheme.omp.json" | Invoke-Expression
}

Set-RandomPoshTheme
