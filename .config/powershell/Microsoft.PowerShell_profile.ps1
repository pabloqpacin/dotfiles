########## Modules
Import-Module ~/dotfiles/windows/Modules/pabloqpacin


########## settings
function sd { Write-Host "supdawg" }
Set-PSReadLineOption -Colors @{ Command = 'DarkCyan' }
Invoke-Expression (& { (zoxide init powershell | Out-String) })


########## aliases
# Set-Alias which Get-Command
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


########## oh-my-posh -- TODO: allow for both json and yaml themes
$posh_themes_path = "$env:HOME/.cache/oh-my-posh/themes"
$randomTheme = ""
$randomThemeCandidates=@(
  'agnosterplus', 'amro', 'blueish', 'bubblesextra', 'bubblesline', 'capr4n', 'catppuccin_frappe',
  'catppuccin_macchiato', 'catppuccin_mocha', 'di4am0nd', 'emodipt', 'glowsticks', 'gmay', 'gruvbox',
  'half-life', 'huvix', 'illusi0n', 'jblab_2021', 'kali', 'lambda', 'M365Princess', 'marcduiker',
  'material', 'microverse-power', 'multiverse-neon', 'negligible', 'night-owl', 'nordtron', 'onehalf',
  'pararussel', 'powerlevel10k_lean', 'powerline', 'probua', 'pure', 'robbyrussell', 'sim-web',
  'smoothie', 'sorin', 'space', 'spaceship', 'star', 'stelbent-compact', 'stelbent',
  'tokyonight_storm', 'tonybaloney', 'uew', 'wopian', 'xtoys', 'ys', 'zash'
)

function Set-RandomPoshTheme {
  $themeFiles = Get-ChildItem -Path $posh_themes_path -Filter '*.omp.json' -File

  if ($themeFiles.Count -eq 0) {
    Write-Host "No theme files found in '$posh_themes_path'."; return
  }

  if ($randomThemeCandidates -and $randomThemeCandidates.Count -gt 0) {
    $global:randomTheme = $randomThemeCandidates | Get-Random } else {
    $global:randomTheme = ($themeFiles | Get-Random).Name -replace '\.omp\.json$'
  }

  # Write-Host "`n[oh-my-posh] Random theme '$randomTheme' loaded"
  oh-my-posh init pwsh --config "$posh_themes_path/$randomTheme.omp.json" | Invoke-Expression
}

Set-RandomPoshTheme

# Import-Module "$env:HOME/WORK/windows_tech_stack/modules/setesur/setesur.psm1"


# $env:PATH -replace ';', "`n"
# New-Item -ItemType Directory "$env:HOMEPATH\Documents\PowerShell\Modules"

