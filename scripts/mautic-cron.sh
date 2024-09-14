#!/bin/bash

# Get the current minute
minute=$(date +%M)

# If the minute is divisible by 5, run the first cron job
if (( minute % 5 == 0 )); then
    php /var/www/html/bin/console mautic:import --limit=500 && \
    php /var/www/html/bin/console mautic:segments:update --batch-limit=900 && \
    php /var/www/html/bin/console mautic:campaigns:rebuild --batch-limit=100 > /var/log/cron.pipe 2>&1
else
    # Otherwise, run the second cron job
    /var/scripts/change-config.sh && \
    php /var/www/html/bin/console mautic:campaigns:trigger --batch-limit=1 > /var/log/cron.pipe 2>&1
fi
