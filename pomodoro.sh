#!/usr/bin/env bash
# Pomodoro Timer v0.2.0 – CLI Improvements & Safety
# Author: Ayushi Singh (@TechWithHer)
# License: MIT

set -euo pipefail

# === Terminal Colors ===
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

# === Help Message ===
show_help() {
    echo -e "${YELLOW}Pomodoro Timer v0.2.0${RESET}"
    echo "Usage: $0 [work_minutes] [break_minutes] [cycles]"
    echo
    echo "Examples:"
    echo "  $0         # Default: 25/5/4"
    echo "  $0 20 5 6  # 20 min work, 5 min break, 6 cycles"
    echo
    echo "Flags:"
    echo "  -h, --help    Show this help message"
    exit 0
}

# === Input Validation ===
is_positive_int() {
    [[ "$1" =~ ^[1-9][0-9]*$ ]]
}

# === Check for Help Flag ===
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    show_help
fi

# === Default or User Arguments ===
WORK_MIN=${1:-25}
BREAK_MIN=${2:-5}
CYCLES=${3:-4}

# === Validate Inputs ===
if ! is_positive_int "$WORK_MIN" || ! is_positive_int "$BREAK_MIN" || ! is_positive_int "$CYCLES"; then
    echo -e "${RED}Error: All inputs must be positive integers.${RESET}"
    echo "Use --help for usage instructions."
    exit 1
fi

# === Notification Function ===
notify() {
    local title=$1
    local message=$2
    if command -v notify-send &> /dev/null; then
        notify-send "$title" "$message"
    else
        echo -e "\a"
    fi
}

# === Countdown Timer ===
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
echo -e "${BLUE}Pomodoro Timer (v0.2.0) – Stay Focused!${RESET}"
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
