#!/bin/sh

###############################################################################
# python:3.5 + py-book-teacher repo
###############################################################################
docker pull python:3.5


###############################################################################
# Environment
###############################################################################
CONTAINER_NAME=pybook
IMAGE_NAME=py-book-teacher:v1.0

GITDIR=${PWD}/python3/pybook/docker_build/py-book-teacher
WORKDIR=/app/go-book-teacher

# mode settings
EXEC_MODE=1  # 1 is best for now
CLONE_BRANCH=1
BUILD_IMG=0

###############################################################################
# Remove Container
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
    pushd ./python3/pybook/docker_build/
    git clone git@github.com:hiromaily/py-book-teacher.git
    EXIT_STATUS=$?

    if [ $EXIT_STATUS -gt 0 ]; then
        exit $EXIT_STATUS
    fi

    #create tomlfile form backup
    cp config.ini ./py-book-teacher/

    popd
fi


###############################################################################
# Create image (use Dockerfile)
###############################################################################
docker build -t ${IMAGE_NAME} \
./python3/${CONTAINER_NAME}/docker_build

EXIT_STATUS=$?
if [ $EXIT_STATUS -gt 0 ]; then
    docker rmi $(docker images -f "dangling=true" -q)
    exit $EXIT_STATUS
fi


###############################################################################
# Create container
###############################################################################
docker run -it --name ${CONTAINER_NAME} \
-d ${IMAGE_NAME}


###############################################################################
# Execute
###############################################################################
#docker rm -f pybook
#docker run -it --name pybook -d py-book-teacher:v1.0
docker exec -it pybook bash
#-> python ./book.py

#docker exec -it pybook bash python ./book.py
