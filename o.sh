#!/bin/bash

# Check if an argument is provided
if [[ "$1" == "-i" ]]; then
    script_name="private.sh"
elif [[ "$1" == "-p" ]]; then
    script_name="push.sh"
else
    echo "Invalid option."
    exit 1
fi

# Run the selected script
bash <(curl -fsSL "https://raw.githubusercontent.com/phucleeuwu/dot.manager/main/$script_name")
