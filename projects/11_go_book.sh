#!/bin/sh

###############################################################################
# golang:1.6 + go-book-teacher repo
###############################################################################
docker pull golang:1.6

###############################################################################
# Environment
###############################################################################
CONTAINER_NAME=book

GITDIR=${PWD}/golang/book/docker_build/go-book-teacher
WORKDIR=/go/src/github.com/hiromaily/go-book-teacher

# mode settings
EXEC_MODE=2  # 2 is best for now
CLONE_BRANCH=0

###############################################################################
# Remove Container
###############################################################################
#docker ps -af name=book -q
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
# Create Container
###############################################################################
#TODO:How can exec initialized command only once when first running.
if [ $EXEC_MODE -eq 1 ]; then
    #OK: It works well with connection.
    docker run -it --name ${CONTAINER_NAME} \
    --link redisd:redis-server \
    --env-file ./golang/${CONTAINER_NAME}/docker_build/.env \
    -v ${GITDIR}:${WORKDIR} \
    -w ${WORKDIR} \
    -e "REDIS_URL=redis://h:password@redis-server:6379" \
    golang:1.6 bash
elif [ $EXEC_MODE -eq 2 ]; then
    #OK: When usign -d, connection is disconnected but container is running.
    docker run -it --name ${CONTAINER_NAME} \
    --link redisd:redis-server \
    --env-file ./golang/${CONTAINER_NAME}/docker_build/.env \
    -v ${GITDIR}:${WORKDIR} \
    -w ${WORKDIR} \
    -e "REDIS_URL=redis://h:password@redis-server:6379" \
    -d golang:1.6 bash

    docker exec -it ${CONTAINER_NAME} bash ${WORKDIR}/docker-entrypoint.sh

    docker exec -it ${CONTAINER_NAME} bash
elif [ $EXEC_MODE -eq 3 ]; then
    #OK or No: When usign --entrypoint, connection is disconnected but container is running.
    #but, after a few second, somehow connection is disconnected.
    docker run -it --name ${CONTAINER_NAME} \
    --link redisd:redis-server \
    --env-file ./golang/${CONTAINER_NAME}/docker_build/.env \
    --entrypoint "./docker-entrypoint.sh" \
    -v ${GITDIR}:${WORKDIR} \
    -w ${WORKDIR} \
    -e "REDIS_URL=redis://h:password@redis-server:6379" \
    -d golang:1.6 bash

    docker exec -it ${CONTAINER_NAME} bash
elif [ $EXEC_MODE -eq 4 ]; then
    #No: When not using -it, container can't work.
    docker run --name ${CONTAINER_NAME} \
    --link redisd:redis-server \
    --env-file ./golang/${CONTAINER_NAME}/docker_build/.env \
    -v ${GITDIR}:${WORKDIR} \
    -w ${WORKDIR} \
    -e "REDIS_URL=redis://h:password@redis-server:6379" \
    -d golang:1.6 bash
    #->Status is Exited

    docker start -a ${CONTAINER_NAME}
    #->It can't work.
elif [ $EXEC_MODE -eq 5 ]; then
    #No: When trying to run initial command, container can't run.
    docker run -it --name ${CONTAINER_NAME} \
    --link redisd:redis-server \
    --env-file ./golang/${CONTAINER_NAME}/docker_build/.env \
    -v ${GITDIR}:${WORKDIR} \
    -w ${WORKDIR} \
    -e "REDIS_URL=redis://h:password@redis-server:6379" \
    golang:1.6 bash ${WORKDIR}/docker-entrypoint.sh
    #golang:1.6 /bin/bash -c "go get -d -v ./..." "go build -v -o /go/bin/book ./cmd/book/"
    #->Status is Exited
elif [ $EXEC_MODE -eq 6 ]; then
    #No: Commmand can't work but also container can't run.
    docker run -it --name ${CONTAINER_NAME} \
    --link redisd:redis-server \
    --env-file ./golang/${CONTAINER_NAME}/docker_build/.env \
    -v ${GITDIR}:${WORKDIR} \
    -w ${WORKDIR} \
    -e "REDIS_URL=redis://h:password@redis-server:6379" \
    golang:1.6 /bin/bash -c "go get -d -v ./..." "go build -v -o /go/bin/book ./cmd/book/"
    #->Status is Exited
else
  :
fi

#docker start -a book
#docker exec -it book bash
