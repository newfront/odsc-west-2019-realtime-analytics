#!/bin/bash

PWD=${PWD}
DATA_DIR=${PWD}/data/
SPARK_VERSION='2.4.4'
DOCKER_COMPOSE_FILE='docker-compose-all.yaml'
DOCKER_NETWORK_NAME='odsc-network'
WINE_DATASET_COMPRESSED='winereviews.json.zip'
BOOKS_DETAILED_COMPRESSED='books_detailed_etl_large.json.zip'
BOOK_DATASET_COMPRESSED='goodreadsbooks.zip'

function installSpark() {
    echo "using curl to download spark 2.4.4"
    mkdir ${PWD}/install
    curl -XGET http://apache.osuosl.org/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz > ${PWD}/install/spark-2.4.4.tgz
    cd ${PWD}/install && tar -xvzf spark-2.4.4.tgz && rm spark-2.4.4.tgz
    mv spark-2.4.4-bin-hadoop2.7 ../spark-2.4.4
    cd ..
    echo "${PWD}"
}

function prepData() {
    cd ${DATA_DIR}
    unzip "${WINE_DATASET_COMPRESSED}"
    unzip "${BOOK_DATASET_COMPRESSED}"
    unzip "${BOOKS_DETAILED_COMPRESSED}"
    cd ..
    echo "${PWD}"
}

function init() {
   installSpark
   prepData
}

function cleanAndBuildDockerNetwork() {
    echo "cleaning up docker network if it was already created. Network Name : ${DOCKER_NETWORK_NAME}"
    docker network rm ${DOCKER_NETWORK_NAME}
    echo "building new docker network : ${DOCKER_NETWORK_NAME}"
    docker network create -d bridge ${DOCKER_NETWORK_NAME}
}

function cleanDocker() {
    docker rm -f `docker ps -aq` # deletes the old containers
}

function start() {
    #init
    export SPARK_HOME=${PWD}/"spark-${SPARK_VERSION}"
    echo "Your Spark Home is set to ${SPARK_HOME}"
    cleanDocker
    cleanAndBuildDockerNetwork
    docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --remove-orphans redis5
    docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --remove-orphans zeppelin
}

function stop() {
    docker-compose -f ${DOCKER_COMPOSE_FILE} down
}

function info() {
    CONTAINER=$2
    echo "INSPECT THIS ${CONTAINER}"
    docker inspect ${CONTAINER}
}

case "$1" in
    install)
        init
    ;;
    prep)
        prepData
    ;;
    start)
        start
    ;;
    stop)
        stop
    ;;
    info)
        info
    ;;
    *)
        echo $"Usage: $0 {install | prep | start | stop | info {CONTAINER_NAME}"
    ;;
esac