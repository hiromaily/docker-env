#!/bin/sh

# Environment Variable
NATS_FLG=1
KAFKA_FLG=0
RMQ_FLG=0


###############################################################################
# NATS
###############################################################################
#https://hub.docker.com/_/nats/
#gnatsd.conf

if [ $NATS_FLG -eq 1 ]; then
    # Environment
    IMAGE_NAME=nats:0.9.4
    CONTAINER_NAME=nats1
    CONTAINER2_NAME=nats2

    # Pull image
    docker pull ${IMAGE_NAME}

    # Remove Container
    DOCKER_PSID=`docker ps -af name="${CONTAINER_NAME}" -q`
    if [ ${#DOCKER_PSID} -ne 0 ]; then
        docker rm -f ${CONTAINER_NAME}
    fi

    # Create Container
    docker run -d --name ${CONTAINER_NAME} \
    -p 4222:4222 \
    -p 6222:6222 \
    -p 8222:8222 \
    ${IMAGE_NAME}

    # To run second server
    #docker run -d --name ${CONTAINER2_NAME} \
    #--link ${CONTAINER_NAME} \
    #--routes=nats-route://ruser:T0pS3cr3t@${CONTAINER_NAME}:6222 \
    #${IMAGE_NAME}

#4222/tcp, 6222/tcp, 8222/tcp
#Default Configuration File
# user: ruser
# password: T0pS3cr3t
fi


###############################################################################
# Apache Kafka
###############################################################################
#https://hub.docker.com/r/wurstmeister/kafka/
#http://wurstmeister.github.io/kafka-docker/
#https://github.com/wurstmeister/kafka-docker

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

fi


docker ps -a
