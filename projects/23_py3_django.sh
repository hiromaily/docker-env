#!/bin/sh

###############################################################################
# Using docker-composer for go-gin-wrapper
###############################################################################

###############################################################################
# Environment
###############################################################################
CONTAINER_NAME=django
IMAGE_NAME=django-py3:v1.0

COMPOSE_FILE=./python3/${CONTAINER_NAME}/docker_build/docker-compose.yml

# mode settings
EXEC_MODE=1
DELETE_IMAGE=1
CLONE_BRANCH=0

echo "mode is ${EXEC_MODE}"
###############################################################################
# Remove Container And Image
###############################################################################
docker rm -f $(docker ps -aq)

if [ $DELETE_IMAGE -eq 1 ]; then
    DOCKER_IMGID=`docker images "${IMAGE_NAME}" -q`
    if [ ${#DOCKER_IMGID} -ne 0 ]; then
        docker rmi ${IMAGE_NAME}
    fi
fi


###############################################################################
# Docker-compose / build and up
###############################################################################
#docker-compose run -f ${COMPOSE_FILE} web django-admin.py startproject proj01 .
docker-compose -f ${COMPOSE_FILE} build
docker-compose -f ${COMPOSE_FILE} up -d

docker exec -it ${CONTAINER_NAME} bash ./docker-entrypoint.sh

###############################################################################
# Docker-compose / down
###############################################################################
#docker-compose -f ${COMPOSE_FILE} down


###############################################################################
# Docker-compose / check
###############################################################################
docker-compose -f ${COMPOSE_FILE} ps
docker-compose -f ${COMPOSE_FILE} logs

#docker-compose -f /python3/django/docker_build/docker-compose.yml logs
#dclog django


###############################################################################
# Exec
###############################################################################
#docker exec -it django bash

#docker exec -it ${CONTAINER_NAME} bash python manage.py runserver 0.0.0.0:8080

#Access by browser
#http://docker.hiromaily.com:8080/

