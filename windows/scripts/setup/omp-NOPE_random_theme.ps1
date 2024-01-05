$NOPE = "$env:POSH_THEMES_PATH\NOPE"

if (-not (Test-Path -Path $NOPE -PathType Container)) {
  New-Item -Path $NOPE -ItemType Directory
}

$themesToDelete = @(
  'cinnamon', 'cloud-native-azure', 'capr4n', 'chips', 'cobalt2', 'dark-blood', 'free-ukraine',
  'gmay', 'hotstick.minimal', 'hul10', 'if_tea', 'jonnychipz', 'jtracey93', 'jv_sitecorian',
  'lambdageneration', 'larserikfinholt', 'lightgreen', 'M365Princess', 'montys',
  'powerlevel10k_classic' 'quick-term', 'rudolfs-dark', 'rudolfs-light',
  'slim', 'slimfat', 'sonicboom_light', 'stelbent-compact.minimal',
  'wholespace'
)

foreach ($theme in $themesToDelete) {
  $themeFile = Join-Path -Path $env:POSH_THEMES_PATH -ChildPath "$theme.omp.json"

  if (Test-Path -Path $themeFile -PathType Leaf) {
    Move-Item -Path $themeFile -Destination (Join-Path -Path $NOPE -ChildPath "$theme.omp.json")
  }
}
