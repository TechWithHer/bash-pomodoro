#!/usr/bin/env bash
set -euo pipefail

# Colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Arguments: work minutes, break minutes, number of cycles
WORK_MIN=${1:-25}
BREAK_MIN=${2:-5}
CYCLES=${3:-4}

function notify() {
    if command -v notify-send &> /dev/null; then
        notify-send "$1" "$2"
    else
        echo -e "\a" # terminal beep
    fi
}

function countdown() {
    local SECONDS_LEFT=$(( $1 * 60 ))
    while (( SECONDS_LEFT > 0 )); do
        MIN=$(( SECONDS_LEFT / 60 ))
        SEC=$(( SECONDS_LEFT % 60 ))
        printf "\r⏳  %02d:%02d remaining..." "$MIN" "$SEC"
        sleep 1
        (( SECONDS_LEFT-- ))
    done
    echo
}

clear
echo -e "${YELLOW}🔔 Pomodoro Timer Started ($WORK_MIN/$BREAK_MIN min × $CYCLES cycles)${RESET}"
echo "--------------------------------------"

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

echo -e "\n${YELLOW}🎉 All sessions complete. Well done!${RESET}"
notify "Pomodoro" "All sessions complete. Take a long break!"

