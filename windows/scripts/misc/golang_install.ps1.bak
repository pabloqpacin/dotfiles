# Script variables
$GO = "$env:ProgramFiles\Go"
$pkg = "go1.21.0.windows-amd64.msi"
$pkgURL = "https://go.dev/dl/$pkg"
$arguments = "/i `"$env:TEMP\$pkg`" INSTALLDIR=`"$GO`" /passive"

# Check for go.exe
if (Test-Path -Path $GO\bin\go.exe) {
    Write-Host "Go executable already exists. Script terminated."
    Get-ChildItem $GO\bin\go.exe; exit 0
}

# Download Golang
if (-not (Test-Path -Path $env:TEMP\$pkg)) {
    Invoke-WebRequest -URI $pkgURL -OutFile $env:TEMP\$pkg
} # else { Write-Host "$en:TEMP\$pkg already exists" }

# Install Golang
Start-Process -FilePath msiexec.exe -ArgumentList $arguments -Wait
