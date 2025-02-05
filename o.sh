#!/bin/bash

# Check if an argument is provided
if [[ "$1" == "-1" ]]; then
    script_name="private.sh"
elif [[ "$1" == "-2" ]]; then
    script_name="push.sh"
elif [[ "$1" == "-3" ]]; then
    script_name="install.sh"
else
    echo "Invalid option. Please use -1 for private.sh, -2 for push.sh, or -3 for install.sh."
    exit 1
fi

# Run the selected script
bash <(curl -fsSL "https://raw.githubusercontent.com/phucleeuwu/dot.manager/main/$script_name")
