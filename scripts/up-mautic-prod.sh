#!/bin/bash


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

# Run Docker Compose to set up and start the containers
# sudo docker compose -f docker-compose.yml -f docker-compose.override.yml up -d
sudo docker compose -f ../docker-compose.yml -f ../docker-compose-prod.override.yml  up -d

# Check if the Docker Compose command was successful
if [ $? -eq 0 ]; then
  echo "Docker Compose containers started successfully."
else
  echo "Failed to start Docker Compose containers."
  exit 1
fi