#!/bin/sh

###############################################################################
# Using Dockerfile for go-book-teacher repo
###############################################################################

###############################################################################
# Environment
###############################################################################
CONTAINER_NAME=book
IMAGE_NAME=go-book-teacher:v1.0

GITDIR=${PWD}/golang/book/docker_build/go-book-teacher

REDIS_HOST_NAME=redis-server

# mode settings
EXEC_MODE=1
CLONE_BRANCH=0


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
    git clone git@github.com:hiromaily/go-book-teacher.git
    EXIT_STATUS=$?

    if [ $EXIT_STATUS -gt 0 ]; then
        exit $EXIT_STATUS
    fi

    popd
else
    pushd ./golang/${CONTAINER_NAME}/docker_build/go-book-teacher/
    git fetch origin
    git reset --hard origin/master
    popd
fi


###############################################################################
# Create image (use Dockerfile)
###############################################################################
docker build -t ${IMAGE_NAME} \
--build-arg testValue1=aaaaa \
--build-arg redisHostName=${REDIS_HOST_NAME} \
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
--link redisd:${REDIS_HOST_NAME} \
--env-file ./golang/${CONTAINER_NAME}/docker_build/.env \
${IMAGE_NAME}


###############################################################################
# Execute
###############################################################################
#docker start -a book
#-> It's enough to enter to container.

#docker exec -it book bash
