#!/bin/bash

# Define the source file
SOURCE_FILE="../../conf/mautic_env.txt"

# Define the destination symlink in the current directory
DESTINATION_FILE="../.env"

# Check if the source file exists
if [ ! -f "$SOURCE_FILE" ]; then
  echo "Source file $SOURCE_FILE does not exist."
  exit 1
fi

# Copy the file, replacing it if it already exists
cp -f "$SOURCE_FILE" "$DESTINATION_FILE"

# Check if the copy operation was successful
if [ $? -eq 0 ]; then
  echo "File copied successfully to $DESTINATION_FILE"
else
  echo "Failed to copy the file."
fi

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