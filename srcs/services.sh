# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    services.sh                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tayamamo <tayamamo@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/27 15:15:13 by tayamamo          #+#    #+#              #
#    Updated: 2020/11/27 17:07:15 by tayamamo         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

service nginx start
service php7.4-fpm start
service mysql restart

bash
