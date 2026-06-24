#!/usr/bin/env bash

set -euo pipefail

detect_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  else
    echo "unknown"
  fi
}

detect_linux_id() {
  if [[ -r "/etc/os-release" ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    printf '%s\n' "${ID:-unknown}"
    return 0
  fi
  echo "unknown"
}

detect_apt_docker_repo_distro() {
  local linux_id
  linux_id="$(detect_linux_id)"

  case "${linux_id}" in
    debian) echo "debian" ;;
    ubuntu|pop|pop_os|popos) echo "ubuntu" ;;
    *)
      echo "unsupported"
      ;;
  esac
}

are_all_packages_installed_apt() {
  local pkg
  for pkg in "$@"; do
    if ! dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null | rg -q "install ok installed"; then
      return 1
    fi
  done
  return 0
}

are_all_packages_installed_dnf() {
  local pkg
  for pkg in "$@"; do
    if ! rpm -q "${pkg}" >/dev/null 2>&1; then
      return 1
    fi
  done
  return 0
}

is_docker_stack_installed() {
  case "$(detect_pkg_manager)" in
    apt)
      are_all_packages_installed_apt \
        docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      ;;
    dnf)
      are_all_packages_installed_dnf \
        docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      ;;
    *)
      return 1
      ;;
  esac
}

install_docker_apt() {
  local docker_repo_distro
  docker_repo_distro="$(detect_apt_docker_repo_distro)"
  if [[ "${docker_repo_distro}" == "unsupported" ]]; then
    echo "Unsupported apt distro for Docker official repo: $(detect_linux_id)"
    return 1
  fi

  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends ca-certificates curl

  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL "https://download.docker.com/linux/${docker_repo_distro}/gpg" \
    -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/${docker_repo_distro}
Suites: $(. /etc/os-release && echo "${VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

  # Cleanup legacy source/key names if they exist.
  if [[ -f /etc/apt/sources.list.d/docker.list ]]; then
    sudo rm /etc/apt/sources.list.d/docker.list
  fi
  if [[ -f /etc/apt/keyrings/docker.gpg ]]; then
    sudo rm /etc/apt/keyrings/docker.gpg
  fi

  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

install_docker_dnf() {
  sudo dnf -y install dnf-plugins-core
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install -y \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

configure_docker_service() {
  if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl enable --now docker
  fi
}

configure_docker_group() {
  local target_user
  target_user="${SUDO_USER:-${USER:-}}"
  [[ -z "${target_user}" ]] && return 0

  if ! getent group docker >/dev/null; then
    sudo groupadd docker
  fi

  if id -nG "${target_user}" | rg -w "docker" >/dev/null 2>&1; then
    return 0
  fi

  sudo usermod -aG docker "${target_user}"
  echo "User '${target_user}' added to docker group."
  echo "Log out/in (or run: newgrp docker) to apply group membership."
}

setup_docker() {
  if is_docker_stack_installed; then
    echo "Docker packages already installed; skipping package installation."
  else
    case "$(detect_pkg_manager)" in
      apt)
        install_docker_apt
        ;;
      dnf)
        install_docker_dnf
        ;;
      *)
        echo "Unsupported package manager for automated Docker setup."
        return 1
        ;;
    esac
  fi

  configure_docker_service
  configure_docker_group
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_docker
fi
