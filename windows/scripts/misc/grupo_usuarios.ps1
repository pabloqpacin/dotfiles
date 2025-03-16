# Obtener el nombre de usuario actual
$currentUser = $env:USERNAME

# Obtener los grupos a los que pertenece el usuario actual
$groups = Get-LocalGroup |
          ForEach-Object { Get-LocalGroupMember -Group $_.Name } |
          Where-Object { $_.Name -eq $currentUser -or $_.SID -eq (New-Object System.Security.Principal.NTAccount($currentUser)).Translate([System.Security.Principal.SecurityIdentifier]).Value }

# Mostrar los nombres de los grupos
$groups | Select-Object -Property Name
