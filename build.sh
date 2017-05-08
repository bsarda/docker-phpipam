#!/bin/sh
docker ps -a | grep bsarda/phpipam | awk '{print $1}' | xargs -n1 docker rm -f
docker rmi bsarda/phpipam:latest
docker build --no-cache -t bsarda/phpipam .
