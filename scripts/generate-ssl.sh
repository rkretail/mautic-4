#!/bin/bash

# Read domains from file and create domain list with and without mailer prefix
domains=$(cat domains.txt)
full_domain_list=""

# Loop through each domain in the file
for domain in $domains
do
    full_domain_list="$full_domain_list -d mailer.$domain"
done


# Run certbot for all domains, including mailer.<domain>
sudo certbot certonly --nginx $full_domain_list
