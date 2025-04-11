<#
.Synopsis
Handy bash-like functions for pwsh.

.Description
.Example
which pwsh == (get-command pwsh).source

.Notes
#>

function which ($command) {
    (get-command $command -erroraction silentlycontinue).source
}

function Get-IP {

    foreach ($interfaz in Get-NetIPConfiguration) {
        $interfaz.InterfaceDescription
        $interfaz.IPv4Address.IPAddress
    }
}


function bat_pwd {
    Get-ChildItem . | ForEach-Object {
        bat $_
    }
}


function get_module_commands {
    # $ get_module_commands ActiveDirectory
    Get-Command -Module $($args[0]) -CommandType Cmdlet
}
