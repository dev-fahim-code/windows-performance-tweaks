# Windows Performance Tweaks

A compact collection of audited administrative batch scripts to optimize Windows for network throughput, visual responsiveness, and general system performance. Designed for gamers and power users who want predictable, low-latency behavior with minimal visual clutter.

By **Dev-Fahim_Code** — [github.com/dev-fahim-code](https://github.com/dev-fahim-code)

---

## ⚠️ Important — Read Before Running

These scripts change system-level settings (registry keys, adapter driver properties, power plans, and services). They can significantly alter system behavior.

- Create a System Restore Point before running any script.
- Inspect each .bat file yourself — they are plain text and annotated.
- Tested on Windows 10 and Windows 11. Results depend on hardware, drivers, and OEM utilities.
- Use at your own risk. No warranty — see the License section.

---

## Contents

- network-optimizer.bat — Tune network adapters for throughput and lower latency
- appearance-optimizer.bat — Strip UI animations and visual effects for snappier responsiveness
- performance-optimizer.bat — General system-level optimizations (telemetry, power, input latency)

(Each script contains inline comments explaining the changes it makes.)

---

## Quick Usage

1. Download the specific .bat file you want from this repo.
2. Right-click the file and choose "Run as administrator" OR run from an elevated PowerShell prompt:

   Start-Process -FilePath .\network-optimizer.bat -Verb RunAs

3. Follow on-screen messages. Some changes require a restart; the script will indicate this.

Note: The scripts automatically request elevation (UAC) when they run, so manual elevation is optional but sometimes preferred for logging or review.

---

## Script Summaries

### network-optimizer.bat
Tunnels adapter settings toward maximum throughput and lower latency where driver support exists.
- Adjusts link speed and duplex when applicable.
- Disables energy-saving features (EEE/Green Ethernet) and MIMO power savings for Wi‑Fi.
- Increases adapter transmit/receive buffers when supported.
- Sets the Windows wireless power policy to Maximum Performance.

Driver property names vary by vendor; unsupported properties are skipped (this is expected and safe).

### appearance-optimizer.bat
Minimizes Windows visual effects for a lean UI while keeping readability:
- Disables animations, fading, shadows for menus/lists, and scrolling animations.
- Enables ClearType font smoothing and thumbnails (keeps visual clarity).
- Restarts Explorer to apply changes immediately (no reboot required).

### performance-optimizer.bat
General OS-level tweaks that reduce background activity and improve foreground responsiveness:
- Disables some telemetry services and related scheduled tasks.
- Adjusts SystemResponsiveness and scheduler heuristics so foreground apps get higher priority.
- Disables hibernation (reclaims disk space equal to RAM) — optional and reversible.
- Lowers mouse/keyboard UI delays to reduce input lag.

A reboot is recommended after running this script for all changes to take effect.

---

## Safety & Reversion

- System Restore: Create a restore point (Control Panel → Recovery → Create a restore point) before making changes.
- Registry exports: If a script modifies registry keys you care about, export those keys first via regedit or reg.exe, e.g.:

  reg export "HKLM\SYSTEM\CurrentControlSet\Services\SomeService" SomeService-before.reg

- Reverting: If you encounter issues, use System Restore or import previously exported .reg files. You can also re-enable settings manually or reinstall drivers.

---

## Troubleshooting

- If a change causes networking problems, roll back using System Restore and reinstall the network adapter driver from the vendor.
- If Explorer behaves unexpectedly after appearance changes, sign out/sign in or reboot.
- If unsure which change caused a problem, run the scripts one at a time and reboot between runs; that makes it easier to identify the cause.

---

## Contributing

Contributions, bug reports, and suggestions are welcome. Please:
- Open an issue describing the hardware, Windows build, and the observed behavior.
- Create a pull request with a clear description and rationale for any change.

Before submitting script changes, ensure commands are safe on clean Windows installs and include comments explaining vendor-specific properties.

---

## License

Free to use and modify. Attribution to **Dev-Fahim_Code** appreciated but not required. No express warranty — use at your own risk.

---

## Contact

GitHub: [dev-fahim-code](https://github.com/dev-fahim-code)

---

(If you'd like, I can commit this improved README to the repository now and open a PR or push directly to the default branch.)