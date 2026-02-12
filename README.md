# Fedora Kinoite Nitro (Acer AN515-43)

Custom Fedora Kinoite (KDE) image optimized for the Acer Nitro 5 (AN515-43) laptop, based on BlueBuild and Universal Blue.

## 🚀 Features

This image is built on top of **Fedora Kinoite Nvidia (v43 Stable)** and includes the following customizations:

### 🎮 Base & Desktop Environment
*   **Base:** `ghcr.io/ublue-os/kinoite-nvidia:43` (Fedora 43 Stable - Proprietary Nvidia drivers included).
*   **KDE Plasma:** Beta Version (`@kdesig/kde-beta` enabled - Optional, keep to test Plasma latest features).
*   **Login Manager:** **Plasma Login** (`plasmalogin.service`) replaces SDDM for a more integrated and lightweight experience (SDDM removed).

### ⚡ Power Optimizations
*   **TLP:** Advanced power management configured and enabled by default.
*   **Removed/Masked Services:** `tuned`, `tuned-ppd`, and `systemd-rfkill` were removed or masked to avoid conflicts with TLP.

### 📦 Packages & Applications
*   **Installed:**
    *   Full **LibreOffice** suite (pt-BR support).
    *   **Plasma Firewall**.
*   **Removed (Bloatware/Redundancy):**
    *   Firefox (RPM) - *Use the Flatpak version from Flathub*.
    *   `sddm`, `sddm-kcm`, `sddm-wayland-plasma`.
    *   `plasma-drkonqi`, `kdebugsettings`, `firewall-config`.

### 🧹 Cleanup & Flatpaks
*   All default Flatpaks from the base image are **removed** during installation.
*   **Flathub** repository enabled by default.
*   **Fedora Flatpaks** repository disabled.

## 📁 Project Structure

*   **`recipes/recipe.yml`**: The core configuration file defining the image build process.
*   **`files/scripts/`**: Directory containing custom shell scripts executed during the build.
    *   `remove-flatpaks.sh`: Cleans default Flatpaks (Flathub is added via module).
    *   `setup-repos.sh`: Installs RPM Fusion repositories.
    *   `setup-tlp.sh`: Installs TLP repository.
    *   `configure-nvidia.sh`: Configures Nvidia power settings.

## 🛠️ Configuration Details

### 1. Base System
*   **Image:** `ghcr.io/ublue-os/kinoite-nvidia:43` (Fedora 43 Stable).
*   **Kernel:** Standard Fedora kernel with proprietary Nvidia drivers pre-loaded.
*   **Desktop Environment:** KDE Plasma (Beta channel enabled via COPR).

### 2. Customizations Module (`recipe.yml`)
*   **RPM Packages:**
    *   **Installed:** `libreoffice-suite` (Full), `plasma-firewall`, `plasma-login-manager`, `kcm-plasmalogin`.
    *   **Removed:** `firefox` (RPM), `sddm`, `tuned`, `plasma-drkonqi`, `kdebugsettings`.
    *   **Fonts:**
        *   **Module:** Fira Sans, Fira Mono (Google Fonts) and NerdFontsSymbolsOnly (Nerd Font).
        *   **Local:** Fonts placed in `files/usr/share/fonts/ms-fonts` will also be installed.
    *   **Flatpaks:** The `default-flatpaks` module configures **Flathub** as the system remote.
    *   **Services:** The `systemd` module automatically enables `plasmalogin`, `tlp`, and masks conflicts.
    1.  **`remove-flatpaks.sh`**: Removes pre-installed Flatpaks, cleans user data. (Flathub setup moved to module).
    2.  **`setup-repos.sh`**: Installs RPM Fusion (Free/Nonfree) repositories.
    3.  **`setup-tlp.sh`**: Installs TLP repository.
    4.  **`configure-nvidia.sh`**: Sets `NVreg_DynamicPowerManagement=0x02`.
    *   **Post-Script Packages:** An `rpm-ostree` module installs packages that depend on the repos above (`libva-nvidia-driver`, `tlp`, etc.).

## 📥 Installation

To rebase an existing Fedora Atomic (Silverblue/Kinoite) installation:

1.  **Rebase to the unsigned image (first step):**
    ```bash
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/silvaivanilto/fedora-kinoite-nitro-an515-43:latest
    systemctl reboot
    ```

2.  **Rebase to the signed image (recommended):**
    ```bash
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/silvaivanilto/fedora-kinoite-nitro-an515-43:latest
    systemctl reboot
    ```

## 🧪 Testing & Verification (Without Installing)

You can test the image as a container before rebasing your main system.

### 1. Simple CLI Check (Package Verification)
Use `podman` to verify if packages and files exist:
```bash
podman run --rm -it ghcr.io/silvaivanilto/fedora-kinoite-nitro-an515-43:latest /bin/bash
# Inside the container:
rpm -q libreoffice-writer  # Check if package is installed
ls -l /etc/tlp.conf        # Check if config file exists
exit
```

### 2. GUI Application Testing (Distrobox)
To run graphical apps (like LibreOffice) from the image:
```bash
# Create a test container
distrobox create -i ghcr.io/silvaivanilto/fedora-kinoite-nitro-an515-43:latest -n nitro-test

# Enter the container
distrobox enter nitro-test

# Run graphical apps (they will appear on your desktop)
libreoffice --writer
```

### 3. Full System Test (Virtual Machine)
To test boot, login manager (Plasma Login), and drivers:
1.  Create a VM using **GNOME Boxes** or **Virt-Manager**.
2.  Install a standard Fedora Kinoite image.
3.  Run the rebase command inside the VM.
4.  Reboot the VM to test startup processes.

## 🔐 Verification

The image is signed with Sigstore/Cosign. verify locally using `cosign.pub`:
```bash
cosign verify --key cosign.pub ghcr.io/silvaivanilto/fedora-kinoite-nitro-an515-43
```
