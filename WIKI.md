# Wiki: Fedora Kinoite Nitro (Acer AN515-43)

Welcome to the official documentation for the **Fedora Kinoite Nitro** custom image. This image is optimized for the **Acer Nitro 5 (AN515-43)** laptop, providing a robust, gaming-ready, and efficient Linux experience based on Fedora Kinoite and BlueBuild.

## 📁 Project Structure

The project repository is organized as follows:

*   **`recipes/recipe.yml`**: The core configuration file defining the image build process.
    *   **Image Name:** `fedora-kinoite-nitro-an515-43` (Lowercase, compliant with OCI standards).
*   **`files/scripts/`**: Directory containing custom shell scripts executed during the build.
    *   `enable-plasmalogin.sh`: Enables Plasma Login Manager.
    *   `remove-flatpaks.sh`: Cleans default Flatpaks.
    *   `setup-multimedia.sh`: Configures codecs and drivers.
    *   `setup-tlp.sh`: Configures power management.
    *   `configure-nvidia.sh`: Configures Nvidia power settings.
*   **`README.md`**: Quick start guide with installation instructions.

## 🛠️ Configuration Details

### 1. Base System
*   **Image:** `ghcr.io/ublue-os/kinoite-nvidia:43` (Fedora 43 Stable).
*   **Kernel:** Standard Fedora kernel with proprietary Nvidia drivers pre-loaded.
*   **Desktop Environment:** KDE Plasma (Beta channel enabled via COPR).

### 2. Customizations Module (`recipe.yml`)
*   **RPM Packages:**
    *   **Installed:** `libreoffice-suite` (Full), `plasma-firewall`, `plasma-login-manager`.
    *   **Removed:** `firefox` (RPM), `sddm`, `tuned`, `plasma-drkonqi`, `kdebugsettings`.
*   **Scripts Execution Order:**
    1.  **`enable-plasmalogin.sh`**: Replaces SDDM with Plasma Login.
    2.  **`remove-flatpaks.sh`**: Removes pre-installed Flatpaks, cleans user data, enables Flathub, disables Fedora Flatpaks.
    3.  **`setup-multimedia.sh`**: Installs RPM Fusion (Free/Nonfree), swaps drivers for `freeworld` (VAAPI/VDPAU), installs `libva-nvidia-driver`.
    4.  **`setup-tlp.sh`**: Installs TLP, enables services, masks `tuned` and `rfkill` to prevent conflicts.
    5.  **`configure-nvidia.sh`**: Sets `NVreg_DynamicPowerManagement=0x02` for hybrid graphics power saving.

## 🚀 Deployment Guide

To deploy this image on your machine:

1.  **Commit & Push**: Ensure all changes are committed and pushed to your GitHub repository.
2.  **Wait for Build**: Check the "Actions" tab in your GitHub repository to see the build progress.
3.  **Rebase**: Once the build is successful, run the following command on your Fedora Atomic system:
    ```bash
    rpm-ostree rebase output:ostree-image-signed:docker://ghcr.io/silvaivanilto/fedora-kinoite-nitro-an515-43:latest
    ```
4.  **Reboot**: Restart your computer to boot into the new image.
    ```bash
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
