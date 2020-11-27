# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    autoindex.sh                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tayamamo <tayamamo@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/27 07:14:50 by tayamamo          #+#    #+#              #
#    Updated: 2020/11/27 17:00:06 by tayamamo         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

INDEX=$1

if [[ "$INDEX" == "on" || "$INDEX" == "off" ]];
then
	sed -i -E "/autoindex/ s/on|off/$INDEX/" /etc/nginx/sites-available/default.conf
	service nginx reload
	echo "Autoindex option is now set to $INDEX"
else
	echo "Please provide a valid value ('on' or 'off') for autoindex"
fi

# service nginx start
# service php7.4-fpm start
# service mysql restart
bash
