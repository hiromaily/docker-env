#!/bin/sh

# Environment Variable
RMQ_FLG=0
KAFKA_FLG=1

###############################################################################
# RabbitMQ
###############################################################################
if [ $RMQ_FLG -eq 1 ]; then
    # Environment
    #IMAGE_NAME=rabbitmq:3.6
    IMAGE_NAME=rabbitmq:3.6-management
    CONTAINER_NAME=rmq1
    WORKDIR=${PWD}/rabitmq
    SECRET=abcabcabcabc
    RMO_USER=hiromaily
    RMO_PASS=hiropass

    # Pull image
    docker pull ${IMAGE_NAME}

    # Remove Container
    DOCKER_PSID=`docker ps -af name="${CONTAINER_NAME}" -q`
    if [ ${#DOCKER_PSID} -ne 0 ]; then
        docker rm -f ${CONTAINER_NAME}
    fi

    # Create Container
    docker run --name ${CONTAINER_NAME} \
    --hostname ${CONTAINER_NAME} \
    -p 4369:4369 \
    -p 5671:5671 \
    -p 5672:5672 \
    -p 15671:15671 \
    -p 15672:15672 \
    -e RABBITMQ_ERLANG_COOKIE=${SECRET} \
    -e RABBITMQ_DEFAULT_USER=${RMO_USER} \
    -e RABBITMQ_DEFAULT_PASS=${RMO_PASS} \
    -d ${IMAGE_NAME}

fi

docker ps -a

#4369/tcp, 5671-5672/tcp, 25672/tcp
#docker run -d --hostname my-rabbit --name rmq rabbitmq:3.6
#docker exec -it rmq bash

#=INFO REPORT==== 26-Aug-2016::08:51:34 ===
#node           : rabbit@my-rabbit
#home dir       : /var/lib/rabbitmq
#config file(s) : /etc/rabbitmq/rabbitmq.config
#cookie hash    : riwMJ1PN5ep5qkJYYG+PvQ==
#log            : tty
#sasl log       : tty
#database dir   : /var/lib/rabbitmq/mnesia/rabbit@my-rabbit

#http://localhost:15672/
## guest/guest (hiromaily/hiropass)


###############################################################################
# Apache Kafka
###############################################################################
#https://hub.docker.com/r/wurstmeister/kafka/
#http://wurstmeister.github.io/kafka-docker/
#https://github.com/wurstmeister/kafka-docker

#git clone https://github.com/wurstmeister/kafka-docker.git

if [ $KAFKA_FLG -eq 1 ]; then

    # Environment
    CLONE_BRANCH=0
    GITREPO=https://github.com/wurstmeister/kafka-docker.git
    GITDIR=${PWD}/kafka/kafka-docker
    MY_IP_ADDRESS=100.69.18.116

    #
    docker rm -f kafkadocker_kafka_1
    docker rm -f kafkadocker_zookeeper_1

    # Git
    if [ $CLONE_BRANCH -eq 1 ]; then
        rm -rf ${GITDIR}
        pushd ./kafka/
        git clone ${GITREPO}
        EXIT_STATUS=$?

        if [ $EXIT_STATUS -gt 0 ]; then
            exit $EXIT_STATUS
        fi

        popd
    fi

    # change docker-compose.yml
    #KAFKA_ADVERTISED_HOST_NAME: ${MY_IP_ADDRESS}

    # Run by docker-compose
    pushd ${GITDIR}
    docker-compose up -d

    # stop
    #docker-compose stop

    # kafkadocker_kafka
    #0.0.0.0:32768->9092/tcp

    # wurstmeister/zookeeper
    #22/tcp, 2888/tcp, 3888/tcp, 0.0.0.0:2181->2181/tcp
fi
