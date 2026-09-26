#!/bin/bash

# ================= COLOURS =================
BLUE='\033[1;34m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
RED='\033[1;31m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Directory containing this menu and export scripts
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"

mkdir -p "$LOG_DIR"

# ================= CENTRE TEXT =================
centre() {
    local text="$1"
    local colour="$2"
    local width
    local column

    width=$(tput cols)
    column=$(( (width - ${#text}) / 2 ))

    (( column < 0 )) && column=0

    printf "%*s" "$column" ""
    echo -e "${colour}${text}${RESET}"
}

pause_menu() {
    echo
    centre "Press Enter to return to the menu..." "$WHITE"
    read -r
}

# ================= MAIN MENU =================
while true
do
    clear

    echo
    echo
    centre "╔════════════════════════════════════════════════════╗" "$CYAN"
    centre "║                                                    ║" "$CYAN"
    centre "║              ★ DATA EXPORT MENU ★                  ║" "$MAGENTA"
    centre "║                                                    ║" "$CYAN"
    centre "╠════════════════════════════════════════════════════╣" "$CYAN"
    centre "║                                                    ║" "$CYAN"
    centre "║   [1] Export Subscription Balance                  ║" "$GREEN"
    centre "║   [2] write                                        ║" "$YELLOW"
    centre "║   [3] Export Subscription Balance 1                ║" "$BLUE"
    centre "║   [4] Export Subscription Balance 2                ║" "$MAGENTA"
    centre "║                                                    ║" "$CYAN"
    centre "║   [5] Exit                                         ║" "$RED"
    centre "║                                                    ║" "$CYAN"
    centre "╚════════════════════════════════════════════════════╝" "$CYAN"

    echo
    centre "Select an option [1-5]:" "$WHITE"

    read -r option

    case "$option" in
        1)
            script_name="export_dwb_sbscrptn_blnc.sh"
            ;;
        2)
            script_name="write.sh"
            ;;
        3)
            script_name="export_dwb_sbscrptn_blnc1.sh"
            ;;
        4)
            script_name="export_dwb_sbscrptn_blnc2.sh"
            ;;
        5)
            clear
            echo
            centre "Menu closed successfully." "$GREEN"
            exit 0
            ;;
        *)
            centre "Invalid selection. Please select 1 to 5." "$RED"
            sleep 2
            continue
            ;;
    esac

    script_path="$SCRIPT_DIR/$script_name"

    if [[ ! -f "$script_path" ]]; then
        centre "Script not found: $script_name" "$RED"
        sleep 3
        continue
    fi

    # ================= DATE INPUT =================
    clear
    echo
    echo
    centre "╔════════════════════════════════════════════════════╗" "$BLUE"
    centre "║              ENTER DATE RANGE                      ║" "$YELLOW"
    centre "╚════════════════════════════════════════════════════╝" "$BLUE"

    echo
    centre "Selected script: $script_name" "$GREEN"

    echo
    centre "Enter start date in YYYYMMDD format:" "$WHITE"
    read -r start_date

    centre "Enter end date in YYYYMMDD format:" "$WHITE"
    read -r end_date

    # Validate format
    if ! [[ "$start_date" =~ ^[0-9]{8}$ ]] ||
       ! [[ "$end_date" =~ ^[0-9]{8}$ ]]; then

        centre "Invalid date format. Example: 20260910" "$RED"
        pause_menu
        continue
    fi

    # Validate real calendar dates
    if ! date -d "$start_date" "+%Y%m%d" >/dev/null 2>&1 ||
       ! date -d "$end_date" "+%Y%m%d" >/dev/null 2>&1; then

        centre "One or both dates are invalid." "$RED"
        pause_menu
        continue
    fi

    # Validate date range
    if [[ "$start_date" -gt "$end_date" ]]; then
        centre "Start date cannot be greater than end date." "$RED"
        pause_menu
        continue
    fi

    # ================= CONFIRMATION =================
    clear
    echo
    echo
    centre "╔════════════════════════════════════════════════════╗" "$CYAN"
    centre "║                CONFIRM EXECUTION                   ║" "$YELLOW"
    centre "╚════════════════════════════════════════════════════╝" "$CYAN"

    echo
    centre "Script     : $script_name" "$GREEN"
    centre "Start date : $start_date" "$BLUE"
    centre "End date   : $end_date" "$MAGENTA"

    echo
    centre "Start this job in the background? [y/n]:" "$WHITE"
    read -r confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        centre "Execution cancelled." "$YELLOW"
        sleep 2
        continue
    fi

    # ================= BACKGROUND EXECUTION =================
    timestamp=$(date "+%Y%m%d_%H%M%S")
    log_file="$LOG_DIR/${script_name%.sh}_${start_date}_${end_date}_${timestamp}.log"

    nohup bash -c '
        script_path="$1"
        script_name="$2"
        start_date="$3"
        end_date="$4"
        log_file="$5"

        current_date="$start_date"

        {
            echo "=============================================="
            echo "Background export job started"
            echo "Script     : $script_name"
            echo "Start date : $start_date"
            echo "End date   : $end_date"
            echo "Start time : $(date)"
            echo "=============================================="
        } >> "$log_file"

        while [[ "$current_date" -le "$end_date" ]]
        do
            {
                echo
                echo "----------------------------------------------"
                echo "Running $script_name for $current_date"
                echo "Started: $(date)"
                echo "----------------------------------------------"
            } >> "$log_file"

            bash "$script_path" "$current_date" >> "$log_file" 2>&1
            exit_code=$?

            if [[ $exit_code -eq 0 ]]; then
                echo "SUCCESS: $current_date completed." >> "$log_file"
            else
                echo "FAILED: $current_date, exit code $exit_code." >> "$log_file"
            fi

            current_date=$(date -d "$current_date +1 day" "+%Y%m%d")
        done

        {
            echo
            echo "=============================================="
            echo "Background export job completed"
            echo "End time: $(date)"
            echo "=============================================="
        } >> "$log_file"

	echo $scripth_path
	echo $script_name

    ' _ "$script_path" "$script_name" \
        "$start_date" "$end_date" "$log_file" \
        >/dev/null 2>&1 &

    background_pid=$!

    clear
    echo
    echo
    centre "╔════════════════════════════════════════════════════╗" "$GREEN"
    centre "║            ✔ BACKGROUND JOB STARTED                ║" "$GREEN"
    centre "╚════════════════════════════════════════════════════╝" "$GREEN"

    echo
    centre "Process ID : $background_pid" "$YELLOW"
    centre "Log file   : $log_file" "$CYAN"

    pause_menu
done

