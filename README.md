# Fedora Kinoite Nitro (Acer AN515-43)

Custom Fedora Kinoite (KDE) image optimized for the Acer Nitro 5 (AN515-43) laptop, based on BlueBuild and Universal Blue.

## 🚀 Features

This image is built on top of **Fedora Kinoite Nvidia (v43 Stable)** and includes the following customizations:

### 🎮 Base & Desktop Environment
*   **Base:** `ghcr.io/ublue-os/kinoite-nvidia:43` (Fedora 43 Stable - Proprietary Nvidia drivers included).
*   **KDE Plasma:** Beta Version (`@kdesig/kde-beta` COPR enabled, all KDE packages upgraded via `dnf distro-sync`).
*   **Login Manager:** **Plasma Login** (`plasmalogin.service`) replaces SDDM.

### ⚡ Power Optimizations
*   **TLP:** Advanced power management configured and enabled by default (replaces `tuned`/`tuned-ppd`).
*   **Masked Services:** `systemd-rfkill` masked to avoid conflicts with TLP.

### 📦 Packages & Applications
*   **Installed:**
    *   **LibreOffice** (Writer, Calc, Impress) with pt-BR support.
    *   **Plasma Firewall**, **Plasma Discover** (rpm-ostree backend).
*   **Removed (Bloatware):**
    *   Firefox (RPM), `sddm`, `tuned`, `plasma-drkonqi`, `kdebugsettings`, `firewall-config`.
    *   `fcitx5` (entire input method framework — 25 packages), `htop`, `nvtop`.

### 🧹 Flatpaks
*   **Flathub** (system scope) configured with:
    *   **Browser:** Google Chrome.
    *   **KDE Apps:** Okular, Elisa, Haruna, Skanpage, Kalk, Koko, Marknote.

### 🔤 Fonts
*   **Google Fonts:** Fira Sans, Fira Mono.
*   **Nerd Fonts:** NerdFontsSymbolsOnly.

### 🍺 Homebrew
*   **Linuxbrew** enabled for post-installation package management.

## 📁 Project Structure

```
recipes/
└── recipe.yml              # Core BlueBuild recipe
files/scripts/
├── upgrade-kde-beta.sh     # Upgrades KDE packages from COPR
└── setup-tlp.sh            # Installs TLP repository
.github/workflows/
├── build.yml               # Daily CI build + push/PR
└── generate-iso.yml        # ISO generation + GitHub Release (auto after build)
```

## 🛠️ Build Pipeline

The `recipe.yml` defines the following modules, executed in order:

| # | Module | Description |
|---|--------|-------------|
| 1 | `dnf` | Add COPR `kde-beta`, install packages (LibreOffice, Plasma Login, Discover), remove bloatware + fcitx5 |
| 2 | `brew` | Enable Homebrew/Linuxbrew |
| 3 | `fonts` | Install Fira Sans, Fira Mono, NerdFontsSymbolsOnly |
| 4 | `script` | `upgrade-kde-beta.sh`, `setup-tlp.sh` |
| 5 | `dnf` | Install TLP packages (`tlp`, `tlp-pd`, `tlp-rdw`) |
| 6 | `default-flatpaks` | Configure Flathub (system scope) and install Flatpak apps |
| 7 | `systemd` | Enable services (`plasmalogin`, `tlp`, `rpm-ostreed-automatic.timer`), mask conflicts |
| 8 | `signing` | Sign image with Cosign/Sigstore |

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

## 🧪 Testing & Verification

### 1. CLI Check (Package Verification)
```bash
podman run --rm -it ghcr.io/silvaivanilto/fedora-kinoite-nitro-an515-43:latest /bin/bash
# Inside the container:
rpm -q libreoffice-writer  # Check if package is installed
ls -l /etc/tlp.conf        # Check if config file exists
exit
```

### 2. GUI Application Testing (Distrobox)
```bash
distrobox create -i ghcr.io/silvaivanilto/fedora-kinoite-nitro-an515-43:latest -n nitro-test
distrobox enter nitro-test
libreoffice --writer
```

### 3. Full System Test (Virtual Machine)
1.  Create a VM using **GNOME Boxes** or **Virt-Manager**.
2.  Install a standard Fedora Kinoite image.
3.  Run the rebase command inside the VM.
4.  Reboot the VM to test startup processes.

## 🔐 Verification

The image is signed with Sigstore/Cosign. Verify locally using `cosign.pub`:
```bash
cosign verify --key cosign.pub ghcr.io/silvaivanilto/fedora-kinoite-nitro-an515-43
```
