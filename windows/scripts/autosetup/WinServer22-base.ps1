
Write-Host "`n------###################################################################------"
Write-Host "#########~~~~~{     WinServer22-base v0.1.3  by @pabloqpacin    }~~~~~#########"
Write-Host "------###################################################################------`n"

### Tested successfully on WindowsServer2022 (fresh VBox VM)
# curl https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/windows/scripts/autosetup/WinServer22-base.ps1 -outfile server.ps1
# .\server.ps1

######## FUNCTIONS ########

# Expected usage --> update_path 'C:\Program Files\bat'
function update_path ($NewPath) {

    $CurrentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)

    if ($CurrentPath -notlike "*$NewPath*") {

        $NewPath = $CurrentPath + ";" + $NewPath
        [System.Environment]::SetEnvironmentVariable("PATH", $NewPath, [System.EnvironmentVariableTarget]::User)

        $env:PATH = $NewPath
        Write-Host "Directory added to PATH. Please restart your PowerShell session or open a new console window for the changes to take effect."

    } else {
        Write-Host "Directory is already in PATH."
    }
}

function install_vcpp_redist {

            if (-not (tree 'C:\ProgramData\' | Select-String 'vcRuntimeMinimum_amd64')) {

            Write-Output '==( Downloading Visual C++ Redist 2015+ )=='
            $req_pkg = 'vc_redist.x64.exe'
            Invoke-WebRequest -Uri https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/$req_pkg -OutFile $req_pkg
        
            if ($?) { 
                Write-Output '==( Installing Visual C++ Redist 2015+ )=='
                Start-Process $req_pkg -ArgumentList '/silent' -Wait
                Remove-Item $req_pkg
            }

        } else {
                # Write-Output '==( Visual C++ Redist 2015+ is already installed! )=='
        }

}

function install_vscode {

    if (-not (Test-Path 'C:\Program Files\Microsoft VS Code\Code.exe')) {
        
        Write-Host '== Downloading VS Code =='
        $pkg = 'VSCodeSetup-x64-1.84.2.exe'
        Invoke-WebRequest -Uri https://az764295.vo.msecnd.net/stable/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/$pkg -OutFile $pkg

        if ($?) {
            Write-Host '== Installing VS Code =='
                # no aplica el argumento 'addcontextmenufolder'
            $arguments = '/SILENT /mergetasks=!runcode,addcontextmenufiles,addcontextmenufolder'
            Start-Process -FilePath $pkg -ArgumentList $arguments -Wait
            Remove-Item $pkg
        }

    } else {
        Write-Output '== VSCode is already installed =='
        # TODO: extensions ...
    }
}

function install_brave {

    if (-not (Test-Path 'C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe')) {
        
        Write-Host '== Downloading Brave =='
        $pkg = 'BraveBrowserSetup-BRV011.exe'
        Invoke-WebRequest -Uri https://referrals.brave.com/latest/$pkg -OutFile $pkg

        if ($?) {
            Write-Host '== Installing Brave ==' 
            Start-Process $pkg -Wait
            Remove-Item $pkg
        }

    } else {
        Write-Host '== Brave is already installed =='
    }

    # Get-Service | Where-Object { $_.ServiceName -like '*Brave*' } | ForEach-Object {
    #     Stop-Service $_.ServiceName; Set-Service -Name $_.ServiceName -StartupType Disabled
    # }

}

function install_pwsh {
    
    if (-not (Test-Path 'C:\Program Files\WindowsApps\Microsoft.PowerShell_7*\pwsh.exe')) {
            
        Write-Host '== Downloading PowerShell 7 (long) =='
        $pwsh = 'PowerShell-7.4.0-win.msixbundle'
        Invoke-WebRequest -Uri https://github.com/PowerShell/PowerShell/releases/download/v7.4.0/$pwsh -OutFile $pwsh

        if ($?) {
            Write-Output '== Installing PowerShell 7 =='
            Add-AppxPackage $pwsh
            Remove-Item $pwsh
        }

    } else {
        Write-Output '== PowerShell 7 is already installed =='
    }
}

function install_terminal {

    # PROBLEMA CON WINSERVER2019

    if (-not (Test-Path 'C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_*\wt.exe')) {
        
        if (-not (Test-Path 'C:\Program Files\WindowsApps\Microsoft.VCLibs.140.00.UWP*')) {

            Write-Output '== (Downloading Windows Terminal requirements) =='
            $req_pkg = 'Microsoft.VCLibs.x64.14.00.Desktop.appx'
            Invoke-WebRequest -Uri https://aka.ms/$req_pkg -OutFile $req_pkg
        
            if ($?) { 
                Write-Output '== (Installing Windows Terminal requirements) =='
                Add-AppxPackage $req_pkg
                Remove-Item $req_pkg
            }

        } else {
            Write-Output '== (Windows Terminal requirements are already installed) =='
        }

        Write-Output '== Downloading Windows Terminal =='
            # $pkg = 'Microsoft.WindowsTerminal_1.7.1091.0_8wekyb3d8bbwe.msixbundle'
            # Invoke-WebRequest -Uri https://github.com/microsoft/terminal/releases/download/$pkg -OutFile $pkg
        $pkg = 'Microsoft.WindowsTerminal_Win10_1.14.2281.0_8wekyb3d8bbwe.msixbundle'
        Invoke-WebRequest -Uri https://github.com/microsoft/terminal/releases/download/v1.14.2281.0/$pkg -OutFile $pkg
        
        if ($?) {
            Write-Output '== Installing Windows Terminal =='
            Add-AppxPackage $pkg
            Remove-Item $pkg
        }

    } else {
        Write-Output '== Windows Terminal is already installed =='
        # TODO: settings.json ...
    }
}

function install_nerdfonts {

    $exists = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' | Select-String FiraCode)

    if (-not ($exists)) {

        $helper = "https://raw.githubusercontent.com/pabloqpacin/PowerShell_Scripts/master/InstallFonts.ps1"

        Write-Host '== Downloading Nerdfont FiraCode =='
        Invoke-WebRequest -Uri https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip -OutFile FiraCode.zip
        Expand-Archive -Path FiraCode.zip -DestinationPath FiraCode

        Set-Location FiraCode
        Invoke-WebRequest -Uri $helper -OutFile helper.ps1
        Write-Host '== Installing Nerdfont FiraCode =='
        .\helper.ps1

        Set-Location ..
        Remove-Item FiraCode.zip
        Remove-Item FiraCode -r

    } else {
        Write-Host '== Nerdfont FiraCode is already installed =='
    }

    $exists = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' | Select-String CaskaydiaCove)

    if (-not ($exists)) {

        $helper = "https://raw.githubusercontent.com/pabloqpacin/PowerShell_Scripts/master/InstallFonts.ps1"

        Write-Host '== Downloading Nerdfont CascadiaCode =='
        Invoke-WebRequest -Uri https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip -OutFile CascadiaCode.zip
        Expand-Archive -Path CascadiaCode.zip -DestinationPath CascadiaCode

        Set-Location CascadiaCode
        Invoke-WebRequest -Uri $helper -OutFile helper.ps1
        Write-Host '== Installing Nerdfont CascadiaCode =='
        .\helper.ps1

        Set-Location ..
        Remove-Item CascadiaCode.zip
        Remove-Item CascadiaCode -r

    } else {
        Write-Host '== Nerdfont CascadiaCode is already installed =='
    }
}

function install_nmap {

    if (-not (Test-Path 'C:\Program Files (x86)\Nmap')) {

        $pkg = 'nmap-7.94-setup.exe'

        Write-Host '== Downloading Nmap =='
        Invoke-WebRequest -uri https://nmap.org/dist/$pkg -outfile $pkg

        if ($?) {
            Write-Output '== Installing Nmap =='
            Read-Host "Npcap can't be installed with '/SILENT'... Just confirm everything! [Y]"
            Start-Process $pkg -Wait
            Remove-Item $pkg
        }

    } else {
        Write-Output '== Nmap is already installed =='
    }
}

function install_neovim {

    if (-not (Test-Path 'C:\Program Files\Neovim')) {

        install_vcpp_redist

        Write-Output '== Downloading Neovim =='
        $pkg = 'nvim-win64.msi'
        Invoke-WebRequest -Uri https://github.com/neovim/neovim/releases/latest/download/$pkg -OutFile $pkg
        
        if ($?) {
            Write-Output '== Installing Neovim =='
            Start-Process $pkg -ArgumentList '/quiet' -Wait
            Remove-Item $pkg
        }

    } else {
        Write-Output '== Neovim is already installed =='
        # TODO: .vimrc
    }
}

function install_git {

    if (-not (Test-Path 'C:\Program Files\Git')) {

        $pkg = 'Git-2.43.0-64-bit.exe'

        Write-Host '== Downloading Git =='
        Invoke-WebRequest -uri https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/$pkg -OutFile $pkg

        if ($?) { 
            Write-Output '== Installing Git =='
            Start-Process $pkg -ArgumentList '/SILENT' -Wait
            Remove-Item $pkg
        }

    } else {
        Write-Output '== Git is already installed =='
    }
}

function install_misc {
    # ... eza lf ... 

    if (-not (Test-Path 'C:\Program Files\bat')) {

        install_vcpp_redist

        Write-Output '== Downloading Bat =='
        $pkg = 'bat-v0.24.0-x86_64-pc-windows-gnu.zip'
        Invoke-WebRequest -Uri https://github.com/sharkdp/bat/releases/download/v0.24.0/$pkg -OutFile $pkg
        
        if ($?) {
            Write-Output '== Installing Bat =='
            Expand-Archive -Path $pkg -DestinationPath 'C:\Program Files\'
            Move-Item "C:\Program Files\bat-v0.24.0-x86_64-pc-windows-gnu" 'C:\Program Files\bat'

            update_path 'C:\Program Files\bat'
            
            Remove-Item $pkg
        }

    } else {
        Write-Output '== Bat is already installed =='
        # TODO: .vimrc
    }

}

# function install_wsl {}
# function setup_dotfiles { ... pwsh (oh-my-posh) vscode terminal (misc) ... }

function print_end {
    Write-Host "Script completed! Restart the shell/machine before running it again!"
}

########## RUNTIME ########

# Get-WindowsFeature

install_vscode
install_brave
install_pwsh
install_terminal
install_nerdfonts
install_nmap
install_neovim
install_git

install_misc

print_end

# ======x======

### if (!($?)) {echo foo} else {echo bar} == si último comando no funciona, haz tal, de lo contrario, cual

# # Install VSCode extensions
# $extensions = @('ms-python.python', 'vscode-icons', '...')  # Add your desired extensions
# $extensions | ForEach-Object {
#     Start-Process -FilePath "$vscode_bin" -ArgumentList " --install-extension $_" -Wait
# }

# $env:PATH -replace ';', "`n"
