#!/bin/bash
# Safe KVM Hypervisor Installation Script for Debian
# Performs checks, installs stack, and configures user permissions.

# install-kvm.sh

set -e # Exit immediately if a command exits with a non-zero status

echo ">>> Starting KVM Hypervisor Installation..."

# 1. Safety Check: Verify CPU Virtualization Support
echo "[1/5] Checking CPU virtualization support..."
if ! grep -qE 'vmx|svm' /proc/cpuinfo; then
    echo "ERROR: CPU virtualization (VT-x/AMD-V) is not detected or enabled in BIOS."
    echo "Please enable virtualization in your BIOS/UEFI settings and try again."
    exit 1
fi
echo "    CPU virtualization support confirmed."

# 2. System Update
echo "[2/5] Updating package lists..."
apt update -qq

# 3. Install Hypervisor Stack
# Includes: QEMU/KVM, Libvirt daemon, CLI tools, bridge utilities, and virt-manager (GUI)
echo "[3/5] Installing KVM, QEMU, Libvirt, and tools..."
DEBIAN_FRONTEND=noninteractive apt install -y \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    virtinst \
    virt-manager \
    cpu-checker \
    ovmf \
    swtpm \
    libosinfo-bin

# 4. Enable and Start Services
echo "[4/5] Enabling and starting libvirtd service..."
systemctl enable --now libvirtd
systemctl enable --now virtlogd

# Verify service status
if ! systemctl is-active --quiet libvirtd; then
    echo "WARNING: libvirtd service failed to start automatically."
else
    echo "    libvirtd service is active."
fi

# 5. Configure User Permissions
# Adds the current user (if running interactively) or the SUDO_USER to the kvm and libvirt groups
TARGET_USER="${SUDO_USER:-${USER}}"
echo "[5/5] Adding user '${TARGET_USER}' to kvm and libvirt groups..."
usermod -aG kvm "$TARGET_USER"
usermod -aG libvirt "$TARGET_USER"

# Set default URI for libvirt to system-wide for the user
if [ -n "$TARGET_USER" ]; then
    HOME_DIR=$(getent passwd "$TARGET_USER" | cut -d: -f6)
    if [ -d "$HOME_DIR" ]; then
        echo "export LIBVIRT_DEFAULT_URI='qemu:///system'" >> "$HOME_DIR/.bashrc"
        echo "    Added LIBVIRT_DEFAULT_URI to $TARGET_USER's .bashrc"
    fi
fi

echo ""
echo ">>> Installation Complete!"
echo "------------------------------------------------"
echo "IMPORTANT: You must LOG OUT and LOG BACK IN (or reboot)"
echo "for the group permissions (kvm, libvirt) to take effect."
echo ""
echo "After logging back in, verify with:"
echo "  virsh list --all"
echo "  virt-manager"
echo "------------------------------------------------"   
