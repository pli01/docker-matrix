#!/bin/bash
DC_APP_DOCKER_CLI="${DC_APP_DOCKER_CLI:-docker-compose.yml}"
echo "# create admin user"
docker-compose -f ${DC_APP_DOCKER_CLI} exec synapse register_new_matrix_user -a -u admin -p CHANGEME -c /data/homeserver.yaml http://localhost:8008
echo "# create test user"
docker-compose -f ${DC_APP_DOCKER_CLI} exec synapse register_new_matrix_user --no-admin -u test -p CHANGEME -c /data/homeserver.yaml http://localhost:8008

