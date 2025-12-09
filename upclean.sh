#!/bin/bash

## -------------------------------------------------------------------
## FULL MAINTENANCE SCRIPT (v1.0)
## Description: Updates, cleans, and optimizes Debian/Ubuntu based systems.
## Author: PwndDaemon
## Date: 2025-11-26
## -------------------------------------------------------------------

# Enviroment configuration:
export LANG='en_US.UTF-8' 

# Robustness configuration:
set -e          
set -u          
set -o pipefail 

# Save start time in seconds
START_TIME=$SECONDS

# ANSI color codes
CYAN='\033[36m' 
RESET='\033[0m'
RED='\033[31m'  
GREEN='\033[32m'
BOLD='\033[1m'
YELLOW='\033[33m'

## FUNCTIONS ##

if [ "$EUID" -ne 0 ]; then
  echo -e "\n${BOLD}${RED}ERROR: You must use 'sudo' to run the script!.\n${RESET}"
  exit 1
fi

# Error handler
handle_error() {
    echo -e "\n${BOLD}${RED}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${RESET}"
    echo -e "${BOLD}${RED}[FATAL ERROR] The script failed on line $1.${RESET}"
    echo -e "${BOLD}${RED}Review the previous APT error message and resolve it.${RESET}"
    echo -e "${BOLD}${RED}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${RESET}\n"
}

# Executes handle_error if the error signal (ERR) is received
trap 'handle_error $LINENO' ERR


# Shows a spinner while waiting
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\\'
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " ${BOLD}[%c]${RESET}" "${spinstr:0:1}" # Prints the spinner state
        local spinstr=$temp${spinstr:0:1}
        sleep $delay
        printf "\b\b\b\b" # Backspaces 4 characters to overwrite
    done
}

# Function to run tasks with animation
run_animated_task() {
    local title="$1"
    local command="$2"
    
    # Print title without newline
    printf "${BOLD}${CYAN}[*] %s ${RESET}" "$title"
    
    # Execute command in background, silencing its output
    ( eval "$command" > /dev/null 2>&1 ) & 
    local pid=$!

    # Start the spinner
    spinner $pid
    
    # Wait for the command to finish and capture the exit status
    wait $pid
    local status=$?

    # Clear the line and display the result [ OK ] / [ FAIL ]
    printf "\r%s\r" "$(tput el)" # Carriage return and clear line

    if [ "$status" -eq 0 ]; then
        printf "${BOLD}${CYAN}[*] %s [ ${GREEN}OK${RESET}${BOLD}${CYAN} ]${RESET}\n" "$title"
    else
        printf "${BOLD}${CYAN}[*] %s [ ${RED}FAIL${RESET}${BOLD}${CYAN} ]${RESET}\n" "$title"
    fi
}


## SCRIPT START ##

clear
echo -e "${BOLD}${YELLOW}[!] STARTING COMPLETE SYSTEM MAINTENANCE [!]${RESET}"
echo "$(date)"
echo

# Package Update
run_animated_task "Updating package lists" "sudo apt update"
run_animated_task "Installing package upgrades" "sudo apt upgrade -y"
run_animated_task "Performing full upgrade" "sudo apt full-upgrade -y"
run_animated_task "Performing distribution upgrade" "sudo apt dist-upgrade -y"

# System Cleanup
run_animated_task "Deleting outdated .deb files" "sudo apt clean"
run_animated_task "Removing orphaned dependencies" "sudo apt autoremove -y" 
run_animated_task "Cleaning outdated package cache" "sudo apt autoclean"

# Optional temp files clean

echo
echo -e "${BOLD}${YELLOW}[!] OPTIONAL TEMPORARY FILE CLEANUP [!]${RESET}"
printf "${BOLD}Do you want to delete temporary files not accessed in the last 7 days? [y/N]: ${RESET}"
read -r TEMP_CLEANUP_CHOICE 

if [[ "$TEMP_CLEANUP_CHOICE" =~ ^[yY]$ ]]; then
    
    echo 
    TEMP_CLEANUP_CMD="sudo find /tmp /var/tmp -type f -atime +7 -delete 2>/dev/null"
    
    run_animated_task "Deleting temporary files older than 7 days" "$TEMP_CLEANUP_CMD"
    
else
    echo 
    echo -e "${BOLD}${GREEN}Skipping deep temporary file cleanup...${RESET}"
fi

## FINALIZATION ##

END_TIME=$SECONDS
DURATION=$((END_TIME - START_TIME))
HOURS=$((DURATION / 3600))
MINUTES=$(( (DURATION % 3600) / 60 ))
SECONDS_FINAL=$((DURATION % 60))

echo
echo

echo -e "${BOLD}${YELLOW}[!] MAINTENANCE FINISHED [!]${RESET}"
echo -e "\n${BOLD}Total elapsed time: ${HOURS} hours, ${MINUTES} minutes and ${SECONDS_FINAL} seconds.${RESET}"
echo -e ""
