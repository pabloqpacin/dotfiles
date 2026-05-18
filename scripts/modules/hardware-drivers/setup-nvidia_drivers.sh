#!/usr/bin/env bash

# NOTE: https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Debian&target_version=13&target_type=deb_local

set -euo pipefail

setup_nvidia_drivers() {
  # CUDA repo (skip if already installed)
  if ! dpkg -s cuda-repo-debian13-13-2-local >/dev/null 2>&1; then
    wget https://developer.download.nvidia.com/compute/cuda/13.2.1/local_installers/cuda-repo-debian13-13-2-local_13.2.1-595.58.03-1_amd64.deb
    sudo dpkg -i cuda-repo-debian13-13-2-local_13.2.1-595.58.03-1_amd64.deb
    sudo cp /var/cuda-repo-debian13-13-2-local/cuda-*-keyring.gpg /usr/share/keyrings/
    sudo apt-get update
  fi

  # headers are required to build the kernel module (this was missing)
  sudo apt-get install -y \
    linux-headers-"$(uname -r)" \
    dkms build-essential \
    nvidia-open \
    nvtop

  sudo dkms autoinstall -k "$(uname -r)"
  sudo modprobe nvidia

  nvidia-smi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if ! nvidia-smi &>/dev/null; then
    setup_nvidia_drivers "$@"
  else
    echo "NVIDIA drivers already installed"
  fi
fi
