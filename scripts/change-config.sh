#!/bin/bash

# Path to the local.php file
CONFIG_FILE="/var/www/html/app/config/local.php"

# Path to the file that stores the last used index
INDEX_FILE="/var/www/html/app/config/last_mailer_index.txt"

# Define an array of mailer settings
# Format: "from_name from_email transport host port user password encryption reply_to_email return_path"
MAILER_SETTINGS=(
  "Sender1 sender1@example.com smtp smtp.office365.com 587 user1 pass1 tls replyto1@example.com returnpath1@example.com"
  "Sender2 sender2@example.com smtp smtp.gmail.com 587 user2 pass2 tls replyto2@example.com returnpath2@example.com"
  "Sender3 sender3@example.com smtp smtp.mail.yahoo.com 465 user3 pass3 ssl replyto3@example.com returnpath3@example.com"
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
MAILER_FROM_NAME=$(echo $SELECTED_SETTING | awk '{print $1}')
MAILER_FROM_EMAIL=$(echo $SELECTED_SETTING | awk '{print $2}')
MAILER_TRANSPORT=$(echo $SELECTED_SETTING | awk '{print $3}')
MAILER_HOST=$(echo $SELECTED_SETTING | awk '{print $4}')
MAILER_PORT=$(echo $SELECTED_SETTING | awk '{print $5}')
MAILER_USER=$(echo $SELECTED_SETTING | awk '{print $6}')
MAILER_PASSWORD=$(echo $SELECTED_SETTING | awk '{print $7}')
MAILER_ENCRYPTION=$(echo $SELECTED_SETTING | awk '{print $8}')
MAILER_REPLY_TO_EMAIL=$(echo $SELECTED_SETTING | awk '{print $9}')
MAILER_RETURN_PATH=$(echo $SELECTED_SETTING | awk '{print $10}')

# Backup the original local.php file
cp "$CONFIG_FILE" "$CONFIG_FILE.bak"

# Update the settings in the local.php file
sed -i "s/'mailer_from_name' => '.*'/'mailer_from_name' => '$MAILER_FROM_NAME'/g" "$CONFIG_FILE"
sed -i "s/'mailer_from_email' => '.*'/'mailer_from_email' => '$MAILER_FROM_EMAIL'/g" "$CONFIG_FILE"
sed -i "s/'mailer_transport' => '.*'/'mailer_transport' => '$MAILER_TRANSPORT'/g" "$CONFIG_FILE"
sed -i "s/'mailer_host' => '.*'/'mailer_host' => '$MAILER_HOST'/g" "$CONFIG_FILE"
sed -i "s/'mailer_port' => '.*'/'mailer_port' => '$MAILER_PORT'/g" "$CONFIG_FILE"
sed -i "s/'mailer_user' => '.*'/'mailer_user' => '$MAILER_USER'/g" "$CONFIG_FILE"
sed -i "s/'mailer_password' => '.*'/'mailer_password' => '$MAILER_PASSWORD'/g" "$CONFIG_FILE"
sed -i "s/'mailer_encryption' => '.*'/'mailer_encryption' => '$MAILER_ENCRYPTION'/g" "$CONFIG_FILE"
sed -i "s/'mailer_reply_to_email' => '.*'/'mailer_reply_to_email' => '$MAILER_REPLY_TO_EMAIL'/g" "$CONFIG_FILE"
sed -i "s/'mailer_return_path' => '.*'/'mailer_return_path' => '$MAILER_RETURN_PATH'/g" "$CONFIG_FILE"

# Print a message indicating the changes were made
echo "SMTP settings updated in $CONFIG_FILE to use $MAILER_HOST:$MAILER_PORT with user $MAILER_USER"
