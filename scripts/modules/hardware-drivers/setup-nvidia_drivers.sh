#!/usr/bin/env bash
#
# Instala drivers NVIDIA propietarios empaquetados por Debian (APT), alineado con:
#   https://wiki.debian.org/NvidiaGraphicsDrivers
# Runtime CUDA (nvidia-smi, NVML): con el driver. Toolkit nvcc en Debian: opcional
# (versiones fijadas por la release; para CUDA muy nuevo ver repo NVIDIA / conda).
#
# Requisitos APT (wiki «Prerequisites»): contrib, non-free y, desde Bookworm,
# non-free-firmware en las suites oficiales (incl. -security).
#
# Limitaciones / manual (no automatizables de forma segura aquí):
#   - Blackwell (p. ej. RTX 50xx): aún sin soporte en drivers empaquetados por Debian;
#     la wiki indica otros métodos de empaquetado hasta que se resuelva.
#   - Secure Boot: hace falta MOK para firmar módulos DKMS (ver wiki).
#   - dracut: si aplica, hay que incluir configs nvidia en dracut.conf.d (ver wiki).
#   - Kernel de backports suele exigir driver desde la misma suite -backports.
#
# Wayland (wiki «Wayland configuration»): por defecto se escribe
#   /etc/modprobe.d/nvidia-wayland.conf (modeset, fbdev, y opcionalmente
#   PreserveVideoMemoryAllocations). En portátiles Optimus híbridos esa última
#   opción puede fallar: exporta NVIDIA_WAYLAND_SKIP_PRESERVE_VIDEO_MEMORY=1.
#
# Variables de entorno:
#   NVIDIA_SKIP_IF_NO_GPU=1   Por defecto: no instalar si lspci no ve NVIDIA (patrón wiki).
#   NVIDIA_SKIP_IF_NO_GPU=0   Forzar instalación.
#   NVIDIA_OPEN_KERNEL_MODULES=1  Flavor «open» (Turing+; no Maxwell/Pascal/Volta).
#   NVIDIA_INSTALL_CUDA_TOOLKIT=1   nvidia-cuda-toolkit + nvidia-cuda-dev (wiki «Optional addons»).
#   NVIDIA_RUN_NVIDIA_DETECT=1      Instala y ejecuta nvidia-detect antes del apt install.
#   NVIDIA_ENABLE_BOOKWORM_SUSPEND_SERVICES=1  (solo Debian 12) habilita servicios systemd
#                                                nvidia-suspend/hibernate/resume (wiki Bookworm).
#   NVIDIA_WAYLAND_MODPROBE=1 (defecto) escribe modprobe.d para Wayland + NVIDIA.
#   NVIDIA_WAYLAND_MODPROBE=0   No tocar modprobe.d.
#   NVIDIA_WAYLAND_SKIP_PRESERVE_VIDEO_MEMORY=1  Omite NVreg_PreserveVideoMemoryAllocations (Optimus).
#
# OJO: máquina oficina MSC — 'NVIDIA RTX 4000 Ada Generation'; modulo_CV / CUDA.

set -euo pipefail

NVIDIA_SKIP_IF_NO_GPU="${NVIDIA_SKIP_IF_NO_GPU:-1}"
NVIDIA_INSTALL_CUDA_TOOLKIT="${NVIDIA_INSTALL_CUDA_TOOLKIT:-0}"
NVIDIA_OPEN_KERNEL_MODULES="${NVIDIA_OPEN_KERNEL_MODULES:-0}"
NVIDIA_RUN_NVIDIA_DETECT="${NVIDIA_RUN_NVIDIA_DETECT:-0}"
NVIDIA_ENABLE_BOOKWORM_SUSPEND_SERVICES="${NVIDIA_ENABLE_BOOKWORM_SUSPEND_SERVICES:-0}"
NVIDIA_WAYLAND_MODPROBE="${NVIDIA_WAYLAND_MODPROBE:-1}"
NVIDIA_WAYLAND_SKIP_PRESERVE_VIDEO_MEMORY="${NVIDIA_WAYLAND_SKIP_PRESERVE_VIDEO_MEMORY:-0}"

detect_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  else
    echo "unknown"
  fi
}

read_os_id() {
  if [[ ! -r /etc/os-release ]]; then
    echo "unknown"
    return 0
  fi
  # shellcheck disable=SC1091
  . /etc/os-release
  printf '%s\n' "${ID:-unknown}" | tr '[:upper:]' '[:lower:]'
}

read_debian_version_id() {
  if [[ ! -r /etc/os-release ]]; then
    echo "0"
    return 0
  fi
  # shellcheck disable=SC1091
  . /etc/os-release
  local v="${VERSION_ID%%.*}"
  if [[ "${v}" =~ ^[0-9]+$ ]]; then
    printf '%s\n' "${v}"
  else
    echo "0"
  fi
}

read_version_codename() {
  if [[ ! -r /etc/os-release ]]; then
    echo ""
    return 0
  fi
  # shellcheck disable=SC1091
  . /etc/os-release
  printf '%s\n' "${VERSION_CODENAME:-}"
}

# Wiki «apt components»: contrib + non-free; non-free-firmware desde Bookworm (12+).
apt_sources_have_required_components() {
  local f found_contrib=0 found_nonfree=0 found_nffw=0
  local major
  major="$(read_debian_version_id)"
  local need_nffw=0
  if [[ "${major}" =~ ^[0-9]+$ ]] && [[ "${major}" -ge 12 ]]; then
    need_nffw=1
  fi

  for f in /etc/apt/sources.list /etc/apt/sources.list.d/*.sources /etc/apt/sources.list.d/*.list; do
    [[ -e "${f}" ]] || continue
    if grep -qiE '(^|[[:space:]])contrib([[:space:]]|$)' "${f}" 2>/dev/null \
      || grep -qiE '^Components:.*\bcontrib\b' "${f}" 2>/dev/null; then
      found_contrib=1
    fi
    if grep -qiE '(^|[[:space:]])non-free([[:space:]]|$)' "${f}" 2>/dev/null \
      || grep -qiE '^Components:.*\bnon-free\b' "${f}" 2>/dev/null; then
      found_nonfree=1
    fi
    if grep -qiE '(^|[[:space:]])non-free-firmware([[:space:]]|$)' "${f}" 2>/dev/null \
      || grep -qiE '^Components:.*\bnon-free-firmware\b' "${f}" 2>/dev/null; then
      found_nffw=1
    fi
  done

  if [[ "${found_contrib}" -ne 1 || "${found_nonfree}" -ne 1 ]]; then
    return 1
  fi
  if [[ "${need_nffw}" -eq 1 && "${found_nffw}" -ne 1 ]]; then
    return 1
  fi
  return 0
}

# Wiki «GPU identification» — lspci | grep -iE "3d|display|vga" | grep -i nvidia
has_nvidia_pci_device() {
  if ! command -v lspci >/dev/null 2>&1; then
    return 1
  fi
  lspci 2>/dev/null | grep -iE '3d|display|vga' | grep -qi nvidia
}

maybe_warn_blackwell_or_unsupported() {
  if ! command -v lspci >/dev/null 2>&1; then
    return 0
  fi
  if lspci 2>/dev/null | grep -i nvidia | grep -qiE 'blackwell|gb20[0-9]|rtx[[:space:]]*5[0-9]{2,3}'; then
    echo "AVISO (wiki Debian): las GPUs Blackwell / RTX 50xx pueden no tener aún driver en paquetes Debian." >&2
    echo "  Revisa NvidiaGraphicsDrivers y métodos alternativos (repo NVIDIA, etc.)." >&2
  fi
}

kernel_headers_package() {
  local kver
  kver="$(uname -r)"
  printf 'linux-headers-%s\n' "${kver}"
}

packages_installed_apt() {
  local pkg status
  for pkg in "$@"; do
    status="$(dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null || true)"
    if [[ "${status}" != *"install ok installed"* ]]; then
      return 1
    fi
  done
  return 0
}

normalize_bool() {
  case "${1,,}" in
    true|1|yes|y|on) echo "true" ;;
    *) echo "false" ;;
  esac
}

ensure_pciutils_for_lspci() {
  if command -v lspci >/dev/null 2>&1; then
    return 0
  fi
  if [[ "$(detect_pkg_manager)" != "apt" ]]; then
    return 1
  fi
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends pciutils
}

run_nvidia_detect_optional() {
  if [[ "$(normalize_bool "${NVIDIA_RUN_NVIDIA_DETECT}")" != "true" ]]; then
    return 0
  fi
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get install -y --no-install-recommends nvidia-detect
  echo "--- nvidia-detect (wiki GPU identification) ---"
  nvidia-detect || true
  echo "--- fin nvidia-detect ---"
}

maybe_enable_bookworm_suspend_services() {
  local codename
  codename="$(read_version_codename)"
  if [[ "${codename}" != "bookworm" ]]; then
    return 0
  fi
  if [[ "$(normalize_bool "${NVIDIA_ENABLE_BOOKWORM_SUSPEND_SERVICES}")" != "true" ]]; then
    return 0
  fi
  if ! command -v systemctl >/dev/null 2>&1; then
    return 0
  fi
  echo "Habilitando servicios systemd NVIDIA para suspensión (Bookworm, wiki)…"
  sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
}

show_dkms_nvidia_status() {
  if ! command -v dkms >/dev/null 2>&1; then
    return 0
  fi
  echo "--- dkms status (módulo nvidia; wiki post-instalación) ---"
  sudo dkms status 2>/dev/null | grep -i nvidia || echo "(sin líneas nvidia en dkms status)"
  echo "--- ---"
}

# https://wiki.debian.org/NvidiaGraphicsDrivers#Wayland_configuration
configure_nvidia_wayland_modprobe_if_enabled() {
  if [[ "$(normalize_bool "${NVIDIA_WAYLAND_MODPROBE}")" != "true" ]]; then
    return 0
  fi

  echo "Configurando modprobe para Wayland + NVIDIA (/etc/modprobe.d/nvidia-wayland.conf)…"

  if [[ "$(normalize_bool "${NVIDIA_WAYLAND_SKIP_PRESERVE_VIDEO_MEMORY}")" == "true" ]]; then
    sudo tee /etc/modprobe.d/nvidia-wayland.conf >/dev/null <<'EOF'
# NVIDIA + Wayland (Debian wiki). Sin PreserveVideoMemoryAllocations — p. ej. portátil Optimus.
options nvidia-drm modeset=1
options nvidia-drm fbdev=1
EOF
  else
    sudo tee /etc/modprobe.d/nvidia-wayland.conf >/dev/null <<'EOF'
# NVIDIA + Wayland — https://wiki.debian.org/NvidiaGraphicsDrivers#Wayland_configuration
# NVreg_PreserveVideoMemoryAllocations puede fallar en Optimus; usa
# NVIDIA_WAYLAND_SKIP_PRESERVE_VIDEO_MEMORY=1 para omitir esa línea.
options nvidia NVreg_PreserveVideoMemoryAllocations=1
options nvidia-drm modeset=1
options nvidia-drm fbdev=1
EOF
  fi

  echo "Tras cambiar modprobe, reinicia para cargar nvidia-drm con modeset/fbdev."
}

install_nvidia_debian_apt() {
  export DEBIAN_FRONTEND=noninteractive

  if ! apt_sources_have_required_components; then
    echo "ERROR: faltan componentes APT requeridos por la wiki Debian (contrib, non-free" >&2
    echo "  y, en Debian 12+, non-free-firmware) en sources.list / sources.list.d." >&2
    echo "  Incluye también -security. Luego: sudo apt-get update" >&2
    return 1
  fi

  ensure_pciutils_for_lspci

  local codename
  codename="$(read_version_codename)"

  local -a pkgs=("$(kernel_headers_package)")

  if [[ "$(normalize_bool "${NVIDIA_OPEN_KERNEL_MODULES}")" == "true" ]]; then
    pkgs+=(nvidia-open-kernel-dkms)
  else
    pkgs+=(nvidia-kernel-dkms)
  fi
  pkgs+=(nvidia-driver nvidia-settings)

  if [[ "${codename}" == "bookworm" || "${codename}" == "bullseye" ]]; then
    pkgs+=(firmware-misc-nonfree)
  fi

  if [[ "$(normalize_bool "${NVIDIA_INSTALL_CUDA_TOOLKIT}")" == "true" ]]; then
    pkgs+=(nvidia-cuda-toolkit nvidia-cuda-dev)
  fi

  sudo apt-get update
  run_nvidia_detect_optional
  sudo apt-get install -y --no-install-recommends "${pkgs[@]}"

  maybe_enable_bookworm_suspend_services
  show_dkms_nvidia_status
  configure_nvidia_wayland_modprobe_if_enabled
}

# Solo Ubuntu/Pop/Mint. Debian usa install_nvidia_debian_apt (sin ubuntu-drivers).
install_nvidia_ubuntu_drivers() {
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  if command -v ubuntu-drivers >/dev/null 2>&1; then
    sudo ubuntu-drivers install
  else
    echo "WARN: ubuntu-drivers no está instalado; usando nvidia-kernel-dkms + nvidia-driver." >&2
    sudo apt-get install -y --no-install-recommends \
      linux-headers-"$(uname -r)" nvidia-kernel-dkms nvidia-driver nvidia-settings
  fi

  if [[ "$(normalize_bool "${NVIDIA_INSTALL_CUDA_TOOLKIT}")" == "true" ]]; then
    sudo apt-get install -y --no-install-recommends nvidia-cuda-toolkit nvidia-cuda-dev
  fi

  configure_nvidia_wayland_modprobe_if_enabled
}

try_show_nvidia_smi() {
  if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi || true
  fi
}

setup_nvidia_drivers() {
  if [[ "$(detect_pkg_manager)" != "apt" ]]; then
    echo "Este módulo solo implementa instalación vía apt (Debian/Ubuntu)." >&2
    return 1
  fi

  if [[ "$(normalize_bool "${NVIDIA_SKIP_IF_NO_GPU}")" == "true" ]]; then
    if ! command -v lspci >/dev/null 2>&1; then
      echo "No hay lspci; instalando pciutils para poder detectar la GPU (wiki)…"
      ensure_pciutils_for_lspci || true
    fi
    if ! has_nvidia_pci_device; then
      echo "Sin NVIDIA en bus PCI (lspci + filtro wiki); se omite. NVIDIA_SKIP_IF_NO_GPU=0 para forzar."
      return 0
    fi
  fi

  maybe_warn_blackwell_or_unsupported

  local os_id
  os_id="$(read_os_id)"
  case "${os_id}" in
    debian)
      if packages_installed_apt nvidia-driver; then
        echo "nvidia-driver ya instalado; comprobación rápida."
        configure_nvidia_wayland_modprobe_if_enabled
        show_dkms_nvidia_status
        try_show_nvidia_smi
        return 0
      fi
      install_nvidia_debian_apt
      ;;
    ubuntu|pop|pop_os|popos|linuxmint)
      install_nvidia_ubuntu_drivers
      ;;
    *)
      echo "Distro '${os_id}': flujo tipo Debian (nvidia-kernel-dkms + nvidia-driver)." >&2
      install_nvidia_debian_apt
      ;;
  esac

  echo "Instalación NVIDIA finalizada. Suele hacer falta reiniciar (nouveau vs. propietario, initramfs)."
  try_show_nvidia_smi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_nvidia_drivers
fi
