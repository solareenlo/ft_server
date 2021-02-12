# ft_server

## Usage
```sh
sudo lsof -i:80
service --status-all
service nginx stop
docker build -t ft_server .
docker run -d --name ft_server -p 80:80 -p 443:443 ft_server:latest
docker run -d --name ft_server -p 80:80 -p 443:443 -e AUTOINDEX=on ft_server:latest
docker run -d --name ft_server -p 80:80 -p 443:443 -e AUTOINDEX=off ft_server:latest
docker exec -it ft_server bash
docker exec ft_server bash /tmp/autoindex.sh on
docker exec ft_server bash /tmp/autoindex.sh off
docker stop ft_server
docker rm ft_server
docker rmi ft_server
docker volume ls
```

```sh
service --status-all
nginx -t
nginx -s reload
service nginx reload
```
