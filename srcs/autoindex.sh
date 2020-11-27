# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    autoindex.sh                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tayamamo <tayamamo@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/27 07:14:50 by tayamamo          #+#    #+#              #
#    Updated: 2020/11/28 04:08:12 by tayamamo         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

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
