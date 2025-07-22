# Nvidia (Pop_OS 22.04 en MSI-GL76)

<!-- 
> Primeras movidas en abril.
>
> Ya no valen porque el repo por defecto no muestra 550 sino 565 y 570. Es decir, el comando `sudo apt install nvidia-driver-550-server` no es streamlined.



#!/usr/bin/env bash

previa(){
    apt list --installed | grep nvidia
        # libnvidia-cfg1-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # libnvidia-common-565/jammy,jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a all [installed,automatic]
        # libnvidia-compute-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # libnvidia-compute-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a i386 [installed,automatic]
        # libnvidia-decode-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # libnvidia-decode-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a i386 [installed,automatic]
        # libnvidia-egl-wayland1/jammy,now 1:1.1.16-1pop1~1725624760~22.04~ab32ce2 amd64 [installed,automatic]
        # libnvidia-egl-wayland1/jammy,now 1:1.1.16-1pop1~1725624760~22.04~ab32ce2 i386 [installed,automatic]
        # libnvidia-encode-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # libnvidia-encode-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a i386 [installed,automatic]
        # libnvidia-extra-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # libnvidia-fbc1-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # libnvidia-fbc1-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a i386 [installed,automatic]
        # libnvidia-gl-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # libnvidia-gl-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a i386 [installed,automatic]
        # nvidia-compute-utils-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # nvidia-dkms-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # nvidia-driver-525/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed]
        # nvidia-driver-550/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed]
        # nvidia-driver-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # nvidia-firmware-565-565.77/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # nvidia-kernel-common-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # nvidia-kernel-source-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # nvidia-settings/jammy,now 510.47.03-0ubuntu1 amd64 [installed,automatic]
        # nvidia-utils-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]
        # xserver-xorg-video-nvidia-565/jammy,now 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64 [installed,automatic]

    nvidia-smi
        # +-----------------------------------------------------------------------------------------+
        # | NVIDIA-SMI 565.77                 Driver Version: 565.77         CUDA Version: 12.7     |
        # |-----------------------------------------+------------------------+----------------------+
        # | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
        # | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
        # |                                         |                        |               MIG M. |
        # |=========================================+========================+======================|
        # |   0  NVIDIA GeForce RTX 3060 ...    Off |   00000000:01:00.0 Off |                  N/A |
        # | N/A   53C    P0             24W /   80W |      16MiB /   6144MiB |      0%      Default |
        # |                                         |                        |                  N/A |
        # +-----------------------------------------+------------------------+----------------------+

        # +-----------------------------------------------------------------------------------------+
        # | Processes:                                                                              |
        # |  GPU   GI   CI        PID   Type   Process name                              GPU Memory |
        # |        ID   ID                                                               Usage      |
        # |=========================================================================================|
        # |    0   N/A  N/A      3410      G   /usr/lib/xorg/Xorg                              4MiB |
        # +-----------------------------------------------------------------------------------------+
}


reddit(){
    # https://www.reddit.com/r/pop_os/comments/1fkqfgg/comment/lnyev0z/

    sudo apt install nvidia-driver-550-server
        # The following packages will be REMOVED:
        # libnvidia-cfg1-565
        # libnvidia-common-565
        # libnvidia-compute-565
        # libnvidia-compute-565:i386
        # libnvidia-decode-565
        # libnvidia-decode-565:i386
        # libnvidia-encode-565
        # libnvidia-encode-565:i386
        # libnvidia-extra-565
        # libnvidia-fbc1-565
        # libnvidia-fbc1-565:i386
        # libnvidia-gl-565
        # libnvidia-gl-565:i386
        # nvidia-compute-utils-565
        # nvidia-dkms-565 (565.77-1pop0ubuntu1~1743807808~22.04~ea6027a)
        # nvidia-driver-525 (565.77-1pop0ubuntu1~1743807808~22.04~ea6027a)
        # nvidia-driver-550 (565.77-1pop0ubuntu1~1743807808~22.04~ea6027a)
        # nvidia-driver-565 (565.77-1pop0ubuntu1~1743807808~22.04~ea6027a)
        # nvidia-kernel-common-565
        # nvidia-kernel-source-565
        # nvidia-utils-565
        # xserver-xorg-video-nvidia-565
        # The following NEW packages will be installed:
        # libnvidia-cfg1-550-server (550.144.03-0ubuntu0.22.04.1)
        # libnvidia-common-550-server (550.144.03-0ubuntu0.22.04.1)
        # libnvidia-compute-550-server (550.144.03-0ubuntu0.22.04.1)
        # libnvidia-compute-550-server:i386 (550.144.03-0ubuntu0.22.04.1)
        # libnvidia-decode-550-server (550.144.03-0ubuntu0.22.04.1)
        # libnvidia-decode-550-server:i386 (550.144.03-0ubuntu0.22.04.1)
        # libnvidia-encode-550-server (550.144.03-0ubuntu0.22.04.1)
        # libnvidia-encode-550-server:i386 (550.144.03-0ubuntu0.22.04.1)
        # libnvidia-extra-550-server (550.144.03-0ubuntu0.22.04.1)
        # libnvidia-fbc1-550-server (550.144.03-0ubuntu0.22.04.1)
        # libnvidia-fbc1-550-server:i386 (550.144.03-0ubuntu0.22.04.1)
        # libnvidia-gl-550-server (550.144.03-0ubuntu0.22.04.1)
        # libnvidia-gl-550-server:i386 (550.144.03-0ubuntu0.22.04.1)
        # nvidia-compute-utils-550-server (550.144.03-0ubuntu0.22.04.1)
        # nvidia-dkms-550-server (550.144.03-0ubuntu0.22.04.1)
        # nvidia-driver-550-server (550.144.03-0ubuntu0.22.04.1)
        # nvidia-firmware-550-server-550.144.03 (550.144.03-0ubuntu0.22.04.1)
        # nvidia-kernel-common-550-server (550.144.03-0ubuntu0.22.04.1)
        # nvidia-kernel-source-550-server (550.144.03-0ubuntu0.22.04.1)
        # nvidia-utils-550-server (550.144.03-0ubuntu0.22.04.1)
        # xserver-xorg-video-nvidia-550-server (550.144.03-0ubuntu0.22.04.1)
        # 0 upgraded, 21 newly installed, 22 to remove and 0 not upgraded.

    nvidia-smi
        # +-----------------------------------------------------------------------------------------+
        # | NVIDIA-SMI 550.144.03             Driver Version: 550.144.03     CUDA Version: 12.4     |
        # |-----------------------------------------+------------------------+----------------------+
        # | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
        # | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
        # |                                         |                        |               MIG M. |
        # |=========================================+========================+======================|
        # |   0  NVIDIA GeForce RTX 3060 ...    Off |   00000000:01:00.0 Off |                  N/A |
        # | N/A   45C    P8              8W /   80W |       9MiB /   6144MiB |      0%      Default |
        # |                                         |                        |                  N/A |
        # +-----------------------------------------+------------------------+----------------------+

        # +-----------------------------------------------------------------------------------------+
        # | Processes:                                                                              |
        # |  GPU   GI   CI        PID   Type   Process name                              GPU Memory |
        # |        ID   ID                                                               Usage      |
        # |=========================================================================================|
        # |    0   N/A  N/A      3529      G   /usr/lib/xorg/Xorg                              4MiB |
        # +-----------------------------------------------------------------------------------------+
}

chatgpt(){
    # (Optional) enable Pop!_OS driver PPA
    sudo apt update
    sudo apt install system76-driver-nvidia

    # Purge newer drivers
    sudo apt purge 'nvidia-*565*' 'nvidia-*525*'

    # Install 550 driver
    sudo apt install nvidia-driver-550 nvidia-utils-550 libnvidia-gl-550

    # Prevent auto‑upgrade
    sudo apt-mark hold nvidia-driver-550 nvidia-utils-550 libnvidia-gl-550

    # Rebuild initramfs and reboot
    sudo update-initramfs -u
    sudo reboot
}



 -->

---


```log
nvidia-smi
Tue Jul 22 15:35:35 2025
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 570.158.01             Driver Version: 570.158.01     CUDA Version: 12.8     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce RTX 3060 ...    Off |   00000000:01:00.0  On |                  N/A |
| N/A   54C    P8             16W /   80W |      64MiB /   6144MiB |      2%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A            3974      G   /usr/lib/xorg/Xorg                       25MiB |
|    0   N/A  N/A           23289    C+G   ...on/ubuntu12_64/steamwebhelper          5MiB |
+-----------------------------------------------------------------------------------------+

```


> - problema con Steam:
>   - se están usando los drives 570
> - solución:
>   - volver a implantar los 550


- Revisar sistema
```sh
# Ver qué drivers hay instalados (vía apt):
apt list --installed | grep nvidia

# Ver GPUs tenemos
lspci | grep -i vga

# Ver si estás usando Nouveau o el driver propietario:
lsmod | grep nvidia

# apt show system76-driver-nvidia
```

- Reinstalar los drivers 550
```sh
sudo apt purge 'nvidia-*570*'
sudo apt autoremove

sudo apt install nvidia-driver-550-server
```

- Monitorizar
```sh
nvtop
```


> [¡CAUTION]
> **INOP**: ahora solo nos deja instalar la 570

----

<!-- ```sh
sudo apt purge system76-driver-nvidia system76-driver \
                'nvidia-*570*' 'libnvidia-*570*'
sudo apt autoremove --purge

# apt list --installed | grep -E 'nvidia|libnvidia'
``` -->

```sh
apt list -a nvidia-driver-550
  # nvidia-driver-550/jammy 565.77-1pop0ubuntu1~1743807808~22.04~ea6027a amd64
  # nvidia-driver-550/jammy-updates 550.163.01-0ubuntu0.22.04.1 amd64
  # nvidia-driver-550/jammy-security 550.144.03-0ubuntu0.22.04.1 amd64

sudo apt-mark hold nvidia-driver-550
# TODO: undo the hold?

sudo apt install nvidia-driver-550=550.144.03-0ubuntu0.22.04.1
  # ...

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


- ...

```sh
# sudo update-initramfs -u
sudo reboot

# Al volver a iniciar, comprueba:
nvidia-smi
```
