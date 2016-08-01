#!/bin/sh

###############################################################################
# Using docker-composer for go-gin-wrapper
###############################################################################

###############################################################################
# Environment
###############################################################################
CONTAINER_NAME=web
IMAGE_NAME=go-gin-wrapper:v1.0
#IMAGE_NAME=dockerbuild_web
GITDIR=${PWD}/golang/web/docker_build/go-gin-wrapper

#export DB_WORKDIR=${PWD}/mysql
#export REDIS_WORKDIR=${PWD}/golang/web/redis_data
#export REDIS_HOST_NAME=redis-server

COMPOSE_FILE=./golang/${CONTAINER_NAME}/docker_build/docker-compose.yml

# mode settings
EXEC_MODE=1
CLONE_BRANCH=0

echo "mode is ${EXEC_MODE}"
###############################################################################
# Remove Container And Image
###############################################################################
DOCKER_PSID=`docker ps -af name="${CONTAINER_NAME}" -q`
if [ ${#DOCKER_PSID} -ne 0 ]; then
    docker rm -f ${CONTAINER_NAME}
fi

DOCKER_IMGID=`docker images "${IMAGE_NAME}" -q`
if [ ${#DOCKER_IMGID} -ne 0 ]; then
    docker rmi ${IMAGE_NAME}
fi


###############################################################################
# Download based git repo
###############################################################################
if [ $CLONE_BRANCH -eq 1 ]; then
    rm -rf ${GITDIR}
    pushd ./golang/${CONTAINER_NAME}/docker_build/
    git clone git@github.com:hiromaily/go-gin-wrapper.git
    EXIT_STATUS=$?

    if [ $EXIT_STATUS -gt 0 ]; then
        exit $EXIT_STATUS
    fi

    popd
fi


###############################################################################
# Docker-compose / build and up
###############################################################################
#docker-compose -f ${COMPOSE_FILE} up --build -d

docker-compose -f ${COMPOSE_FILE} build
#docker-compose -f ${COMPOSE_FILE} up -d redisd
#docker-compose -f ${COMPOSE_FILE} up -d mysql
#docker-compose -f ${COMPOSE_FILE} up -d web
docker-compose -f ${COMPOSE_FILE} up -d


###############################################################################
# Exec
###############################################################################
#docker exec -it web bash


###############################################################################
# Docker-compose / down
###############################################################################
#docker-compose -f ${COMPOSE_FILE} down


###############################################################################
# Docker-compose / check
###############################################################################
docker-compose -f ${COMPOSE_FILE} ps
docker-compose -f ${COMPOSE_FILE} logs

#docker-compose -f ./golang/web/docker_build/docker-compose.yml ps

#WARNING: The REDIS_WORKDIR variable is not set. Defaulting to a blank string.
#WARNING: The DB_WORKDIR variable is not set. Defaulting to a blank string.


###############################################################################
# Exec
###############################################################################
#docker start -a web
#docker exec -it web bash

