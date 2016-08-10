#!/bin/sh

###############################################################################
# Using Dockerfile for go-gin-wrapper repo
###############################################################################

###############################################################################
# Environment
###############################################################################
CONTAINER_NAME=web
IMAGE_NAME=go-gin-wrapper:v1.0

GITDIR=${PWD}/golang/web/docker_build/go-gin-wrapper
LOGDIR=${PWD}/golang/web/logs

REDIS_HOST_NAME=redis-server
MYSQL_HOST_NAME=mysql-server

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
else
    pushd ./golang/${CONTAINER_NAME}/docker_build/go-gin-wrapper/
    git fetch origin
    git reset --hard origin/master
    popd
fi


###############################################################################
# Create image (use Dockerfile)
###############################################################################
docker build -t ${IMAGE_NAME} \
--build-arg redisHostName=${REDIS_HOST_NAME} \
--build-arg mysqlHostName=${MYSQL_HOST_NAME} \
./golang/${CONTAINER_NAME}/docker_build

EXIT_STATUS=$?
if [ $EXIT_STATUS -gt 0 ]; then
    docker rmi $(docker images -f "dangling=true" -q)
    exit $EXIT_STATUS
fi

###############################################################################
# Create container
###############################################################################
docker run -it --name ${CONTAINER_NAME} \
--link redisd:redis-server \
--link mysqld:mysql-server \
--expose 9999 \
-p 9999:9999 \
-v ${LOGDIR}:/var/log/goweb \
-d ${IMAGE_NAME} bash


###############################################################################
# Execute
###############################################################################
#docker start -a web
#-> It's enough to enter to container.

#docker exec -it web bash

#Access by browser
#http://docker.hiromaily.com:9999/
