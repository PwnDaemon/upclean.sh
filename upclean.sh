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

# ANSI color codes
CYAN='\033[36m' 
RESET='\033[0m'
RED='\033[31m'  
GREEN='\033[32m'
BOLD='\033[1m'
YELLOW='\033[33m'

handle_error() {
    echo -e "\n${BOLD}${RED}[ERROR] The script failed on line $1.${RESET}"
    echo -e "${BOLD}${RED}[ERROR] Review the previous APT error message and resolve it.\n${RESET}"
}

trap 'handle_error $LINENO' ERR


# Animation function
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
     
    #Print title without newline
    printf "${BOLD}${CYAN}[*] %s ${RESET}" "$title"
    
    #Execute command in background, silencing its output
    ( eval "$command" > /dev/null 2>&1 ) & 
    local pid=$!

    #Start the spinner
    spinner $pid
    
    #Wait for the command to finish and capture the exit status
    wait $pid
    local status=$?

    #Clear the line and display the result [ OK ] / [ FAIL ]
    printf "\r%s\r" "$(tput el)" # Carriage return and clear line

    if [ "$status" -eq 0 ]; then
        printf "${BOLD}${CYAN}[*] %s [ ${GREEN}OK${RESET}${BOLD}${CYAN} ]${RESET}\n" "$title"
    else
        printf "${BOLD}${CYAN}[*] %s [ ${RED}FAIL${RESET}${BOLD}${CYAN} ]${RESET}\n" "$title"
    fi
}


# --- SCRIPT START ---

clear
echo -e "${BOLD}${YELLOW}[!] STARTING COMPLETE SYSTEM MAINTENANCE [!]${RESET}"
echo "$(date)"
echo

#Package Update
run_animated_task "Updating package list" "sudo apt update"
run_animated_task "Installing package upgrades" "sudo apt upgrade -y"
run_animated_task "Performing full upgrade" "sudo apt full-upgrade -y"
run_animated_task "Performing distribution upgrade" "sudo apt dist-upgrade -y"

#System Cleanup
run_animated_task "Deleting outdated .deb files " "sudo apt clean"
run_animated_task "Removing orphaned dependencies " "sudo apt autoremove -y" 
run_animated_task "Cleaning outdated package cache" "sudo apt autoclean"

# --- Finalization ---

END_TIME=$SECONDS
DURATION=$((END_TIME - START_TIME))
HOURS=$((DURATION / 3600))
MINUTES=$(( (DURATION % 3600) / 60 ))
SECONDS_FINAL=$((DURATION % 60))

# Extra empty lines for spacing
echo
echo

echo -e "${BOLD}${YELLOW}[!] MAINTENANCE FINISHED [!]${RESET}"
echo -e "\n${BOLD}Total elapsed time: ${HOURS} hours, ${MINUTES} minutes and ${SECONDS_FINAL} seconds.${RESET}"
echo -e ""


