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

## 🔐 Verification

The image is signed with Sigstore/Cosign. To verify the signature locally:

```bash
cosign verify --key cosign.pub ghcr.io/silvaivanilto/fedora-kinoite-nitro-an515-43
```
