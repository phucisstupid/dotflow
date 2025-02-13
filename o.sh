#!/bin/bash

# Check if an argument is provided
if [[ "$1" == "-i" ]]; then
    script_name="private.sh"
elif [[ "$1" == "-p" ]]; then
    script_name="push.sh"
else
    script_name="install.sh"
fi

# Fetch the script safely
url="https://raw.githubusercontent.com/phucleeuwu/dot.manager/main/$script_name"
script_content=$(curl -fsSL "$url")

# Check if curl succeeded
if [[ -z "$script_content" ]]; then
    echo "Error: Failed to download $script_name"
    exit 1
fi

# Execute the script
bash -c "$script_content"
