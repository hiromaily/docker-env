#!/bin/sh

# Environment Variable
MYSQL_FLG=0
REDIS_FLG=0
MONGO_FLG=0
MONGO2_FLG=0
CASSANDRA_FLG=1

###############################################################################
# MySQL
###############################################################################
if [ $MYSQL_FLG -eq 1 ]; then
    # Environment
    IMAGE_NAME=mysql:5.7
    CONTAINER_NAME=mysqld
    WORKDIR=${PWD}/mysql

    # Pull image
    docker pull ${IMAGE_NAME}

    # Remove Container
    DOCKER_PSID=`docker ps -af name="${CONTAINER_NAME}" -q`
    if [ ${#DOCKER_PSID} -ne 0 ]; then
        docker rm -f ${CONTAINER_NAME}
    fi

    # Create Container
    docker run --name ${CONTAINER_NAME} \
    -p 13306:3306 \
    -v ${WORKDIR}/conf:/etc/mysql/conf.d \
    -v ${WORKDIR}/data:/var/lib/mysql \
    -v ${WORKDIR}/init.d:/docker-entrypoint-initdb.d \
    -e MYSQL_DATABASE=hiromaily \
    -e MYSQL_USER=hiromaily \
    -e MYSQL_PASSWORD=12345678 \
    -e MYSQL_ROOT_PASSWORD=root \
    -d ${IMAGE_NAME}

    #--env-file  ${WORKDIR}/.env \

    # Check connection
    #mysql -u root -p -h 127.0.0.1 -P 13306


    #ERROR 2003 (HY000): Can't connect to MySQL server on '127.0.0.1' (61)
    #->It's settled by restart docker from menu.
fi

###############################################################################
# Redis
###############################################################################
if [ $REDIS_FLG -eq 1 ]; then
    # Environment
    IMAGE_NAME=redis:3.2
    CONTAINER_NAME=redisd
    WORKDIR=${PWD}/redis
    REDIS_PASS=password


    # Pull image
    docker pull ${IMAGE_NAME}

    # Remove Container
    DOCKER_PSID=`docker ps -af name="${CONTAINER_NAME}" -q`
    if [ ${#DOCKER_PSID} -ne 0 ]; then
        docker rm -f ${CONTAINER_NAME}
    fi


    # Create Container
    docker run --name ${CONTAINER_NAME} \
    -p 16379:6379 \
    -v ${WORKDIR}/data:/data \
    -d ${IMAGE_NAME} \
    redis-server --requirepass ${REDIS_PASS} --appendonly yes

    #Check
    #redis-cli -h 127.0.0.1 -p 16379 -a password
fi

###############################################################################
# MongoDB
###############################################################################
if [ $MONGO_FLG -eq 1 ]; then
    # Environment
    IMAGE_NAME=mongo:3.3
    CONTAINER_NAME=mongod
    WORKDIR=${PWD}/mongo
    MONGO_PASS=password
    NUM_CONTAINER=1
    PORT=27017

    # Pull image
    docker pull ${IMAGE_NAME}

    # Remove Container
    DOCKER_PSID=`docker ps -af name="${CONTAINER_NAME}" -q`
    if [ ${#DOCKER_PSID} -ne 0 ]; then
        docker rm -f ${CONTAINER_NAME}
    fi

    # Create Container (default port is 27017)
    docker run --name ${CONTAINER_NAME} \
    -p ${PORT}:27017 \
    -d ${IMAGE_NAME}
    #-v ${WORKDIR}/data:/data/db \
    #-d ${IMAGE_NAME} --auth

    # Another One
    #docker run --name ${CONTAINER_NAME}2 \
    #-p 27018:27017 \
    #-d ${IMAGE_NAME} --auth

    #1. Initial Settings
    sleep 2s
    mongo 127.0.0.1:${PORT}/admin --eval "var port = ${PORT};" ${WORKDIR}/init.js
    #mongo 127.0.0.1:27017/admin ./mongo/create.js
    #mongo 127.0.0.1:27017/hiromaily -u hiromaily -p 12345678 ./mongo/hiromaily.js
fi
###### TEST ######
if [ $MONGO2_FLG -eq 1 ]; then
    # Environment
    IMAGE_NAME=mongo:3.3
    CONTAINER_NAME=mongod2
    WORKDIR=${PWD}/mongo
    MONGO_PASS=password
    NUM_CONTAINER=1
    PORT=27018

    # Pull image
    docker pull ${IMAGE_NAME}

    # Remove Container
    DOCKER_PSID=`docker ps -af name="${CONTAINER_NAME}" -q`
    if [ ${#DOCKER_PSID} -ne 0 ]; then
        docker rm -f ${CONTAINER_NAME}
    fi

    # Create Container (default port is 27017)
    docker run --name ${CONTAINER_NAME} \
    -p ${PORT}:27017 \
    -d ${IMAGE_NAME}


    #1. Initial Settings
    sleep 2s
    mongo 127.0.0.1:${PORT}/admin --eval "var port = ${PORT};" ${WORKDIR}/init.js
    #mongo 127.0.0.1:27018/admin --eval "var port = 27018;" ./mongo/init.js
fi

# Check connection
#docker exec -it mongod mongo admin

#mongo admin --port 27017 --host 127.0.0.1

#mongo 127.0.0.1:27017/hiromaily -u hiromaily -p 12345678
#mongo 127.0.0.1:27017/hiromaily -u hiromaily -p 12345678 ./mongo/hiromaily.js

# Export json from mongo collection
#mongoexport -h 127.0.0.1:27017 --db hiromaily -c articles --out articles.json
#mongoexport -h 127.0.0.1:27017 --db hiromaily -c articles2 --out articles2.json

# Dump
#mongodump -h 127.0.0.1:27017 --db hiromaily --out dump

# Restore
#mongorestore -h 127.0.0.1:27017 --db hiromaily dump/hiromaily

###############################################################################


###############################################################################
# Cassandra
###############################################################################
if [ $CASSANDRA_FLG -eq 1 ]; then
    # Environment
    IMAGE_NAME=cassandra:3.7
    CONTAINER_NAME=cassandra
    WORKDIR=${PWD}/cassandra

    # Pull image
    docker pull ${IMAGE_NAME}

    # Remove Container
    DOCKER_PSID=`docker ps -af name="${CONTAINER_NAME}" -q`
    if [ ${#DOCKER_PSID} -ne 0 ]; then
        docker rm -f ${CONTAINER_NAME}
    fi


    # Create Container
    docker run --name ${CONTAINER_NAME} \
    -p 9042:9042 \
    -d ${IMAGE_NAME}
    #-v ${WORKDIR}/data:/var/lib/cassandra \

    #7000-7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp

    # Create Key Space
    #docker exec -it ${CONTAINER_NAME} bash ${WORKDIR}/docker-entrypoint.sh
    docker exec -it cassandra sh -c 'mkdir hy'
    docker cp ${WORKDIR}/init.sh cassandra:/hy/
    docker cp ${WORKDIR}/init.sql cassandra:/hy/

    #for i in {0..5}; do
    #    sleep 1s
    #    docker exec -it cassandra bash /hy/init.sh
    #    EXIT_STATUS=$?
    #    if [ $EXIT_STATUS -gt 0 ]; then
    #        echo 'error'
    #    else
    #        echo 'done!'
    #        break
    #    fi
    #    #echo $i
    #done

    #$CASSANDRA_PORT_9042_TCP_ADDR

    #Connection error: ('Unable to connect to any servers',
    # {'127.0.0.1': error(111, "Tried connecting to [('127.0.0.1', 9042)].
    # Last error: Connection refused")})

    #docker exec -it cassandra bash
fi
