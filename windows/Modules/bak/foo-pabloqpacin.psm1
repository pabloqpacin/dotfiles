### powershell recursively cat all files within the directories of a directory?

# Specify the path to the parent directory you want to start from
$parentDirectory = "C:\Path\To\Parent\Directory"

# Recursively get all files within the subdirectories
$files = Get-ChildItem -Path $parentDirectory -File -Recurse

# Loop through each file and read its content
foreach ($file in $files) {
    Write-Host "Content of file: $($file.FullName)"
    Get-Content -Path $file.FullName
    Write-Host "-----------------------------------"
}

Get-ChildItem -Path 'C:\Path\To\Parent\Directory' -File -Recurse | ForEach-Object { Get-Content -Path $_.FullName }