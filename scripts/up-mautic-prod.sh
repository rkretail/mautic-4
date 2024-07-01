#!/bin/bash

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