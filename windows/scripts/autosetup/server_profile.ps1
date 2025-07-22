Set-PSReadLineOption -Colors @{ Command = 'DarkCyan' }

function showHist {
    bat -l ps1 (Get-PSReadlineOption).HistorySavePath
}

function get_module_commands {
    # $ get_module_commands ActiveDirectory
    Get-Command -Module $($args[0]) -CommandType Cmdlet
}

