# Windows Performance & Optimization Tweaks
### 🚀 Created by FAHIM

A highly streamlined collection of administrative batch (`.bat`) scripts designed to maximize network throughput, minimize system latency, and strip away sluggish Windows UI animations without sacrificing essential visual clarity or accessibility.

---

## 📂 Repository Contents & Features

This repository contains three target-specific automation files:

### 1. `network_optimize.bat` (Network & Wi-Fi Speeds)
Optimizes physical and wireless network interface controllers (NICs) for maximum bandwidth and lowest packet loss.
* Forces **1.0 Gbps Full Duplex** on Realtek Ethernet interfaces to prevent 100 Mbps caps.
* Locks Intel Wi-Fi adapters into **802.11ax (Wi-Fi 6)** operational mode.
* Disables aggressive hardware energy-throttling (`Green Ethernet`, `Energy-Efficient Ethernet`, `SMPS`).
* Maximizes `Receive` and `Transmit` buffers to handle heavy data packet bursts.

### 2. `max_perf_visuals.bat` (UI Appearance & Speed)
Strips away laggy window animations and fading transitions so the OS responds instantly, while explicitly keeping only **3 essential visual effects** for a clean aesthetic:
* **Smooth edges of screen fonts:** Keeps text crisp and perfectly readable.
* **Show thumbnails instead of icons:** Retains image and video previews in File Explorer.
* **Show shadows under windows:** Preserves visual depth between overlapping applications.

### 3. `system_latency_perf.bat` (CPU & Core Latency)
Fine-tunes background scheduling priorities to feed resources directly to active games and tools.
* Adjusts Windows Multimedia Network/System Profile keys to give **High Priority** and maximum CPU scheduling to active applications.
* Disables background Windows Telemetry tracking and diagnostic data uploads.
* Shuts down Windows Hibernation (`powercfg -h off`) to eliminate constant background disk writes.
* Drastically reduces hardware polling input lag (`MouseHoverTime` and keyboard delays).

---

## 🌐 DNS Optimization Quick Tips

DNS resolution can significantly impact network responsiveness. Consider these quick improvements:

* **Use a Public DNS Service:**
  * **Cloudflare:** `1.1.1.1` and `1.0.0.1` (fastest, privacy-focused)
  * **Google:** `8.8.8.8` and `8.8.4.4` (reliable, widely-used)
  * **Quad9:** `9.9.9.9` (security-focused, blocks malware)

* **Change DNS via Command Prompt (Admin):**
  ```
  netsh interface ip set dns name="Ethernet" static 1.1.1.1
  netsh interface ip add dns name="Ethernet" 1.0.0.1
  ```

* **Flush DNS Cache:**
  ```
  ipconfig /flushdns
  ```

* **Why it matters:** A fast DNS service reduces domain lookup latency, improving browsing speed and online game responsiveness.

---

## 🛠️ How to Use

> ⚠️ **Disclaimer:** These scripts modify network driver properties and Windows registry keys. Running them with administrative privileges is required to write changes to system hardware keys.

1. Download the `.bat` files from this repository to your local drive.
2. **Right-click** on the specific script you wish to apply.
3. Select **Run as administrator** from the context menu.
4. Restart your computer once execution finishes to fully commit the registry adjustments.

---

## 📜 License
This project is licensed under the permissive **MIT License** — feel free to modify, share, and use these configurations to keep your hardware running at its peak capability.

***
**Project Maintained and Optimized by:** [FAHIM](https://github.com/)
