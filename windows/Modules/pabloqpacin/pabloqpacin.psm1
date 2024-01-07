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

