#!/bin/sh

CMD=$1
CONTAINER="none"
ACTION="pass"
RUN_OPTS="-it"

case "$CMD"
in
    php) 
        CONTAINER="phpcli"
        ACTION="php"
        ;;
    composer)
        CONTAINER="phpcli"
        ACTION="composer"
        ;;
    phing)
        CONTAINER="phpcli"
        ACTION="phing"
        ;;
    fpm) 
        CONTAINER="php"
        ACTION="bash"
        ;;
    mysql) 
        CONTAINER="mysql56"
        ACTION="mysql"
        ;;
    mysqlimport)
        CONTAINER="mysql56"
        ACTION="mysql"
        RUN_OPTS="-i"
        ;;
    sel) 
        CONTAINER="selenium"
        ;;
    node) 
        CONTAINER="node"
        ACTION="bash"
        ;;
    yarn) 
        CONTAINER="node"
        ACTION="yarn"
        ;;
esac

case "$2"
in
    cli) 
        ACTION="cli"
    ;;
esac

if [ $CONTAINER = "none" ]; then
    echo "Valid containers are php, fpm, mysql, sel, yarn"
    exit 1;
fi


if [ $ACTION = "cli" ]; then
    echo "Dropping to shell in $CONTAINER"
    docker exec -it -u `id -u`:`id -g` $(basename $(pwd))_${CONTAINER}_1 /bin/bash
else
    shift
    echo "Running command $ACTION in $CONTAINER"
    if [ "mysqlimport" = $CMD ]; then
        docker exec ${RUN_OPTS} -u `id -u`:`id -g` $(basename $(pwd))_${CONTAINER}_1 ${ACTION} "$@" < /proc/$$/fd/0
    elif [ "yarn" = $CMD ]; then
	echo "Please update dr.sh and change the yarn-folder value"
	exit 1;
        # docker exec ${RUN_OPTS} -u `id -u`:`id -g` $(basename $(pwd))_${CONTAINER}_1 bash -c "cd themes/yarn-folder; yarn $@"
    else
        docker exec ${RUN_OPTS} -u `id -u`:`id -g` $(basename $(pwd))_${CONTAINER}_1 ${ACTION} "$@"
    fi
fi
