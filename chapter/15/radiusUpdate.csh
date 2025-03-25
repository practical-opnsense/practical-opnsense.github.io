#!/bin/csh
# [de] Zweck: eigene oeffentlichen IP-Adresse an JumpCloud RADIUS-Server uebermitteln
# [en] purpose: update JumpCloud RADIUS server with local public IP address

# [de] Dieses Skript ist die C-Shell Variante vom offiziellen JumpCloud-Skript
# [en] This script is a modified version of the official JumpCloud script
# https://github.com/TheJumpCloud/support/blob/master/scripts/api/v1/radius/dhcpRadiusUpdate.sh


# [de] Zugriff zur JumpCloud API
# [en] Access the JumpCloud API
set apiKey=jca_5MsDUhMx37Y5ZTeDN5RZuH3ppTQfhb8c4pa1
set radiusId=59fe206fb63f4b3053ce0e1a

# [de] haben wir einen API-Schluessel?
# [en] check if an API key is present
if ( "$apiKey" == "" ) then
  echo "apiKey must be defined, exiting..."
  exit 1
endif

# [de] Eigene oeffentliche IP-Adresse ermitteln
# [en] Get the public IP address of this host
set newIp = `curl --silent https://api.ipify.org/`
if ( $? != 0 ) then
  echo "Unable to determine newIp, exiting..."
  exit 2
endif

# [de] Hole die aktuelle IP-Adresse von der JumpCloud API
# [en] Get the current IP address using the JumpCloud API
curl --silent --request GET \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header "x-api-key: $apiKey" \
  "https://console.jumpcloud.com/api/radiusservers/$radiusId" \
  | json_pp -json_opt pretty > /tmp/current_ip.txt

# [de] Wenn sich die IP-Adresse nicht veraendert hat, endet das Skript hier
# [en] If the IP address hasn't changed, the script ends here
grep $newIp /tmp/current_ip.txt > /dev/null
if ( $? == 0 ) then
  echo "IP has not changed, have a nice day"
  exit 0
endif

# [de] Neue IP-Adresse ins API-Kommando einbauen
# [en] insert new IP address into the API command
sed -i '' 's/"networkSourceIp".*/"networkSourceIp" : "'${newIp}'",/' /tmp/current_ip.txt

# [de] Neue IP-Adresse bei JumpCloud hinterlegen
# [en] Upload the new IP address to JumpCloud
curl --silent --request PUT \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header "x-api-key: $apiKey" \
  --output /dev/null --fail \
  --data @/tmp/current_ip.txt \
  "https://console.jumpcloud.com/api/radiusservers/$radiusId"

if ( $? == 0 ) then
  echo "IP has changed to $newIp, updated JumpCloud"
else
  echo "Failed to update JumpCloud about new IP $newIp"
endif

exit 0
