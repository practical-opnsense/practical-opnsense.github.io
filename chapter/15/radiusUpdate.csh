#!/bin/csh
# [de] Zweck: eigene oeffentlichen IP-Adresse an JumpCloud RADIUS-Server uebermitteln
# [en] purpose: update JumpCloud RADIUS server with local public IP address

# [de] Dieses Skript ist die C-Shell Variante vom offiziellen JumpCloud-Skript
# [en] This script is a modified version of the official JumpCloud script
# https://github.com/TheJumpCloud/support/blob/master/scripts/api/v1/radius/dhcpRadiusUpdate.sh


# [de] Zugriff zur JumpCloud API
# [en] Access the JumpCloud API
set apiKey=7e2563b0ca4c7988cf8ce0ec644da128351a3b62
set radiusId=5a04df3ffe73e29b568b6af3

# [de] haben wir einen API-Schluessel?
# [en] check if an API key is present
if ( "$apiKey" == "" ) then
  echo "apiKey must be defined, exiting..."
  exit 1
endif

# [de] eigene oeffentliche IP-Adresse ermitteln
# [en] get the public IP address of this host
set newIp = `curl --silent http://ipecho.net/plain`

if ( $? != 0 ) then
  echo "Unable to determine newIp, exiting..."
  exit 2
endif

# [de] hole die aktuelle IP von der JumpCloud API
# [en] get the current IP address using the JumpCloud API
set currentIp=`curl --silent -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "x-api-key: $apiKey" "https://console.jumpcloud.com/api/radiusservers/$radiusId"`

# [de] Wenn sich die IP-Adresse nicht veraendert hat, endet das Skript hier
# [en] If the IP address hasn't changed, the script ends here
if ( "$currentIp" =~ {*\"$newIp\"*} ) then
  echo "IP has not changed, have a nice day."
  exit 0
endif


# [de] API-Kommando im JSON-Format vorbereiten
# [en] prepare API command in JSON format
cat << EOF > /tmp/current_ip.txt
{"networkSourceIp" : "$newIp"}
EOF

# [de] neue IP-Adresse bei JumpCloud hinterlegen
# [en] upload the new IP address to JumpCloud
curl -X PUT \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H "x-api-key: $apiKey" \
  --data @/tmp/current_ip.txt \
  "https://console.jumpcloud.com/api/radiusservers/$radiusId"

exit 0
