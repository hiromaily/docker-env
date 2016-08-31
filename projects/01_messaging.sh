#!/bin/sh

# Environment Variable
RMQ_FLG=1

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



