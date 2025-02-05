#!/bin/bash

# Check if an argument is provided
if [[ "$1" == "-1" ]]; then
    script_name="private.sh"
elif [[ "$1" == "-2" ]]; then
    script_name="push.sh"
else
    echo "Select an option:"
    echo "1) private.sh"
    echo "2) push.sh"
    read -p "Enter 1 or 2: " choice

    if [[ "$choice" == "1" ]]; then
        script_name="private.sh"
    elif [[ "$choice" == "2" ]]; then
        script_name="push.sh"
    else
        echo "Invalid choice. Exiting."
        exit 1
    fi
fi

bash <(curl -fsSL "https://raw.githubusercontent.com/phucleeuwu/dot.manager/main/$script_name")
