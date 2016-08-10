#!/bin/sh

###############################################################################
# Using docker-composer for go-gin-wrapper
###############################################################################

###############################################################################
# Environment
###############################################################################
CONTAINER_NAME=web
IMAGE_NAME=go-gin-wrapper:v1.0
IMAGE_NAME2=nginxs:v1.0
#IMAGE_NAME=dockerbuild_web
GITDIR=${PWD}/golang/web/docker_build/go-gin-wrapper

#export DB_WORKDIR=${PWD}/mysql
#export REDIS_WORKDIR=${PWD}/golang/web/redis_data
#export REDIS_HOST_NAME=redis-server

COMPOSE_FILE=./golang/${CONTAINER_NAME}/docker_build/docker-compose2.yml

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

    DOCKER_IMGID=`docker images "${IMAGE_NAME2}" -q`
    if [ ${#DOCKER_IMGID} -ne 0 ]; then
        docker rmi ${IMAGE_NAME2}
    fi
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
else
    pushd ./golang/${CONTAINER_NAME}/docker_build/go-gin-wrapper/
    git fetch origin
    git reset --hard origin/master
    popd
fi


###############################################################################
# Docker-compose / build and up
###############################################################################
#docker-compose -f ${COMPOSE_FILE} up --build -d
docker-compose -f ${COMPOSE_FILE} build
docker-compose -f ${COMPOSE_FILE} up -d


###############################################################################
# Docker-compose / down
###############################################################################
#docker-compose -f ${COMPOSE_FILE} down


###############################################################################
# Docker-compose / check
###############################################################################
docker-compose -f ${COMPOSE_FILE} ps
docker-compose -f ${COMPOSE_FILE} logs

#docker-compose -f ./golang/web/docker_build/docker-compose2.yml logs
#dclog nginx


###############################################################################
# Exec
###############################################################################
#Access by browser
#http://docker.hiromaily.com:8080/
