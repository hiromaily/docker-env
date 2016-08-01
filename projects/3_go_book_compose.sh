#!/bin/sh

###############################################################################
# Using docker-composer for go-book-teacher
###############################################################################

###############################################################################
# Environment
###############################################################################
#export DB_WORKDIR=${PWD}/mysql
#export REDIS_WORKDIR=${PWD}/golang/book/redis_data
#export REDIS_HOST_NAME=redis-server

CONTAINER_NAME=book
IMAGE_NAME=go-book-teacher:v1.0
#IMAGE_NAME=dockerbuild_book
GITDIR=${PWD}/golang/book/docker_build/go-book-teacher

COMPOSE_FILE=./golang/book/docker_build/docker-compose.yml

# mode settings
EXEC_MODE=1
CLONE_BRANCH=0
RUN_TEST=0

###############################################################################
# Remove Container And Image
###############################################################################
DOCKER_PSID=`docker ps -af name="${CONTAINER_NAME}" -q`
if [ ${#DOCKER_PSID} -ne 0 ]; then
    docker rm -f ${CONTAINER_NAME}
fi

DOCKER_IMGID=`docker images "${IMAGE_NAME}" -q`
if [ ${#DOCKER_IMGID} -ne 0 ]; then
    docker rmi go-book-teacher:v1.0
fi


###############################################################################
# Download based git repo
###############################################################################
if [ $CLONE_BRANCH -eq 1 ]; then
    rm -rf ${GITDIR}
    pushd ./golang/book/docker_build/
    git clone git@github.com:hiromaily/go-book-teacher.git
    EXIT_STATUS=$?

    if [ $EXIT_STATUS -gt 0 ]; then
        exit $EXIT_STATUS
    fi

    popd
fi


###############################################################################
# Docker-compose / build and up
###############################################################################
#docker-compose -f ${COMPOSE_FILE} up -d
#docker-compose -f ${COMPOSE_FILE} up --build -d

docker-compose -f ${COMPOSE_FILE} build
docker-compose -f ${COMPOSE_FILE} up -d redisd
docker-compose -f ${COMPOSE_FILE} up -d ${CONTAINER_NAME}


###############################################################################
# Exec
###############################################################################

#login to book
#docker-compose -f ${COMPOSE_FILE} run book bash
#->created container as new one

#error after executed, redis can't be connected.
#REDIS_URL=redis://h:password@redis-server:6379


#docker exec -it $(docker-compose -f "$COMPOSE_FILE" ps -q book) bash
#->Container 1c31d9dbb40fe15c2730674ce748301377db786db2105d0532ea31cc8c3a0f32 is not running

docker exec -it ${CONTAINER_NAME} bash


###############################################################################
# Docker-compose / down
###############################################################################
#docker-compose -f ${COMPOSE_FILE} down


###############################################################################
# Docker-compose / check
###############################################################################
#docker-compose -f ${COMPOSE_FILE} ps
#docker-compose -f ${COMPOSE_FILE} logs

#WARNING: The REDIS_WORKDIR variable is not set. Defaulting to a blank string.
#WARNING: The DB_WORKDIR variable is not set. Defaulting to a blank string.


###############################################################################
# Test (This works well)
###############################################################################
if [ $RUN_TEST -eq 1 ]; then
    docker run -it --name booktest --link redisd:redis-server \
    --env-file ./golang/book/docker_build/.env \
    --net dockerbuild_default dockerbuild_book

    #docker start -a booktest
    #docker exec -it booktest bash
fi
