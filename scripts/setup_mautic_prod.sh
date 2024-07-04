#!/bin/bash

# Define the source files array
SOURCE_FILES=(
  "../../conf/mautic_env.txt"
  "../../conf/mailer_settings.env"
)

# Define the destination files array
DESTINATION_FILES=(
  "../.env"
  "../mailer_settings.env"
)

# Check if the source and destination arrays have the same length
if [ ${#SOURCE_FILES[@]} -ne ${#DESTINATION_FILES[@]} ]; then
  echo "Source and destination files arrays must have the same length."
  exit 1
fi

# Loop through the arrays and copy each file
for i in "${!SOURCE_FILES[@]}"; do
  SOURCE_FILE="${SOURCE_FILES[$i]}"
  DESTINATION_FILE="${DESTINATION_FILES[$i]}"

  # Check if the source file exists
  if [ ! -f "$SOURCE_FILE" ]; then
    echo "Source file $SOURCE_FILE does not exist."
    continue
  fi

  # Copy the file, replacing it if it already exists
  cp -f "$SOURCE_FILE" "$DESTINATION_FILE"

  # Check if the copy operation was successful
  if [ $? -eq 0 ]; then
    echo "File $SOURCE_FILE copied successfully to $DESTINATION_FILE"
  else
    echo "Failed to copy the file $SOURCE_FILE to $DESTINATION_FILE."
  fi
done



# change ownership of cronjob to root:root to avoid not running cronjobs
FILE_PATH="../cron.d/mautic"

# Check if the file exists
if [ -f "$FILE_PATH" ]; then
  # Change ownership to root:root
  sudo chown root:root "$FILE_PATH"
  echo "Ownership of $FILE_PATH has been changed to root:root"
else
  echo "File $FILE_PATH does not exist"
fi