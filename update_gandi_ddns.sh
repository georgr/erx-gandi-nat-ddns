#!/bin/bash

API_KEY=$1
FQDN=$2

#extract subdomain and domain name
SUBDOMAIN=${FQDN%%.*}
DOMAINNAME=${FQDN#*.}

#URL for the zone records
DOMAIN_RECORDS_URL=$(curl -s -H "X-Api-Key: $API_KEY" https://dns.api.gandi.net/api/v5/zones | jq --arg DOMAINNAME "$DOMAINNAME" '.[] | select(.name == $DOMAINNAME)' | jq -r '.zone_records_href')

#URL for the subdomain A record to update
A_RECORD_URL="$DOMAIN_RECORDS_URL/$SUBDOMAIN/A"

#ip currently configured for the A record
CONFIGURED_IP=$(curl -s -H "X-Api-Key: $API_KEY" $A_RECORD_URL | jq -r '.rrset_values[0]')
#current external ip discovered via external service
CURRENT_IP=$(curl -s https://dynamic.zoneedit.com/checkip.html)

#check if the current configured ip matches the current external ip
if [ "$CONFIGURED_IP" != "$CURRENT_IP" ]; then
  #update the A record to current external ip
  curl -s -X PUT -H "Content-Type: application/json" -H "X-Api-Key: $API_KEY" -d '{"rrset_values": ["'"$CURRENT_IP"'"]}' $A_RECORD_URL
fi
