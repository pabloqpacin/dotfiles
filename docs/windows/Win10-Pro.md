# Windows 10 (Pro)

```yaml
Instalar ahora:
    Activar Windows: No tengo clave de producto
    Sistema Operativo: Windows 10 Pro
    Licencia: Aceptar
    Instalación:
        Personalizada:
            Disco 50GB:
                - Nuevo
                - Siguiente
    
    Región: España
    Teclado: Español
    Cuenta:
        Uso personal:
            Cuenta sin conexión: Experiencia limitada:
                - Nombre: pabloqpacin
                - Contra: changeme
    
    Importar expl. Edge: No
    Ubicación: No
    Encontrar dispositivo: No
    Enviar telemetría: Requerida
    Manuscritos: No
    Exp. personalizada: No
    ID publicidad: No
    Experiencia: Omitir
    Cortana: No
    Edge: Cerrar


Devices: Guest Additions: VBoxWindowsAdditions: Reboot now

Configuración:
    Actualización y seguridad: Buscar actualizaciones
    Personalización: ...

Microsoft Store:
    Descargas y actualizaciones: 
        Instalador de aplicación: Obtener actualizaciones
```


```ps1
winget install `
    microsoft.windowsterminal `
    brave.brave neovim.neovim `
    sharkdp.bat git.git

git clone https://github.com/pabloqpacin/dotfiles


<#
ADMIN
#>
New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\nvim"
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.vimrc" -Path "$env:LOCALAPPDATA\nvim\init.vim"
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\bat" -Path "$env:APPDATA\bat"


set-executionpolicy unrestricted -scope process
.\dotfiles\windows\scripts\setup\ssh_server.ps1

winget uninstall `
    # Microsoft.Edge 'Microsoft Edge Update' Microsoft.EdgeWebView2Runtime `
    Microsoft.MicrosoftEdge.Stable_8wekyb3d8bbwe `
    # Microsoft.Advertising.Xaml_8wekyb3d8bbwe `
    Microsoft.BingWeather_8wekyb3d8bbwe `
    Microsoft.BingSearch_8wekyb3d8bbwe `
    Microsoft.Xbox.TCUI_8wekyb3d8bbwe `
    Microsoft.XboxApp_8wekyb3d8bbwe `
    Microsoft.XboxGameOverlay_8wekyb3d8bbwe `
    Microsoft.XboxGamingOverlay_8wekyb3d8bbwe `
    Microsoft.XboxIdentityProvider_8wekyb3d8bbwe `
    Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe `
    Cortana Microsoft.549981C3F5F10_8wekyb3d8bbwe `
    Skype Microsoft.SkypeApp_kzf8qxf38zg5c

<#
USER
#>
```

- VPN

```ps1
winget install wireguard.wireguard

# echo "
# [Interface]
# PrivateKey = sGUraZ/VsBiRKM+wtIkxy22nasVLZy6X9kMoMjABU0U=
# Address = 10.144.146.4/24
# DNS = 1.1.1.1, 8.8.8.8

# [Peer]
# PublicKey = Zj7UU3UQ97/msrZH51nqePa/ykrHm5Gc34oZhhMrWgI=
# PresharedKey = KwZWADLj4nrjSOyweScTPin+Q6XdSfGqr6ekdKW4fkE=
# AllowedIPs = 0.0.0.0/1, 128.0.0.0/1, ::/1, 8000::/1
# Endpoint = josea991.ddns.net:51820
# PersistentKeepalive = 25
# "

brave 192.168.1.150:8006
# user: pablo
# pass: P@blo1234

brave 192.168.1.50
# user: pablo.quevedo@rpj.solutions.com
# pass: changeme
```
