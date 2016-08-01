#!/bin/sh

###############################################################################
# MySQL
###############################################################################
docker pull mysql:5.7

# Remove Container
DOCKER_PSID=`docker ps -af name=mysqld -q`
if [ ${#DOCKER_PSID} -eq 0 ]; then
  :
else
    docker rm -f mysqld
fi


# Environment
WORKDIR=${PWD}/mysql


# Create Container
docker run --name mysqld \
-p 3306:3306 \
-v ${WORKDIR}/conf:/etc/mysql/conf.d \
-v ${WORKDIR}/data:/var/lib/mysql \
-v ${WORKDIR}/init.d:/docker-entrypoint-initdb.d \
-e MYSQL_DATABASE=hiromaily \
-e MYSQL_USER=hiromaily \
-e MYSQL_PASSWORD=12345678 \
-e MYSQL_ROOT_PASSWORD=root \
-d mysql:5.7

#--env-file  ${WORKDIR}/.env \

# Check connection
#mysql -u root -p -h 127.0.0.1 -P 3306


#ERROR 2003 (HY000): Can't connect to MySQL server on '127.0.0.1' (61)
#->It's settled by restart docker from menu.

###############################################################################
# Redis
###############################################################################
docker pull redis:3.2

# Remove Container
DOCKER_PSID=`docker ps -af name=redisd -q`
if [ ${#DOCKER_PSID} -eq 0 ]; then
  :
else
    docker rm -f redisd
fi


# Environment
WORKDIR=${PWD}/redis
REDIS_PASS=password


# Create Container
docker run --name redisd \
-p 6379:6379 \
-v ${WORKDIR}/data:/data \
-d redis:3.2 \
redis-server --requirepass ${REDIS_PASS} --appendonly yes

#Check
#redis-cli -h 127.0.0.1 -p 6379 -a password
