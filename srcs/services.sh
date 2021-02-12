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

service php7.4-fpm start
/usr/sbin/nginx -g "daemon off;"
