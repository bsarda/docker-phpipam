# docker-phpIPAM
This is the phpIPAM container on CentOS 7.2 1511.  
This container uses a MariaDB external database.


```

Sample usage:
`docker run -d --name phpipam --restart unless-stopped -p 8080:80 --env TIMEZONE=Europe/Paris --env DB_SERVER=172.16.0.2 --env DB_PORT=3306 --env DB_NAME=phpipam --env DB_USER=phpipam --env DB_PASSWORD=phoeniX1 bsarda/phpipam:latest`

docker run -d --name phpipam -p 8080:80 --env TIMEZONE=Europe/Paris --env DB_SERVER=172.16.0.2 --env DB_PORT=3306 --env DB_NAME=phpipam --env DB_USER=phpipam --env DB_PASSWORD=phoeniX1 bsarda/phpipam:latest
docker exec phpipam /usr/sbin/httpd -k stop
docker exec phpipam /usr/sbin/httpd -k start
docker exec phpipam cat /var/www/html/config.php | grep db


Open the interface from a brower, like https://192.168.63.5:8080  

## Options as environment vars
- TIMEZONE => default 'Europe/Paris'  
- DB_SERVER => default '172.12.31.2'  
- DB_PORT => default '3306'  
- DB_NAME => default 'phpipam'  

```
