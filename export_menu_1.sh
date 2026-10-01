#!/bin/bash

change1
change2

# ---------- Colours ----------
BLUE='\033[1;34m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
RED='\033[1;31m'
WHITE='\033[1;37m'
RESET='\033[0m'

# ---------- Centre a line ----------
centre_line() {
    local row="$1"
    local text="$2"
    local colour="$3"

    local terminal_width
    local text_length
    local column

    terminal_width=$(tput cols)
    text_length=${#text}
    column=$(( (terminal_width - text_length) / 2 ))

    (( column < 0 )) && column=0

    tput cup "$row" "$column"
    echo -e "${colour}${text}${RESET}"
}

# ---------- Display message ----------
show_message() {
    local message="$1"
    local colour="$2"
    local terminal_height
    local row

    terminal_height=$(tput lines)
    row=$((terminal_height / 2 + 10))

    centre_line "$row" "$message" "$colour"
    sleep 2
}

while true
do
    clear

    TERMINAL_HEIGHT=$(tput lines)
    START_ROW=$(( (TERMINAL_HEIGHT - 18) / 2 ))

    (( START_ROW < 1 )) && START_ROW=1

    centre_line "$START_ROW"     "╔══════════════════════════════════════════════╗" "$CYAN"
    centre_line "$((START_ROW+1))" "║                                              ║" "$CYAN"
    centre_line "$((START_ROW+2))" "║           ★  DATA EXPORT MENU  ★             ║" "$MAGENTA"
    centre_line "$((START_ROW+3))" "║                                              ║" "$CYAN"
    centre_line "$((START_ROW+4))" "╠══════════════════════════════════════════════╣" "$CYAN"
    centre_line "$((START_ROW+5))" "║                                              ║" "$CYAN"
    centre_line "$((START_ROW+6))" "║   [1]  Export Subscription Balance           ║" "$GREEN"
    centre_line "$((START_ROW+7))" "║   [2]  Run Export 1                          ║" "$YELLOW"
    centre_line "$((START_ROW+8))" "║   [3]  Export Subscription Balance 1         ║" "$BLUE"
    centre_line "$((START_ROW+9))" "║   [4]  Export Subscription Balance 2         ║" "$MAGENTA"
    centre_line "$((START_ROW+10))" "║                                              ║" "$CYAN"
    centre_line "$((START_ROW+11))" "║   [5]  Exit                                   ║" "$RED"
    centre_line "$((START_ROW+12))" "║                                              ║" "$CYAN"
    centre_line "$((START_ROW+13))" "╚══════════════════════════════════════════════╝" "$CYAN"

    tput cup "$((START_ROW+15))" "$(( ($(tput cols) - 28) / 2 ))"
    echo -ne "${WHITE}Select an option [1-5]: ${RESET}"
    read -r option

    case "$option" in
        1)
            script_name="export_dwb_sbscrptn_blnc.sh"
            script_title="Export Subscription Balance"
            ;;
        2)
            script_name="export1.sh"
            script_title="Run Export 1"
            ;;
        3)
            script_name="export_dwb_sbscrptn_blnc1.sh"
            script_title="Export Subscription Balance 1"
            ;;
        4)
            script_name="export_dwb_sbscrptn_blnc2.sh"
            script_title="Export Subscription Balance 2"
            ;;
        5)
            clear
            centre_line "$((TERMINAL_HEIGHT / 2))" \
                "Thank you. Menu closed successfully." "$GREEN"
            echo
            exit 0
            ;;
        *)
            show_message "Invalid selection! Please select 1 to 5." "$RED"
            continue
            ;;
    esac

    clear

    centre_line "$((START_ROW+2))" \
        "╔══════════════════════════════════════════════╗" "$BLUE"
    centre_line "$((START_ROW+3))" \
        "║             SCRIPT INFORMATION               ║" "$YELLOW"
    centre_line "$((START_ROW+4))" \
        "╚══════════════════════════════════════════════╝" "$BLUE"

    centre_line "$((START_ROW+6))" "Selected: $script_title" "$GREEN"

    tput cup "$((START_ROW+8))" "$(( ($(tput cols) - 39) / 2 ))"
    echo -ne "${WHITE}Enter date in YYYYMMDD format: ${RESET}"
    read -r run_date

    # Check the input contains exactly eight digits
    if ! [[ "$run_date" =~ ^[0-9]{8}$ ]]; then
        show_message "Invalid format! Example: 20260910" "$RED"
        continue
    fi

    # Check that the entered value is a real date
    if ! date -d "$run_date" "+%Y%m%d" >/dev/null 2>&1; then
        show_message "Invalid calendar date!" "$RED"
        continue
    fi

    if [[ ! -f "./$script_name" ]]; then
        show_message "Script not found: $script_name" "$RED"
        continue
    fi

    clear

    centre_line "$((START_ROW+2))" \
        "╔══════════════════════════════════════════════╗" "$CYAN"
    centre_line "$((START_ROW+3))" \
        "║              CONFIRM EXECUTION               ║" "$YELLOW"
    centre_line "$((START_ROW+4))" \
        "╚══════════════════════════════════════════════╝" "$CYAN"

    centre_line "$((START_ROW+6))" "Script : $script_name" "$GREEN"
    centre_line "$((START_ROW+7))" "Date   : $run_date" "$MAGENTA"

    tput cup "$((START_ROW+9))" "$(( ($(tput cols) - 31) / 2 ))"
    echo -ne "${WHITE}Start this script? [y/n]: ${RESET}"
    read -r confirm

    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        clear

        centre_line "$((START_ROW+2))" \
            "▶ Running $script_name with date $run_date" "$GREEN"

        echo
        echo

        bash "./$script_name" "$run_date"
        exit_code=$?

        echo

        if [[ $exit_code -eq 0 ]]; then
            centre_line "$((START_ROW+8))" \
                "✔ Script completed successfully." "$GREEN"
        else
            centre_line "$((START_ROW+8))" \
                "✘ Script failed. Exit code: $exit_code" "$RED"
        fi
    else
        show_message "Script execution cancelled." "$YELLOW"
        continue
    fi

    tput cup "$((START_ROW+11))" "$(( ($(tput cols) - 36) / 2 ))"
    echo -ne "${WHITE}Press Enter to return to the menu...${RESET}"
    read -r
done


