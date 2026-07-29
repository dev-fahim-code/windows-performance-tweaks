# Windows Performance Tweaks

A collection of batch scripts to optimize Windows for **network throughput, visual responsiveness, and overall system performance**. Built for gamers and power users who want a fast, no-fluff Windows setup.

By **Dev-Fahim_Code** — [github.com/dev-fahim-code](https://github.com/dev-fahim-code)

---

## ⚠️ Disclaimer

These scripts modify system-level registry keys, network adapter settings, and power plans. Use at your own risk.

- Create a **System Restore Point** before running any of these.
- Review each script before running it — know what it changes.
- Tested on Windows 10/11. Effects may vary depending on your hardware and drivers.

---

## Scripts

### 1. `network-optimizer.bat`
Tunes network adapters for maximum throughput and lowest latency.

**What it does:**
- **Realtek Ethernet**: forces 1.0 Gbps full duplex, disables all power-saving features (Energy-Efficient Ethernet, Green Ethernet, Gigabit Lite), maximizes receive/transmit buffers, enables hardware checksum/offload features.
- **Intel Wi-Fi 6**: forces 802.11ax mode, sets lowest roaming aggressiveness, maximizes transmit power, disables MIMO power saving and packet coalescing.
- **Windows Power Plan**: sets the wireless adapter power setting to Maximum Performance on both AC and battery.

> Note: Setting names/values are driver-specific. If your adapter doesn't expose a particular property, that step is silently skipped — this is expected and not an error.

---

### 2. `appearance-optimizer.bat`
Strips Windows visual effects down to a lean, high-performance UI.

**What it does:**
- Sets Visual Effects to **Custom**.
- Disables window/taskbar animations, menu fading, list-view fade/shadow, and scrolling animations.
- Keeps only three visual effects enabled:
  - Font smoothing (ClearType)
  - Thumbnails instead of generic icons
  - Window drop shadows
- Restarts Windows Explorer automatically to apply changes instantly — no reboot required.

---

### 3. `performance-optimizer.bat`
General system-level performance tweaks.

**What it does:**
- **Disables telemetry**: turns off `AllowTelemetry` and disables the `DiagTrack` service, reducing background CPU/network usage.
- **CPU task scheduling**: sets `SystemResponsiveness` to 0 and raises GPU/CPU priority for games, so foreground apps get more resources.
- **Disables hibernation**: frees disk space equal to your RAM size and stops related background disk writes.
- **Reduces input delay**: lowers mouse hover time and removes keyboard acceptance delay.

> A restart is recommended after running this script for all changes to take full effect.

---

## Usage

1. Download the `.bat` file you want to run.
2. Double-click it — each script **automatically requests administrator permission** via a UAC prompt. You don't need to manually right-click → "Run as administrator."
3. Click **Yes** on the UAC prompt.
4. Wait for the script to finish and follow any on-screen instructions (some scripts recommend a restart).

---

## Requirements

- Windows 10 or Windows 11
- Administrator access (the script will prompt for this automatically)
- PowerShell available on the system (included by default on all supported Windows versions)

---

## License

Free to use and modify. Attribution to **Dev-Fahim_Code** appreciated but not required.
