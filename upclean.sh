#!/bin/bash

## -------------------------------------------------------------------
## FULL MAINTENANCE SCRIPT (v1.0)
## Description: Updates, cleans, and optimizes Debian/Ubuntu based systems.
## Author: PwndDaemon
## Date: 2025-11-26
## -------------------------------------------------------------------

export LANG='en_US.UTF-8'

set -e          
set -u          
set -o pipefail 

START_TIME=$SECONDS

CYAN='\033[36m'
RESET='\033[0m'
RED='\033[31m'
GREEN='\033[32m'
BOLD='\033[1m'
YELLOW='\033[33m'


handle_error() {
    echo -e "${BOLD}${RED}[ERROR] The script failed on line $1.${RESET} [ERROR]"
    echo -e "${BOLD}${RED}[ERROR] Review the previous APT error message and resolve it.${RESET} [ERROR]\n"
 }

trap 'handle_error $LINENO' ERR

clear
echo -e "${BOLD}${YELLOW}[!] Starting complete system maintenance [!]${RESET}"
echo "Start: $(date)"
echo

echo -e "${BOLD}${CYAN}[*] Updating package list [*]${RESET}"
echo
sudo apt update || { echo "Error in apt update. Terminating."; exit 1; }
echo

echo -e "${BOLD}${CYAN}[*] Updating installed packages [*]${RESET}"
echo
sudo apt upgrade -y || { echo "Error in apt upgrade. Continuing with cleanup."; }
echo

echo -e "${BOLD}${CYAN}[*] Full upgrade [*]${RESET}"
echo
sudo apt full-upgrade -y || { echo "Error in apt full-upgrade. Continuing with cleanup."; }
echo

echo -e "${BOLD}${CYAN}[*] Distribution upgrade [*]${RESET}"
echo
sudo apt dist-upgrade -y || { echo "Error in apt dist-upgrade. Continuing with cleanup."; }
echo

echo -e "${BOLD}${CYAN}[*] Deleting outdated .deb files [*]${RESET}"
echo
sudo apt clean
echo

echo -e "${BOLD}${CYAN}[*] Deleting orphaned dependencies [*]${RESET}"
echo
sudo apt autoremove -y
echo

echo -e "${BOLD}${CYAN}[*] Cleaning outdated package cache [*]${RESET}"
echo
sudo apt autoclean
echo

END_TIME=$SECONDS
DURATION=$((END_TIME - START_TIME))
HOURS=$((DURATION / 3600))
MINUTES=$(( (DURATION % 3600) / 60 ))
SECONDS_FINAL=$((DURATION % 60))

echo -e "\n${BOLD}${YELLOW}[!] Maintenance finished [!]${RESET}"
echo "End: $(date)"
echo -e "\n${BOLD}Total elapsed time: ${HOURS} hours, ${MINUTES} minutes and ${SECONDS_FINAL} seconds.${RESET}"
echo -e ""
echo -e "\n${BOLD}${GREEN}[*] Hasta la vista baby! [*]${RESET}\n"
echo -e""

