<#  ABOUT
    - Functions and useful commands covered in HTB Academy: Windows Fundamentals
#>


########## PWSH
# Import-Module .\someScript.ps1                  # Import ps1 script to access enable its functions during the session
# Get-Module | select Name,ExportedCommands | fl  # See loaded modules and their functions


########## USERS
# runas
function showUsers {
    $userList = net user | ForEach-Object {
        if ($_ -match '^(?i)([a-z0-9_]+)\s+') {
            $matches[1]
        }
    }
    foreach ($user in $userList) {
        Write-Host "User: $user"
        net user $user
    }
}
# whoami /user      # SID!!


########## GROUPS
# Get-LocalGroup | fl


########## SYSTEM
# wmic os list brief
# wmic computersystem get name
# Get-WmiObject -Class ( win32_OperatingSystem || win32_Process || win32_Service || win32_Bios )
# Get-WmiObject -Class Win32_OperatingSystem | select SystemDirectory,BuildNumber,SerialNumber,Version | ft


########## EXECUTION POLICY
# Get-ExecutionPolicy -List
# Set-ExecutionPolicy Bypass -Scope Process


########## FILESYSTEM
function rename_wmi_object ($object, $new_object) {
    Invoke-WmiMethod -Path "CIM_DataFile.Name='$object'" -Name Rename -ArgumentList "$new_object"
}   # Invoke-WmiMethod -Path "CIM_DataFile.Name='C:\users\public\spns.csv'" -Name Rename -ArgumentList "C:\Users\Public\kerberoasted_users.csv"


########## PERMISSIONS
# icacls C:\Windows
# icacls C:\USERS /grant JOE:F; icacls C:\USERS /remove JOE


########## SERVICES
# sc stop wuauserv
# sc config wuauserv binPath=C:\Windows\PerfectlyLegitProgram.exe
function services_all { Get-Service | ForEach-Object { sc qc $_.Name } }
function services_running { Get-Service | Where-Object { $_.Status -eq 'Running' } | ForEach-Object { sc qc $_.Name } }
function services_running_fl { Get-Service | ? {$_.Status -eq "Running"} | Format-List }
function service_ACL ($service) { Get-ACL -Path HKLM:\System\CurrentControlSet\Services\$service | Format-List }


########## SYSINTERNALS
# [ procdump procexp procmon psexec tcpview ]


########## HKEYS
# Get-ChildItem $env:SYSTEMROOT\System32\Config
# Get-ChildItem -Hidden $env:HOMEPATH             # ntuser.dat == HKCU
function showRunHKEYS {
    reg query HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run
    reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
}


########## SECURITY
function showDefenderProtection { Get-MpComputerStatus | findstr "True" }


