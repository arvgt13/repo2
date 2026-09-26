#!/bin/bash
echo "hello3"

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
    centre "║              * date format 2026-09-01*             ║" "$YELLOW"
	centre "║                                                    ║" "$CYAN"
    centre "╠════════════════════════════════════════════════════╣" "$CYAN"
    centre "║                                                    ║" "$CYAN"
    centre "║   [1] write.sh                                     ║" "$YELLOW"
    centre "║   [2] export_dwo_rms_device_sim_hist.sh            ║" "$CYAN"
    centre "║   [3] export_dwo_rms_device_msisdn_hist.sh         ║" "$GREEN"
    centre "║   [4] export_dwo_ussd_ussd_cdr_hist.sh             ║" "$YELLOW"
    centre "║   [5] export_dwo_cmp_cmp.sh                        ║" "$BLUE"
    centre "║   [6] export_dwo_cbsmediation_data_swap.sh         ║" "$MAGENTA"
    centre "║   [7] export_dwo_mediation_smsc_comviva.sh         ║" "$CYAN"
    centre "║   [8] export_dwo_mediation_rec.sh                  ║" "$GREEN"
    centre "║   [9] export_dwo_mediation_volte_c.sh              ║" "$YELLOW"
    centre "║   [10] export_dwo_cbsmediation_sms.sh              ║" "$BLUE"
    centre "║   [11] export_dwo_cbsmediation_mon_swap.sh         ║" "$MAGENTA"
    centre "║   [12] export_dwo_cbsmediation_mgr_swap.sh         ║" "$CYAN"
    centre "║   [13] export_dwo_mediation_msc_c.sh               ║" "$GREEN"
    centre "║   [14] export_dwo_cbsmediation_data_swap_test.sh   ║" "$YELLOW"
	centre "║   [15] write1.sh                                   ║" "$RED"
	centre "║                                                    ║" "$BLUE"
	centre "║                                                    ║" "$CYAN"
    centre "║   [16] Exit                                        ║" "$RED"
    centre "║                                                    ║" "$CYAN"
    centre "╚════════════════════════════════════════════════════╝" "$CYAN"

    echo
    centre "Select an option [1-16]:" "$WHITE"

    read -r option

    case "$option" in
        1)
            script_name="write.sh"
            ;;
        2)
            script_name="export_dwo_rms_device_sim_hist.sh"
            ;;
        3)
            script_name="export_dwo_rms_device_msisdn_hist.sh"
            ;;
        4)
            script_name="export_dwo_ussd_ussd_cdr_hist.sh"
            ;;
        5)
            script_name="export_dwo_cmp_cmp.sh"
            ;;
			
        6)
            script_name="export_dwo_cbsmediation_data_swap.sh"
            ;;		
		
		7)
            script_name="export_dwo_mediation_smsc_comviva.sh"
            ;;
		
		8)
            script_name="export_dwo_mediation_rec.sh"
            ;;
		
		9)
            script_name="export_dwo_mediation_volte_c.sh"
            ;;
		
		10)
            script_name="export_dwo_cbsmediation_sms.sh"
            ;;
		
		11)
            script_name="export_dwo_cbsmediation_mon_swap.sh"
            ;;
		12)
            script_name="export_dwo_cbsmediation_mgr_swap.sh"
            ;;
		13)
            script_name="export_dwo_mediation_msc_c.sh"
            ;;
		
		14)
            script_name="export_dwo_cbsmediation_data_swap_test.sh"
            ;;
		
		 15)
            script_name="write1.sh"
            ;;
		
		16)
            clear
            echo
            centre "Menu closed successfully." "$GREEN"
            exit 0
            ;;
        *)
            centre "Invalid selection. Please select 1 to 15." "$RED"
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
centre "Enter start date in YYYY-MM-DD format:" "$WHITE"
read -r start_date

centre "Enter end date in YYYY-MM-DD format:" "$WHITE"
read -r end_date

# Validate format
if ! [[ "$start_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] ||
   ! [[ "$end_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then

    centre "Invalid date format. Example: 2026-09-10" "$RED"
    pause_menu
    continue
fi

# Validate real calendar dates
if [[ "$(date -d "$start_date" "+%Y-%m-%d" 2>/dev/null)" != "$start_date" ]] ||
   [[ "$(date -d "$end_date" "+%Y-%m-%d" 2>/dev/null)" != "$end_date" ]]; then

    centre "One or both dates are invalid." "$RED"
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

#######looping the script ###################

    while [[ "$current_date" < "$end_date" || "$current_date" == "$end_date" ]]
    do
        {
            echo
            echo "----------------------------------------------"
            echo "Running $script_name for $current_date"
            echo "Started: $(date)"
            echo "----------------------------------------------"
        } >> "$log_file"
        
		echo "$script_path" "$current_date" >> "$log_file"
        bash "$script_path" "$current_date" >> "$log_file" 2>&1
        exit_code=$?

        if [[ $exit_code -eq 0 ]]; then
            echo "SUCCESS: $current_date completed." >> "$log_file"
        else
            echo "FAILED: $current_date, exit code $exit_code." >> "$log_file"
        fi

        current_date=$(date -d "$current_date +1 day" "+%Y-%m-%d")
    done

    {
        echo
        echo "=============================================="
        echo "Background export job completed"
        echo "End time: $(date)"
        echo "=============================================="
    } >> "$log_file"

' _ "$script_path" "$script_name" \
    "$start_date" "$end_date" "$log_file" \
    >> "$log_file" 2>&1 &

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
