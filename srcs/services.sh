# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    services.sh                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tayamamo <tayamamo@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/27 15:15:13 by tayamamo          #+#    #+#              #
#    Updated: 2020/11/29 22:11:43 by tayamamo         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

DATABASE_NAME=wordpress
USERNAME=username
PASSWORD=password
DATABASE_HOST=localhost
DB_PHPMYADMIN=phpmyadmin

service mysql start
mysql -u root -e "CREATE USER '$USERNAME'@'$DATABASE_HOST' IDENTIFIED BY '$PASSWORD';"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS $DATABASE_NAME"
mysql -u root -e "GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$USERNAME'@'$DATABASE_HOST';"
mysql -u root -e "CREATE DATABASE $DB_PHPMYADMIN;"
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_PHPMYADMIN.* TO '$USERNAME'@'$DATABASE_HOST';"

sed -i -E "/autoindex/ s/AUTOINDEX/$AUTOINDEX/" /etc/nginx/sites-available/default.conf
service nginx start
service php7.4-fpm start

bash
