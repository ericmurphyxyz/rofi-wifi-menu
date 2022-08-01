#!/usr/bin/env bash

notify-send.py "Abrindo wifi..."
# Get a list of available wifi connections and morph it into a nice-looking list
wifi_list=$(nmcli --fields "IN-USE,SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "habilitado" ]]; then
	toggle="睊  Desligar wifi"
elif [[ "$connected" =~ "desabilitado" ]]; then
	toggle="直  Ligar wifi"
fi

# Use rofi to select wifi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: " )
# Get name of connection
chosen_id=$(echo "${chosen_network:3}" | xargs)

if [ "$chosen_network" = "" ]; then
	exit
elif [ "$chosen_network" = "直  Ligar wifi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "睊  Desligar wifi" ]; then
	nmcli radio wifi off
else
	# Message to show when connection is activated successfully
	success_message="Conectado a \"$chosen_id\"."
	# Get saved connections
	saved_connections=$(nmcli -g NAME connection)
	# check saved connections
	check_saved_connections=$(echo "$saved_connections" | grep -w "$chosen_id")

	if [[ $check_saved_connections == *"Automático(a)"* ]]; then
		chosen_id="$chosen_id Automático(a)"
    	nmcli connection up id "$chosen_id" | grep "sucesso" || wifi_password=$(rofi -dmenu -p "Password: " ) && nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "sucesso" && notify-send.py "$success_message"
	else
		if [[ $check_saved_connections = "$chosen_id" ]]; then
			nmcli connection up id "$chosen_id" | grep "sucesso" || wifi_password=$(rofi -dmenu -p "Password: " ) && nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "sucesso" && notify-send.py "$success_message"
		else
			if [[ "$chosen_network" =~ "" ]]; then
				wifi_password=$(rofi -dmenu -p "Password: " )
			fi
			nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "sucesso" && notify-send.py "Conexão estabelecida" "$success_message"
		fi
	fi
fi
