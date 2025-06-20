#!/usr/bin/env bash
# Pomodoro Timer v0.1.0 – MVP Edition
# Author: Ayushi Singh (@TechWithHer)
# Description: A terminal-based Pomodoro timer using Bash
# License: MIT

set -euo pipefail

# Colors for terminal output
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# === Default Values ===
WORK_MIN=${1:-25}
BREAK_MIN=${2:-5}
CYCLES=${3:-4}

# === Notify Function ===
# Uses desktop notification if available, else falls back to terminal bell
notify() {
    local title=$1
    local message=$2
    if command -v notify-send &> /dev/null; then
        notify-send "$title" "$message"
    else
        echo -e "\a"  # ASCII bell character
    fi
}

# === Countdown Function ===
# Takes minutes as input and displays countdown in terminal
countdown() {
    local minutes=$1
    local total_seconds=$((minutes * 60))
    while (( total_seconds > 0 )); do
        local min=$(( total_seconds / 60 ))
        local sec=$(( total_seconds % 60 ))
        printf "\r⏳  %02d:%02d remaining..." "$min" "$sec"
        sleep 1
        (( total_seconds-- ))
    done
    echo
}

# === Begin Timer ===
clear
echo -e "${YELLOW}🔔 Pomodoro Timer (v0.1.0) – Let's stay focused!${RESET}"
echo "Work: $WORK_MIN min | Break: $BREAK_MIN min | Cycles: $CYCLES"
echo "-------------------------------------------"

for (( i=1; i<=CYCLES; i++ )); do
    echo -e "\n${GREEN}▶️  Work Session $i${RESET}"
    countdown "$WORK_MIN"
    notify "Pomodoro" "Time for a break!"

    if (( i != CYCLES )); then
        echo -e "\n${RED}💤 Break Time${RESET}"
        countdown "$BREAK_MIN"
        notify "Pomodoro" "Back to work!"
    fi
done

echo -e "\n${YELLOW}🎉 All sessions complete. Great job!${RESET}"
notify "Pomodoro" "All sessions complete. Take a long break!"
