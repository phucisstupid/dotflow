#!/bin/bash

# Check if an argument is provided
if [[ "$1" == "-i" ]]; then
    script_name="private.sh"
elif [[ "$1" == "-p" ]]; then
    script_name="push.sh"
else
    script_name="install.sh"
fi

# Run the selected script
bash <(curl -fsSL "https://raw.githubusercontent.com/phucleeuwu/Dotflow/main/$script_name")
