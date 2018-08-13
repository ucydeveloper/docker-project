#!/bin/sh
CONTAINERS="apache php phpcli adminer mysql56 selenium mailhog node"

if [ -z "$DOCKER_SHARED_PATH" ]; then
    DOCKER_SHARED_PATH=~/docker
    echo "Setting default shared path to $DOCKER_SHARED_PATH "
fi

if [ -z "$DOCKER_PROJECT_PATH" ]; then
    DOCKER_PROJECT_PATH=${DOCKER_SHARED_PATH}/$(basename $(pwd))
    echo "Setting default project data path to $DOCKER_PROJECT_PATH "
fi

if [ -z "$PHP_VERSION" ]; then
    PHP_VERSION=7.1
    echo "Setting default PHP version to $PHP_VERSION "
fi

if [ -z "$MYSQL_VERSION" ]; then
    MYSQL_VERSION=5.6
    echo "Setting default MySQL version to $MYSQL_VERSION "
fi

case "$CONTAINERS" in 
    *solr*)
        if [ -d ${DOCKER_PROJECT_PATH}/solr-data ]; then
            echo "Solr data dir found, if solr does _NOT_ start, please sudo chown 8983:8983 ${DOCKER_SHARED_PATH}/solr-data"
        else 
            echo "Creating solr data-dir, sudo chown'd as the solr user (8983)"
            mkdir ${DOCKER_PROJECT_PATH}/solr-data
            sudo chown 8983:8983 ${DOCKER_PROJECT_PATH}/solr-data
        fi
    ;;
esac

export DOCKER_SHARED_PATH=$DOCKER_SHARED_PATH
export DOCKER_PROJECT_PATH=$DOCKER_PROJECT_PATH
export PHP_VERSION=$PHP_VERSION
export MYSQL_VERSION=$MYSQL_VERSION

echo "Creating services: ${CONTAINERS}"
docker-compose up -d ${CONTAINERS}
