#!/bin/sh

# Environment Variable
NATS_FLG=1
SONAR_QUBE_FLG=1

###############################################################################
# Sonar Qube
###############################################################################
#https://hub.docker.com/_/sonarqube/

if [ $SONAR_QUBE_FLG -eq 1 ]; then
    docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube:6.0
fi