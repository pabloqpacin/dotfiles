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
