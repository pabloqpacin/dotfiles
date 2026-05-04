# Pop!_OS 22.04 LTS - Kernel 6.12.10 - NVIDIA 550.144.03

<!-- 
- https://www.reddit.com/r/pop_os/comments/1fkqfgg/comment/lnyev0z/

 -->

## 1. Kernel

- Ver kernel actual

```sh
uname -r
```

- Ver kernels disponibles
```sh
dpkg -l | grep linux-image

ls -la /boot/vmlinuz-*
ls -la /boot/initrd.img-*
```

- Limpieza...

```sh
# Eliminar todos los kernels excepto 6.12.10 y 6.17.9
sudo apt remove --purge $(dpkg -l | grep linux-image | grep -v "6.12.10\|6.17.9\|generic$" | awk '{print $2}')

# Limpiar archivos de /boot manualmente
sudo rm -f /boot/initrd.img-6.0.12-76060012-generic /boot/initrd.img-6.16.3-76061603-generic

# Limpiar restos
sudo apt autoremove --purge
```

- Verificar

```sh
ls -la /boot/vmlinuz-*
  # .rw------- 16M root root  1 Jul  2025  /boot/vmlinuz-6.12.10-76061203-generic
  # .rw------- 17M root root  2 Dec  2025  /boot/vmlinuz-6.17.9-76061709-generic

ls -la /boot/initrd.img-*
  # .rw-r--r-- 95M root root 11 Feb 23:26  /boot/initrd.img-6.12.10-76061203-generic
  # .rw-r--r-- 99M root root 16 Feb 00:07  /boot/initrd.img-6.17.9-76061709-generic
```

- Menú **systemd-boot** con 6.17.9 como default y 6.12.10 como oldkernel

<!--
```sh
sudo ls -la /boot/efi/EFI
sudo ls -la /boot/efi/loader

efibootmgr -v

sudo cat /boot/efi/loader/loader.conf
sudo cat /boot/efi/loader/entries
sudo cat /boot/efi/loader/entries/Pop_OS-current.conf
``` -->

```sh
# Paso 1: Forzar 6.12.10 como current (temporalmente)
sudo kernelstub -v \
  -k /boot/vmlinuz-6.12.10-76061203-generic \
  -i /boot/initrd.img-6.12.10-76061203-generic

# Paso 2: Inmediatamente forzar 6.17.9 de vuelta a current
sudo kernelstub -v \
  -k /boot/vmlinuz-6.17.9-76061709-generic \
  -i /boot/initrd.img-6.17.9-76061709-generic

# Asegurar que el timeout esté configurado
if ! sudo grep -q "^timeout" /boot/efi/loader/loader.conf; then
    echo "timeout 3" | sudo tee -a /boot/efi/loader/loader.conf
fi
```

<!--
```bash
# Ver entradas de systemd-boot
sudo ls -la /boot/efi/loader/entries/

# Ver configuración actual de kernelstub
sudo kernelstub -v
```
--->

## 2. Compilar Nvidia 550 solo para 6.12

```sh
# Excluir kernel 6.17.9 de DKMS (evita que intente compilar para él)
echo 'EXCLUDE="6.17.9-76061709-generic"' | sudo tee /etc/dkms/nvidia

# Verificar que los módulos están compilados para 6.12.10
sudo dkms status | grep nvidia
  # nvidia/550.144.03, 6.12.10-76061203-generic, x86_64: installed
ls -la /lib/modules/6.12.10-76061203-generic/kernel/drivers/char/drm/nvidia*

# Configurar paquetes pendientes (debería funcionar ahora)
sudo dpkg --configure -a
```

> [!IMPORTANT]
> Si da error con el 6.17 da igual... la cosa es que compile bien para el 6.12

**Después de reiniciar con kernel 6.12.10:**

```sh
uname -r
  # 6.12.10-76061203-generic

# Los módulos deberían cargarse automáticamente
nvidia-smi
  # Debe mostrar: Driver Version: 550.144.03
```

### Más gestión del 550 si fuera necesario

- Verificar versión instalada
```bash
# Ver qué versión de drivers NVIDIA 550 está instalada
apt list --installed | grep nvidia-driver-550

# Ver estado de DKMS
sudo dkms status
```

- Si los drivers no están correctamente instalados:
```bash
# Instalar versión específica 550.144.03
sudo apt install nvidia-driver-550=550.144.03-0ubuntu0.22.04.1 \
libnvidia-gl-550=550.144.03-0ubuntu0.22.04.1 \
nvidia-dkms-550=550.144.03-0ubuntu0.22.04.1 \
nvidia-kernel-common-550=550.144.03-0ubuntu0.22.04.1 \
nvidia-kernel-source-550=550.144.03-0ubuntu0.22.04.1 \
libnvidia-compute-550=550.144.03-0ubuntu0.22.04.1 \
libnvidia-extra-550=550.144.03-0ubuntu0.22.04.1 \
nvidia-compute-utils-550=550.144.03-0ubuntu0.22.04.1 \
libnvidia-decode-550=550.144.03-0ubuntu0.22.04.1 \
libnvidia-encode-550=550.144.03-0ubuntu0.22.04.1 \
nvidia-utils-550=550.144.03-0ubuntu0.22.04.1 \
xserver-xorg-video-nvidia-550=550.144.03-0ubuntu0.22.04.1 \
libnvidia-cfg1-550=550.144.03-0ubuntu0.22.04.1 \
libnvidia-fbc1-550=550.144.03-0ubuntu0.22.04.1
```

<!--
- Congelar paquetes NVIDIA para evitar actualizaciones
```bash
# Congelar todos los paquetes NVIDIA 550
sudo apt-mark hold nvidia-driver-550 nvidia-dkms-550 nvidia-kernel-common-550 \
    nvidia-kernel-source-550 nvidia-compute-utils-550 nvidia-utils-550 \
    xserver-xorg-video-nvidia-550 libnvidia-cfg1-550 libnvidia-compute-550 \
    libnvidia-decode-550 libnvidia-encode-550 libnvidia-extra-550 \
    libnvidia-fbc1-550 libnvidia-gl-550

# Verificar paquetes congelados
apt-mark showhold | grep nvidia
``` -->

- Bloqueo de paquetes NVIDIA...
```sh
vim /etc/apt/preferences.d/nvidia-550
```
```ini
# Preferir versión 550 de NVIDIA
Package: nvidia-driver-550 nvidia-dkms-550 nvidia-kernel-common-550 \
         nvidia-kernel-source-550 nvidia-compute-utils-550 nvidia-utils-550 \
         xserver-xorg-video-nvidia-550 \
         libnvidia-cfg1-550 libnvidia-compute-550 libnvidia-decode-550 \
         libnvidia-encode-550 libnvidia-extra-550 libnvidia-fbc1-550 \
         libnvidia-gl-550 libnvidia-common-550
Pin: version 550.144.*
Pin-Priority: 2000

# Bloquear versiones 565 de NVIDIA
Package: nvidia-driver-565 nvidia-dkms-565 nvidia-kernel-common-565 \
         nvidia-kernel-source-565 nvidia-compute-utils-565 nvidia-utils-565 \
         xserver-xorg-video-nvidia-565 \
         libnvidia-cfg1-565 libnvidia-compute-565 libnvidia-decode-565 \
         libnvidia-encode-565 libnvidia-extra-565 libnvidia-fbc1-565 \
         libnvidia-gl-565 libnvidia-common-565
Pin: version 565.*
Pin-Priority: -1

# Bloquear versiones 570 de NVIDIA
Package: nvidia-driver-570 nvidia-dkms-570 nvidia-kernel-common-570 \
         nvidia-kernel-source-570 nvidia-compute-utils-570 nvidia-utils-570 \
         xserver-xorg-video-nvidia-570 \
         libnvidia-cfg1-570 libnvidia-compute-570 libnvidia-decode-570 \
         libnvidia-encode-570 libnvidia-extra-570 libnvidia-fbc1-570 \
         libnvidia-gl-570 libnvidia-common-570
Pin: version 570.*
Pin-Priority: -1
```

- Compilar drivers para kernel 6.12.10 específicamente si fuera necesario
```bash
# Asegurar que los drivers se compilen solo para 6.12.10
sudo dkms install nvidia/550.144.03 -k 6.12.10-76061203-generic

# Verificar compilación
sudo dkms status
ls -la /lib/modules/6.12.10-76061203-generic/kernel/drivers/char/drm/nvidia*
```

## 3. Reiniciar y Verificar

### 3.1 Reiniciar el sistema

```bash
sudo reboot
```

### 3.2 Al arrancar

1. **Si configuraste timeout**: Verás el menú de systemd-boot con opciones:
   - `Pop!_OS 22.04` (kernel 6.17.9 - current)
   - `Pop!_OS 22.04 (oldkernel)` (kernel 6.12.10)
   
2. **Selecciona**: `Pop!_OS 22.04 (oldkernel)` para usar kernel 6.12.10

### 3.3 Verificar después del arranque

```bash
# Verificar kernel activo
uname -r
# Debe mostrar: 6.12.10-76061203-generic

# Verificar drivers NVIDIA
nvidia-smi
# Debe mostrar: Driver Version: 550.144.03

# Verificar estado de DKMS
sudo dkms status
# Debe mostrar: nvidia/550.144.03, 6.12.10-76061203-generic, x86_64: installed
```


---

## 4. Configuración de Mantenimiento

### 4.1 Prevenir actualizaciones automáticas de kernel

```bash
# Congelar kernels específicos (opcional)
sudo apt-mark hold linux-image-6.12.10-76061203-generic \
    linux-headers-6.12.10-76061203-generic

# # O congelar todos los kernels (más agresivo)
# sudo apt-mark hold linux-image-generic linux-headers-generic
```

### 4.2 Configurar APT para mantener drivers NVIDIA 550

El archivo `/etc/apt/preferences.d/nvidia-550` ya debería estar configurado. Verificar:

```bash
cat /etc/apt/preferences.d/nvidia-550
```

Si no existe, crearlo:

```bash
sudo nano /etc/apt/preferences.d/nvidia-550
```

Contenido:
```
# Preferir versión 550 de NVIDIA
Package: nvidia-driver-550 nvidia-dkms-550 nvidia-kernel-common-550 \
         nvidia-kernel-source-550 nvidia-compute-utils-550 nvidia-utils-550 \
         xserver-xorg-video-nvidia-550 \
         libnvidia-cfg1-550 libnvidia-compute-550 libnvidia-decode-550 \
         libnvidia-encode-550 libnvidia-extra-550 libnvidia-fbc1-550 \
         libnvidia-gl-550 libnvidia-common-550
Pin: version 550.144.03*
Pin-Priority: 1001
```

### 4.3 Actualizar sistema sin tocar NVIDIA o kernels

```bash
# Ver qué se actualizaría
sudo apt update
apt list --upgradable

# Actualizar excluyendo kernels y NVIDIA
sudo apt upgrade --exclude=linux-image-*,linux-headers-*,nvidia-*
```

- Actualizar firmware del sistema (UEFI, dispositivos) para mejoras de seguridad y compatibilidad (con cuidao!!)

```bash
fwupdmgr get-updates
fwupdmgr update
```

## 5. Solución de Problemas

### 5.1 Error: DKMS no compila para kernel 6.12.10

```bash
# Verificar que los headers están instalados
ls /usr/src/linux-headers-6.12.10-76061203-generic/

# Si no están, instalarlos
sudo apt install linux-headers-6.12.10-76061203-generic

# Limpiar y reinstalar DKMS
sudo dkms remove nvidia/550.144.03 --all
sudo dkms install nvidia/550.144.03 -k 6.12.10-76061203-generic
```

### 5.2 Error: Paquetes NVIDIA no se configuran

```bash
# Ver estado de paquetes
dpkg -l | grep nvidia-driver-550

# Forzar configuración
sudo dpkg --configure -a
sudo apt --fix-broken install
```

### 5.3 Problema: Menú de systemd-boot no aparece

```bash
# Verificar configuración
sudo cat /boot/efi/loader/loader.conf

# Asegurar que tiene timeout
echo "timeout 3" | sudo tee -a /boot/efi/loader/loader.conf

# Verificar entradas
sudo ls -la /boot/efi/loader/entries/
```

### 5.4 Problema: Sistema arranca en TTY en lugar de gráfico

```bash
# Verificar opciones de arranque
sudo kernelstub -v

# Si muestra multi-user.target, corregir:
sudo kernelstub -v \
  -k /boot/vmlinuz-6.12.10-76061203-generic \
  -i /boot/initrd.img-6.12.10-76061203-generic \
  -o "root=UUID=7233fcdf-a7eb-4bc6-bf8f-7b98d30ff992 ro quiet loglevel=0 systemd.show_status=false splash systemd.unit=graphical.target"
```

## 6. Verificaciones Finales

### 6.1 Estado del sistema

```bash
# Kernel activo
uname -r
# Esperado: 6.12.10-76061203-generic

# Drivers NVIDIA
nvidia-smi
# Esperado: Driver Version: 550.144.03

# DKMS
sudo dkms status
# Esperado: nvidia/550.144.03, 6.12.10-76061203-generic, x86_64: installed

# Módulos cargados
lsmod | grep nvidia
# Debe mostrar varios módulos nvidia cargados

# Ver GPUs disponibles
lspci | grep -i vga

# Ver drivers instalados (vía apt)
apt list --installed | grep nvidia

# Ver versiones disponibles de drivers 550
apt list -a nvidia-driver-550

# Monitorizar GPU en tiempo real
nvtop
```

### 8.2 Funcionalidad

- ✅ Segundo monitor funcionando
- ✅ Juegos funcionando (Steam, etc.)
- ✅ Aceleración GPU disponible
- ✅ Sin errores en logs del sistema


---

## Resumen

Con esta configuración:

1. ✅ **Kernel 6.12.10** disponible en el menú de arranque
2. ✅ **Drivers NVIDIA 550.144.03** compilados y funcionando
3. ✅ **Menú de systemd-boot** visible para elegir kernel
4. ✅ **Sistema protegido** contra actualizaciones no deseadas
5. ✅ **Compatibilidad completa** con segundo monitor y juegos

**Nota importante**: Cada vez que se actualice el kernel, necesitarás repetir los pasos 3.1 para mantener 6.12.10 disponible como `oldkernel`, o considerar hacer 6.12.10 el kernel por defecto (paso 3.2).
