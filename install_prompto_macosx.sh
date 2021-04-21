#!/bin/bash

# check docker-compose install
docker-compose version &>/dev/null
version=$?
if [ $version -eq 0 ]
then
  # read folder to mount for logs and mongo files
  PROMPTO_DATA=~/prompto-data
  while [[ -z "$USER_INPUT" ]] ; do
      read -p "enter the folder where prompto will store its data (return for default: ${PROMPTO_DATA})" USER_INPUT
      USER_INPUT=${USER_INPUT:-${PROMPTO_DATA}}
  done
  PROMPTO_DATA=$USER_INPUT
  mkdir -p ${PROMPTO_DATA}
  echo prompto will store its data in folder ${PROMPTO_DATA}
  USER_INPUT=

  # read port to connect to mongo
  MONGO_PORT=27017
  while [[ -z "$USER_INPUT" ]] ; do
      read -p "enter the tcp port to use for connecting to the Mongo database (return for default: ${MONGO_PORT})" USER_INPUT
      USER_INPUT=${USER_INPUT:-${MONGO_PORT}}
  done
  MONGO_PORT=$USER_INPUT
  echo Mongo database will be accessible at localhost:${MONGO_PORT}
  USER_INPUT=

  # read port to connect to factory
  FACTORY_PORT=80
  while [[ -z "$USER_INPUT" ]] ; do
      read -p "enter the http port to use for the prompto factory UI (return for default: ${FACTORY_PORT})" USER_INPUT
      USER_INPUT=${USER_INPUT:-${FACTORY_PORT}}
  done
  FACTORY_PORT=$USER_INPUT
  echo prompto will be accessible at http://localhost:${FACTORY_PORT}
  USER_INPUT=

  # read port to connect to webapp
  DEVELOPER_PORT=8000
  while [[ -z "$USER_INPUT" ]] ; do
      read -p "enter the http port to use by your app (return for default: ${DEVELOPER_PORT})" USER_INPUT
      USER_INPUT=${USER_INPUT:-${DEVELOPER_PORT}}
  done
  DEVELOPER_PORT=$USER_INPUT
  echo your app will be accessible at http://localhost:${DEVELOPER_PORT}
  USER_INPUT=

  # read factory version
  echo reading latest prompto factory version
  FACTORY_VERSION=$(curl -s https://api.github.com/repos/prompto/prompto-factory/releases/latest | grep tag_name | cut -d'"' -f 4 | cut -dv -f 2)
  echo found factory version ${FACTORY_VERSION}

  echo downloading prompto for docker
  curl -s https://raw.githubusercontent.com/prompto/prompto-docker/master/docker-compose.yml >> ${PROMPTO_DATA}/docker-compose.yml

  echo installing prompto for docker at ${PROMPTO_DATA}
  pushd ${PROMPTO_DATA} || exit
    rm -f .env
    echo PROMPTO_DATA=${PROMPTO_DATA} >> .env
    echo MONGO_PORT=${MONGO_PORT} >> .env
    echo FACTORY_PORT=${FACTORY_PORT} >> .env
    echo DEVELOPER_PORT=${DEVELOPER_PORT} >> .env
    echo FACTORY_IMAGE=prompto/factory:${FACTORY_VERSION} >> .env
    rm -f start-prompto.sh
    echo docker-compose up --detach >> start-prompto.sh
    echo open http://localhost:${FACTORY_PORT} >> start-prompto.sh
    chmod 777 start-prompto.sh
    docker-compose up --no-start
  popd || exit

  echo prompto for docker installed at ${PROMPTO_DATA}
  echo to start prompto, open terminal and type:
  echo   cd ${PROMPTO_DATA}
  echo   ./start-prompto.sh
  echo to stop prompto, open terminal and type:
  echo   cd ${PROMPTO_DATA}
  echo   docker-compose stop

  echo starting prompto...
  pushd ${PROMPTO_DATA} || exit
    ./start-prompto.sh
  popd || exit

else
  # shellcheck disable=SC1010
  echo it seems you do not have docker-compose installed, please install docker-compose and retry
fi


