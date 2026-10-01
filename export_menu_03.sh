#!/bin/bash
echo "hello3"
echo "hello3"
echo "hello3"
echo "hello3"
echo "hello3"

# ================= COLOURS =================
BLUE='\033[1;34m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
RED='\033[1;31m'
WHITE='\033[1;37m'
BG_BLUE='\033[44m'
BG_CYAN='\033[46m'
BG_GREEN='\033[42m'
BG_MAGENTA='\033[45m'
BG_RED='\033[41m'
BG_YELLOW='\033[43m'
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

centre_option() {
    local number="$1"
    local label="$2"
    local badge_colour="$3"
    local label_colour="$4"
    local inner="   [$number] $label"
    local inner_width=52
    local width
    local column
    local padding

    width=$(tput cols)
    column=$(( (width - inner_width - 2) / 2 ))
    (( column < 0 )) && column=0
    padding=$((inner_width - ${#inner}))
    (( padding < 0 )) && padding=0

    printf "%*s" "$column" ""
    printf '%b' "${CYAN}║${RESET}   ${badge_colour}[${number}]${RESET} ${label_colour}${label}${RESET}"
    printf "%*s" "$padding" ""
    printf '%b\n' "${CYAN}║${RESET}"
}

pause_menu() {
    echo
    centre "Press Enter to return to the menu..." "$BG_CYAN$WHITE"
    read -r
}

# ================= MAIN MENU =================
while true
do
    clear

    echo
    echo
    centre "╔════════════════════════════════════════════════════╗" "$BG_BLUE$WHITE"
    centre "║                                                    ║" "$CYAN"
    centre "║              ★ DATA EXPORT MENU ★                  ║" "$BG_MAGENTA$WHITE"
    centre "║              * date format 2026-09-01*             ║" "$BG_YELLOW$BLUE"
    centre "╠════════════════════════════════════════════════════╣" "$BG_CYAN$WHITE"
    centre_option 1 "write.sh" "$BG_YELLOW$BLUE" "$YELLOW"
    centre_option 2 "export_dwo_rms_device_sim_hist.sh" "$BG_CYAN$BLUE" "$CYAN"
    centre_option 3 "export_dwo_rms_device_msisdn_hist.sh" "$BG_GREEN$BLUE" "$GREEN"
    centre_option 4 "export_dwo_ussd_ussd_cdr_hist.sh" "$BG_YELLOW$BLUE" "$YELLOW"
    centre_option 5 "export_dwo_cmp_cmp.sh" "$BG_BLUE$WHITE" "$BLUE"
    centre_option 6 "export_dwo_cbsmediation_data_swap.sh" "$BG_MAGENTA$WHITE" "$MAGENTA"
    centre_option 7 "export_dwo_mediation_smsc_comviva.sh" "$BG_CYAN$BLUE" "$CYAN"
    centre_option 8 "export_dwo_mediation_rec.sh" "$BG_GREEN$BLUE" "$GREEN"
    centre_option 9 "export_dwo_mediation_volte_c.sh" "$BG_YELLOW$BLUE" "$YELLOW"
    centre_option 10 "export_dwo_cbsmediation_sms.sh" "$BG_BLUE$WHITE" "$BLUE"
    centre_option 11 "export_dwo_cbsmediation_mon_swap.sh" "$BG_MAGENTA$WHITE" "$MAGENTA"
    centre_option 12 "export_dwo_cbsmediation_mgr_swap.sh" "$BG_CYAN$BLUE" "$CYAN"
    centre_option 13 "export_dwo_mediation_msc_c.sh" "$BG_GREEN$BLUE" "$GREEN"
    centre_option 14 "export_dwo_cbsmediation_data_swap_test.sh" "$BG_YELLOW$BLUE" "$YELLOW"
    centre_option 15 "write1.sh" "$BG_RED$WHITE" "$RED"
    centre "║                                                    ║" "$CYAN"
    centre_option 16 "Exit" "$BG_RED$WHITE" "$RED"
    centre "╚════════════════════════════════════════════════════╝" "$BG_BLUE$WHITE"

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
            centre "Menu closed successfully." "$BG_GREEN$BLUE"
            exit 0
            ;;
        *)
            centre "Invalid selection. Please select 1 to 16." "$BG_RED$WHITE"
            sleep 2
            continue
            ;;
    esac

    script_path="$SCRIPT_DIR/$script_name"

    if [[ ! -f "$script_path" ]]; then
        centre "Script not found: $script_name" "$BG_RED$WHITE"
        sleep 3
        continue
    fi

    # ================= DATE INPUT =================
    clear
    echo
    echo
    centre "╔════════════════════════════════════════════════════╗" "$BG_BLUE$WHITE"
    centre "║              ENTER DATE RANGE                      ║" "$BG_YELLOW$BLUE"
    centre "╚════════════════════════════════════════════════════╝" "$BG_BLUE$WHITE"

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

    centre "Invalid date format. Example: 2026-09-10" "$BG_RED$WHITE"
    pause_menu
    continue
fi

# Validate real calendar dates
if [[ "$(date -d "$start_date" "+%Y-%m-%d" 2>/dev/null)" != "$start_date" ]] ||
   [[ "$(date -d "$end_date" "+%Y-%m-%d" 2>/dev/null)" != "$end_date" ]]; then

    centre "One or both dates are invalid." "$BG_RED$WHITE"
    pause_menu
    continue
fi

    # ================= CONFIRMATION =================
    clear
    echo
    echo
    centre "╔════════════════════════════════════════════════════╗" "$BG_CYAN$WHITE"
    centre "║                CONFIRM EXECUTION                   ║" "$BG_YELLOW$BLUE"
    centre "╚════════════════════════════════════════════════════╝" "$BG_CYAN$WHITE"

    echo
    centre "Script     : $script_name" "$GREEN"
    centre "Start date : $start_date" "$BLUE"
    centre "End date   : $end_date" "$MAGENTA"

    echo
    centre "Start this job in the background? [y/n]:" "$WHITE"
    read -r confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        centre "Execution cancelled." "$BG_YELLOW$BLUE"
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
    centre "╔════════════════════════════════════════════════════╗" "$BG_GREEN$BLUE"
    centre "║            ✔ BACKGROUND JOB STARTED                ║" "$BG_GREEN$BLUE"
    centre "╚════════════════════════════════════════════════════╝" "$BG_GREEN$BLUE"

    echo
    centre "Process ID : $background_pid" "$YELLOW"
    centre "Log file   : $log_file" "$CYAN"

    pause_menu
done
