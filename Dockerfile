# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tayamamo <tayamamo@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/21 05:19:27 by tayamamo          #+#    #+#              #
#    Updated: 2020/11/24 10:52:59 by tayamamo         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

LABEL maintainer="tayamamo@student.42tokyo.jp"

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes

RUN set -eux; \
	apt-get update; \
	apt-get upgrade -y; \
	apt-get install -y --no-install-recommends \
		wget \
		curl \
		gnupg2 \
		ca-certificates \
		lsb-release \
		apt-transport-https \
		nginx \
# Ghostscript is required for WordPress rendering PDF previews
		ghostscript \
	; \
	rm -rf /var/lib/apt/lists/*

# Install php7.4
RUN set -eux; \
	wget https://packages.sury.org/php/apt.gpg; \
	apt-key add apt.gpg; \
	echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.list; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		php7.4-fpm \
		php7.4-mysql \
	; \
	rm -rf /var/lib/apt/lists/*

# Install WorldPress
ENV WORDPRESS_VERSION 5.5.3
ENV WORDPRESS_SHA1 61015720c679a6cbf9ad51701f0f3fedb51b3273

RUN set -ex; \
	curl -o wordpress.tar.gz -fSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz"; \
	echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c -; \
# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
	tar -xzf wordpress.tar.gz -C /usr/src/; \
	rm wordpress.tar.gz; \
	chown -R www-data:www-data /usr/src/wordpress; \
# pre-create wp-content (and single-level children) for folks who want to bind-mount themes, etc so permissions are pre-created properly instead of root:root
# wp-content/cache: https://github.com/docker-library/wordpress/issues/534#issuecomment-705733507
	mkdir wp-content; \
	for dir in /usr/src/wordpress/wp-content/*/ cache; do \
		dir="$(basename "${dir%/}")"; \
		mkdir "wp-content/$dir"; \
	done; \
	chown -R www-data:www-data wp-content; \
	chmod -R 777 wp-content

VOLUME /var/www/html

COPY srcs /app

WORKDIR /tmp

# Install MySQL
ENV MYSQL_VERSION 0.8.16-1
ENV MYSQL_MD5SUM f6a7c41f04cc4fea7ade285092eea77a

RUN set -eux; \
	wget https://dev.mysql.com/get/mysql-apt-config_${MYSQL_VERSION}_all.deb; \
	echo "$MYSQL_MD5SUM mysql-apt-config_${MYSQL_VERSION}_all.deb" | md5sum -c -; \
	dpkg -i mysql-apt-config_${MYSQL_VERSION}_all.deb; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		mysql-server \
		mysql-client \
	; \
	rm -rf /var/lib/apt/lists/*

CMD bash
