install-module activedirectory  # --no-confirm or -y or whatever

Get-AdDomain

# ...


# ---

Get-WmiObject -Class win32_Process | select-object 'Name', 'ID'
