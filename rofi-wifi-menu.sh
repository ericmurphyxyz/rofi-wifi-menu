#!/usr/bin/env bash

# Starts a scan of available broadcasting SSIDs
# nmcli dev wifi rescan

wifi_list=$(nmcli --fields "SSID,SECURITY" device wifi list | sed '/^--/d' | sed 1d)
# Gives a list of known connections so we can parse it later
saved_connections=$(nmcli -g NAME connection)

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
	TOGGLE="Disable Wifi"
elif [[ "$connected" =~ "disabled" ]]; then
	TOGGLE="Enable Wifi"
fi

chosen_network=$(echo -e "$TOGGLE\n$wifi_list" | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " )
chosen_id=$(echo "$chosen_network" | sed 's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')

	# If the connection is already in use, then this will still be able to get the SSID
if [ "$chosen_id" = "*" ]; then
	chosen_id=$(echo "$chosen_network" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
fi

# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
	nmcli connection up id "$chosen_id"
else
	if [[ "$chosen_network" =~ "WPA2" ]] || [[ "$chosen_network" =~ "WEP" ]]; then
		wifi_password=$(echo "if connection is stored, hit enter" | rofi -dmenu -p "password: " )
	fi
	nmcli device wifi connect "$chosen_id" password "$wifi_password"
fi
