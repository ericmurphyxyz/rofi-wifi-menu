#!/usr/bin/env bash

# Starts a scan of available broadcasting SSIDs
# nmcli dev wifi rescan

FIELDS=SSID,SECURITY

LIST=$(nmcli --fields "$FIELDS" device wifi list | sed '/^--/d')
# For some reason rofi always approximates character width 2 short... hmmm
RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }')+2))
# Gives a list of known connections so we can parse it later
KNOWNCON=$(nmcli -g NAME connection)
# Really janky way of telling if there is currently a connection
CONSTATE=$(nmcli -fields WIFI g)

CURRSSID=$(LANGUAGE=C nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes/ {print $2}')

if [[ "$CONSTATE" =~ "enabled" ]]; then
	TOGGLE="toggle off"
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	TOGGLE="toggle on"
fi



CHENTRY=$(echo -e "$TOGGLE\n$LIST" | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " )
CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')

	# If the connection is already in use, then this will still be able to get the SSID
if [ "$CHSSID" = "*" ]; then
	CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
fi

# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
if [[ $(echo "$KNOWNCON" | grep -w "$CHSSID") = "$CHSSID" ]]; then
	nmcli connection up id "$CHSSID"
else
	if [[ "$CHENTRY" =~ "WPA2" ]] || [[ "$CHENTRY" =~ "WEP" ]]; then
		WIFIPASS=$(echo "if connection is stored, hit enter" | rofi -dmenu -p "password: " )
	fi
	nmcli device wifi connect "$CHSSID" password "$WIFIPASS"
fi
