#!/bin/sh

###############################################################################
# golang:1.6 + go-gin-wrapper repo
###############################################################################
docker pull golang:1.6

###############################################################################
# Environment
###############################################################################
CONTAINER_NAME=web
GITDIR=${PWD}/golang/web/docker_build/go-gin-wrapper
WORKDIR=/go/src/github.com/hiromaily/go-gin-wrapper
LOGDIR=${PWD}/golang/web/logs/

# mode settings
EXEC_MODE=3  # 3 is best for now.
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
# Create Container
###############################################################################
if [ $EXEC_MODE -eq 1 ]; then
    #OK: It works well with connection.
    #--env-file ./golang/${CONTAINER_NAME}/docker_build/.env \
    docker run -it --name ${CONTAINER_NAME} \
    --link redisd:redis-server \
    --link mysqld:mysql-server \
    --expose 9999 \
    -p 9999:9999 \
    -v ${GITDIR}:${WORKDIR} \
    -v ${LOGDIR}:/var/log/goweb/ \
    -w ${WORKDIR} \
    -e "CLEARDB_DATABASE_URL=mysql://hiromaily:12345678@mysql-server/hiromaily?reconnect=true" \
    -e "REDIS_URL=redis://h:password@redis-server:6379" \
    golang:1.6 bash
elif [ $EXEC_MODE -eq 2 ]; then
    #OK: When usign -d, connection is disconnected but container is running.
    #--env-file ./golang/${CONTAINER_NAME}/docker_build/.env \
    docker run -it --name ${CONTAINER_NAME} \
    --link redisd:redis-server \
    --link mysqld:mysql-server \
    --expose 9999 \
    -p 9999:9999 \
    -v ${GITDIR}:${WORKDIR} \
    -v ${LOGDIR}:/var/log/goweb/ \
    -w ${WORKDIR} \
    -e "CLEARDB_DATABASE_URL=mysql://hiromaily:12345678@mysql-server/hiromaily?reconnect=true" \
    -e "REDIS_URL=redis://h:password@redis-server:6379" \
    -d golang:1.6 bash

    docker exec -it ${CONTAINER_NAME} bash ${WORKDIR}/docker-entrypoint.sh
    #docker exec -it ${CONTAINER_NAME} bash ginserver -f ${WORKDIR}/configs/docker.toml
    #->error: /go/bin/ginserver: cannot execute binary file

    #docker exec -it web bash

    #Access by browser
    #http://docker.hiromaily.com:9999/
elif [ $EXEC_MODE -eq 3 ]; then
    #OK: When usign -d and run initial command, connection is disconnected but container is running.
    #--env-file ./golang/${CONTAINER_NAME}/docker_build/.env \
    docker run -it --name ${CONTAINER_NAME} \
    --link redisd:redis-server \
    --link mysqld:mysql-server \
    --expose 9999 \
    -p 9999:9999 \
    -v ${GITDIR}:${WORKDIR} \
    -v ${LOGDIR}:/var/log/goweb/ \
    -w ${WORKDIR} \
    -e "CLEARDB_DATABASE_URL=mysql://hiromaily:12345678@mysql-server/hiromaily?reconnect=true" \
    -e "REDIS_URL=redis://h:password@redis-server:6379" \
    -d golang:1.6 bash ${WORKDIR}/docker-entrypoint.sh

    #docker exec -it web bash

    #Access by browser
    #http://docker.hiromaily.com:9999/
elif [ $EXEC_MODE -eq 4 ]; then
    #OK: When not using -it, but added -d, it can work. 3 and 4 are very similar.
    #--env-file ./golang/${CONTAINER_NAME}/docker_build/.env \
    docker run --name ${CONTAINER_NAME} \
    --link redisd:redis-server \
    --link mysqld:mysql-server \
    --expose 9999 \
    -p 9999:9999 \
    -v ${GITDIR}:${WORKDIR} \
    -v ${LOGDIR}:/var/log/goweb/ \
    -w ${WORKDIR} \
    -e "CLEARDB_DATABASE_URL=mysql://hiromaily:12345678@mysql-server/hiromaily?reconnect=true" \
    -e "REDIS_URL=redis://h:password@redis-server:6379" \
    -d golang:1.6 bash ${WORKDIR}/docker-entrypoint.sh

    #docker exec -it web bash

    #Access by browser
    #http://docker.hiromaily.com:9999/
else
  :
fi

#docker start -a ${CONTAINER_NAME}
#docker exec -it ${CONTAINER_NAME} bash
