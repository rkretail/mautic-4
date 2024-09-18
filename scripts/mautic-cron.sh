#!/bin/bash

# Get the current hour and minute
hour=$(date +%H)
minute=$(date +%M)

# Run the first cron job if the hour is divisible by 6 and minute is 0
if (( hour % 6 == 0 && minute == 0)); then
    /var/scripts/change-config.sh && \
    php /var/www/html/bin/console mautic:broadcasts:send -l 1 > /var/log/cron.pipe 2>&1
    # php /var/www/html/bin/console mautic:campaigns:trigger --batch-limit=1 > /var/log/cron.pipe 2>&1
# Otherwise, run the second cron job if the minute is divisible by 5
elif (( minute % 5 == 0 )); then
    php /var/www/html/bin/console mautic:import --limit=500 && \
    php /var/www/html/bin/console mautic:segments:update --batch-limit=900 && \
    php /var/www/html/bin/console mautic:campaigns:rebuild --batch-limit=100 > /var/log/cron.pipe 2>&1
fi
