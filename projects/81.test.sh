#!/bin/sh

###############################################################################
# golang:1.6 + go-gin-wrapper repo
###############################################################################
docker pull golang:1.6
#docker pull golang:1.6.2
#docker pull golang:1.6.3

###############################################################################
# Environment
###############################################################################
CONTAINER_NAME=webtest
GITDIR=${PWD}/golang/${CONTAINER_NAME}/docker_build/go-server
WORKDIR=/go/src/github.com/hiromaily/go-server

# mode settings
EXEC_MODE=3
CLONE_BRANCH=0

echo "mode is ${EXEC_MODE}"
###############################################################################
# Remove Container
###############################################################################
#docker ps -af name=web -q
DOCKER_PSID=`docker ps -af name="${CONTAINER_NAME}" -q`
if [ ${#DOCKER_PSID} -ne 0 ]; then
    docker rm -f ${CONTAINER_NAME}
fi


###############################################################################
# Download based git repo
###############################################################################
if [ $CLONE_BRANCH -eq 1 ]; then
    rm -rf ${GITDIR}
    pushd ./golang/${CONTAINER_NAME}/docker_build/
    git clone git@github.com:hiromaily/go-server.git
    EXIT_STATUS=$?

    if [ $EXIT_STATUS -gt 0 ]; then
        exit $EXIT_STATUS
    fi

    popd
else
    pushd ./golang/${CONTAINER_NAME}/docker_build/go-server/
    git fetch origin
    git reset --hard origin/master
    popd
fi


###############################################################################
# Create Container
###############################################################################
if [ $EXEC_MODE -eq 1 ]; then
    #OK: It works well with connection.
    docker run -it --name ${CONTAINER_NAME} \
    -p 80:8080 \
    -v ${GITDIR}:${WORKDIR} \
    -w ${WORKDIR} \
    golang:1.6 bash

    docker exec -it web bash

elif [ $EXEC_MODE -eq 2 ]; then
    docker run -it --name ${CONTAINER_NAME} \
    -p 80:8080 \
    -v ${GITDIR}:${WORKDIR} \
    -w ${WORKDIR} \
    -d golang:1.6 bash

    docker exec -it ${CONTAINER_NAME} bash ${WORKDIR}/docker-entrypoint.sh

    docker exec -it web bash

    #Access by browser
    #http://docker.hiromaily.com:9999/
elif [ $EXEC_MODE -eq 3 ]; then
    docker run -it --name ${CONTAINER_NAME} \
    -p 9999:9999 \
    -v ${GITDIR}:${WORKDIR} \
    -w ${WORKDIR} \
    -d golang:1.6.2 bash ${WORKDIR}/docker-entrypoint.sh

    #TODO:処理性能が遅いPCの場合、sleepで待機が必要かも
    #docker exec -it web bash
    #アクセスできる。。。

    #Access by browser
    #http://docker.hiromaily.com:9999/
elif [ $EXEC_MODE -eq 4 ]; then
    docker run --name ${CONTAINER_NAME} \
    -p 80:8080 \
    -v ${GITDIR}:${WORKDIR} \
    -w ${WORKDIR} \
    -d golang:1.6 bash ${WORKDIR}/docker-entrypoint.sh

    #docker exec -it web bash

    #Access by browser
    #http://docker.hiromaily.com:9999/
else
  :
fi

#docker start -a ${CONTAINER_NAME}
#docker exec -it ${CONTAINER_NAME} bash
