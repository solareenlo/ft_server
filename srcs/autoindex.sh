#!/bin/bash

INDEX=$1

if [[ "$INDEX" == "on" || "$INDEX" == "off" ]];
then
	sed -i -E "/autoindex/ s/on|off/$INDEX/" /etc/nginx/sites-available/default.conf
	service nginx reload
	echo "Autoindex is now set to $INDEX"
else
	echo "Please set a valid value ('on' or 'off')."
fi
