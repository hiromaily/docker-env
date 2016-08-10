#!/bin/sh

###############################################################################
# Remove Container
###############################################################################
#docker rm -f mysqld
#docker rm -f redisd
#docker rm -f book

#delete all docker container
docker rm -f $(docker ps -aq)

#check
docker ps -a

###############################################################################
# Remove Image
###############################################################################

#docker rmi $(docker images go-book-teacher -q)
docker rmi -f dockerbuild_book
docker rmi -f dockerbuild_web
docker rmi -f go-gin-wrapper:v1.0
docker rmi -f go-gin-wrapper:v1.1
docker rmi -f go-book-teacher:v1.0
docker rmi -f go-book-teacher:v1.1
docker rmi -f py-book-teacher:v1.0
docker rmi -f py-book-teacher:v1.1
docker rmi -f nginxs:v1.0

docker rmi $(docker images -f "dangling=true" -q)

#check
docker images
