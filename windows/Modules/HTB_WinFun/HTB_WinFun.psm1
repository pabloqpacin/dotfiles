<#

.Synopsis
PWSH - SYSTEM - FILESYSTEM - EXEC. POL. - PERMISSIONS - USERS - GROUPS - A.D. -
NETWORKING - PROCESSES - SERVICES - HKEYS - SECURITY - SYSINTERNALS - FILES

.Description  
CMD and PWSH functions and useful commands covered in HTB Academy: Windows Fundamentals. Recon & enumeration flags:
1. General System Information: hostname, OS-specific details (name, version, configuration, etc.), and installed hotfixes/patches for the system
2. Networking Information: host IP address, available network interfaces, accessible subnets, DNS server(s), known hosts, and network resources
3. Basic Domain Information
4. User Information: environment variables, currently running tasks, scheduled tasks, and known services

.Example  
...

.Notes  
- https://learn.microsoft.com/en-us/powershell/scripting/developer/module/writing-a-windows-powershell-module?view=powershell-7.2
- https://learn.microsoft.com/en-us/powershell/scripting/developer/help/writing-help-for-windows-powershell-scripts-and-functions?view=powershell-7.2
- https://learn.microsoft.com/en-us/powershell/scripting/developer/help/comment-based-help-keywords?view=powershell-7.2
- https://learn.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2022-ps
- https://github.com/PowerShellMafia/PowerSploit#out-encodedcommand
- https://github.com/carlospolop/PEASS-ng/tree/master
- https://github.com/BC-SECURITY/Empire/tree/main
- https://github.com/Kevin-Robertson/Inveigh
- https://github.com/SpecterOps/BloodHound          # (New-Object Net.WebClient).DownloadFile("https://github.com/SpecterOps/BloodHound/archive/refs/tags/v5.0.10.zip", "Bloodhound.zip")
- https://github.com/SnaffCon/Snaffler

#>


########## PWSH
# Import-Module .\someScript.ps1                  # Import ps1 script to access enable its functions during the session
# Get-Module | select Name,ExportedCommands | fl  # See loaded modules and their functions


########## SYSTEM
# systeminfo; hostname; ver
# wmic os list brief
# wmic computersystem get name
# Get-WmiObject -Class ( win32_OperatingSystem || win32_Process || win32_Service || win32_Bios )
# Get-WmiObject -Class Win32_OperatingSystem | select SystemDirectory,BuildNumber,SerialNumber,Version | ft


########## FILESYSTEM
# fsutil volume list
# function reconCMD { dir /A /P %SYSTEMROOT%\Temp; dir /A /P %TEMP%; dir /A /P %PUBLIC%; dir /A /P "C:\Program Files"; dir /A /P "C:\Program Files (x86)" }
function rename_wmi_object ($object, $new_object) {
    Invoke-WmiMethod -Path "CIM_DataFile.Name='$object'" -Name Rename -ArgumentList "$new_object"
}   # Invoke-WmiMethod -Path "CIM_DataFile.Name='C:\users\public\spns.csv'" -Name Rename -ArgumentList "C:\Users\Public\kerberoasted_users.csv"


########## EXECUTION POLICY
# Get-ExecutionPolicy -List
# Set-ExecutionPolicy Bypass -Scope Process


########## PERMISSIONS
# icacls C:\Windows
# icacls C:\USERS /grant JOE:F; icacls C:\USERS /remove JOE


########## USERS
# runas
# whoami /user; whoami /all         # SID!!
# Get-LocalUser * | Select-Object -Property Name,PasswordLastSet
# Get-LocalUser * | Sort-Object -Property Name | Group-Object -property Enabled
function showUsers {
    $userList = net user | ForEach-Object { if ($_ -match '^(?i)([a-z0-9_]+)\s+') { $matches[1] } }
    foreach ($user in $userList) { Write-Host "User: $user"; net user $user }
}


########## GROUPS
# Get-LocalGroup | fl
function showGroupUsers {
    foreach ($Group in Get-LocalGroup) {
        Write-Host "$Group"
        Get-LocalGroupMember -Name $Group | Format-List
    }
}


########## ACTIVE DIRECTORY
# net user; net localgroup; net group; net share


########## NETWORKING
# ipconfig /all; arp /a; netstsat -an
# Get-NetAdapter; Get-NetIPInterface; Get-NetIPAddress


########## PROCESSES
# get-process | sort | unique | measure-object
# get-process | where-object CPU | where-object path | get-item


########## SERVICES
# tasklist /svc; wmic service list brief; sc query type= service | more; SCHTASKS /Query /V /FO list
# sc stop wuauserv; sc config wuauserv binPath=C:\Windows\PerfectlyLegitProgram.exe
# Get-Service | where DisplayName -like '*Defender*'
# Get-Service | Format-Table DisplayName,Status
function scs { sc query type=service | less }
function services_all { Get-Service | ForEach-Object { sc qc $_.Name } }
function services_running { Get-Service | Where-Object { $_.Status -eq 'Running' } | ForEach-Object { sc qc $_.Name } }
function services_running_fl { Get-Service | ? {$_.Status -eq "Running"} | Format-List }
function service_ACL ($service) { Get-ACL -Path HKLM:\System\CurrentControlSet\Services\$service | Format-List }


########## HKEYS
# Get-ChildItem -Hidden $env:HOMEPATH             # ntuser.dat == HKCU
# Get-ChildItem $env:SYSTEMROOT\System32\Config
# REG QUERY HKCU /F "Password" /t REG_SZ /S /K
function showRunHKEYS {
    # Get-Item -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run | Select-Object -ExpandProperty Property
    # Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
    reg query HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run
    reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
}


########## SECURITY
function showDefenderProtection { Get-MpComputerStatus | findstr "True" }


########## SYSINTERNALS
# [ procdump procexp procmon psexec tcpview ]


########## FILES (CMD)
# xcopy /E /K; find /n /i "OJO" < ojo.txt                                               
