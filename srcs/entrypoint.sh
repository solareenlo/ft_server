# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    entrypoint.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tayamamo <tayamamo@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/24 15:56:25 by tayamamo          #+#    #+#              #
#    Updated: 2020/11/24 16:12:46 by tayamamo         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

service php7.4-fpm start
service nginx start
