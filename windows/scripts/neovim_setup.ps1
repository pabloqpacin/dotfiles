### Admin warning
if (-not ($isAdmin)) {
  do { $userInput = Read-Host "Non-admin session detected. Run as admin to avoid prompts apply symlinks. Continue? (Y/N)" }
    while ($userInput -ne "Y" -and $userInput -ne "N")
  if ($userInput -eq "N") { exit 0 }
}


### Install Neovim & Packer
if (-not (Test-Path -Path "$env:PROGRAMFILES\Neovim")) {
  # Start-Process -FilePath "winget" -ArgumentList "install neovim.neovim.nightly" -Wait
  winget install neovim.neovim.nightly
  if ($LASTEXITCODE -ne 0) { winget install neovim.neovim }
}

git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"


### Install dependencies
winget upgrade --all
winget install OpenJS.NodeJS
winget install python.python.3.11
winget install msys2
  # winget install zig.zig                    # 15 minutes extraction, looking forward for .msi -- https://github.com/microsoft/winget-cli/issues/3306
  # Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    # choco install mingw -y

Write-Host "`nTime to install a C compiler. In the new terminal, please enter"
Write-Host "'pacman -Syu base-devel mingw-w64-x86_64-toolchain --noconfirm'." -ForegroundColor Yellow
Write-Host "Might need to do it a couple times, as MSYS2 updates itself. Ready?"
$null = Read-Host

do {
  Start-Process "$env:SYSTEMDRIVE\msys64\msys2.exe"
  reloadPath
  $userInput = Read-Host "Run 'msys2' again to complete the installation? (Y/N)"
} while ($userInput -eq "Y")
  # Start-Process "$env:SYSTEMDRIVE\msys64\msys2.exe" -ArgumentList "pacman -Syu neofetch base-devel mingw-w64-x86_64-{gcc,cmake,make,ninja,diffutils} --noconfirm" -Wait


### Apply the config
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\nvim" -Path "$env:LOCALAPPDATA\nvim"

$anyInput = Read-Host "
Time to install them plugins. Skip error messages with <Enter> and type in ':so' and ':PackerSync'.
Then ':qa' and to verify, open the file again with 'nvim lua\pabloqpacin\packer.lua'. Ready?"

cd $env:LOCALAPPDATA\nvim
nvim lua\pabloqpacin\packer.lua   # -c ":so" -c ":PackerSync"


<#
  - https://www.msys2.org/docs/environments
  - https://code.visualstudio.com/docs/cpp/config-mingw
  - https://blog.nikfp.com/how-to-install-and-set-up-neovim-on-windows
  - https://github.com/neovim/neovim/wiki/Building-Neovim#windows--msys2--mingw
  - https://blogs.embarcadero.com/what-is-the-best-c-compiler-for-windows-in-2022
#>
