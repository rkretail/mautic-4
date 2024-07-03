#!/bin/bash

# Path to the local.php file
CONFIG_FILE="app/config/local.php"

# Path to the file that stores the last used index
INDEX_FILE="app/config/last_mailer_index.txt"

# Define an array of mailer settings
MAILER_SETTINGS=(
  "smtp smtp.office365.com 587"
  "smtp smtp.gmail.com 587"
  "smtp smtp.mail.yahoo.com 465"
)

# Get the number of mailer settings
NUM_SETTINGS=${#MAILER_SETTINGS[@]}

# Read the last used index from the file, default to -1 if the file does not exist
if [[ -f "$INDEX_FILE" ]]; then
  LAST_INDEX=$(cat "$INDEX_FILE")
else
  LAST_INDEX=-1
fi

# Calculate the next index in a round-robin fashion
NEXT_INDEX=$(( (LAST_INDEX + 1) % NUM_SETTINGS ))

# Save the next index to the file
echo "$NEXT_INDEX" > "$INDEX_FILE"

# Get the selected mailer setting
SELECTED_SETTING=${MAILER_SETTINGS[$NEXT_INDEX]}

# Parse the selected setting
MAILER_TRANSPORT=$(echo $SELECTED_SETTING | awk '{print $1}')
MAILER_HOST=$(echo $SELECTED_SETTING | awk '{print $2}')
MAILER_PORT=$(echo $SELECTED_SETTING | awk '{print $3}')

# Backup the original local.php file
cp "$CONFIG_FILE" "$CONFIG_FILE.bak"

# Update the settings in the local.php file
sed -i "s/'mailer_transport' => '.*'/'mailer_transport' => '$MAILER_TRANSPORT'/g" "$CONFIG_FILE"
sed -i "s/'mailer_host' => '.*'/'mailer_host' => '$MAILER_HOST'/g" "$CONFIG_FILE"
sed -i "s/'mailer_port' => '.*'/'mailer_port' => '$MAILER_PORT'/g" "$CONFIG_FILE"

# Print a message indicating the changes were made
echo "SMTP settings updated in $CONFIG_FILE to use $MAILER_HOST:$MAILER_PORT"
