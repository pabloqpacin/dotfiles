# Script variables
$pkg = "FiraCode.zip"
$pkgURL = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/$pkg"
$helperURL = "https://raw.githubusercontent.com/pabloqpacin/PowerShell_Scripts/master/InstallFonts.ps1"


# Download 'FiraCode Nerd Font'
Invoke-WebRequest -Uri $pkgURL -OutFile $env:TEMP\$pkg

# Extract zip
Expand-Archive -Path $env:TEMP\$pkg -DestinationPath $env:TEMP\FiraCode

# Install font faces
curl $helperURL --output "$env:TEMP\FiraCode\helper.ps1"
cd $env:TEMP; .\FiraCode\helper.ps1
cd -

# [PDQ Deploy](https://www.pdq.com/blog/how-to-download-and-install-fonts)
