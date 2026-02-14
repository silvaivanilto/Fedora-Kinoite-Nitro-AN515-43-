# Fedora Kinoite Nitro (CachyOS Edition)

Custom **Fedora Kinoite** (CachyOS Kernel + Nvidia) image optimized for the Acer Nitro 5 (AN515-43).

## 🚀 Features

This image is built on top of **Fedora Kinoite (Main)** and replaces the stock kernel with **CachyOS**:

### 🎮 Base & Kernel
*   **Base:** `ghcr.io/ublue-os/kinoite-main:43` (Stock Fedora Atomic).
*   **Kernel:** **CachyOS Kernel** (`kernel-cachyos`) with **BORE Scheduler** and **Nvidia Open Modules**.
*   **Addons:** `scx-scheds` (Sched-ext), `ananicy-cpp` (Auto-priority), `uksmd`.
*   **KDE Plasma:** Beta Version (`@kdesig/kde-beta` COPR enabled).
*   **Login Manager:** **Plasma Login** (`plasmalogin.service`). replaces SDDM.

### ⚡ Power Optimizations
*   **TLP:** Advanced power management configured and enabled by default (replaces `tuned`/`tuned-ppd`).
*   **Masked Services:** `systemd-rfkill` masked to avoid conflicts with TLP.

### 🖨️ Printing
*   **Epson Drivers:** `epson-inkjet-printer-escpr` and `epson-inkjet-printer-escpr2` (installed from Fedora 41 — orphaned in Fedora 43).

### 🖥️ Boot & GRUB
*   **Dual Boot Ready:** GRUB configured to detect other OSs (`os-prober` enabled).
*   **Save Last Boot:** GRUB remembers the last selected OS (`GRUB_DEFAULT=saved`).

### 📦 Packages & Applications
*   **Installed:**
    *   **Google Chrome** (RPM) — Default Browser.
    *   **LibreOffice** (Writer, Calc, Impress, Draw, Math) with pt-BR support.
    *   **Plasma Firewall**, **Plasma Discover** (rpm-ostree backend).
    *   **Distrobox** (replaces Toolbox for container management).
*   **Removed (Bloatware):**
    *   Firefox (RPM), `sddm`, `tuned`, `plasma-drkonqi`, `kdebugsettings`, `firewall-config`.
    *   `fcitx5` (entire input method framework — 18 packages).
    *   `ibus` engines for idiomas não utilizados (anthy, hangul, libpinyin, chewing, m17n).
    *   `kate` (kwrite já incluso), `toolbox`, `htop`, `nvtop`, `mozilla-filesystem`.

### 🧹 Flatpaks
*   **Flathub** (system scope) configured with:
    *   **KDE Apps:** Okular, Elisa, Haruna, Skanpage, Kalk, Koko, Marknote, Merkuro.
    *   **Containers:** Kontainer.
*   **User-scope Flathub** removed to avoid duplicates in Discover.

### 🔤 Fonts
*   **Google Fonts:** Fira Sans, Fira Mono.
*   **Nerd Fonts:** NerdFontsSymbolsOnly.

### 🍺 Homebrew
*   **Linuxbrew** enabled for post-installation package management.

## 📁 Project Structure

```
recipes/
└── recipe.yml                  # Core BlueBuild recipe
files/scripts/
├── upgrade-kde-beta.sh         # Upgrades KDE packages from COPR
├── setup-tlp.sh                # Installs TLP repository
├── install-epson-escpr.sh      # Installs Epson drivers from Fedora 41
└── install-chrome.sh           # Installs Google Chrome RPM & sets default
└── install-oh-my-bash.sh       # Installs Oh My Bash & sets underline cursor
├── setup-root-theme-sync.sh    # Syncs root theme with UID 1000
└── configure-grub.sh           # Configures GRUB for Dual Boot & Savedefault
.github/workflows/
├── build.yml                   # Daily CI build + push/PR
└── generate-iso.yml            # ISO generation + GitHub Release (auto after build)
```

## 🛠️ Build Pipeline

The `recipe.yml` defines the following modules, executed in order:

| # | Module | Description |
|---|--------|-------------|
| 1 | `dnf` | Add COPR `kde-beta`, install packages (LibreOffice, Plasma Login, Discover, Distrobox), remove bloatware + fcitx5 + ibus engines + kate + toolbox |
| 2 | `brew` | Enable Homebrew/Linuxbrew |
| 3 | `fonts` | Install Fira Sans, Fira Mono, NerdFontsSymbolsOnly |
| 4 | `script` | `upgrade-kde-beta.sh`, `setup-tlp.sh`, `install-epson-escpr.sh`, `install-chrome.sh`, `install-oh-my-bash.sh`, `setup-root-theme-sync.sh`, `configure-grub.sh` |
| 5 | `dnf` | Install TLP packages (`tlp`, `tlp-pd`, `tlp-rdw`) |
| 6 | `default-flatpaks` | Configure Flathub (system), install Flatpak apps, remove user-scope Flathub |
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

## 🪟 Dual Boot Setup (Windows)

The image configures `/etc/default/grub` to detect Windows and save the last selected entry. **However**, you must regenerate the bootloader config locally for this to take effect:

```bash
# Run this once after rebasing to the image:
sudo grub2-mkconfig -o /etc/grub2.cfg
# Or if on UEFI (most modern systems):
sudo grub2-mkconfig -o /etc/grub2-efi.cfg
```

## 🧪 Testing & Verification

### 1. CLI Check (Package Verification)
```bash
podman run --rm -it ghcr.io/silvaivanilto/fedora-kinoite-nitro-an515-43:latest /bin/bash
# Inside the container:
rpm -q libreoffice-writer libreoffice-draw distrobox  # Check if packages are installed
rpm -q toolbox kate                                    # Should NOT be found
ls -l /etc/tlp.conf                                    # Check if config file exists
exit
```

### 2. Full System Test (Virtual Machine)
1.  Create a VM using **GNOME Boxes** or **Virt-Manager**.
2.  Install standard Fedora Kinoite.
3.  Rebase to this image.
4.  **Verify Kernel:** `uname -r` should show `cachyos`.
5.  **Verify Nvidia:** `nvidia-smi` should work (using open modules).

## 🔐 Verification

### Kernel & Nvidia
```bash
uname -r  # Output must contain "cachyos"
modinfo nvidia | grep license  # Should show "Dual MIT/GPL" (Open modules)
```
The image is signed with Sigstore/Cosign. Verify locally using `cosign.pub`:
```bash
cosign verify --key cosign.pub ghcr.io/silvaivanilto/fedora-kinoite-nitro-an515-43
```

## 📀 ISO Download

ISOs are generated automatically after each successful build and published as GitHub Releases. If the ISO exceeds 2 GB, it is split into parts. To reassemble:
```bash
cat fedora-kinoite-nitro-an515-43.iso.part_* > fedora-kinoite-nitro-an515-43.iso
```
