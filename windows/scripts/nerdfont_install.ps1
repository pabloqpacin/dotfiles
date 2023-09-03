# Script variables
$pkg = "FiraCode.zip"
$pkgURL = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/$pkg"


# Download 'FiraCode Nerd Font'
Invoke-WebRequest -Uri $pkgURL -OutFile $env:TEMP\$pkg

# Extract zip
Expand-Archive -Path $env:TEMP\$pkg -DestinationPath $env:TEMP\FiraCode

# Install font faces
Install-Font -FilePath $env:TEMP\FiraCode\*.ttf
