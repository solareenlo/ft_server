# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tayamamo <tayamamo@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/21 05:19:27 by tayamamo          #+#    #+#              #
#    Updated: 2020/11/22 17:26:29 by tayamamo         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y --no-install-recommends \
	ca-certificates \
	nginx \
	wget \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.16-1_all.deb

COPY srcs /app

CMD bash
