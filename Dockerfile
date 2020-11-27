# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tayamamo <tayamamo@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/21 05:19:27 by tayamamo          #+#    #+#              #
#    Updated: 2020/11/28 05:53:39 by tayamamo         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

LABEL maintainer="tayamamo@student.42tokyo.jp"

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
		apt-get update; \
		apt-get upgrade -y; \
		apt-get install -y --no-install-recommends \
			wget \
			curl \
			gnupg2 \
			dirmngr \
			ca-certificates \
			lsb-release \
			apt-transport-https \
			nginx \
			vim \
			xz-utils \
		; \
		rm -rf /var/lib/apt/lists/*

COPY srcs/ /tmp/

# Install php7.4
ENV PHP_VERSION 7.4.12
ENV PHP_URL="https://www.php.net/distributions/php-7.4.12.tar.xz"
ENV PHP_ASC_URL="https://www.php.net/distributions/php-7.4.12.tar.xz.asc"
ENV PHP_SHA256="e82d2bcead05255f6b7d2ff4e2561bc334204955820cabc2457b5239fde96b76"

RUN set -eux; \
		wget https://packages.sury.org/php/apt.gpg; \
		apt-key add apt.gpg; \
		echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.list; \
		rm apt.gpg; \
		apt-get update; \
		apt-get install -y --no-install-recommends \
			php7.4-fpm \
			php7.4-mysql \
			php7.4-mbstring \
		; \
		rm -rf /var/lib/apt/lists/*

# Install WorldPress
ENV WORDPRESS_VERSION 5.5.3
ENV WORDPRESS_SHA1 61015720c679a6cbf9ad51701f0f3fedb51b3273

RUN set -ex; \
		# curl -o wordpress.tar.gz -fSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz"; \
		echo "$WORDPRESS_SHA1 */tmp/wordpress-${WORDPRESS_VERSION}.tar.gz" | sha1sum -c -; \
		tar -xzf /tmp/wordpress-${WORDPRESS_VERSION}.tar.gz -C /var/www/; \
		rm /tmp/wordpress-${WORDPRESS_VERSION}.tar.gz; \
		mv /tmp/favicon.ico /var/www/wordpress/; \
		mv /tmp/phpinfo.php /var/www/wordpress/; \
		chown -R www-data:www-data /var/www/wordpress

# Install MySQL
ENV MYSQL_VERSION 0.8.16-1
ENV MYSQL_MD5SUM f6a7c41f04cc4fea7ade285092eea77a

RUN set -eux; \
		wget https://dev.mysql.com/get/mysql-apt-config_${MYSQL_VERSION}_all.deb; \
		echo "$MYSQL_MD5SUM mysql-apt-config_${MYSQL_VERSION}_all.deb" | md5sum -c -; \
		{ \
			echo mysql-community-server mysql-community-server/data-dir select ''; \
			echo mysql-community-server mysql-community-server/root-pass password ''; \
			echo mysql-community-server mysql-community-server/re-root-pass password ''; \
			echo mysql-community-server mysql-community-server/remove-test-db select false; \
			echo mysql-apt-config mysql-apt-config/select-server select mysql-5.7; \
		} | debconf-set-selections; \
		dpkg -i mysql-apt-config_${MYSQL_VERSION}_all.deb; \
		rm mysql-apt-config_${MYSQL_VERSION}_all.deb; \
		apt-get update; \
		apt-get install -y --no-install-recommends \
			mysql-server \
			mysql-client \
		; \
		rm -rf /var/lib/apt/lists/*

# Install phpMyAdmin
ENV PHPMYADMIN_VERSION 5.0.4
ENV PHPMYADMIN_SHA256 1578c1a08e594da4f4f62e676ccbdbd17784c3de769b094ba42c35bf05c057db
ENV PHPMYADMIN_URL https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.xz

ENV PHPMYADMIN_ZIP_SHA256 830bbca930d5e417ae4249931838e2c70ca0365044268fa0ede75e33aff677de

RUN set -eux; \
		export GNUPGHOME="$(mktemp -d)"; \
		export GPGKEY="3D06A59ECE730EB71B511C17CE752F178259BD92"; \
		curl -fsSL -o phpMyAdmin.tar.xz $PHPMYADMIN_URL; \
		curl -fsSL -o phpMyAdmin.tar.xz.asc $PHPMYADMIN_URL.asc; \
		echo "$PHPMYADMIN_SHA256 *phpMyAdmin.tar.xz" | sha256sum -c -; \
		gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPGKEY" \
			|| gpg --batch --keyserver ipv4.pool.sks-keyservers.net --recv-keys "$GPGKEY" \
			|| gpg --batch --keyserver keys.gnupg.net --recv-keys "$GPGKEY" \
			|| gpg --batch --keyserver pgp.mit.edu --recv-keys "$GPGKEY" \
			|| gpg --batch --keyserver keyserver.pgp.com --recv-keys "$GPGKEY"; \
		gpg --batch --verify phpMyAdmin.tar.xz.asc phpMyAdmin.tar.xz; \
		mkdir /var/www/wordpress/phpmyadmin; \
		tar -xf phpMyAdmin.tar.xz -C /var/www/wordpress/phpmyadmin --strip-components=1; \
		rm -r "$GNUPGHOME" phpMyAdmin.tar.xz phpMyAdmin.tar.xz.asc; \
		mv /tmp/config.inc.php /var/www/wordpress/phpmyadmin/; \
		chown -R www-data:www-data /var/www/wordpress/phpmyadmin; \
		gpgconf --kill all; \
		rm -rf /var/lib/apt/lists/*

# Set up Self-Signed SSL certificate
RUN set -eux; \
		yes "" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
			-keyout /etc/ssl/private/private.key \
			-out /etc/ssl/certs/public.crt

# Set up Nginx
RUN set -eux; \
		mv /tmp/default.conf /etc/nginx/sites-available/default.conf; \
		cd /; \
		rm /etc/nginx/sites-enabled/default; \
		ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/

EXPOSE 80 443

CMD ["bash", "/tmp/services.sh"]
