
Write-Host "`n------###################################################################------"
Write-Host "#########~~~~~{     WinServer22-base v0.1.1  by @pabloqpacin    }~~~~~#########"
Write-Host "------###################################################################------`n"

### Tested successfully on WindowsServer2022 (fresh VBox VM)
# curl https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/windows/scripts/autosetup/WinServer22-base.ps1 -o server.ps1
# .\server.ps1

########## FUNCTIONS ########

function install_brave {

    if (-not (Test-Path 'C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe')) {
        Write-Host '== Downloading Brave =='
        
        $brave_pkg = 'BraveBrowserSetup-BRV011.exe'
        Invoke-WebRequest -Uri https://referrals.brave.com/latest/$brave_pkg -OutFile $brave_pkg

        if ($?) {
            Write-Host '== Installing Brave ==' 
            Start-Process $brave_pkg -Wait
            Remove-Item $brave_pkg
        }
    } else {
        Write-Host '== Brave is already installed =='
    }
}

function install_vscode {

    if (-not (Test-Path 'C:\Program Files\Microsoft VS Code\Code.exe')) {
        Write-Host '== Downloading VS Code =='
        
        $vscode_url = 'https://az764295.vo.msecnd.net/stable/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/'
        $vscode_pkg = 'VSCodeSetup-x64-1.84.2.exe'
        Invoke-WebRequest -Uri ($vscode_url + $vscode_pkg) -OutFile $vscode_pkg

        if ($?) {
            Write-Host '== Installing VS Code =='

            # no aplica el argumento 'addcontextmenufolder'
            $arguments = '/SILENT /mergetasks=!runcode,addcontextmenufiles,addcontextmenufolder'
            Start-Process -FilePath $vscode_pkg -ArgumentList $arguments -Wait
            Remove-Item $vscode_pkg
        }

    } else {
        Write-Output '== VSCode is already installed =='
    }
        # TODO: extensions ...
}

function install_terminal {

    if (-not (Test-Path 'C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_*\wt.exe')) {
        
        if (-not (Test-Path 'C:\Program Files\WindowsApps\Microsoft.VCLibs.140.00.UWP*')) {
            Write-Output '== Downloading Windows Terminal requirements =='

            $req_pkg = 'Microsoft.VCLibs.x64.14.00.Desktop.appx'
            Invoke-WebRequest -Uri https://aka.ms/$req_pkg -OutFile $req_pkg
        
            if ($?) { 
                Write-Output '== Installing Windows Terminal requirements =='
                Add-AppxPackage $req_pkg
                Remove-Item $req_pkg
            }

        } else {
            Write-Output '== Windows Terminal requirements are already installed =='
        }

        Write-Output '== Downloading Windows Terminal =='
        
        # $terminal_pkg = 'Microsoft.WindowsTerminal_1.7.1091.0_8wekyb3d8bbwe.msixbundle'
        # Invoke-WebRequest -Uri https://github.com/microsoft/terminal/releases/download/$terminal_pkg -OutFile $terminal_pkg
        $terminal_pkg = 'Microsoft.WindowsTerminal_Win10_1.14.2281.0_8wekyb3d8bbwe.msixbundle'
        Invoke-WebRequest -Uri https://github.com/microsoft/terminal/releases/download/v1.14.2281.0/$terminal_pkg -OutFile $terminal_pkg
        
        if ($?) {
            Write-Output '== Installing Windows Terminal =='
            Add-AppxPackage $terminal_pkg
            Remove-Item $terminal_pkg
        }

    } else {
        Write-Output '== Windows Terminal is already installed =='
    }
        # TODO: settings.json ...
}

function install_pwsh {
    $pwsh7_pkg = 'PowerShell-7-4-0-win-x64.msixbundle'
    Invoke-WebRequest -Uri https://github.com/PowerShell/PowerShell/releases/download/v7.4.0/$pwsh7_pkg -OutFile $pwsh7_pkg
    Add-AppxPackage $pwsh7_pkg
    Remove-Item $pwsh7_pkg
}

function install_nerdfont {
    # ...
}


# function install_git {}
# function install_tldr {}
# function install_dotfiles {}

function install_nmap {
    # website downloads windows
    # click click click
}

# function install_neovim {}
# function install_wsl {}
# function install_misc { ... bat eza lf ... }

########## RUNTIME ########

# Get-WindowsFeature

install_brave
install_vscode

install_terminal
# install_pwsh

# install_nmap
# install_nerdfont


# ======x======

### if (!($?)) {echo foo} else {echo bar} == si último comando no funciona, haz tal, de lo contrario, cual

# # Install VSCode extensions
# $extensions = @('ms-python.python', 'vscode-icons', '...')  # Add your desired extensions
# $extensions | ForEach-Object {
#     Start-Process -FilePath "$vscode_bin" -ArgumentList " --install-extension $_" -Wait
# }