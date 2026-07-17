# Windows Performance & Optimization Tweaks

A streamlined collection of administrative batch scripts to maximize network speed, minimize system latency, and improve overall Windows performance.

---

## 📂 Scripts Overview

### 1. `network_optimize.bat`
**Purpose:** Optimize network and Wi-Fi speeds
- Forces Gigabit speeds on Ethernet adapters
- Enables Wi-Fi 6 mode for Intel adapters
- Disables power-saving features that throttle network
- Increases buffer sizes for better packet handling

### 2. `max_perf_visuals.bat`
**Purpose:** Remove UI lag and animations
- Disables window animations and transitions
- Removes visual effects consuming CPU
- Keeps 3 essential effects: font smoothing, thumbnails, window shadows
- Enables visual performance mode for faster UI response

### 3. `system_latency_perf.bat`
**Purpose:** Reduce CPU latency and input lag
- Prioritizes active applications for CPU scheduling
- Disables Windows Telemetry and diagnostics
- Disables hibernation mode
- Reduces mouse and keyboard input delays
- Optimizes multimedia service priorities

---

## 🌐 DNS Optimization

Fast DNS improves browsing and gaming responsiveness.

**Recommended DNS Services:**
- **Cloudflare:** `1.1.1.1` (fastest, privacy-focused)
- **Google:** `8.8.8.8` (reliable)
- **Quad9:** `9.9.9.9` (security-focused)

**Set DNS (Admin Command Prompt):**
```
netsh interface ip set dns name="Ethernet" static 1.1.1.1
ipconfig /flushdns
```

---

## 🔧 Disable Non-Microsoft Services

Remove unnecessary background services to free up system resources.

**Safe to Disable:**
- Printer services (HP, Canon, Epson)
- Adobe Update Services
- OneDrive (if using alternatives)
- Cortana/Search Indexing
- GPU Telemetry (Nvidia/AMD)
- OEM Bloatware services

**How to Disable (Services.msc):**
1. Press `Win + R` → type `services.msc`
2. Right-click service → Properties
3. Set Startup type to `Disabled`
4. Click Stop → Apply → OK

**Command (Admin PowerShell):**
```powershell
Set-Service -Name "ServiceName" -StartupType Disabled
Stop-Service -Name "ServiceName"
```

**⚠️ DO NOT disable:**
- Windows Update (`wuauserv`)
- Windows Defender (`WinDefend`)
- Network Discovery (`FDResPub`)
- Windows Event Log (`eventlog`)
- Plug and Play (`PlugPlay`)
- Device Setup Manager (`DeviceInstall`)

---

## 🛠️ How to Use

0. Clone the repository

Clone the repository (HTTPS):
```
git clone https://github.com/dev-fahim-code/windows-performance-tweaks.git
```

Or using SSH:
```
git clone git@github.com:dev-fahim-code:windows-performance-tweaks.git
```

1. Download `.bat` files from repository
2. Right-click → Run as administrator
3. Restart computer to apply changes

> **Disclaimer:** Scripts modify network drivers and Windows registry. Administrator privileges required.

---

## 📜 License
MIT License — Modify and share freely

**Project Maintained and Optimized by:** [FAHIM](https://github.com/dev-fahim-code)
