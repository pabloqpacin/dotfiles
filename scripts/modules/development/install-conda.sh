#!/usr/bin/env bash

# https://www.anaconda.com/docs/getting-started/miniconda/install#linux-2
# https://wiki.setenova.es/en/tecnologias/python/conda

download_install_conda_for_user(){
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh && \
        bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 && \
        rm ~/miniconda3/miniconda.sh
}

enable_conda_on_shell(){
    source ~/miniconda3/bin/activate

    CURRENT_SHELL=$(basename $SHELL)
    # conda init --all --dry-run
    conda init $CURRENT_SHELL

    # echo "auto_activate_base: false" >> ~/.condarc
    conda config --set auto_activate false
}

ensure_build_essentials(){
    if command -v gcc >/dev/null 2>&1 && command -v g++ >/dev/null 2>&1; then
        echo "=== build-essential ya está disponible (gcc/g++) ==="
        return 0
    fi

    if [[ ! -f /etc/os-release ]]; then
        echo "ERROR: No se pudo detectar la distro (falta /etc/os-release)." >&2
        return 1
    fi

    # shellcheck disable=SC1091
    source /etc/os-release
    if [[ "${ID:-}" != "debian" && "${ID:-}" != "ubuntu" && "${ID_LIKE:-}" != *"debian"* ]]; then
        echo "ERROR: ensure_build_essentials() solo soporta Debian/Ubuntu." >&2
        return 1
    fi

    echo "=== Instalando build-essential (requerido para wheels compilados por pip) ==="
    if [[ "$(id -u)" -eq 0 ]]; then
        apt-get update && apt-get install -y build-essential
    else
        sudo apt-get update && sudo apt-get install -y build-essential
    fi
}

install_conda() {
    ensure_build_essentials

    if ! command -v conda &> /dev/null; then
        download_install_conda_for_user
        enable_conda_on_shell
    else
        echo "=== Conda ya debería estar instalado ==="
        echo "---"
        type -a conda
        echo "---"
        conda --version
        echo "---"
        conda env list || conda info --envs
    fi
}

# ---
# NOTE: opcionalmente podríamos instalar el binario en /opt/miniconda3 y luego crear este archivo para tener environments por usuario:
# /opt/miniconda3/.condarc
# envs_dirs:
#   - ~/.conda/envs
# pkgs_dirs:
#   - ~/.conda/pkgs
# ---

# ---
# USO EN EL STACK:
# 1. Crear entorno:
# $ yes a | conda env create -f modulo_cv/environment.yml
# 2. Activar entorno:
# $ CONDA_ENV_NAME=$(awk -F': ' '/^name:/ {print $2}' modulo_cv/environment.yml)
# $ conda activate $CONDA_ENV_NAME
# ---
# 99. Ejecutar entorno:
# $ export VALKEY_PASSWORD=$(awk -F= '/^VALKEY_PASSWORD=/{print $2}' .env)
# $
# $ python -m modulo_cv.src.app --backend pytorch
# $ ... otros backends...
# ---
# 3. Desactivar entorno:
# $ conda deactivate
# 4. Eliminar entorno:
# $ conda env remove -n $CONDA_ENV_NAME
# 5. Listar entornos:
# $ conda env list
# 6. Listar paquetes instalados en un entorno:
# $ conda list -n $CONDA_ENV_NAME
# 7. Listar paquetes disponibles:
# $ conda search -n $CONDA_ENV_NAME


# ---
# Borrar cachés cuando fallos en build:
# conda clean --all --yes
# pip cache purge || true
