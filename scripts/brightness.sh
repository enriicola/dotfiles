sudo ddcutil getvcp 10 | awk '{gsub(/,/, "", $9); print $9}' | xargs -I {} bash -c 'sudo ddcutil setvcp 10 $(( {} + 5 ))'

sudo ddcutil getvcp 10 | awk '{gsub(/,/, "", $9); print $9}' | xargs -I {} bash -c 'sudo ddcutil setvcp 10 $(( {} - 5 ))'
