# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tayamamo <tayamamo@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/21 05:19:27 by tayamamo          #+#    #+#              #
#    Updated: 2020/11/24 03:21:54 by tayamamo         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

LABEL maintainer="tayamamo@student.42tokyo.jp"

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		nginx \
		wget \
		php7.3-fpm \
		php7.3-mysql \
	&& rm -rf /var/lib/apt/lists/*

COPY srcs /app

WORKDIR /tmp

# Install mysql
RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.16-1_all.deb \
	&& md5sum -c /app/md5sum_mysql.txt \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		lsb-release gnupg \
	&& dpkg -i mysql-apt-config_0.8.16-1_all.deb \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		mysql-server \
		mysql-client \
	&& rm -rf /var/lib/apt/lists/*


CMD bash
