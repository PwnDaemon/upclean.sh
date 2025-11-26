# ⚙️ upclean.sh: Advanced System Maintenance Script

**Advanced APT maintenance script. Includes error handling (trap) and time measurement, ensuring a robust and clean system upgrade process.**

## ✨ Features

This script automates the complete maintenance cycle for **Debian/Ubuntu-based systems**, providing a safe and clean environment:

* **Complete Update Chain:** Executes `apt update`, `apt upgrade -y`, `apt full-upgrade -y`, and `apt dist-upgrade -y`.
* **Deep Cleaning:** Performs multiple cleanup routines (`apt autoremove`, `apt clean`, `apt autoclean`) to free up disk space.
* **Robust Error Handling:** Uses the `set -euf pipefail` configuration and a custom `trap` function to stop execution immediately and display a clear **RED** error message if any command fails.
* **Performance Tracking:** Calculates and prints the total time elapsed for the entire maintenance process.
* **User Experience:** Includes a `clear` command at startup and color-coded output for readability.


## 🚀 How to Use

Follow these steps to download and run the script on your system:

### 1. Download

Clone the repository or download the script file directly:

```bash
git clone https://github.com/PwndDaemon/upclean.sh.git
cd upclean.sh
